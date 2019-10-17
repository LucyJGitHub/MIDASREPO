     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Process CAR migration SDINPHPD')              *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SMU00003 - German Feature migration for SDINPHPD             *
      *                                                               *
      *  Called By: SMUC00000                                         *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER071             Date 01Aug16               *
      *                 CER070             Date 19Aug14               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26037B          Date 12Oct09               *
      *                 BUG26037A          Date 25Sep09               *
      *                 BUG26037           Date 18Sep09               *
      *                 BUG25589           Date 19Aug09               *
      *                 CSM011  *CREATE    Date 08May09               *
      *                 xxxxxx             Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26037B - Change logical used for retrieval of Customer    *
      *              by country of tax                                *
      *  BUG26037A - Some customers are missing from SDINPHPD         *
      *  BUG26037 - Some customers are missing from SDINPHPD          *
      *  BUG25589 - Some accounts does not post tax properly          *
      *  CSM011 - Midas SM Process CAR migration                      *
      *                                                               *
      *****************************************************************
     FSMUGF03PD IF   E             DISK
      * Template file for GLCADHPP
     FSDACUSPD  IF   E             DISK                                                     BUG26037
      * Additional Customer Details                                                         BUG26037
     FSDJACCL4  IF   E           K DISK                                                     BUG26037
     F***SDINPHPD  UF A E             DISK                                                  BUG26037
     FSDINPHL0  UF A E           K DISK                                                     BUG26037
      * Customer Details by Country of Tax                                                 BUG26037A
     F***SDACTXL1  IF   E           K DISK                                       BUG26037A BUG26037B
     FSDACTXL4  IF   E           K DISK                                                    BUG26037B
      *
      /EJECT
      *
      ** Short Access Object Data Structure                                                 BUG25589
     D DSFDY         E DS                  EXTNAME(DSFDY)                                   BUG25589
                                                                                            BUG25589
      ** Long Access Object Data Structure                                                  BUG25589
     D DSSDY         E DS                  EXTNAME(DSSDY)                                   BUG25589
                                                                                            BUG25589
      ** Long Access Object Data Structure                                                  BUG26037
     D DSLDY         E DS                  EXTNAME(DSLDY)                                   BUG26037
                                                                                            BUG26037
      ** External DS for Bank Details                                                       BUG25589
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                BUG25589
                                                                                            BUG25589
      ** External DS for Currency Details                                                   BUG25589
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                BUG25589
                                                                                            BUG25589
      ** External DS for Customer Details                                                   BUG26037
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                BUG26037
                                                                                            BUG26037
      ** Local Data Area for Database Error Details                                         BUG25589
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)                         BUG25589
                                                                                            BUG25589
      ** Access object parameters                                                           BUG25589
     D PRtCd           S              7A                                                    BUG25589
     D POptn           S              7A                                                    BUG25589
     D PCcy            S              3A                                                    BUG25589
     D PKYST           S              7A                                                    BUG26037
     D PKEY1           S             10A                                                    BUG26037
     D WDivAmt         S              5P 0 INZ(1)                                           BUG25589
      *                                                                                     BUG25589
     D Recursive       S              1
      *
     D                 DS
     D FCUSTa                  1      6
     D FCUSTn                  1      6  0
      *                                                                                     BUG25589
      ** Retrieve bank details                                                              BUG25589
      *                                                                                     BUG25589
     C                   CALL      'AOBANKR0'                                               BUG25589
     C                   PARM      *BLANKS       PRtCd                                      BUG25589
     C                   PARM      '*FIRST '     POptn                                      BUG25589
     C     SDBANK        PARM      SDBANK        DSFDY                                      BUG25589
      *                                                                                     BUG25589
     C                   IF        PRtCd <> *BLANKS                                         BUG25589
     C     *LOCK         IN        LDA                                                      BUG25589
     C                   EVAL      DBFile = 'SDBANKPD'                                      BUG25589
     C                   EVAL      DBKey = '*FIRST'                                         BUG25589
     C                   EVAL      DBase = 1                                                BUG25589
     C                   OUT       LDA                                                      BUG25589
     C                   EXSR      *PSSR                                                    BUG25589
     C                   ENDIF                                                              BUG25589
      *                                                                                     BUG25589
      ** Retreive currency details of bank currency                                         BUG25589
      *                                                                                     BUG25589
     C                   CALL      'AOCURRR0'                                               BUG25589
     C                   PARM      *BLANKS       PRtCd                                      BUG25589
     C                   PARM      '*KEY   '     POptn                                      BUG25589
     C                   PARM      BJCYCD        PCcy                                       BUG25589
     C     SDCURR        PARM      SDCURR        DSSDY                                      BUG25589
      *                                                                                     BUG25589
     C                   IF        PRtCd <> *BLANKS                                         BUG25589
     C     *LOCK         IN        LDA                                                      BUG25589
     C                   EVAL      DBFile = 'SDCURRPD'                                      BUG25589
     C                   EVAL      DBKey = PCcy                                             BUG25589
     C                   EVAL      DBase = 2                                                BUG25589
     C                   OUT       LDA                                                      BUG25589
     C                   EXSR      *PSSR                                                    BUG25589
     C                   ENDIF                                                              BUG25589
      *                                                                                     BUG25589
     C                   EVAL      WDivAmt = 10 ** A6NBDP                                   BUG25589
      *
      * Read template file.
     C     1             SETLL     SMUGF03PD
     C                   READ      SMUGF03PD
     C                   DOW       NOT %EOF
      *
     C                   EVAL      TIBRCA = FBRCAC
     C                   EVAL      FCUSTn = FCUST
     C                   EVAL      TICUST = FCUSTa
     C                   EVAL      TILSSD = FLSTSD
     C                   EVAL      TIPGNO = FPAGNO
     C                   EVAL      TISTRQ = FSRQD
     C                   EVAL      TIUTTH = FUUTHR
     C                   EVAL      TITOUT = FUTIL
     C**********         EVAL      TICUTH = FCTHR                                           BUG25589
     C                   EVAL      TICUTH = FCTHR / WDivAmt                                 BUG25589
      *                                                                                    BUG26037A
      ** Get EU Tax Status                                                                 BUG26037A
      *                                                                                    BUG26037A
     C*****TICUST        CHAIN     SDACTXl1                                      BUG26037A BUG26037B
     C*********          IF        %FOUND(SDACTXl1)                              BUG26037A BUG26037B
     C     TICUST        CHAIN     SDACTXl4                                                BUG26037B
     C                   IF        %FOUND(SDACTXl4)                                        BUG26037B
     C                   IF        AXETXS = 'T'                                            BUG26037A
     C                   EVAL      TISTRQ = 'Y'                                            BUG26037A
     C                   ENDIF                                                             BUG26037A
     C                   ENDIF                                                             BUG26037A
      *                                                                                    BUG26037A
     C                   WRITE     SDINPHD0
      *
     C                   READ      SMUGF03PD
     C                   ENDDO
      *
     C     1             SETLL     SDACUSPD                                                 BUG26037
     C                   READ      SDACUSPD                                                 BUG26037
                                                                                            BUG26037
     C                   DOW       NOT %EOF                                                 BUG26037
                                                                                            BUG26037
     C                   IF        E5JATP = 'Y' OR                                          BUG26037
     C                             E5JATP = 'I'                                             BUG26037
                                                                                            BUG26037
     C                   CALL      'AOCUSTR1'                                               BUG26037
     C                   PARM      *BLANKS       PRTCD                                      BUG26037
     C                   PARM      '*KEY   '     POptn                                      BUG26037
     C                   PARM      E5CUST        PKey1                                      BUG26037
     C                   PARM                    PKySt                                      BUG26037
     C     SDCUST        PARM      SDCUST        DSLDY                                      BUG26037
                                                                                            BUG26037
     C                   IF        PRTCD <> *BLANKS                                         BUG26037
     C     *LOCK         IN        LDA                                                      BUG26037
     C                   EVAL      DBFile = 'SDCUSTPD'                                      BUG26037
     C                   EVAL      DBKey = E5CUST                                           BUG26037
     C                   EVAL      DBase = 3                                                BUG26037
     C                   OUT       LDA                                                      BUG26037
     C                   EXSR      *PSSR                                                    BUG26037
     C                   ENDIF                                                              BUG26037
                                                                                            BUG26037
     C     E5CUST        CHAIN     SDINPHL0                                                 BUG26037
                                                                                            BUG26037
     C                   IF        NOT %FOUND (SDINPHL0)                                    BUG26037
     C                   EVAL      TIBRCA = BBBRCD                                          BUG26037
     C                   EVAL      TICUST = E5CUST                                          BUG26037
     C                   EVAL      TILSSD = *ZERO                                           BUG26037
     C                   EVAL      TIPGNO = *ZERO                                           BUG26037
     C***********        EVAL      TISTRQ = 'Y'                                   BUG26037 BUG26037A
     C                   EVAL      TIUTTH = *ZERO                                           BUG26037
     C                   EVAL      TITOUT = *ZERO                                           BUG26037
     C                   EVAL      TICUTH = E5EXTH                                          BUG26037
      *                                                                                    BUG26037A
      ** Get EU Tax Status                                                                 BUG26037A
      *                                                                                    BUG26037A
     C*****TICUST        CHAIN     SDACTXl1                                      BUG26037A BUG26037B
     C**********         IF        %FOUND(SDACTXl1)                              BUG26037A BUG26037B
     C     TICUST        CHAIN     SDACTXl4                                                BUG26037B
     C                   IF        %FOUND(SDACTXl4)                                        BUG26037B
     C                   IF        AXETXS = 'T'                                            BUG26037A
     C                   EVAL      TISTRQ = 'Y'                                            BUG26037A
     C                   ELSE                                                              BUG26037A
     C                   EVAL      TISTRQ = 'N'                                            BUG26037A
     C                   ENDIF                                                             BUG26037A
     C                   ENDIF                                                             BUG26037A
                                                                                            BUG26037
     C                   SELECT                                                             BUG26037
                                                                                            BUG26037
     C                   WHEN      E5JATP = 'Y'                                             BUG26037
     C                   EVAL      TIJOIN = TICUST                                          BUG26037
                                                                                            BUG26037
     C                   WHEN      E5JATP = 'I'                                             BUG26037
     C     E5CUST        CHAIN     SDJACCL4                                                 BUG26037
                                                                                            BUG26037
     C                   IF        %FOUND (SDJACCL4)                                        BUG26037
     C                   EVAL      TIJOIN =JCJANO                                           BUG26037
     C                   ELSE                                                               BUG26037
     C                   EVAL      TIJOIN = *BLANKS                                         BUG26037
     C                   ENDIF                                                              BUG26037
                                                                                            BUG26037
     C                   ENDSL                                                              BUG26037
                                                                                            BUG26037
     C                   WRITE     SDINPHD0                                                 BUG26037
     C                   ENDIF                                                              BUG26037
                                                                                            BUG26037
     C                   ENDIF                                                              BUG26037
                                                                                            BUG26037
     C                   READ      SDACUSPD                                                 BUG26037
     C                   ENDDO                                                              BUG26037
                                                                                            BUG26037
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     KEY           KLIST                                                              BUG26037
     C                   KFLD                    E5CUST                                     BUG26037
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = *blanks
     C                   EVAL      Recursive = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
