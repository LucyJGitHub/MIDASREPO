     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GO BSPL Analysis Data Export')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOBSANXPT - BSPL Analysis Data Export                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 BUG6789            Date 21Apr05               *
      *                 CAS014             Date 10Aug05               *
      *                 CGP010  *CREATE    Date 17Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG6789- Add more fields to analysis data file               *
      *  CAS014 - IAS21 The Effects of Changes in Foreign Exchange    *
      *           Rates                                               *
      *  CGP010 - Global BSPL                                         *
      *                                                               *
      *****************************************************************
 
     FGPACBLZPD IP   E             DISK    INFSR(*PSSR)
     FGPBSADPD  O  A E             DISK    INFSR(*PSSR)
 
 
      * Branch Details
     D GZSDBRCH      E DS                  EXTNAME(GZSDBRCHPD)
      * Country Details
     D GPICTRY       E DS                  EXTNAME(GPICTRYPD)
      * Industry Details
     D GZSDINDS      E DS                  EXTNAME(GZSDINDSPD)
 
 
      * BSPL Analysis Data
     D GPBSAD        E DS                  EXTNAME(GPBSADPD)
     D CExpLevels             37    636
     D CEXPLV                 37    636    DIM(10)
 
 
     D                 DS
     D  SANLYSC                1    200
     D  ZoneOfData             1     10
     D  SubModule             11     14
 
     D  Cust_Details          14     31
     D  Cust                  15     24
     D  CustBranch            25     27
     D  CustCntyofCit         28     29
     D  CustCntyofLoc         30     31
     D  CustLocalInd          32     34
     D  CustLocalInst         35     36
     D  CustBankNonBk         37     37
     D  CustSWIFTFinI         38     38
 
     D  Prnt_Details          39     62
     D  Prnt                  39     48
     D  PrntBranch            49     51
     D  PrntCntyofCit         52     53
     D  PrntCntyofLoc         54     55
     D  PrntLocalInd          56     58
     D  PrntLocalInst         59     60
     D  PrntBankNonBk         61     61
     D  PrntSWIFTFinI         62     62
 
     D  TransactionID         63     82
 
     D  MatDate0              83     92
     D  MatDate1              93    100
     D  MatDate2             101    108
     D  MatDate3             109    116
     D  MatDate4             117    124
     D  MatDate5             125    132
     D  MatDate6             133    140
     D  MatDate7             141    148
     D  MatDate8             149    156
     D  MatDate9             157    164
                                                                                             BUG6789
     D  OrigCcy              165    167                                                      BUG6789
 
 
      * Input analysis codes
 
     C                   MOVEL     ANLYSC        SANLYSC
 
      * C U S T O M E R   D E T A I L S
 
      * Access Customer Name
 
     C                   MOVEL     CustBranch    I#BRCD
     C                   MOVEL     Cust          I#CUST
     C                   EXSR      ACS_CRNM
     C                   MOVEL     CustRepName   CustName         20
 
      * Access Customer Country of Citizenship
 
     C                   MOVEL     CustCntyofCit I#CTRY
     C     I#CTRY        IFNE      *BLANK
     C                   EXSR      ACS_CTRY
     C                   MOVEL     CNCNNM        CCName           30
     C                   ELSE
     C                   MOVEL     *BLANK        CCName
     C                   ENDIF
 
      * Access Customer Country of Location
 
     C                   MOVEL     CustCntyofLoc I#CTRY
     C     I#CTRY        IFNE      *BLANK
     C                   EXSR      ACS_CTRY
     C                   MOVEL     CNCNNM        CLName           30
     C                   ELSE
     C                   MOVEL     *BLANK        CLName
     C                   ENDIF
 
      * Access Customer Local Industry
 
     C                   MOVEL     ZoneOfData    I#ZONE
     C                   MOVEL     CustLocalInd  I#LICD
     C     I#LICD        IFNE      *BLANK
     C                   EXSR      ACS_INDS
     C                   MOVEL     AOLINA        CLIName          30
     C                   ELSE
     C                   MOVEL     *BLANK        CLIName
     C                   ENDIF
 
      * P A R E N T    D E T A I L S
 
      * Access Parent Name
 
     C                   MOVEL     PrntBranch    I#BRCD
     C                   MOVEL     Prnt          I#CUST
     C                   EXSR      ACS_CRNM
     C                   MOVEL     CustRepName   PrntName         20
 
      * Access Parent Country of Citizenship
 
     C                   MOVEL     PrntCntyofCit I#CTRY
     C     I#CTRY        IFNE      *BLANK
     C                   EXSR      ACS_CTRY
     C                   MOVEL     CNCNNM        PCName           30
     C                   ELSE
     C                   MOVEL     *BLANK        PCName
     C                   ENDIF
 
      * Access Parent Country of Location
 
     C                   MOVEL     PrntCntyofLoc I#CTRY
     C     I#CTRY        IFNE      *BLANK
     C                   EXSR      ACS_CTRY
     C                   MOVEL     CNCNNM        PLName           30
     C                   ELSE
     C                   MOVEL     *BLANK        PLName
     C                   ENDIF
 
      * Access Parent Local Industry
 
     C                   MOVEL     ZoneOfData    I#ZONE
     C                   MOVEL     PrntLocalInd  I#LICD
     C     I#LICD        IFNE      *BLANK
     C                   EXSR      ACS_INDS
     C                   MOVEL     AOLINA        PLIName          30
     C                   ELSE
     C                   MOVEL     *BLANK        PLIName
     C                   ENDIF
 
      * Export Data
 
     C                   EXSR      Export_Data
 
      /SPACE 5
      ********************************************************************
      * Export Data
      ********************************************************************
     C     Export_Data   BEGSR
 
     C                   MOVEL     DDRQID        RQID
     C                   MOVEL     DDRRQID       RRQID
 
     C                   MOVEL     A8BRCD        BRCA
     C                   MOVEL     A6CYCD        REPCCY
 
     C                   MOVEL     GRHIER        CExpLevels
 
     C                   EVAL      ACDESC = GRACOD +' '+ %SUBST(GRDESC:1:49)
 
     C                   EVAL      ZONE       = ZoneOfData
     C                   EVAL      SUBMOD     = SubModule
     C                   EVAL      CUSTOMER   = Cust  +' '+ CustName
     C                   EVAL      CUSTCTYCIT = CustCntyofCit +' '+ CCName
     C                   EVAL      CUSTCTYLOC = CustCntyofLoc +' '+ CLName
     C                   EVAL      CUSTLOCIND = CustLocalInd  +' '+ CLIName
     C                   EVAL      CUSTLOCINS = CustLocalInst
     C                   EVAL      CUSTBNK    = CustBankNonBk
     C                   EVAL      CUSTFININS = CustSWIFTFinI
     C                   EVAL      PARENT     = Prnt +' '+ PrntName
     C                   EVAL      PRNTCTYCIT = PrntCntyofCit +' '+ PCName
     C                   EVAL      PRNTCTYLOC = PrntCntyofLoc +' '+ PLName
     C                   EVAL      PRNTLOCIND = PrntLocalInd  +' '+ PLIName
     C                   EVAL      PRNTLOCINS = PrntLocalInst
     C                   EVAL      PRNTBNK    = PrntBankNonBk
     C                   EVAL      PRNTFININS = PrntSWIFTFinI
     C                   EVAL      TRANSID    = TransactionID
     C                   EVAL      MATURITY0  = MatDate0
     C                   EVAL      MATURITY1  = MatDate1
     C                   EVAL      MATURITY2  = MatDate2
     C                   EVAL      MATURITY3  = MatDate3
     C                   EVAL      MATURITY4  = MatDate4
     C                   EVAL      MATURITY5  = MatDate5
     C                   EVAL      MATURITY6  = MatDate6
     C                   EVAL      MATURITY7  = MatDate7
     C                   EVAL      MATURITY8  = MatDate8
     C                   EVAL      MATURITY9  = MatDate9
 
     C                   Z-ADD     SREPCCYBAL    TAMOUNT
                                                                                             BUG6789
     C                   EVAL      ORGCCY     = OrigCcy                                      BUG6789
 
     C                   WRITE     GPBSADD0
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      **********************************************************************************
      * Access branch details
      **********************************************************************************
     C     ACS_BRCH      BEGSR
     C                   CALL      'GPACSBRCH'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * Branch
     C                   PARM                    I#BRCD            3
     C                   PARM                    GZSDBRCH
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      ********************************************************************
      * Access Country Details
      ********************************************************************
     C     ACS_CTRY      BEGSR
     C                   CALL      'GPACSCTRY'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * country
     C                   PARM                    I#CTRY            2
     C                   PARM                    GPICTRY
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Access Industry Details
      ********************************************************************
     C     ACS_INDS      BEGSR
     C                   CALL      'GPACSINDS'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * local industry
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#LICD            3
     C                   PARM                    GZSDINDS
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Access Customer Report Name
      ********************************************************************
     C     ACS_CRNM      BEGSR
     C                   CALL      'GPACSCRNM'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * branch of customer
      * customer
     C                   PARM                    I#BRCD            3
     C                   PARM                    I#CUST           10
 
     C                   PARM                    CustRepName      20
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR - Initial Processing
      ********************************************************************
     C     *INZSR        BEGSR
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
 
      * Report Set Name
      * Maximum Level
 
     C                   PARM                    RepSetName       50
     C                   PARM                    MaximumLevel      2
 
      * Request Type
     C                   PARM                    DDRQTYP           1
      * Request ID
      * Related Request ID
     C                   PARM                    DDRQID           15
     C                   PARM                    DDRRQID          15
      * Zone or Global
      * Zone To Run Report
     C                   PARM                    DDZNGL            1
     C                   PARM                    DDZONE           10
      * Branch
      * Branch Group
      * Branch Consolidation
     C                   PARM                    DDBRC             3
     C                   PARM                    DDBRGRP          15
     C                   PARM                    DDBRCON           1
      * BSPL Report Set
      * Hierarchy Depth
      * Chart of Accounts
     C                   PARM                    DDRPSET          15
     C                   PARM                    DDHDPTH           2
     C                   PARM                    DDCHART           1
      * Relative Period Number
     C                   PARM                    DDRELPN           3
      * Calendar Year
      * Calendar Month
     C                   PARM                    DDCYR             2
     C                   PARM                    DDCMTH            2
      * Report Type
      * Report Movement Duration
     C                   PARM                    DDRPTYP           1
     C                   PARM                    DDRMDUR           1
      * Interim Currency Type
      * Interim Currency
      * Interim Currency Conv. Methd
      * Interim Currency Nom. Zone
     C                   PARM                    DDINTDTLS        15
      * Report Currency Type
      * Report Currency
      * Report Currency Conv. Methd
      * Report Currency Nom. Zone
     C                   PARM                    DDREPDTLS        15
      * A/c Code Breakdown
      * Print Zero Balances
      * Rounding
     C                   PARM                    DDACDBD           1
     C                   PARM                    DDPRTZB           1
     C                   PARM                    DDROUND           1
      * Include For. Ccy Transfer
      * Include Base Ccy Transfer
     C                   PARM                    DDIFCTFR          1
     C                   PARM                    DDIBCTFR          1
      * Instruction ID
     C                   PARM                    DDINSID          10
      * Description
     C                   PARM                    DDDESC           50
      * Export
     C                   PARM                    DDEXPRT           1
      * Sequence
     C                   PARM                    SEQUENCE          5
                                                                                              CAS014
      ** Interim Conversion of I/E using Average Rates                                        CAS014
      ** Interim Average Rate Period                                                          CAS014
      ** Interim Average Period End                                                           CAS014
      ** Reporting Conversion of I/E using Average Rates                                      CAS014
      ** Reporting Average Rate Period                                                        CAS014
      ** Reporting Average Period End                                                         CAS014
                                                                                              CAS014
     C                   PARM                    DDINTREP         14                          CAS014
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * *PSSR  --- ABNORMAL ERROR CONDITIONS
      *********************************************************************
     C     *PSSR         BEGSR
 
     C     RunBefore     IFEQ      *BLANKS
 
     C                   MOVE      'Y'           RunBefore         1
 
     C                   DUMP
     C                   ENDIF
 
     C                   SETON                                        LRU7U8
     C                   RETURN
 
     C                   ENDSR
      *********************************************************************
