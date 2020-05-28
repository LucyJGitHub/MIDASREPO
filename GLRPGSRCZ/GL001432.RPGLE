     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Format Posting Details')                      *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL001432 - Midas GL Format Posting details                   *
      *                                                               *
      *  Function:  This program formats posting details for TAG 61   *
      *             and 86.  It is based on the program GL1300.       *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD055642A          Date 27May20               *
      *  Prev Amend No. CMG009             Date 18Dec19               *
      *                 CMG008             Date 25Nov19               *
      *                 MD050696           Date 15May18               *
      *                 MD046248           Date 27Oct17               *
      *                 CDL099             Date 06Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CGL152             Date 02Dec13               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR787620           Date 10Jun11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26832           Date 10Dec09               *
      *                 BUG25311           Date 107ug09               *
      *                 BUG24690A          Date 04Aug09               *
      *                 BUG25147           Date 24Jul09               *
      *                 BUG24690           Date 07Jul09               *
      *                 BUG23742           Date 26May09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP204             Date 17Feb10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 216937             Date 28Apr03               *
      *                 CRE008             Date 24May02               *
      *                 CGL013  *CREATE    Date 17Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055642A - FM 2.1 SP21 Duplicate MultiCash Narr 22 on       *
      *             field 61 subfield 86                              *
      *  CMG009 - Upgrade of UMA001 to FB21 SP21                      *
      *           MT942 without Forward Value Postings                *
      *  CMG008 - Upgrade of EMP005 to FB21 SP21                      *
      *       EMP005CC1 - Remove EMP005 limitation on Destination     *
      *                   and Network.                                *
      *       EMP005 - SWIFT translation table for French characters. *
      *                This is an upgrade of TFJ002. As character     *
      *                conversion is now done in GL001432, EML008     *
      *                (to remove German characters) has been taken   *
      *                out from MG000940/942/950.                     *
      *  MD050696 - Multicash extended narratives from BuN interface  *
      *            postings not merged in field 86                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CGL152 - Include Transaction Type Identification Code on     *
      *           MT940/MT950                                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,GLH00180                                 *
      *             WNCPYSRC,GLH00181                                 *
      *             WNCPYSRC,GLH00183                                 *
      *             WNCPYSRC,GLH00202                                 *
      *             WNCPYSRC,GLH00203                                 *
      *             WNCPYSRC,GLH00204                                 *
      *             WNCPYSRC,GLH00205                                 *
      *             WNCPYSRC,GLH00206                                 *
      *             WNCPYSRC,GLH00207                                 *
      *             WNCPYSRC,GLH00208                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26832 - Incorrect Debit/Credit mark in Field 61 subfield 3*
      *  BUG25311 - Missing extended narrative on GCMS MT940          *
      *  BUG24690A - Incorrect field 61 subfield 7 and 9 on MT942     *
      *  BUG25147 - Missing MTCASH narratives for SWIFT network       *
      *  BUG24690 - Incorrect field 61 subfield 7 and 9 on MT942      *
      *  BUG23742 - Improper handling of Ext Narr from Batch          *
      *             Interface Input (Recompile)                       *
      *  CAP204 - Retail Account Transfer                             *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  216937 - Include src. of account for GA replicated postings  *
      *  CRE008 - Cash Management                                     *
      *  CGL013 - MT94x Messages Generation                           *
      *                                                               *
      *****************************************************************

     F/COPY WNCPYSRC,GLH00413
     FCLOAN     IF   E           K DISK                   INFSR(*PSSR)
      ** Midas LE Loans File
     F                                     INCLUDE(CLOANCLF) PREFIX(CL)
     FDEALS     IF   E           K DISK                   INFSR(*PSSR)                      BUG24690
     F                                                    PREFIX(DL)                        BUG24690
      ** Midas DL Dealing File                                                              BUG24690
      *                                                                                     BUG25147
     FGLMNARL1  IF   E           K DISK                      INFSR(*PSSR)                   BUG25147
      ** Midas GL Journal Entry - MultiCash - Retrieval.                                    BUG25147
     F/COPY WNCPYSRC,GLH00180
     FSDNTTIL0  IF   E           K DISK                      INFSR(*PSSR)                     CGL152
      ** Midas SD Network Transaction Identifier.                                             CGL152

     FMGCONVPD  IF   E           K DISK                   INFSR(*PSSR) USROPN                 CMG008
      ** MG Character Conversion file                                                         CMG008
                                                                                              CMG008
      *****************************************************************
      *                                                               *
      * Use of Indicators                                             *
      *                                                               *
      * Database Access Indicators                                    *
      *                                                               *
      * Database Error Indicators                                     *
      *                                                               *
      * U7 - Abnormal Completion                                      *
      * U8 - File Out of Balance                                      *
      * U7 + U8 - Database Error                                      *
      *                                                               *
      * Other Indicators                                              *
      *                                                               *
      * 99 - Multi-purpose                                            *
      *                                                               *
      *****************************************************************

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
                                                                                              CRE008
     D SCSARD        E DS                  EXTNAME(SCSARDPD) PREFIX(SS)                       CRE008
      **  Data Structure for Switchable features descriptions.                                CRE008

     D GLposting     E DS                  EXTNAME(GLPOSTPD) PREFIX(GL)
      **  Data Structure for Posting detail in General Ledger format.

     D MGposting     E DS                  EXTNAME(MGX940PD)
      **  Data Structure for Posting detail in Message Genration Format.

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      **  Data Structure for Customer record format.
                                                                                            BUG26832
     D SDNWRK        E DS                  EXTNAME(SDNWRKPD)                                BUG26832
      **  Data Structure for Network Description format                                     BUG26832
                                                                                              CRE008
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CRE008
      **  Second DS for access programs, short data structure.                                CRE008

     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  First DS for access programs, long data structure.
                                                                                            BUG26832
     D DSLDY         E DS                  EXTNAME(DSLDY)                                   BUG26832


     D W1DATA          DS           256
      **  Define FT0325 parameter data structure
     D  W1PREF                 1     15                                         Payment Reference
     D  W1SBF6                16     19                                         Sub Field 6
     D  W1SBF7                21     36                                         Sub Field 7
     D  W1SBF8                37     52                                         Sub Field 8
     D  W1SBF9                53     86                                         Sub Field 9
     D  W1DRCR                87     88                                         Debit/Credit
     D  W1CQSQ                89     90                                         Cheque sequence
     D/COPY WNCPYSRC,GLH00414

     D                 DS
      **  Arrays to retrieve Module Transaction according Deal Type.
     D TransType                     40    DIM(41) CTDATA PERRCD(1)
     D    TrDealType                  2    OVERLAY(TransType)                   Deal Type
     D      TrFiller1                 1    OVERLAY(TransType:*NEXT)
     D    TrModuleID                  2    OVERLAY(TransType:*NEXT)             MIDAS Module
     D      TrFiller2                 1    OVERLAY(TransType:*NEXT)
     D    TrDescrip                  34    OVERLAY(TransType:*NEXT)             Description
     D/COPY WNCPYSRC,GLH00415

      ** Declared variables
      ** ------------------

     D W0RTN           S              7A                                        Return Code
     D W0ACT           S              8A                                        Transaction Type

     D KeyLNRF         S                   LIKE(CLLNRF)                         Loan reference
     D KeyRCDT         S                   LIKE(CLRCDT) INZ('A')                Record Type

     D P@RTCD          S              7A                                        Return code
     D P@OPTN          S              7A                                        Option
     D P@SARD          S              6                                         Sar           CRE008
     D P@KEY1          S             10A                                        Key field
     D P@KYST          S              7A                                        Key status
     D PRtcd           S             10A                                                    BUG26832
     D POptn           S              7A                                                    BUG26832
     D PNwrk           S              6A                                                    BUG26832

     D ZAMNT           S             13  0                                      Original Amount
     D ZCCY            S              3A                                        Original Currency
     D ZSAMNT          S             17A                                        SWIFT Amount
     D ZSCCY           S              3A                                        SWIFT Currency
     D ZERR            S              1A                                        Error flag
     D ZSWDPC          S              1A

     D WkModuleID      S              2A                                        Module ID
     D WkDealType      S              2A                                        Deal Type
     D WkERI           S              1A                                        ERI Info. Exist
     D X               S              5U 0                                      Working Field
     D WkField6        S              6A                                        Working Field 6
     D WkField30       S             30A                                        Working Field 30
     D CRE008          S              6                                         CRE008 flag   CRE008
     D CGL152          S              1                                         CGL152 flag   CGL152
     D CMG009          S              1                                         CMG009 flag   CMG009
     D/COPY WNCPYSRC,GLH00416
      *                                                                                     BUG25147
     D                 DS                                                                   BUG25147
      ** Data Structure to retrieve the Batch Number and the Item Number                    BUG25147
     D GLSPOSX                        7A                                                    BUG25147
     D  WBatchNb               1      3A                                                    BUG25147
     D  WItemNb                4      6S 0                                                  BUG25147
     D/COPY WNCPYSRC,GLH00181
                                                                                              CMG008
     D ValSwiftChr     C                   CONST('ABCDEFGHIJKLMNOPQRSTUVWXYZ+                 CMG008
     D                                            abcdefghijklmnopqrstuvwxyz+                 CMG008
     D                                            0123456789+()?:-/,''. ')                    CMG008
      ** Valid Swift Characters                                                               CMG008
                                                                                              CMG008
                                                                                              CMG008
     D WBlank          C                   CONST(' ')                                         CMG008
      ** Replacement Blank character                                                          CMG008
                                                                                              CMG008
     D WConvFld        S             65A                                                      CMG008
      ** String to be converted                                                               CMG008
                                                                                              CMG008
     D To_Char         S            100A                                                      CMG008
      ** TO character string                                                                  CMG008
                                                                                              CMG008
     D Fr_Char         S            100A                                                      CMG008
      ** FROM character string                                                                CMG008
                                                                                              CMG008
     D WPos            S              3S 0                                                    CMG008
      ** Work field for %CHECK and %REPLACE operation                                         CMG008
                                                                                              CMG008
     D WLen            S              3S 0                                                    CMG008
      ** Work field for %SUBST operation                                                      CMG008
                                                                                              CMG008

      ** Input Specs
      ** -----------

      *------------------------------------------------------------------------*
      ** C Spec. Declaratives
      ** ====================

     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode                     Return Code
     C                   PARM                    GLPosting                      GL Posting Detail
     C                   PARM                    MGPosting                      MG Posting Detail

      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*

      ** Init processing uses the standard *INZSR subroutine

     C/COPY WNCPYSRC,GLH00417
     C                   EVAL      ReturnCode = *BLANKS

     C                   EVAL      MGNWRK = GLMGNWRK                            Network
     C                   EVAL      MGBRCA = GLBRCA                              Branch Code - Alpha
     C                   EVAL      MGCNUM = GLCNUM                              Customer number
     C                   EVAL      MGCCY  = GLCCY                               Currency code
     C                   EVAL      MGACCD = GLACOD                              Account code
     C                   EVAL      MGACSQ = GLACSQ                              Account sequence num
     C                   EVAL      MGNATY = GLMGNATY                            Network Account Type
     C                   EVAL      MGDSTN = GLMGDSTN                            Destination
     C                   EVAL      MGVALD = GLVALD                              Value date
     C                   EVAL      MGPSTD = GLPSTD                              Posting date

     C                   EVAL      MGPSTA = GLPSTA                              Posting Amount
     C/COPY WNCPYSRC,GLH00183
                                                                                            BUG26832
     C                   CALL      'AONWRKR1'                                               BUG26832
     C                   PARM      *BLANKS       PRtcd                                      BUG26832
     C                   PARM      '*KEY'        POptn                                      BUG26832
     C                   PARM      MGNWRK        PNwrk                                      BUG26832
     C     SDNWRK        PARM                    DSLDY                                      BUG26832
      *                                                                                     BUG26832
     C                   IF        PRtcd   <> *BLANKS                                       BUG26832
      *                                                                                     BUG26832
     C     *LOCK         IN        LDA                                                      BUG26832
      *                                                                                     BUG26832
     C                   EVAL      DBASE = 001                                              BUG26832
     C                   EVAL      DBFILE = 'SDNWRKPD'                                      BUG26832
     C                   EVAL      DBKEY  = PNwrk                                           BUG26832
     C                   EVAL      DBPGM = 'GL001432'                                       BUG26832
      *                                                                                     BUG26832
     C                   OUT       LDA                                                      BUG26832
     C                   EXSR      *PSSR                                                    BUG26832
     C                   ENDIF                                                              BUG26832

     C                   IF        EDMCNW <> 'Y'                                            BUG26832
                                                                                            BUG26832

     C                   SELECT
     C                   WHEN      GLRECI = 'P' AND GLDRCR = 0
     C                   EVAL      MGDRCR = 'D '                                Debit/Credit Ind.
     C                   WHEN      GLRECI = 'P' AND GLDRCR = 1
     C                   EVAL      MGDRCR = 'C '                                Debit/Credit Ind.
     C                   WHEN      GLRECI = 'S' AND GLDRCR = 0
     C                   IF        CMG009 = 'Y'                                               CMG009
     C                   EVAL      MGDRCR = 'D'                                               CMG009
     C                   ELSE                                                                 CMG009
     C                   EVAL      MGDRCR = 'ED'                                Debit/Credit Ind.
     C                   ENDIF                                                                CMG009
     C                   WHEN      GLRECI = 'S' AND GLDRCR = 1
     C                   IF        CMG009 = 'Y'                                               CMG009
     C                   EVAL      MGDRCR = 'C'                                               CMG009
     C                   ELSE                                                                 CMG009
     C                   EVAL      MGDRCR = 'EC'                                Debit/Credit Ind.
     C                   ENDIF                                                                CMG009
     C                   ENDSL
     C/COPY WNCPYSRC,GLH00202
                                                                                            BUG26832
     C                   ELSE                                                               BUG26832
                                                                                            BUG26832
     C                   IF        GLDRCR = 0                                               BUG26832
     C                   EVAL      MGDRCR = 'D '                                            BUG26832
     C                   ELSE                                                               BUG26832
     C                   EVAL      MGDRCR = 'C '                                            BUG26832
     C                   ENDIF                                                              BUG26832
     C                   ENDIF                                                              BUG26832

     C                   EVAL      MGSFD6 = *BLANKS                             Sub field 6
     C                   EVAL      MGSFD7 = *BLANKS                             Sub field 7 - Ref to
     C                   EVAL      MGSFD8 = *BLANKS                             Sub field 8 - A/c Se
     C                   EVAL      MGSFD9 = *BLANKS                             Sub field 9 - Supple

     C                   EVAL      MGADI1 = *BLANKS                             Additional Informati
     C                   EVAL      MGADI2 = *BLANKS                             Additional Informati
     C                   EVAL      MGADI3 = *BLANKS                             Additional Informati
     C                   EVAL      MGADI4 = *BLANKS                             Additional Informati
     C                   EVAL      MGADI5 = *BLANKS                             Additional Informati
     C                   EVAL      MGADI6 = *BLANKS                             Additional Informati

      ** Retrieve Details

     C                   EXSR      $RtvDtl

      ** Format MT950 subfields

     C                   IF        WkModuleID = 'FT'                            Fund Transfer
     C                   EXSR      $FT0325
     C                   ENDIF

      ** Format Field 61 / Sub field 6

     C                   EXSR      $SubFld6

      ** Format Field 61 / Sub field 7 - Ref to the A/c Owner

     C                   EXSR      $SubFld7

      ** Format Field 61 / Sub field 8 - A/c Servicing Institution Ref

     C                   EXSR      $SubFld8

      ** Format Field 61 / Sub field 9 - Supplementary Details

     C                   EXSR      $SubFld9

      ** Format Field 86 - Information to Account Owner

     C                   EXSR      $Field86

     C                   RETURN

      *========================================================================*
      * $RtVMod: Retrieve Details.                                            *
      *------------------------------------------------------------------------*

     C     $RtvDtl       BEGSR
      *    -------       -----

     C                   EVAL      WkModuleID = *BLANKS                         Module ID
     C                   EVAL      WkDealType = %SUBST(GLOTTP:1:2)              Deal Type

     C                   SELECT

      ** Lending

     C                   WHEN      GLSPOS = '  GE-LE'
     C                   EVAL      WkModuleID = 'LE'                            Module ID

      ** Dealing

     C                   WHEN      GLSPOS = '  GE-DL'

     C                   EVAL      X = 1
     C     WkDealType    LOOKUP    TrDealType(X)                          99
     C                   IF        *IN99
     C                   EVAL      WkModuleID = TrModuleID(X)                   Module ID
     C                   ENDIF

      ** Fund Transfer

     C                   WHEN      GLSPOS = '  GE-FT'
     C                   EVAL      WkModuleID = 'FT'                            Module ID

      ** General Ledger

     C                   WHEN      GLSPOS = '  GE-XF'
     C                             OR GLSPOS = '  GE-XB'
     C                   EVAL      WkModuleID = 'GL'                            Module ID

      ** Securities Trading module.

     C                   WHEN      GLSPOS = '  GE-ST'
     C                   EVAL      WkModuleID = 'SE'                            Module ID

      ** Customer Exchange transactions.

     C                   WHEN      GLSPOS = '  GE-CE'
     C                   EVAL      WkModuleID = 'RE'                            Module ID

      **  Standing Order

     C                   WHEN      GLSPOS = '  GE-SO'
     C                   EVAL      WkModuleID = 'SO'                            Module ID

     C                   WHEN      GLSPOS = '  GE-TX'                                         CAP204
     C                   EVAL      WkModuleID = 'RE'                                          CAP204
                                                                                              CAP204
     C                   ENDSL

      **  Retail Transaction Type

     C                   IF        %SUBST(GLOTRF:1:2) = '91'                    Retail Transact Type
     C                   EVAL      WkField6 = %SUBST(GLOTRF:1:6)                Orig. Transact. Ref
     C     '0123456789'  CHECK     WkField6      X
     C                   IF        X = 6
     C                   EVAL      WkModuleID = 'RE'                            Module ID
     C                   ENDIF
     C                   ENDIF

      ** Batch Transaction

     C/COPY WNCPYSRC,GLH00418
     C*****'0123456789'  CHECK     GLSPOS        X                                          MD050696
     C     ' '           SCAN      GLSPOS        X                                          MD050696

      ** If Source of Posting contains 6 numeric digits (batch number + batch item)

     C                   IF        X = 7
     C/COPY WNCPYSRC,GLH00419
     C                   EVAL      WkModuleID = 'BA'                            Module ID
     C/COPY WNCPYSRC,GLH00420
     C                   ENDIF

      *    -------       -----
     C     @RtvDtl       ENDSR

      *========================================================================*
      * $FT0325: Format MT950 subfields                                        *
      *------------------------------------------------------------------------*

     C     $FT0325       BEGSR
      *    -------       -----

      ** Set up parameters

     C/COPY WNCPYSRC,GLH00421
     C                   EVAL      W0ACT  = GLOTTP                              Transaction type
     C/COPY WNCPYSRC,GLH00422

     C                   CLEAR                   W1DATA

     C                   EVAL      W1PREF = GLPREF                              Payment Reference
     C                   EVAL      W1CQSQ = %SUBST(GLPNAR:16:2)                 Cheque Sequence
     C                   IF        GLDRCR = 1
     C                   EVAL      W1DRCR = 'CR'                                Debit/Credit
     C                   ELSE
     C                   EVAL      W1DRCR = 'DR'
     C                   ENDIF
     C/COPY WNCPYSRC,GLH00423

      ** Format Sub Fields

     C                   CALL      'FT0325'                             99
     C                   PARM      *BLANKS       W0RTN
     C                   PARM                    W0ACT
     C                   PARM                    W1DATA
      *
     C                   IF        *IN99
     C                             OR W0RTN <> *BLANKS
     C                   CLEAR                   W1DATA
     C                   ENDIF

      *    -------       -----
     C     @FT0325       ENDSR

      *========================================================================*
      * $SubFld6  : Format Sub field 6                                         *
      *------------------------------------------------------------------------*

     C     $SubFld6      BEGSR
      *    --------      -----

      **  Default

     C                   EVAL      MGSFD6 = 'FMSC'                              Miscellaneous

     C                   SELECT

      **  Cash Management Zero Balancing entry                                                CRE008
                                                                                              CRE008
     C                   WHEN      GLSPOS = '  GE-CX'  And                                    CRE008
     C                             GLMGZ616 <> *Blank                                         CRE008
     C                   Eval      MGSFD6 = GLMGZ616                                          CRE008
                                                                                              CRE008
      **  Fund Transfer

     C                   WHEN      WkModuleID = 'FT'                            Fund Transfer

     C                   SELECT
     C                   WHEN      W1SBF6 <> *BLANKS
     C                   EVAL      MGSFD6 = W1SBF6                              From FT0325
     C                   WHEN      GLCHQN <> 0
     C                   EVAL      %SUBST(MGSFD6:2:3) = 'CHK'                   Cheques
     C                   WHEN      GLOTTP = 'CP'
     C                   EVAL      %SUBST(MGSFD6:2:3) = 'CLR'                   Cheques remittance
     C                   OTHER
     C                   EVAL      %SUBST(MGSFD6:2:3) = 'COL'                   Collections
     C                   ENDSL

      **  xxxxxxxxxxxxx

     C                   WHEN      WkModuleID = 'GL'
     C                   EVAL      %SUBST(MGSFD6:2:3) = 'FEX'

      **  Forex deal

     C                   WHEN      WkModuleID = 'FX'
     C                   EVAL      %SUBST(MGSFD6:2:3) = 'FEX'

      **  Standing Order

     C                   WHEN      WkModuleID = 'SO'
     C                   EVAL      %SUBST(MGSFD6:2:3) = 'STO'                   Standing Order

      **  Retail Interest

     C                   WHEN      GLSPOS = '  GE-IC'
     C                   EVAL      %SUBST(MGSFD6:2:3) = 'INT'                   Interest
     C/COPY WNCPYSRC,GLH00424

     C                   ENDSL
      ** Override MGSFD6 if found to exist in SDNTTIPD                                        CGL152
     C                   EXSR      $CGL152SFld6                                               CGL152
     C/COPY WNCPYSRC,GLH00203

      *    --------      -----
     C     @SubFld6      ENDSR

      *========================================================================*
      * $SubFld7  : Format Sub field 7 - Ref to the A/c Owner                  *
      *------------------------------------------------------------------------*

     C     $SubFld7      BEGSR
      *    --------      -----

      **  Default

      **  SWIFT Common Reference

     C                   IF        GLSWCR <> *BLANKS
     C                             AND GLSWCR <> GLDLREF
     C                   EVAL      MGSFD7 = GLSWCR                              Swift Common Ref.

     C                   ELSE
     C/COPY WNCPYSRC,GLH00425

      **  First 16 characters of posting narrative

     C                   EVAL      MGSFD7 = %SUBST(GLPNAR:1:16)                 Posting Narrative
     C/COPY WNCPYSRC,GLH00426

     C                   ENDIF

     C                   SELECT

      **  Cash Management Zero Balancing entry                                                CRE008
                                                                                              CRE008
     C                   WHEN      GLSPOS = '  GE-CX'  And                                    CRE008
     C                             GLMGZ617 <> *Blank                                         CRE008
     C                   Eval      MGSFD7 = GLMGZ617                                          CRE008
                                                                                              CRE008
      **  Fund Transfer

     C                   WHEN      WkModuleID = 'FT'                            Fund Transfer
     C                             AND W1SBF7 <> *BLANKS
     C                   EVAL      MGSFD7 = W1SBF7                              From FT0325

      **  xxxxxxxxxxxxx

     C                   WHEN      GLSPOS = '  GE-CM'

     C                   SELECT

     C                   WHEN      GLDRCR = 0
     C                             AND GLSWCR = *BLANKS
     C                   EVAL      MGSFD7 = %SUBST(GLSPOS:3:5)

     C                   WHEN      GLDRCR = 1
     C                   EVAL      MGSFD7 = %SUBST(GLSPOS:3:5)
     C                   ENDSL
     C/COPY WNCPYSRC,GLH00630

     C                   ENDSL

      *                                                                                       CMG008
      ** If CMG008 is ON, convert French characters based on translation table.               CMG008
      ** Also convert any non-SWIFT character not in translation table to *BLANK.             CMG008
     C                   If        CMG008 = 'Y'                                               CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MGSFD7                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MGSFD7 = WConvFld                                          CMG008
     C                   Endif                                                                CMG008
                                                                                              CMG008
      *    --------      -----
     C     @SubFld7      ENDSR

      *========================================================================*
      * $SubFld8  : Format Sub field 8 - A/c Servicing Institution Ref         *
      *------------------------------------------------------------------------*

     C     $SubFld8      BEGSR
      *    --------      -----

     C                   SELECT

      **  Cash Management Zero Balancing entry                                                CRE008
                                                                                              CRE008
     C                   WHEN      GLSPOS = '  GE-CX'  And                                    CRE008
     C                             GLMGZ618 <> *Blank                                         CRE008
     C                   Eval      MGSFD8 = GLMGZ618                                          CRE008
     C/COPY WNCPYSRC,GLH00427
                                                                                              CRE008
     C                   WHEN      WkModuleID = 'BA'                            Batch Input
     C                   EVAL      MGSFD8 = '//' + 'G' + GLSPOS

     C                   WHEN      WkModuleID = 'GL'                            General Ledger
     C                   EVAL      MGSFD8 = '//' + 'G' +  %SUBST(GLSPOS:3:5)

     C                   WHEN      GLSPOS = '  GE-CM'
     C                   IF        GLDRCR = 0
     C                             AND GLSWCR <> *BLANKS
     C                   EVAL      MGSFD8 = '//' + %SUBST(GLSPOS:3:5)           Source of Posting
     C                   ENDIF

     C                   WHEN      WkModuleID = 'FT'                            Fund transfer
     C                             AND W1SBF8 <> *BLANKS
     C                   EVAL      MGSFD8 = '//' + W1SBF8

     C                   WHEN      GLDLREF <> *BLANKS                           Deal/Loan Reference
     C                   EVAL      MGSFD8 = '//' + GLDLREF

     C                   WHEN      WkModuleID = 'FX'                            Forex Deal
     C                             OR WkModuleID = 'IR'                         Interest Rate
     C                             OR WkModuleID = 'FR'                         Future Rate Agreem.
     C                             OR WkModuleID = 'RE'                         Retail
     C                             OR WkModuleID = 'LE'                         Lending
     C                   EVAL      MGSFD8 = '//' + %SUBST(WkModuleID:1:1) +
     C                             GLOTRF
     C/COPY WNCPYSRC,GLH00631

     C                   ENDSL

      *                                                                                       CMG008
      ** If CMG008 is ON, convert French characters based on translation table.               CMG008
      ** Also convert any non-SWIFT character not in translation table to *BLANK.             CMG008
     C                   If        CMG008 = 'Y'                                               CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MGSFD8                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MGSFD8 = WConvFld                                          CMG008
     C                   Endif                                                                CMG008
                                                                                              CMG008
      *    --------      -----
     C     @SubFld8      ENDSR
     C/COPY WNCPYSRC,GLH00428

      *========================================================================*
      * $SubFld9  : Format Sub field 9 - Supplementary Details                 *
      *------------------------------------------------------------------------*

     C     $SubFld9      BEGSR
      *    --------      -----

     C                   SELECT

      **  Cash Management Zero Balancing entry                                                CRE008
                                                                                              CRE008
     C                   WHEN      GLSPOS = '  GE-CX'  And                                    CRE008
     C                             GLMGZ619 <> *Blank                                         CRE008
     C                   Eval      MGSFD9 = GLMGZ619                                          CRE008
                                                                                              CRE008
     C/COPY WNCPYSRC,GLH00632
      **  Batch Input

     C                   WHEN      WkModuleID = 'BA'                            Batch Input
     C                   EVAL      MGSFD9 = GLPNAR

      **  Fund transfer

     C                   WHEN      WkModuleID = 'FT'                            Fund transfer
     C                             AND W1SBF9 <> *BLANKS
     C                   EVAL      MGSFD9 = W1SBF9

      **  If posting relating to a deal

     C                   WHEN      GLDLREF <> *BLANKS                           Deal/Loan Reference

      **  Retrieve the transaction customer

     C                   MOVEL(P)  GLCNUM        P@KEY1                         Default Accnt Cust.

     C**********         IF        GLDBCNUM <> *ZEROS                    Dealt/Borrower Cust. CSD027
     C                   IF        GLDBCNUM <> *BLANKS                          Dealt/Borrowe CSD027
     C                   MOVEL(P)  GLDBCNUM      P@KEY1
     C                   ENDIF

     C                   IF        WkModuleID = 'LE'                            Lending
     C                   EVAL      WkField6 =  %SUBST(GLDLREF:2:6)
     C                   MOVE      WkField6      KeyLNRF
     C     KeyCLOAN      CHAIN     CLOANCLF                           99
     C                   IF        NOT *IN99
     C                             AND CLPTYP >= 64 AND CLPTYP <= 65            Participation
     C                             AND CLRCSI <> 'Y'
     C**********                   AND CLOLNO <> *ZEROS                         Original Borr CSD027
     C                             AND CLOLNO <> *BLANKS                        Original Borr CSD027
     C                   MOVEL(P)  CLOLNO        P@KEY1
     C                   ENDIF
     C                   ELSE                                                               BUG24690
      *                                                                                     BUG24690
     C                   MOVEL     GLOTRF        keyDLNO           6 0                      BUG24690
     C     KeyDLNO       CHAIN     DEALS                              99                    BUG24690
     C                   IF        NOT *IN99                                                BUG24690
     C**********                   AND DLFACO <> *BLANKS                          BUG24690 BUG24690A
     C                   IF        DLFACO = *BLANKS                                        BUG24690A
     C                   MOVEL     DLCNUM        P@KEY1                                    BUG24690A
     C                   ELSE                                                              BUG24690A
     C                   MOVEL     DLFACO        P@KEY1                                     BUG24690
     C                   ENDIF                                                             BUG24690A
     C                   ENDIF                                                              BUG24690
      *                                                                                     BUG24690
     C                   ENDIF

      **  Retrieve the Customer Report Name and Town.

     C                   CALLB     'AOCUSTR0'
     C                   PARM      '*MSG   '     P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM                    P@KEY1
     C                   PARM                    P@KYST
     C     SDCUST        PARM      SDCUST        DSSDY

     C                   IF        P@RTCD = *BLANKS
     C     BBCRNM        CAT(P)    BBCRTN:1      MGSFD9
     C                   ENDIF

     C                   OTHER

      **  Otherwise, retrieve the posting narrative and suppress the leading ' ', '-' or ':',
      **  According the common SWIFT reference, the program extracts details from 1 or 17 position

     C                   IF        GLSWCR <> *BLANKS                            Swift common referen
     C                   EVAL      X = 1
     C                   ELSE
     C                   EVAL      X = 17
     C                   ENDIF

     C                   EVAL      WkField30 = %TRIM(%SUBST(GLPNAR:X:30-X+1))
     C     1             DO        30            X
     C                   IF        %SUBST(WkField30:X:1) <> ':'
     C                             AND %SUBST(WkField30:X:1) <> '-'
     C                   LEAVE
     C                   ELSE
     C                   EVAL      %SUBST(WkField30:X:1) = ' '
     C                   ENDIF
     C                   ENDDO
     C                   EVAL      MGSFD9 = %TRIM(WkField30)

     C                   ENDSL

      *                                                                                       CMG008
      ** If CMG008 is ON, convert French characters based on translation table.               CMG008
      ** Also convert any non-SWIFT character not in translation table to *BLANK.             CMG008
     C                   If        CMG008 = 'Y'                                               CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MGSFD9                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MGSFD9 = WConvFld                                          CMG008
     C                   Endif                                                                CMG008
                                                                                              CMG008
      *    --------      -----
     C     @SubFld9      ENDSR

      *========================================================================*
      * $Field86  : Format Field 86 - Information to Account Owner             *
      *------------------------------------------------------------------------*

     C     $Field86      BEGSR
      *    --------      -----
     C/COPY WNCPYSRC,GLH00204
      *                                                                                     BUG25147
     C     KeyAddInf     KLIST                                                              BUG25147
     C                   KFLD                    GLPSTD                                     BUG25147
     C                   KFLD                    WBatchNb          3                        BUG25147
     C                   KFLD                    WItemNb           3 0                      BUG25147
      *                                                                                     BUG25147
     C                   IF        WkModuleID = 'BA'                                        BUG25147
     C                   MOVE      GLSPOS        GLSPOSX                                    BUG25147
     C     KeyAddInf     CHAIN     GLMNARL1                           99                    BUG25147
     C                   ENDIF                                                              BUG25147
      *                                                                                     BUG25147
     C                   IF        WkModuleID = 'BA'                                        BUG25147
     C                             AND *IN99 = *OFF                                         BUG25147
     C                   EVAL      MGADI1 = BAEX1                                           BUG25147
     C                   EVAL      MGADI2 = BAEX2                                           BUG25147
     C                   EVAL      MGADI3 = BAEX3                                           BUG25147
     C                   EVAL      MGADI4 = BAEX4                                           BUG25147
     C                   EVAL      MGADI5 = BAEX5                                           BUG25147
     C                   EVAL      MGADI6 = BAEX6                                           BUG25147
     C                   EVAL      MG8621 = BAEX7                                           BUG25147
     C                   EVAL      MG8622 = BAEX8                                           BUG25147
     C                   EVAL      MG8623 = BAEX9                                           BUG25147
     C                   EVAL      MG8624 = BAEX10                                          BUG25147
     C                   EVAL      MG8625 = BAEX11                                          BUG25147
     C                   EVAL      MG8626 = BAEX12                                          BUG25147
     C                   EVAL      MG8627 = BAEX13                                          BUG25147
     C                   EVAL      MG8628 = BAEX14                                          BUG25147
     C                   EVAL      MG8629 = BAEX15                                          BUG25147
     C                   EVAL      MG8660 = BAEX16                                          BUG25147
     C                   EVAL      MG8661 = BAEX17                                          BUG25147
     C                   EVAL      MG8662 = BAEX18                                          BUG25147
     C                   EVAL      MG8663 = BAEX19                                          BUG25147
     C                   EVAL      MG8664 = BAEX20                                          BUG25147
     C                   EVAL      MG8665 = BAEX21                                          BUG25147
     C**********         EVAL      MG8632 = BAEX22                                BUG25147 MD055642A
     C                   EVAL      MG8635 = 'Y'                                             BUG25311
     C                   ELSE                                                               BUG25147

      ** Retrieve ERI information

     C                   EVAL      WkERI = 'N'                                  ERI Info. Exist

     C                   IF        GLOCCY <> *BLANKS                            Original Currency
     C                             AND GLOAMT <> *ZEROS                         Original Amount
     C                   CALL      'ZM0040'
     C                   PARM      GLOAMT        ZAMNT                          Original Amount
     C                   PARM      GLOCCY        ZCCY                           Original Currency
     C                   PARM      *BLANKS       ZSAMNT                         SWIFT Amount
     C                   PARM      *BLANKS       ZSCCY                          SWIFT Currency
     C                   PARM      *BLANKS       ZERR                           Error flag
     C                   PARM      *BLANKS       ZSWDPC
     C                   IF        ZERR = *BLANKS
     C                   EVAL      WkERI = 'Y'                                  ERI Info. Exist
     C                   ENDIF
     C                   ENDIF

      ** Default 'Information to Account Owner' with 'Additional Information'.

     C                   EVAL      MGADI1 = GLMGADI1                            Add. Information 1
     C                   EVAL      MGADI2 = GLMGADI2                            Add. Information 2
     C                   EVAL      MGADI3 = GLMGADI3                            Add. Information 3
     C                   EVAL      MGADI4 = GLMGADI4                            Add. Information 4
     C                   EVAL      MGADI5 = GLMGADI5                            Add. Information 5
     C                   EVAL      MGADI6 = GLMGADI6                            Add. Information 6

     C                   SELECT
                                                                                              CRE008
      **  Cash Management Zero Balancing entry                                                CRE008
                                                                                              CRE008
     C                   WHEN      GLSPOS = '  GE-CX'  And                                    CRE008
     C                             GLMGZ861 <> *Blank                                         CRE008
     C/COPY WNCPYSRC,GLH00633
     C                   EVAL      MGADI1 = GLMGZ861                                          CRE008
     C                   EVAL      MGADI2 = GLMGZ862                                          CRE008
     C                   EVAL      MGADI3 = GLMGZ863                                          CRE008
     C                   EVAL      MGADI4 = GLMGZ864                                          CRE008
     C                   EVAL      MGADI5 = GLMGZ865                                          CRE008
     C                   EVAL      MGADI6 = GLMGZ866                                          CRE008
                                                                                              CRE008
      **  Cash Management Group Accounting replicated posting                                 216937
     C                   WHEN      GLXRFI = 'GA '                                             216937
     C/COPY WNCPYSRC,GLH00205
     C                   EVAL      MGADI1 = *blank                                            216937
     C                   EVAL      MGADI2 = *blank                                            216937
     C                   EVAL      MGADI3 = *blank                                            216937
     C                   EVAL      MGADI4 = *blank                                            216937
     C                   EVAL      MGADI5 = *blank                                            216937
     C                   EVAL      MGADI6 = *blank                                            216937
     C                   EVAL      MGADI1 = GLMGSRCA                                          216937
     C/COPY WNCPYSRC,GLH00206

      ** If ERI Indicator = ' ' and ERI Information exists, it should be in first line.

     C                   WHEN      GLMGAERI = ' '                               ERI Indicator
     C                             AND WkERI = 'Y'                              ERI Info. Exist
     C                   EVAL      MGADI1 = '/OCMT/' + ZSCCY + ZSAMNT           Add. Information 1
     C                   CAT       '/':0         MGADI1                         Add. Information 1
     C                   EVAL      MGADI2 = GLMGADI1                            Add. Information 2
     C                   EVAL      MGADI3 = GLMGADI2                            Add. Information 3
     C                   EVAL      MGADI4 = GLMGADI3                            Add. Information 4
     C                   EVAL      MGADI5 = GLMGADI4                            Add. Information 5
     C                   EVAL      MGADI6 = GLMGADI5                            Add. Information 6

      ** If ERI Indicator = '1', the ERI information should be in the fist line.

     C                   WHEN      GLMGAERI = '1'                               ERI Indicator
     C                             AND WkERI = 'Y'                              ERI Info. Exist
     C                   EVAL      MGADI1 = '/OCMT/' + ZSCCY + ZSAMNT           Add. Information 1
     C                   CAT       '/':0         MGADI1                         Add. Information 1
     C                   EVAL      MGADI2 = GLMGADI1                            Add. Information 2
     C                   EVAL      MGADI3 = GLMGADI2                            Add. Information 3
     C                   EVAL      MGADI4 = GLMGADI3                            Add. Information 4
     C                   EVAL      MGADI5 = GLMGADI4                            Add. Information 5
     C                   EVAL      MGADI6 = GLMGADI5                            Add. Information 6

      ** If ERI Indicator = 'A', the ERI information should be in the fist available line.

     C                   WHEN      GLMGAERI = 'A'                               ERI Indicator
     C                             AND WkERI = 'Y'                              ERI Info. Exist
     C                   SELECT
     C                   WHEN      MGADI1 = *BLANKS
     C                   EVAL      MGADI1 = '/OCMT/' + ZSCCY + ZSAMNT           Add. Information 1
     C                   CAT       '/':0         MGADI1                         Add. Information 1
     C                   WHEN      MGADI2 = *BLANKS
     C                   EVAL      MGADI2 = '/OCMT/' + ZSCCY + ZSAMNT           Add. Information 2
     C                   CAT       '/':0         MGADI2                         Add. Information 2
     C                   WHEN      MGADI3 = *BLANKS
     C                   EVAL      MGADI3 = '/OCMT/' + ZSCCY + ZSAMNT           Add. Information 3
     C                   CAT       '/':0         MGADI3                         Add. Information 3
     C                   WHEN      MGADI4 = *BLANKS
     C                   EVAL      MGADI4 = '/OCMT/' + ZSCCY + ZSAMNT           Add. Information 4
     C                   CAT       '/':0         MGADI4                         Add. Information 4
     C                   WHEN      MGADI5 = *BLANKS
     C                   EVAL      MGADI5 = '/OCMT/' + ZSCCY + ZSAMNT           Add. Information 5
     C                   CAT       '/':0         MGADI5                         Add. Information 5
     C                   WHEN      MGADI6 = *BLANKS
     C                   EVAL      MGADI6 = '/OCMT/' + ZSCCY + ZSAMNT           Add. Information 6
     C                   CAT       '/':0         MGADI6                         Add. Information 6
     C                   ENDSL

      ** If ERI Indicator = 'M', the ERI information should be manually inputted in the
      ** Additional Information. The processing does not consider the ERI Information
      ** held in the GLPOSTPD.
      ** The default processing has loaded correctly the fields.

     C********           WHEN      GLMGAERI = 'M'                               ERI Indicator

      ** If ERI Indicator = 'N', the ERI information should not be used for this posting.
      ** The default processing has loaded correctly the fields.

     C********           WHEN      GLMGAERI = 'N'                               ERI Indicator

     C                   ENDSL
     C/COPY WNCPYSRC,GLH00429
      *                                                                                     BUG25147
     C                   ENDIF                                                              BUG25147
     C/COPY WNCPYSRC,GLH00207

      *                                                                                       CMG008
      ** If CMG008 is ON, convert French characters based on translation table.               CMG008
      ** Also convert any non-SWIFT character not in translation table to *BLANK.             CMG008
     C                   If        CMG008 = 'Y'                                               CMG008
      ** Convert MGADI1                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MGADI1                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MGADI1 = WConvFld                                          CMG008
      ** Convert MGADI2                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MGADI2                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MGADI2 = WConvFld                                          CMG008
      ** Convert MGADI3                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MGADI3                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MGADI3 = WConvFld                                          CMG008
      ** Convert MGADI4                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MGADI4                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MGADI4 = WConvFld                                          CMG008
      ** Convert MGADI5                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MGADI5                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MGADI5 = WConvFld                                          CMG008
      ** Convert MGADI6                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MGADI6                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MGADI6 = WConvFld                                          CMG008
      ** Convert MG8621                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MG8621                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MG8621 = WConvFld                                          CMG008
      ** Convert MG8622                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MG8622                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MG8622 = WConvFld                                          CMG008
      ** Convert MG8623                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MG8623                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MG8623 = WConvFld                                          CMG008
      ** Convert MG8624                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MG8624                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MG8624 = WConvFld                                          CMG008
      ** Convert MG8625                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MG8625                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MG8625 = WConvFld                                          CMG008
      ** Convert MG8626                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MG8626                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MG8626 = WConvFld                                          CMG008
      ** Convert MG8627                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MG8627                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MG8627 = WConvFld                                          CMG008
      ** Convert MG8628                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MG8628                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MG8628 = WConvFld                                          CMG008
      ** Convert MG8629                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MG8629                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MG8629 = WConvFld                                          CMG008
      ** Convert MG8660                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MG8660                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MG8660 = WConvFld                                          CMG008
      ** Convert MG8661                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MG8661                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MG8661 = WConvFld                                          CMG008
      ** Convert MG8662                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MG8662                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MG8662 = WConvFld                                          CMG008
      ** Convert MG8663                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MG8663                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MG8663 = WConvFld                                          CMG008
      ** Convert MG8664                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MG8664                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MG8664 = WConvFld                                          CMG008
      ** Convert MG8665                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MG8665                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MG8665 = WConvFld                                          CMG008
      ** Convert MG8632                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MG8632                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MG8632 = WConvFld                                          CMG008
                                                                                              CMG008
     C                   Endif                                                                CMG008
                                                                                              CMG008
      *    --------      -----
     C     @Field86      ENDSR

      *========================================================================*              CGL152
      * $CGL152Fld6 : Format Sub field 6 w/ SDNTTIL0.NINTTI when CGL152 is On  *              CGL152
      *------------------------------------------------------------------------*              CGL152
                                                                                              CGL152
     C     $CGL152SFld6  BEGSR                                                                CGL152
      *    --------      -----                                                                CGL152
                                                                                              CGL152
     C                   IF        CGL152 = 'Y'                                               CGL152
                                                                                              CGL152
     C                   EVAL      MGTRAT = GLTRAT                                            CGL152
     C                   MOVEL     MGTRAT        NIRTTY                                       CGL152
                                                                                              CGL152
     C     KeyNTTIL0     CHAIN     SDNTTIL0                           99                      CGL152
                                                                                              CGL152
     C                   IF        NOT *IN99                                                  CGL152
     C                   MOVEL(P)  NINTTI        MGSFD6                                       CGL152
     C                   ENDIF                                                                CGL152
                                                                                              CGL152
     C                   ENDIF                                                                CGL152
                                                                                              CGL152
      *    --------      -----                                                                CGL152
     C     @CGL152SFld6  ENDSR                                                                CGL152
      *========================================================================*              CMG008
      * BldConvFil : Build Conversion Table for removing French character      *              CMG008
      *------------------------------------------------------------------------*              CMG008
                                                                                              CMG008
     C     BldConvFil    BEGSR                                                                CMG008
      *    ----------    -----                                                                CMG008
      *                                                                                       CMG008
      ** Open Character conversion file                                                       CMG008
     C                   Open      MGCONVPD                                                   CMG008
      *                                                                                       CMG008
      ** Initialise work fields                                                               CMG008
     C                   Eval      Fr_Char = *Blanks                                          CMG008
     C                   Eval      To_Char = *Blanks                                          CMG008
     C                   Eval      WLen = 0                                                   CMG008
                                                                                              CMG008
      ** Read file and collect characters in FROM and TO alpha fields                         CMG008
     C     *Loval        Setll     MGCONVPD                                                   CMG008
     C                   Read      MGCONVPD                                                   CMG008
                                                                                              CMG008
     C                   Dow       NOT %EOF                                                   CMG008
     C                   Eval      Fr_Char = %SUBST(Fr_Char:1:WLen) + FRCHAR                  CMG008
     C                   Eval      To_Char = %SUBST(To_Char:1:WLen) + TOCHAR                  CMG008
     C                   Eval      WLen = Wlen + 1                                            CMG008
                                                                                              CMG008
     C                   Read      MGCONVPD                                                   CMG008
     C                   Enddo                                                                CMG008
      *                                                                                       CMG008
      ** Close file                                                                           CMG008
     C                   Close     MGCONVPD                                                   CMG008
      *                  -----                                                                CMG008
     C                   ENDSR                                                                CMG008
                                                                                              CMG008
      *========================================================================*              CMG008
      * ConvChar : Convert Character and remove remove invalid non-SWIFT chars *              CMG008
      *------------------------------------------------------------------------*              CMG008
                                                                                              CMG008
     C     ConvChar      BEGSR                                                                CMG008
      *    --------      -----                                                                CMG008
      *                                                                                       CMG008
      ** Only process field if not blank                                                      CMG008
     C                   If        WConvFld <> *BLANKS                                        CMG008
                                                                                              CMG008
      ** Convert all French characters based on conversion table                              CMG008
     C                   Eval      WConvFld = %XLATE(%TRIM(Fr_Char)                           CMG008
     C                                        :%TRIM(To_Char):WConvFld)                       CMG008
                                                                                              CMG008
      ** Convert all remaining non-SWIFT chars (not defined in the table)                     CMG008
      ** into blanks. Use pre-defined 'Valid Swift Chars' field for comparison.               CMG008
     C                   Eval      WPos = 0                                                   CMG008
     C                   Eval      WPos = %CHECK (ValSwiftChr:WConvFld)                       CMG008
                                                                                              CMG008
      ** Repeat process until all invalid chars are found and converted to blank              CMG008
     C                   Dow       WPos > 0                                                   CMG008
     C                   Eval      WConvFld = %REPLACE(WBlank:WConvFld:WPos:1)                CMG008
     C                   Eval      WPos = 0                                                   CMG008
     C                   Eval      WPos = %CHECK(ValSwiftChr:WConvFld)                        CMG008
     C                   Enddo                                                                CMG008
                                                                                              CMG008
     C                   Endif                                                                CMG008
      *                  -----                                                                CMG008
     C                   ENDSR                                                                CMG008
                                                                                              CMG008
      *========================================================================*
      * *INZSR    : Init Processing                                            *
      *------------------------------------------------------------------------*

     C     *INZSR        BEGSR
      *    ------        -----

      ** Initialise Copyright Array
     C                   MOVEA     CPY@          CPY@@            80

      ** Initialise LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     PSProcPgm     DBpgm
     C                   OUT       LDA

      ** Key list for CHAIN to CLOAN
     C     KeyCLOAN      KLIST
     C                   KFLD                    KeyLNRF                        Loan reference
     C                   KFLD                    KeyRCDT                        Record Type
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
     C                   ENDIF                                                                CRE008
      ** Check if feature CMG009 (MT942 without Forward Value Postings) is installed          CMG009
                                                                                              CMG009
     C                   EVAL      CMG009 = 'N'                                               CMG009
                                                                                              CMG009
     C                   CALLB     'AOSARDR0'                                                 CMG009
     C                   PARM      *BLANKS       P@RTCD                         Return Code   CMG009
     C                   PARM      '*VERIFY'     P@OPTN                         Option        CMG009
     C                   PARM      'CMG009'      P@SARD                         Feature Ref.  CMG009
     C     SCSARD        PARM      SCSARD        DSFDY                                        CMG009
                                                                                              CMG009
     C                   IF        P@RTCD = *BLANKS                                           CMG009
     C                   EVAL      CMG009 = 'Y'                                               CMG009
     C                   ENDIF                                                                CMG009
                                                                                              CGL152
      ** Key list for CHAIN to SDNTTIL0                                                       CGL152
     C     KeyNTTIL0     KLIST                                                                CGL152
     C                   KFLD                    NIRTTY                         Trans Type    CGL152
     C                   KFLD                    MGNWRK                         Network ID    CGL152
                                                                                              CGL152
      ** Check if feature CGL152 (Include Transaction Type Identification Code                CGL152
      **                          in MT940/MT950) is installed                                CGL152
                                                                                              CGL152
     C                   EVAL      CGL152 = 'N'                                               CGL152
                                                                                              CGL152
     C                   CALLB     'AOSARDR0'                                                 CGL152
     C                   PARM      *BLANKS       P@RTCD                         Return Code   CGL152
     C                   PARM      '*VERIFY'     P@OPTN                         Option        CGL152
     C                   PARM      'CGL152 '     P@SARD                         Feature Ref.  CGL152
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL152
                                                                                              CGL152
     C                   IF        P@RTCD = *BLANKS                                           CGL152
     C                   EVAL      CGL152 = 'Y'                                               CGL152
     C                   ENDIF                                                                CGL152
     C/COPY WNCPYSRC,GLH00430

      ** Check if feature CMG008 is installed                                                 CMG008
                                                                                              CMG008
     C                   EVAL      CMG008 = 'N'                                               CMG008
                                                                                              CMG008
     C                   CALLB     'AOSARDR0'                                                 CMG008
     C                   PARM      *BLANKS       P@RTCD                         Return Code   CMG008
     C                   PARM      '*VERIFY'     P@OPTN                         Option        CMG008
     C                   PARM      'CMG008 '     P@SARD                         Feature Ref   CMG008
                                                                                              CMG008
     C                   IF        P@RTCD = *BLANKS                                           CMG008
     C                   MoveL     'Y'           CMG008            1                          CMG008
     C                   ENDIF                                                                CMG008
                                                                                              CMG008
      * If CMG008 is ON, build the character conversion table                                 CMG008
                                                                                              CMG008
     C                   IF        CMG008 = 'Y'                                               CMG008
     C                   EXSR      BldConvFil                                                 CMG008
     C                   ENDIF                                                                CMG008
     C/COPY WNCPYSRC,GLH00208
      *    ------        -----
     C     @INZSR        ENDSR

      *========================================================================*
      * *PSSR     : Program exception error subroutine                         *
      *------------------------------------------------------------------------*

     C     *PSSR         BEGSR
      *    -----         ------

     C                   IF        ReturnCode = *BLANKS
     C                   EVAL      ReturnCode = 'PSSR_Error'
     C                   ENDIF

     C                   DUMP
     C                   ROLBK

     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On

     C                   RETURN

      *    ----------    ------
     C     @PSSR         ENDSR

      *========================================================================*
**CTDATA CPY@
(c) Finastra International Limited 2002
**CTDATA TransType
FP FX Foreign Exch. Purch.
FS FX Foreign Exch. Sold
CX FX Cross Deal
SW FX Swap Deal
OP FX Option
OT FX Option Takedown
PI FX Purch. Cover. Inter.
SI FX Sale Cover. Interest
RF IR Interest Rate Floors
RP IR Interest Rate Caps
RR IR Interest Rate Collar
RS IR Single curr.int.Swap
RX IR Single curr.int.Swap
FR FR Future Rate Agreement
IT MM Interbank taking
IP MM Interbank placing
TD MM Time deposit
TI MM Time loan
CI MM CD issued
CD MM Call/notice deposit
CL MM Call/notice deposit
DL MM Demand loan
C1 NP Primary CD
C2 NP Secondary CD
BP NP Bond
BD NP Bill
TB NP Treasury bill
DA NP Bank acceptance
TA NP Trade acceptance
CS NS Primary or secondary CD sold
BS NS Bond Sold
BR NS Bill Sold
TS NS Treasury bill Sold
RA NS Bank acceptance Sold
TR NS Trade acceptance Sold
FL DF Fixed term Placing (Bank side)
FT DF Fixed term Taking (Customer side)
DT DF Call Taking
LT DF Call Taking (Fiduciary Loan)
DP DF Call Placing
LP DF Call Placing (Fiduciary Loan)
