     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD EU W/H Tax Exchange of Info Extract')         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000773 - EU Withholding Tax Exchange of Information Extract*
      *                                                               *
      *  Function:  This program will run on request when CGL032      *
      *             feature is implemented to extract Data from       *
      *             PF/SDCSINPD Customer Income file to populate      *
      *             PF/SDEXINPD Midas SD EU Withholding Tax Exchange  *
      *             of Information file.                              *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. CGL157             Date 17Aug15               *
      *                 MD046248           Date 27Oct17               *
      *                 CER070             Date 19Aug14               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 BUG23123           Date 09Mar09               *
      *                 BUG22529           Date 10Feb09               *
      *                 CER048             Date 19May08               *
      *                 CER034             Date 06Aug08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 03May06               *
      *                 232543             Date 01Apr05               *
      *                 CGL035             Date 01Mar05               *
      *                 CGL032 *CREATE     Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  CGL157 - CRS Reporting (Recompile)                           *
      *  MD046248 - Finastra Rebranding                               *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG23123 - Report: Does not show Retail Account Number       *
      *                     Date is not Midas Standard Date           *
      *                     Period should be actual int. calc. period *
      *                     Secondary Tax amount is not printed       *
      *                     Added field TSSLID                        *
      *                     (Recompile)                               *
      *  BUG22529 - Global Additional Customer Details (Recompile)    *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER034 - German Features - New Fields and Enquiries          *
      *           (Recompile)                                         *
      *  CSD027A - Conversion of customer number to alpha (post       *
      *            build 103). Recompiled.                            *
      *  232543 - Fix to CGL032 (Recompile)                           *
      *  CGL035 - EUSD Upgrade to MidasPlus                           *
      *  CGL032 - Automatic Exchange of Information                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRClrFld - Clear fields for next record                       *
      * SREXIFmt - Format PF/SDEXINPD fields for update               *
      * SRGetISO - Retrieve ISO Country code from PF/SDCTRYPD         *
      * SRAccCUS - Access Branch Internal Customer's Main and         *
      *            Additional Details                                 *
      * SRGetSWC - Retrieve Swift Currency Code from PF/SDCURRPD      *
      * *INZSR  - Initialise                                          *
      * *PSSR   - Error processing                                    *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** SD Customer Income
     FSDCSINLA  UF   E           K DISK    INFSR(*PSSR)
 
      ** EU Withholding Tax Exchange of Info
     FSDEXINPD  UF A E             DISK    INFSR(*PSSR)
 
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      **  Short DS for access programs
     D DSFDY         E DS                  Extname(DSFDY)
 
      ** DS for access objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Externally described DS for Branch Details
     D SDBRCH        E DS                  Extname(SDBRCHPD)
 
      ** Externally described DS for Customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTL1)
 
      ** Externally described DS for Branch Details
     D SDACUS        E DS                  EXTNAME(SDACUSPD)
 
      ** Externally described DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Externally described DS for Country Details
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
 
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
 
      ** Parameters for access object programs
     D PRtcd           S              7
     D POptn           S              7
     D PKeySts         S              7
     D PBrcd           S              3
     D PCust           S             10
     D PCncd           S              2
     D POccy           S              3
 
      ** Other fields used
     D WRun            S              1
     D WDiff           S              5  0 INZ(0)
     D WRCTR           S              2
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Set file pointer to first record and do initial read.
 
     C     *LOVAL        SETLL     SDCSINLA
     C                   READ      SDCSINLA
 
      ** Read until a record is not found
 
     C                   DOW       NOT %EOF(SDCSINLA)
 
      ** Process record from SDCSINPD
 
     C                   EXSR      SRClrFld
     C                   EXSR      SREXIFMT
     C                   WRITE     SDEXIND0
 
      ** Tag record from SDCSINPD as processed
 
     C                   EVAL      TSINPR = 'Y'
     C                   UPDATE    SDCSIND0
 
     C                   READ      SDCSINLA
     C                   ENDDO
 
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClrFld - Subroutine to clear fields for next record        *
      *                                                               *
      *****************************************************************
     C     SRClrFld      BEGSR
 
     C                   EVAL      WRCTR = *BLANKS
     C                   EVAL      F001 = *ZEROS
     C                   EVAL      F002 = *BLANKS
     C                   EVAL      F003 = *BLANKS
     C                   EVAL      F007 = *BLANKS
     C                   EVAL      F008 = *ZEROS
     C                   EVAL      F009 = *BLANKS
     C                   EVAL      F010 = *BLANKS
     C                   EVAL      F014 = *BLANKS
     C                   EVAL      F016 = *BLANKS
     C                   EVAL      F028 = *ZEROS
     C                   EVAL      F029 = *BLANKS
     C                   EVAL      F030 = *BLANKS
     C                   EVAL      F032 = *BLANKS
     C                   EVAL      F033 = *BLANKS
     C                   EVAL      F045 = *ZEROS
     C                   EVAL      F046 = *BLANKS
     C                   EVAL      F047 = *BLANKS
     C                   EVAL      F050 = *BLANKS
     C                   EVAL      F051 = *BLANKS
     C                   EVAL      F052 = *BLANKS
     C                   EVAL      F054 = *BLANKS
     C                   EVAL      F055 = *BLANKS
     C                   EVAL      F088 = *BLANKS
     C                   EVAL      F090 = *BLANKS
     C                   EVAL      F091 = *BLANKS
     C                   EVAL      F092 = *ZEROS
     C                   EVAL      F101 = *BLANKS
     C                   EVAL      F102 = *BLANKS
     C                   EVAL      F103 = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREXIFmt - Subroutine to format PF/SDEXINPD fields before    *
      *             record is written                                 *
      *                                                               *
      *****************************************************************
     C     SREXIFmt      BEGSR
 
     C                   EVAL      F001 = 1
 
     C                   EVAL      WRCTR = TSRCTR
     C                   IF        WRCTR <> *BLANKS
     C                   EXSR      SRGetISO
     C                   EVAL      F002 = A4ISOC
     C                   ENDIF
 
     C                   IF        TSRTIN <> *BLANKS
     C                   EVAL      F003 = TSRTIN
     C                   EVAL      F007 = *BLANKS
     C                   EVAL      F014 = *BLANKS
     C                   EVAL      F016 = *BLANKS
     C                   ELSE
     C                   EVAL      F003 = *BLANKS
     C                   EVAL      F007 = TSDBTH
     C                   EVAL      F014 = TSTBTH
     C                   EVAL      F016 = TSCBTH
     C                   ENDIF
 
     C                   EVAL      F008 = *ZEROS
     C                   EVAL      F009 = TSFAMN
     C                   EVAL      F010 = TSFIRN
     C                   EVAL      F028 = *ZEROS
     C                   EVAL      F029 = TSSTRT
     C                   EVAL      F030 = TSCITY
     C                   EVAL      F032 = TSZIPC
     C                   EVAL      F033 = A4ISOC
     C                   EVAL      F045 = *ZEROS
 
     C                   IF        TSBRCA <> *BLANKS
     C                   EXSR      SRAccCUS
     C                   EVAL      F046 = E5CNA1
     C                   EVAL      F047 = E5CNA2
     C                   EVAL      F051 = E5CNA3 + E5CNA4
     C                   EVAL      F052 = E5CITY
     C                   EVAL      F054 = E5ZIPC
 
     C                   EVAL      WRCTR = BBCOLC
     C                   EXSR      SRGetISO
     C                   EVAL      F055 = A4ISOC
     C                   ENDIF
 
     C                   EVAL      F050 = *ZEROS
 
     C                   EVAL      F088 = TSIPDT
 
     C                   IF        TSMODI = 'S' and TSETYP = *BLANKS
     C                             or TSMODI = 'S' and TSETYP = 'MT'
     C                   EVAL      F090 = '2X '
     C                   ELSE
     C                   EVAL      F090 = '1X '
     C                   ENDIF
 
     C                   EXSR      SRGetSWC
     C                   EVAL      F091 = A6SWCY
 
     C                   SELECT
     C                   WHEN      TSOCDP = 0
     C                   EVAL      F092 = TSGINT
     C                   WHEN      TSOCDP = 1
     C                   EVAL      F092 = TSGINT / 10
     C                   WHEN      TSOCDP = 2
     C                   EVAL      F092 = TSGINT / 100
     C                   WHEN      TSOCDP = 3
     C                   EVAL      F092 = TSGINT / 1000
     C                   ENDSL
 
     C                   EVAL      F101 = TSINST
     C                   EVAL      F102 = *BLANKS
 
     C                   SELECT
     C                   WHEN      TSMODI = 'G'
     C                   EVAL      F103 = TSIBAN
     C                   WHEN      TSMODI = 'S'
     C                   EVAL      F103 = TSISIN
     C                   WHEN      TSMODI = 'D'
     C                   EVAL      F103 = TSINST
     C                   ENDSL
 
     C                   EVAL      FILL01 = *BLANKS
     C                   EVAL      FILL02 = *BLANKS
     C                   EVAL      FILL03 = *BLANKS
     C                   EVAL      FILL04 = *BLANKS
     C                   EVAL      FILL05 = *BLANKS
     C                   EVAL      FILL06 = *BLANKS
     C                   EVAL      FILL07 = *BLANKS
     C                   EVAL      FILL08 = *BLANKS
     C                   EVAL      FILL09 = *BLANKS
     C                   EVAL      FILL10 = *BLANKS
     C                   EVAL      FILL11 = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetISO - Subroutine to retrieve ISO Country code from      *
      *             PF/SDCTRYPD                                       *
      *                                                               *
      *****************************************************************
     C     SRGetISO      BEGSR
 
     C                   IF        WRCTR <> *BLANKS
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      WRCTR         PCncd
     C     SDCTRY        PARM      SDCTRY        DSFDY
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCTRYPD'
     C                   EVAL      DBKEY  = PCncd
     C                   EVAL      DBPGM  = 'SD000773'
     C                   EVAL      DBASE  = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAccCUS - Subroutine to access corresponding Main and       *
      *             Additional Details of Branch's Internal Customer  *
      *                                                               *
      *****************************************************************
     C     SRAccCUS      BEGSR
 
     C**********         CALL      'AOBRCHR0'                                                 CGL035
     C                   CALL      'AOBRCHR1'                                                 CGL035
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      TSBRCA        PBrcd
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL035
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL035
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBKEY  = PBrcd
     C                   EVAL      DBPGM  = 'SD000773'
     C                   EVAL      DBASE  = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      A8BICN        PCust
     C                   PARM      *BLANKS       PKeySts
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBKEY  = PCust
     C                   EVAL      DBPGM  = 'SD000773'
     C                   EVAL      DBASE  = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      A8BICN        PCust
     C     SDACUS        PARM      SDACUS        DSSDY
      *
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDACUSPD'
     C                   EVAL      DBKEY  = PCust
     C                   EVAL      DBPGM  = 'SD000773'
     C                   EVAL      DBASE  = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetSWC - Subroutine to retrieve Swift Currency Code from   *
      *             PF/SDCURRPD                                       *
      *                                                               *
      *****************************************************************
     C     SRGetSWC      BEGSR
 
     C                   IF        TSOCCY <> *BLANKS
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      TSOCCY        POccy
     C     SDCURR        PARM      SDCURR        DSSDY
     C
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY  = POptn
     C                   EVAL      DBPGM  = 'SD000773'
     C                   EVAL      DBASE  = 5
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *DTAARA       DEFINE                  LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'SD000773'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY =  *BLANKS
     C                   EVAL      DBASE = 0
     C                   OUT       LDA
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
 
     C                   ENDSR
