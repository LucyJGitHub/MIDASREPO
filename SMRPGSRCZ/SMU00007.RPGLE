     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Process CAR migration SDCSINPD - 01')         *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SMU00007 - German Feature migration for SDCSINPD             *
      *                                                               *
     ****Called By: SMUC00007******************************************         262664
      *  Called By: SMUC00213                                         *         262664
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. CER071             Date 01Aug16               *
      *  Prev Amend No. CER070             Date 19Aug14               *
      *                 CLE134             Date 01Aug12               *
      *                 262664             Date 11Nov09               *
      *                 B24746A            Date 16Jun09               *
      *                 B24416             Date 17Jun09               *
      *                 CSM011  *CREATE    Date 08May09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  262664  - SMUC00007 is now redundant in GF. New program name *
      *            is SMUC00213.                                      *
      *  B24746A - Further migration refinement.  Recompile.          *
      *  B24416 - Additional changes for join type.  (recompile)      *
      *  CSM011 - Midas SM Process CAR migration                      *
      *                                                               *
      *****************************************************************
      *
     FSMUGF07PD IF   E           K DISK
      * Template file for SDCSINPD
     FSMUGF01PD IF   E           K DISK
      * Template file for SDACUSPD
     FSDCSINL0  IF A E           K DISK
      * Midas SD Customer Income
     FSDACUSL0  IF   E           K DISK
      * Customer file
     FSDCCYXL1  IF   E           K DISK
      * Midas SD Currency codes
     FACCNTL1   IF   E           K DISK
      * Midas Account numbers
     FSDBANKPD  IF   E             DISK
      * Midas BAnk details
     FSDJACCL0  IF   E           K DISK
      * Joint Account Members
      /EJECT
      *
     D WKACCS          S             10S 0
     D @@DAYN          S              5S 0
     D WKCUST          S              6
     D WKDLNA          S              6
     D WKDLAC          S             12
     D WKACC           S             10
     D Recursive       S              1
     D WkDate          S              8S 0
     D WGINTC          S                   LIKE(FGINTC)
     D WGINTD          S                   LIKE(FGINTD)
     D WWHTC           S                   LIKE(FWHTC )
     D WWHTB           S                   LIKE(FWHTB )
     D WSCNC           S                   LIKE(FSCNC )
     D WSCNB           S                   LIKE(FSCNB )
     D WNINTC          S                   LIKE(FNINTC)
     D WNINTD          S                   LIKE(FNINTD)
     D WTADJC          S                   LIKE(FTADJC)
     D WTADJB          S                   LIKE(FTADJB)
     D WSADJC          S                   LIKE(FSADJC)
     D WSADJB          S                   LIKE(FSADJB)
     D WTHUSC          S                   LIKE(FTHUSC)
     D WTHUSD          S                   LIKE(FTHUSD)
     D PMode           S              7
     D PReport         S             10    INZ(*blanks)
     D PErrorMsg       S            100    INZ(*blanks)
      /COPY ZSRSRC,ZDATE9Z1LE
      /COPY ZSRSRC,ZDATE9Z2LE
      *
     C     *LOVAL        SETLL     SMUGF07D0
     C                   READ      SMUGF07D0
     C                   DOW       NOT %EOF
     C                   MOVE      FCUST         WKCUST
      *
     C                   EXSR      MoveDetail
     C     JoinAccInt    SETLL     SDCSIND0
     C                   IF        NOT %FOUND
     C                   WRITE     SDCSIND0
     C                   ELSE
     C                   EVAL      PErrorMsg='Duplicate record found in ' +
     C                             'SDCSINL0 for Customer '+
     C                             '-' + %CHAR(FCUST)
     C                   EXSR      ReportError
     C                   ENDIF
      *
     C                   READ      SMUGF07D0
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      *                                                               *
      * MoveDetail: Set field level values                            *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     MoveDetail    BEGSR
      *
      * Creation details.
     C                   EVAL      TSCUST=WKCUST
     C                   EVAL      TSRDNB=FCRTDT
     C                   EVAL      TSEDAT=FPSTD
      * Posting date / generation date.
     C                   EXSR      ExtDate1
      * Country of Tax.
     C                   EVAL      TSCTRT='DE'
      * Branch.
     C                   EVAL      TSBRCA=FBRCA
      * Joint Account Number: Cleared - set in SMU00009.
     C                   CLEAR                   TSJOIN
     C                   CLEAR                   TSINVP
      * Non Account Holder reference.
     C                   EVAL      TSNAHO=*BLANKS
      * Details set from Customer record.
     C     CustomerNo    CHAIN     @ACUSL0
     C                   IF        %FOUND
     C     CustomerNo    CHAIN     SMUGF01D0
     C                   IF        %FOUND
     C                   EXSR      MoveDetCust
     C                   ELSE
     C                   EVAL      PErrorMsg='Customer - '+%CHAR(FCUST) +
     C                             'not found SDACUSL0'
     C                   EXSR      ReportError
     C                   ENDIF
     C                   ENDIF
      * Set Tax basket; Tax account codes.
     C                   EXSR      TaxDet
      * Currency details.
     C                   EXSR      CurDet
      * Module ID.
     C                   SELECT
     C                   WHEN      FTRTP = 'GEHA'
     C                   EVAL      TSMODI='D'
     C                   WHEN      FTRTP = 'KORE'
     C                   EVAL      TSMODI='G'
     C                   WHEN      FTRTP = 'PEOY'
     C                   EVAL      TSMODI='G'
     C                   OTHER
     C                   EVAL      TSMODI='M'
     C                   ENDSL
      * Account details.
     C                   EXSR      AccDet
      * Instrument Ref.
     C                   SELECT
     C                   WHEN      TSMODI= 'D'
     C                   EVAL      TSINST= 'Deposit No. '+%TRIMR(%CHAR(TSDLLN))
     C                   WHEN      TSMODI= 'G'
     C                   MOVEL     TSIBAN        TSINST
     C                   OTHER
     C                   CLEAR                   TSINST
     C                   ENDSL
      *
     C                   CLEAR                   TSETYP
     C                   CLEAR                   TSSESN
     C                   CLEAR                   TSSRPN
     C                   CLEAR                   TSISIN
     C                   CLEAR                   TSPAMT
      * Amount details.
     C                   EXSR      AmntDet
      *
     C     MoveDetailE   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * MoveDetCust - Set details from M+ customer record             *
      *                                                               *
      * Called by: MoveDetails                                        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     MoveDetCust   BEGSR
      *
      * Customer status.
     C                   CLEAR                   TSSTAT
     C                   IF        FTAXI = 'E' OR
     C                             FTAXI = 'G'
     C                   EVAL      TSSTAT= 'T'
     C                   ENDIF
      *
     C                   MOVEL(P)  E5CNA1        TSFAMN
     C                   MOVEL(P)  E5CNA2        TSFIRN
     C                   EVAL      TSSTRT = %TRIMR(E5CNA3) + ' ' +
     C                                      %TRIMR(E5CNA4)
     C                   MOVEL     E5ZIPC        TSZIPC
     C                   MOVEL     E5CITY        TSCITY
     C                   MOVEL     BBCOLC        TSRCTR
     C                   MOVEL     E5DBTH        TSDBTH
     C                   MOVEL     E5TINO        TSRTIN
     C                   MOVEL     E5BTHT        TSTBTH
     C                   MOVEL     E5BTHC        TSCBTH
      *
     C                   Z-ADD     FVALD         @@DAYN
     C                   EXSR      ZDATE9
     C                   MOVE      @@VDT         TSIPDT
     C     MoveDetCustE  ENDSR
      *
      *****************************************************************
      *                                                               *
      * TaxDet - Set tax details                                      *
      *                                                               *
      * Called by: MoveDetail                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     TaxDet        BEGSR
      *
      * Tax Basket; Tax account code: Set to zero till feature is installed.
     C                   EVAL      TSTXBS = 0
     C                   EVAL      TSWTAC = 0
     C                   EVAL      TSSTXB = 0
     C                   EVAL      TSSTAC = 0
      * Tax rate.
     C                   IF        FESORA >=100
     C                   EVAL      PErrorMsg='Tax Rate > 100%: '+%CHAR(FESORA)+
     C                             ' unable to set in M+ format for Customer'+
     C                             '-' + %CHAR(FCUST)
     C                   EXSR      ReportError
     C                   ELSE
     C                   Z-ADD     FESORA        TSSTRA
     C                   ENDIF
      *
      * Secondary tax deducted at src in set Ccy.
     C                   EVAL      TSSTDS = TSSTDO
      *
      * Secondary tax deducted at src in Base Ccy.
     C                   EVAL      TSSTDB = TSSTDT
      *
      * Start date or Last int date.
     C                   EVAL      TSSLID = FSLID
      *
     C     TaxDetE       ENDSR
      *
      *****************************************************************
      *                                                               *
      * CurDet - Set currency, spot rate details                      *
      *                                                               *
      * Called by: MoveDetail                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     CurDet        BEGSR
     C                   EVAL      TSOCCY = FCCY
     C                   EVAL      TSOCSR = FSPRT
     C                   EVAL      TSTXCY = BJCYCD
     C                   EVAL      TSTCSR = 1
     C                   EVAL      TSXROS = 1
      *
     C     TSOCCY        CHAIN     @A6REA3
     C                   IF        NOT %FOUND
     C                   EVAL      PErrorMsg='Orignial Currency - '+TSOCCY +
     C                             ' not found on SDCCYXL1 - Customer - '+
     C                             %CHAR(FCUST)
     C                   EXSR      ReportError
     C                   LEAVESR
     C                   ENDIF
      *
      * Original
     C                   EVAL      TSOCMD = A6MDIN
     C                   EVAL      TSOCDP = A6NBDP
      * Settlement.
     C                   EVAL      TSSCCY = TSOCCY
     C                   EVAL      TSSCSR = TSOCSR
     C                   EVAL      TSSCMD = TSOCMD
     C                   EVAL      TSSCDP = TSOCDP
      * Tax.
     C     TSTXCY        CHAIN     @A6REA3
     C                   IF        NOT %FOUND
     C                   EVAL      PErrorMsg='Tax Currency - '+TSTXCY +
     C                             ' not found on SDCCYXL1 - Customer - '+
     C                             %CHAR(FCUST)
     C                   EXSR      ReportError
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      TSTCMD = A6MDIN
     C                   EVAL      TSTCDP = A6NBDP
      * Transaction Original.
     C                   EVAL      TSXRST = TSOCSR
     C                   EVAL      TSOSMD = TSOCMD
     C                   EVAL      TSSTMD = TSOCMD
     C     CurDetE       ENDSR
      *
      *****************************************************************
      *                                                               *
      * AccDet - Set account details                                  *
      *                                                               *
      * Called by: MoveDetail                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     AccDet        BEGSR
      *
      * Deal typ/sub type.
     C                   EVAL      TSTRTP = FDTYP
     C                   EVAL      TSTRST = FDLST
      * Deal Trade number.
     C                   SELECT
     C                   WHEN      FTRTP = 'GEHA'
     C                   CLEAR                   WKDLNA
     C                   MOVE      FDLAC         WKDLAC
     C                   EVAL      WKDLNA= %SUBST(WKDLAC:7)
     C                   MOVE      WKDLNA        TSDLLN
     C                   CLEAR                   TSACOD
     C                   CLEAR                   TSACSQ
     C                   CLEAR                   TSIBAN
      *
     C                   OTHER
      * Account Code, Account Seq.
     C                   CLEAR                   TSDLLN
     C                   CLEAR                   WKACC
     C                   MOVE      FDLAC         WKDLAC
     C                   EVAL      WKACC = %SUBST(WKDLAC:3)
     C                   MOVE      WKACC         WKACCS
     C     WKACCS        CHAIN     ACCNTABF
     C                   IF        NOT %FOUND
     C                   EVAL      PErrorMsg='Retail Account -'+WKACC +
     C                             ' not found on ACNUM - Customer - '+
     C                             %CHAR(FCUST)
     C                   EXSR      ReportError
     C                   ELSE
     C                   EVAL      TSACOD = ACOD
     C                   EVAL      TSACSQ = ACSQ
     C                   EVAL      TSIBAN = IBAN
     C                   ENDIF
     C                   ENDSL
      *
     C     AccDetE       ENDSR
      *
      *****************************************************************
      *                                                               *
      * AmntDet     - Set Amount details                              *
      *                                                               *
      * Called by: MoveDetails                                        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     AmntDet       BEGSR
      *
     C                   Z-ADD     FGINTC        WGINTC
     C                   Z-ADD     FGINTD        WGINTD
     C                   Z-ADD     FWHTC         WWHTC
     C                   Z-ADD     FWHTB         WWHTB
     C                   Z-ADD     FSCNC         WSCNC
     C                   Z-ADD     FSCNB         WSCNB
     C                   Z-ADD     FNINTC        WNINTC
     C                   Z-ADD     FNINTD        WNINTD
     C                   Z-ADD     FTADJC        WTADJC
     C                   Z-ADD     FTADJB        WTADJB
     C                   Z-ADD     FSADJC        WSADJC
     C                   Z-ADD     FSADJB        WSADJB
     C                   Z-ADD     FTHUSC        WTHUSC
     C                   Z-ADD     FTHUSD        WTHUSD
      *
     C     *KEY          READE     SMUGF07D0
     C                   IF        NOT %EOF
      * Check if account is a joint account: Set Cust and investment proportions.
     C     CustomerNo    CHAIN     SDJACCD0
     C                   IF        %FOUND
     C                   MOVE      TSJOIN        TSCUST
     C                   MOVEL     '1/1'         TSINVP
     C                   ENDIF
     C                   ENDIF
      *
     C                   DOW       NOT %EOF
      *
     C                   EVAL      WGINTC = WGINTC + FGINTC
     C                   EVAL      WGINTD = WGINTD + FGINTD
     C                   EVAL      WWHTC  = WWHTC  + FWHTC
     C                   EVAL      WWHTB  = WWHTB  + FWHTB
     C                   EVAL      WSCNC  = WSCNC  + FSCNC
     C                   EVAL      WSCNB  = WSCNB  + FSCNB
     C                   EVAL      WNINTC = WNINTC + FNINTC
     C                   EVAL      WNINTD = WNINTD + FNINTD
     C                   EVAL      WTADJC = WTADJC + FTADJC
     C                   EVAL      WTADJB = WTADJB + FTADJB
     C                   EVAL      WSADJC = WSADJC + FSADJC
     C                   EVAL      WSADJB = WSADJB + FSADJB
     C                   EVAL      WTHUSC = WTHUSC + FTHUSC
     C                   EVAL      WTHUSD = WTHUSD + FTHUSD
      *
     C     *KEY          READE     SMUGF07D0
     C                   ENDDO
     C     ResetKey      SETGT     SMUGF07D0
      *
      * Gross Interest in Ccy.
     C                   EVAL      TSGINT = WGINTC
      * Tax deducted at src in original currency.
     C                   EVAL      TSTXSR = WWHTC + WTADJC
      * Net interest in Orig Ccy.
     C                   EVAL      TSNINT = WNINTC
      * Tax Deducted at src in Original Ccy.
     C                   EVAL      TSTXSR = WWHTB + WTADJB
      * Net Int Amt in Tax Ccy.
     C                   EVAL      TSNINC = WNINTD
      * Secondary tax deducted at src in orig Ccy.
     C                   EVAL      TSSTDO = WSCNC + WSADJC
      * Secondary tax deducted at src in tax Ccy.
     C                   EVAL      TSSTDT = WSCNB + WSADJB
      * Gross int Amnt in Tax CCY.
     C                   EVAL      TSGINC = WGINTD+ WWHTB
      * Tax Deducted at Src in tax CCY.
     C                   EVAL      TSTXSC = WTADJB
      * Portion of Threshold used.
     C                   EVAL      TSPTHU = WTHUSC
      * Portion of Threshold used.
     C                   EVAL      TSPTUT = WTHUSD
      * Effective Tax Rate.
     C                   EVAL      TSTXRT = FETARA
      * Gross Int Amt in Set Ccy.
     C                   EVAL      TSGINS = TSGINT
      * Tax Deducted at Src in Set Ccy.
     C                   EVAL      TSTXSS = TSTXSR
      * Net int Amt in Set Ccy.
     C                   EVAL      TSNINS = TSNINT
      * Gross int Amt in Base CCY.
     C                   EVAL      TSGINB = TSGINC
      * Tax deducted at src in Base Ccy.
     C                   EVAL      TSTXSB = TSTXSC
      * Net int Amt in Base CCY.
     C                   EVAL      TSNINB = TSNINC
      * Principal Amt in Set Ccy.
     C                   EVAL      TSPAMS = 0
      * Principal Amt Tax Ccy.
     C                   EVAL      TSPAMC = 0
      * Principal Amt in Base CCY.
     C                   EVAL      TSPAMB = 0
      * Net int Amt in Base CCY.
     C                   EVAL      TSINPR = 'N'
      * Transcation no of last update.
     C                   EVAL      TSTNLU = 0
      *
     C     AmntDetE      ENDSR
      *
      *****************************************************************
      *                                                               *
      * ExtDate1 - Convert and extract year and month                 *
      *                                                               *
      * Called by: MoveDetails                                        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     ExtDate1      BEGSR
      *
     C                   Z-ADD     TSRDNB        @@DAYN
     C                   EXSR      ZDATE9
     C                   EVAL      TSTAXY=       @@YR
     C                   EVAL      TSTAXM=       @@Z71M
      *
     C     ExtDate1E     ENDSR
      *
      *****************************************************************
      *                                                               *
      * ReportError                                                   *
      *                                                               *
      * Called by: TaxDet, CurDet                                     *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     ReportError   BEGSR
      *
     C                   CALL      'UP008010'
     C                   PARM      '*WRITE'      PMode
     C                   PARM                    PReport
     C                   PARM                    PErrorMsg
     C                   CLEAR                   PErrorMsg
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
      *
     C     ReportErrorE  ENDSR
      *
      *****************************************************************
      *                                                               *
      * *INZSR - Program initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     CustomerNo    KLIST
     C                   KFLD                    WKCUST
      *
     C     JoinAccInt    KLIST
     C                   KFLD                    TSCTRT
     C                   KFLD                    TSBRCA
     C                   KFLD                    TSRCTR
     C                   KFLD                    TSCUST
     C                   KFLD                    TSIPDT
     C                   KFLD                    TSMODI
     C                   KFLD                    TSINST
      *
     C     ResetKey      KLIST
     C                   KFLD                    FBRCA
     C                   KFLD                    FCCY
     C                   KFLD                    FDLAC
     C                   KFLD                    FBITM
     C                   KFLD                    FRVIN
     C                   KFLD                    FTRTP
     C                   KFLD                    FSLID
     C                   READ      SDBANKPD
      *
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
      *****************************************************************
      * C Spec for ZDATE9
      /COPY ZSRSRC,ZDATE9Z3LE
      *
      * Compile time array for ZDATE9
      /COPY ZSRSRC,ZDATE9Z4
