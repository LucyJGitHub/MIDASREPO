     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO BSPL Analysis File Extract')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOBSANEXT - BSPL Analysis File Extract                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. BUG6789            Date 21Apr05               *
      *                 BUG6543            Date 08Apr05               *
      *                 CGP010  *CREATE    Date 17Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG6789 - Add more fields to analysis data file              *
      *  BUG6543 - MRTRAPXPD file is not purged.                      *
      *  CGP010 - Global BSPL                                         *
      *                                                               *
      *****************************************************************
 
     F*MRTRAPPD**IP***E*************DISK****INFSR(*PSSR)                                     BUG6543
     FMRTRAPXPD IP   E             DISK    INFSR(*PSSR)                                      BUG6543
     FMRTRDTPD  IF   E           K DISK    INFSR(*PSSR)                                      BUG6543
     FGOBSANEPD O    E             DISK    INFSR(*PSSR)
 
 
      * Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
 
     D                 DS
     D  ANLYSC                 1    200
     D  ZoneOfData             1     10
     D  SubModule             11     14
 
     D  Cust_Details          15     38
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
 
 
     IMRTRAPD0      01                                                                       BUG6543
     I                                          EXTDAT        L1                             BUG6543
                                                                                             BUG6543
                                                                                             BUG6543
     C   L1EXTDAT        CHAIN     MRTRDTD0                           99                     BUG6543
     C   L1                                                                                  BUG6543
     CAN 99              MOVEL     'X'           RECTYP                                      BUG6543
                                                                                             BUG6543
     C     RECTYP        IFEQ      'M'                                                       BUG6543
                                                                                             BUG6543
     C                   MOVEL     EXBRCH        BRCA
     C                   MOVEL     EXCYCD        CCY
     C                   MOVEL     EXPACC        ACOD
 
     C                   MOVEL     EXCY          YR
     C                   MOVEL     EXCM          PR
 
     C                   MOVEL     EXPDCI        EPBLDC
     C     EXPAMT        MULT      EXPSGN        EPBLAC
 
     C                   EXSR      DET_ANALYSIS
 
     C                   MOVEL     I#ZONE        A1ZONE
 
      * Write BSPL Analysis record (extract)
 
     C     EXSTAT        IFNE      'N'
     C     EXSTAT        ANDNE     'S'
     C                   WRITE     GPBSAND0
     C                   ENDIF
     C                   ENDIF                                                               BUG6543
 
      /SPACE 5
      ********************************************************************
      * Determine Analysis Codes
      ********************************************************************
     C     DET_ANALYSIS  BEGSR
 
     C                   MOVEL     I#ZONE        ZoneOfData
     C                   MOVEL     EXSUB         SubModule
 
 
     C                   MOVEL     EXCUSN        Cust
 
      * Access customer branch
 
     C                   MOVEL     EXCUSN        I#LFD1
     C                   EXSR      ACS_CUST
     C                   MOVEL     BBBRCD        CustBranch
     C                   MOVEL     EXCCIT        CustCntyofCit
     C                   MOVEL     EXCLOC        CustCntyofLoc
     C                   MOVEL     EXCIND        CustLocalInd
     C                   MOVEL     EXCINT        CustLocalInst
     C                   MOVEL     EXCBNK        CustBankNonBk
     C                   MOVEL     EXCSWF        CustSWIFTFinI
 
 
     C                   MOVEL     EXPARN        Prnt
 
      * Access parent branch
 
     C                   MOVEL     EXPARN        I#LFD1
     C                   EXSR      ACS_CUST
     C                   MOVEL     BBBRCD        PrntBranch
     C                   MOVEL     EXPCIT        PrntCntyofCit
     C                   MOVEL     EXPLOC        PrntCntyofLoc
     C                   MOVEL     EXPIND        PrntLocalInd
     C                   MOVEL     EXPINT        PrntLocalInst
     C                   MOVEL     EXPBNK        PrntBankNonBk
     C                   MOVEL     EXPSWF        PrntSWIFTFinI
 
     C     Prnt          IFEQ      *BLANK
     C                   MOVEL     Cust_Details  Prnt_Details
     C                   ENDIF
 
     C                   MOVEL     EXTRID        TransactionID
 
     C                   MOVEL     EXMDT0        MatDate0
     C                   MOVEL     EXMDT1        MatDate1
     C                   MOVEL     EXMDT2        MatDate2
     C                   MOVEL     EXMDT3        MatDate3
     C                   MOVEL     EXMDT4        MatDate4
     C                   MOVEL     EXMDT5        MatDate5
     C                   MOVEL     EXMDT6        MatDate6
     C                   MOVEL     EXMDT7        MatDate7
     C                   MOVEL     EXMDT8        MatDate8
     C                   MOVEL     EXMDT9        MatDate9
                                                                                             BUG6789
     C                   MOVEL     EXCYCD        OrigCcy                                     BUG6789
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Access customer
      ********************************************************************
     C     ACS_CUST      BEGSR
     C                   CALLB     'MXACSCUST2'
     C/COPY MXCPYSRC,MXACSPRME
     C                   MOVEL     InData        SDCUST
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR - Initial Processing
      ********************************************************************
     C     *INZSR        BEGSR
     C     *ENTRY        PLIST
     C                   PARM                    I#ZONE           10
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
