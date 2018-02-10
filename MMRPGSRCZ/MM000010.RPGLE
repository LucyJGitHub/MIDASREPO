     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas MM Initialisation program for CER048')           *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Module                                  *
      *                                                               *
      *  MM000010 - Midas MM Initialisation program for CER048        *
      *                                                               *
      *  Function:  This program will update 'Taxable Indicator'      *
      *             Field on DEALSDC                                  *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CRE073             Date 06Dec10               *
      *                 AR739524           Date 04Apr11               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 BUG22704           Date 08Apr09               *
      *                 CER048  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  AR739524 - CER048 Implementation Manual (Child: AR739525)    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG22704 - Take on Program did not flag deposit to Threhsold *
      *  CER048 - German Features - Taxes                             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas DL Money market & loans deals details
      *
     FDEALSDC   UF   E             DISK    INFSR(*PSSR)
      *                                                                                     BUG22704
      ** SD Cust Details by Country fo Tax                                                  BUG22704
      *                                                                                     BUG22704
     FSDACTXL1  IF   E           K DISK    INFSR(*PSSR)                                     BUG22704
      *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY includes the MM standard declares:
      *
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures. They have meaningful
      ** names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** External DS for Bank Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** First DS for access programs, long data structure
      *
     D DSLDY         E DS                  EXTNAME(DSLDY)
      *
      ** First DS for access programs, short data structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Long DS for access programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** External DS for Customer Details
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D                                     PREFIX(@)
      *
      ** External DS for Branch Details
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      *
      ** External DS for Location Details
      *
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)
      *
      ** External DS for Country Of Tax Details
      *
     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D PRtcd           S              7A
     D POptn           S              7A
     D PBrca           S              3A
     D PLccd           S              3A
     D PKey1           S             10A
     D PKyst           S              7A
     D WCncd           S              2A
     D WColc           S              2A
     D WRun            S              1A
     D KCtax           S              2A                                                    BUG22704
     D KCust           S              6A                                                    BUG22704
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *                                                                                     BUG22704
      ** Key List for SDAXCTL1                                                              BUG22704
      *                                                                                     BUG22704
     C     KCustByTax    KLIST                                                              BUG22704
     C                   KFLD                    KCust                                      BUG22704
     C                   KFLD                    KCtax                                      BUG22704
      *
      ** Update Taxable Indicator Field
      *
     C                   EXSR      SrInitInTx
      *
      ** Program Termination
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInitInTx - Update Taxable Indicator                        *
      *                                                               *
      *  Called By: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRInitInTx    BEGSR
      *
      ** Read Money Market Deals File
      *
     C     1             SETLL     DEALSDC
     C                   READ      DEALSDC
      *
     C                   DOW       (NOT %EOF(DEALSDC))
      *                                                                                     BUG22704
     C                   EVAL      TAXI = 'N'                                               BUG22704
      *
      ** Process only if Taxable indicator is 'Y' or *BLANKS
      *
     C                   EXSR      SRCttxDet
      *
      ** Based on Threshold Method and Tax Status of the Counterparty
      *
     C**********         IF        (EWTHMD = 'Y' AND @BBTAIN = 'Y')                         BUG22704
     C                   IF        (EWTHMD = 'Y' AND AXETXS = 'T')                          BUG22704
     C                   EVAL      TAXI = 'T'
     C                   ENDIF                                                              BUG22704
     C                   UPDATE    DEALSDCF
     C**********         ELSEIF    (EWTHMD = 'Y' AND @BBTAIN = 'N')                         BUG22704
     C**********         EVAL      TAXI = 'N'                                               BUG22704
     C**********         UPDATE    DEALSDCF                                                 BUG22704
     C**********         ENDIF                                                              BUG22704
      *
     C                   READ      DEALSDC
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCttxDet - Retrieve Country of Tax Details                  *
      *                                                               *
      *  Called By: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCttxDet     BEGSR
      *
     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      BRCA          PBrca
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
     C                   IF        (PRtcd <> *BLANKS)
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBKEY = BRCA
     C                   EVAL      DBASE = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
      ** Get the Location Code to get the country details
      *
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      A8LCCD        PLccd
     C     SDLOCN        PARM      SDLOCN        DSFDY
      *
     C                   IF        (PRtcd <> *BLANKS)
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDLOCNPD'
     C                   EVAL      DBKEY = A8LCCD
     C                   EVAL      DBASE = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
     C                   MOVEL     CNUM          PKey1
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM                    PKey1
     C                   PARM      *BLANKS       PKyst
     C     SDCUST        PARM      SDCUST        DSLDY
      *
     C                   IF        (PRtcd <> *BLANKS)
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBKEY = PKey1
     C                   EVAL      DBASE = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      DVCNCD        WCncd
     C                   PARM      @BBCOLC       WColc
     C     SDCTTX        PARM      SDCTTX        DSFDY
      *
     C                   IF        (PRtcd <> *BLANKS)
      *
     C******LOCK         IN        LDA                                                      AR739524
     C**********         EVAL      DBFILE = 'SDCTTXPD'                                      AR739524
     C**********         EVAL      DBKEY = DVCNCD + @BBCOLC                                 AR739524
     C**********         EVAL      DBASE = 004                                              AR739524
     C**********         OUT       LDA                                                      AR739524
     C**********         EXSR      *PSSR                                                    AR739524
      *
     C                   EVAL      EWTHMD = *BLANKS                                         AR739524
     C                   ENDIF
      *                                                                                     BUG22704
      ** Chain Customer Details by Country of Tax File to get                               BUG22704
      ** the European Tax Status                                                            BUG22704
      *                                                                                     BUG22704
     C                   EVAL      KCust = PKey1                                            BUG22704
     C                   EVAL      KCtax = DVCNCD                                           BUG22704
      *                                                                                     BUG22704
     C     *LOVAL        SETLL     SDACTXL1                                                 BUG22704
     C     KCustByTax    CHAIN     SDACTXL1                                                 BUG22704
      *                                                                                     BUG22704
      ** No Record Found                                                                    BUG22704
      *                                                                                     BUG22704
     C                   IF        NOT %FOUND(SDACTXL1)                                     BUG22704
     C                   EVAL      AXETXS = *BLANKS                                         BUG22704
     C                   ENDIF                                                              BUG22704
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: SRCttxDet                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
**  CPY@
(c) Finastra International Limited 2008
