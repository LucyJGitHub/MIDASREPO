     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Retail Accounts Accruals at Eff Dates')       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  GL000560- GL Deals Accruals Extract at Effective Dates       *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12671           Date 14Nov06               *
      *                 BUG11626           Date 28Jun06               *
      *                 CSD027A            Date 09May06               *
      *                 CGL035             Date 01Mar05               *
      *                         *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  BUG12671 - I/O error in PF/SDTXBSL1 due to missing key.      *
      *  BUG11626 - GLC0561 failed                                    *
      *  CSD027A- Conversion of cust. no. to alpha (post 103 build)   *
      *  CGL035 - EUSD Upgrade to MidasPlus                           *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
 
      ** Midas SD Branch codes retrieval
     FSDBRCHL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD Tax basket details
     FSDTXBSL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas RE Retail accrued Int. to date det
     FREACRDL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas GL EU Tax Accruals at Effective Dates
     FGLETXAL1  UF A E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
 
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
 
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  ErrorOnFl             01     01
     D  EndOfFile             02     02
     D  RecNotFnd             03     03
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for access programs, long data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, short data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Externally described DS for locn details
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)
 
      ** Externally described DS for Country of tax details
     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)
 
      ** Externally described DS for Midas GL Account details
     D SDACCT        E DS                  EXTNAME(ACCNTAB)
 
      ** True and False can be used for indicators being on or off.
     D True            C                   *On
     D False           C                   *Off
 
      ** Parameters for access object programs
     D PRTCD           S              7
     D POPTN           S              7
 
      ** Parameters for Location access object programs
     D PLOCN           S              3
 
      ** Parameters for Country of Tax access object programs
     D PCTRR           S              2
     D PCTRT           S              2    INZ(' ')
 
      ** Parameters for Tax Basket access object programs
     D PTXBS           S              2
 
      ** Parameters for GL Account access object programs
     D PRETL           S             10
     D PCNUM           S              6
     D PACCY           S              3
     D***PACOD**         S              4                                                     CGL035
     D PACOD           S             10                                                       CGL035
     D PACSQ           S              2
     D PBRCA           S              3
     D***WACOD**         S              4                                                     CGL035
     D WACOD           S             10                                                       CGL035
     D WCUST           S              6
     D WASEQ           S              2
 
      ** Work Field for Branch Code
     D WBRCA           S              3
 
      ** Work Field for GL EU Tax Accruals
     D***WTRRF**         S             18                                                     CGL035
     D WTRRF           S             24                                                       CGL035
     D WMODI           S              1    INZ('G')
 
      ** Work Field for MIDAS GL Acct master
     D WLCID           S              5P 0
     D WNCID           S              5P 0
 
      ** Work Field for Current run date from SDBANK file
     D WDATE           S              5P 0
 
      ** Other fields used
     D @RUN            S              1
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      *                                                               *
      * MAIN - Main processing                                        *
      *                                                               *
      *****************************************************************
 
      ** Set file pointer to first record and do initial read.
 
     C     *LOVAL        SETLL     SDBRCHL1
     C                   READ      SDBRCHL1
 
      ** Read until a record is not found
 
     C                   DOW       NOT %EOF(SDBRCHL1)
 
      ** Move Branch Code to Work Variable
 
     C                   EVAL      WBRCA = A8BRCD
 
      ** Retrieve Location with Standard DBase Error Mgt
 
     C                   EXSR      SRFNDLOC
 
      ** Retrieve Country of Tax with Standard DBase Error Mgt
 
     C                   EXSR      SRFNDCTX
 
     C                   IF        PRTCD = *Blanks
     C                             AND PTXBS <> *BLANKS                                     BUG11626
     C                   EXSR      SRProcRE
     C                   ENDIF
 
      ** Read next record of Branch File
 
     C                   READ      SDBRCHL1
 
     C                   ENDDO
 
      ** Set-on LR
 
     C                   EVAL      *INLR = *ON
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: Main Processing                                        *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'GL000561'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY =  *BLANKS
     C                   EVAL      DBASE = 0
     C                   OUT       LDA
 
      ** Database error management
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST  '    POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY  = POPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 90
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
 
      ** Retrieve current run date
 
     C                   EVAL      WDATE = BJRDNB
     C                   ENDIF
 
      ** KLIST for SDTXBSL1
 
     C     TXBKEY        KLIST
     C                   KFLD                    PCTRT
     C                   KFLD                    PTXBS
 
      ** KLIST for GLETXAL1
 
     C     GLEKEY        KLIST
     C                   KFLD                    WMODI
     C                   KFLD                    WTRRF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFNDLOC - Retrieve Location                                  *
      *                                                               *
      *****************************************************************
     C     SRFNDLOC      BEGSR
 
      ** Access Location Details
 
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      A8LCCD        PLOCN
     C     SDLOCN        PARM      SDLOCN        DSFDY
 
      * Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY  = A8LCCD
     C                   EVAL      DBFILE = 'SDLOCNPD'
     C                   EVAL      DBASE  = 91
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFNDCTX - Retrieve Country of Tax                            *
      *                                                               *
      *****************************************************************
     C     SRFNDCTX      BEGSR
 
      ** Access Country of Tax Details
 
     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DVCNCD        PCTRT
     C                   PARM      *BLANKS       PCTRR
     C     SDCTTX        PARM      SDCTTX        DSFDY
 
      * Retrieve Tax Basket
 
     C                   EVAL      PTXBS = EWTXBS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFNDACT - Retrieve GL Account Master                         *
      *                                                               *
      *****************************************************************
     C     SRFNDACT      BEGSR
 
      ** Access GL Account Details
 
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      *BLANKS       PRETL
     C                   PARM      WCUST         PCNUM
     C                   PARM      ACCY          PACCY
     C                   PARM      WACOD         PACOD
     C                   PARM      WASEQ         PACSQ
     C                   PARM      BRCA          PBRCA
     C     SDACCT        PARM      SDACCT        DSSDY
 
      * Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY  = PCNUM + PACCY + PACOD +
     C                                      PACSQ + PBRCA
     C                   EVAL      DBFILE = 'ACCNTAB'
     C                   EVAL      DBASE  = 93
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
 
      * Retrieve Last and Next Interest Date
 
     C                   EVAL      WLCID = LCID
     C                   EVAL      WNCID = NCID
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWRTGLE - Subroutine to write the fields to PF/GLETXAPD     *
      *                                                               *
      *****************************************************************
     C     SRWRTGLE      BEGSR
 
      ** Check if same Module ID and Transaction Ref already exist
 
     C     GLEKEY        CHAIN     GLETXAL1                           99
 
     C                   IF        NOT %FOUND(GLETXAL1)
 
      ** Replace Module ID with constant value 'G'
 
     C                   EVAL      EAMODI = WMODI
 
      ** Replace Transaction Ref Variable with Branch Code
 
     C                   EVAL      EATRRF = WTRRF
 
      ** Replace Transaction Reference with last Change Date(REACRD)
 
     C                   EVAL      EAACDT = LCD
 
      ** Do computation to get the value of Interese Accrued
 
     C                   EVAL      EAACCR = CAIC1 + MACI + GACI
 
      ** Replace Last Interest Date with ACCNT.LCID
 
     C                   EVAL      EAISDT = WLCID
 
      ** Replace Next Interest Date with ACCNT.NCID
 
     C                   EVAL      EAIEDT = WNCID
 
      ** Replace Accrual Process Indicator with constant 'N'
 
     C                   EVAL      EAACPR = 'N'
 
      ** Write the record to GLETXAPD File
 
     C                   WRITE     GLETXAD0
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcRE - Process Retail Records                            *
      *                                                               *
      *****************************************************************
     C     SRProcRE      BEGSR
 
      ** Check from SDTXBSL1
 
     C     TXBKEY        SETLL     SDTXBSL1
     C     TXBKEY        READE     SDTXBSD0                                                 BUG12671
     C**********         READE     SDTXBSD0                                                 BUG12671
 
      ** Read until a record is not found
 
     C                   DOW       NOT %EOF(SDTXBSL1)
 
      ** If a rate change occur and effective Date is lower than Run Date
 
     C                   IF        TBTYLC = 'A' and TBLCD = WDATE and
     C                             TBEFDT < WDATE
 
      ** Set pointer to first record of REACRD to read and extract
 
     C     *LOVAL        SETLL     REACRDL1
     C                   READ      REACRDF
 
      ** Read until a record is not found
 
     C                   DOW       NOT %EOF(REACRDL1)
 
     C                   IF        RECI = 'D'
 
      ** Move Branch Code to Transaction Ref Variable
 
     C                   MOVE      ACOD          WACOD
     C                   MOVE      CUST          WCUST
     C                   MOVE      ASEQ          WASEQ
 
      ** Move Branch Code to Transaction Ref Variable
 
     C                   EVAL      WTRRF = WBRCA+WCUST+ACCY+WACOD+WASEQ
 
      ** Retrieve GL Account Master with Standard DBase Error Mgt
 
     C                   EXSR      SRFNDACT
 
      ** Process record from REACRD and write to GLETXAPD
 
     C                   EXSR      SRWRTGLE
 
     C                   ENDIF
 
      ** Read next record
 
     C                   READ      REACRDF
 
     C                   ENDDO
 
     C                   ENDIF
 
      ** Read next record of Tax Basket Details
 
     C     TXBKEY        READE     SDTXBSD0
 
     C                   ENDDO
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR   -  Error Handling Subroutine                         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
