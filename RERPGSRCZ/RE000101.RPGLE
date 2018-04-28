     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Initialization Program for CER048')           *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Module                                  *
      *                                                               *
      *  RE000101 - Midas RE Initialisation program for CER048        *
      *                                                               *
      *  Function:  This program will update 'Taxable Indicator'      *
      *             Field on ACCNTBXC                                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. CER070             Date 19Aug14               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CER055             Date 06Dec10               *
      *                 AR739524           Date 04Apr11               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      *                 BUG22662           Date 05Feb09               *
      *                 CER048  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER055 - Penalty Interest on Exceeding Overdraft Limit       *
      *           (Recompile)                                         *
      *  AR739524 - CER048 Implementation Manual (Child: AR739525)    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  BUG22662 - DBASE error due to missing record in SDACTXPD     *
      *  CER048 - German Features - Taxes                             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Customer Details by Country of Tax
      *
     FSDACTXL1  IF   E           K DISK    INFSR(*PSSR)
      *                                                                                     BUG22662
      ** Additional Customer Details                                                        BUG22662
      *                                                                                     BUG22662
     FSDACUSL1  IF   E           K DISK    INFSR(*PSSR)                                     BUG22662
      *
      ** Midas GL Account Details
      *
     FACCNTBY0  UF   E           K DISK    INFSR(*PSSR)
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
      **  Long DS for access programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** External DS for Customer details file
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D                                     PREFIX(@)
      *
      ** External DS for Branch codes
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      *
      ** External DS for Location codes
      *
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)
      *
      ** External DS for Country of Tax Codes
      *
     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D WCncd           S              2A
     D WCloc           S              2A
     D PRtcd           S              7A
     D POptn           S              7A
     D PLccd           S              3A
     D PKyst           S              7A
     D PKey1           S             10A
     D PBrca           S             25A
     D KCust           S              6A
     D KCtax           S              2A
     D WRun            S              1A
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
      *
      ** Update Taxable Indicator Field
      *
     C                   EXSR      SRInitInTx
      *
      ** Program Termination
      *
     C                   EVAL      *INLR = *ON
      *
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
      *
     C     SRInitInTx    BEGSR
      *
     C     KCustByTax    KLIST
     C                   KFLD                    KCust
     C                   KFLD                    KCtax
      *
      ** Read Money Market Deals File
      *
     C     *LOVAL        SETLL     ACCNTBY0
     C                   READ      ACCNTBY0
      *
     C                   DOW       (NOT %EOF(ACCNTBY0))
      *
     C                   MOVE      ATCNUM        KCust                                      BUG22662
                                                                                            BUG22662
      ** Check first if Customer exists in Additional Customer Details File                 BUG22662
                                                                                            BUG22662
     C     KCust         CHAIN     SDACUSL1                           99                    BUG22662
                                                                                            BUG22662
      ** If found                                                                           BUG22662
                                                                                            BUG22662
     C                   IF        *IN99 = *OFF AND E5JATP = 'I'                            BUG22662
     C                             OR *IN99 = *OFF AND E5JATP = 'Y'                         BUG22662
      *                                                                                     BUG22662
     C                   EXSR      SRCttxDet
      *
      ** Based on Threshold Method and European Tax Status
      *
     C                   IF        (EWTHMD = 'Y' AND AXETXS = 'T')
     C                   EVAL      ATITAX = 'T'
     C                   UPDATE    ACCNTBD0
     C                   ELSEIF    (EWTHMD = 'Y' AND AXETXS <> 'T')
     C                   EVAL      ATITAX = 'N'
     C                   UPDATE    ACCNTBD0
     C                   ENDIF
      *                                                                                     BUG22662
     C                   ENDIF                                                              BUG22662
      *
     C                   READ      ACCNTBY0
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCttxDet: Retrieve Country of Tax Details                   *
      *                                                               *
      *  Called By: SRInitInTx                                        *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCttxDet     BEGSR
      *
     C                   CALL      'AOBRCHR0'
      *
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      ATBRCA        PBrca
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
     C                   IF        (PRtcd <> *BLANKS)
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBKEY = ATBRCA
     C                   EVAL      DBASE = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
      ** Get the Location Code to get the country details
      *
     C                   CALL      'AOLOCNR0'
      *
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      A8LCCD        PLccd
     C     SDLOCN        PARM      SDLOCN        DSLDY
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
      ** To get the Country of Location, Use the Customer
      ** Table to get the data
      *
     C                   MOVEL     ATCNUM        PKey1
      *
     C                   CALL      'AOCUSTR0'
      *
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
      ** Fetch the Threshold Method Using the Country of Tax Table
      *
     C                   CALL      'AOCTTXR0'
      *
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      DVCNCD        WCncd
     C                   PARM      @BBCOLC       WCloc
     C     SDCTTX        PARM      SDCTTX        DSFDY
      *
     C                   IF        (PRtcd <> *BLANKS)
      *
     C******LOCK         IN        LDA                                                      AR739524
     C**********         EVAL      DBFILE = 'SDCTTXPD'                                      AR739524
     C**********         EVAL      DBKEY = WCncd + WCloc                                    AR739524
     C**********         EVAL      DBASE = 004                                              AR739524
     C**********         OUT       LDA                                                      AR739524
     C**********         EXSR      *PSSR                                                    AR739524
      *
     C                   EVAL      EWTHMD = *BLANKS                                         AR739524
     C                   ENDIF
      *
      ** Chain Customer Details by Country of Tax File to get
      ** the European Tax Status
      *
     C                   MOVE      ATCNUM        KCust
     C                   EVAL      KCtax = DVCNCD
      *
     C     KCustByTax    CHAIN     SDACTXL1
      *
      ** No Record Found
      *
     C                   IF        NOT %FOUND(SDACTXL1)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDACTXPD  '
     C                   EVAL      DBKEY = KCust + KCtax
     C                   EVAL      DBASE = 005
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
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
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2008
