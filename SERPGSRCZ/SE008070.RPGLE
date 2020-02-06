     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Fiscal Price Set up on Priced Init')          *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE008070 - SE Fiscal Price Set up on Priced                  *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 05May06               *
      *                 BUG11164           Date 06Apr06               *
      *                 236137             Date 20Sep05               *
      *                 236453             Date 31Aug05               *
      *                 236822             Date 10Aug05               *
      *                 235045             Date 26Jun05               *
      *                 234675             Date 05Jul05               *
      *                 234440             Date 21Jun05               *
      *                 236823             Date 18Jun05               *
      *                 233615 *CREATE     Date 16May05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  BUG11164 - A Serious Midas Error on SETRAD insert/amend      *
      *  236137 - Change Control for CGL031 Parts 4 & 5.              *
      *           Several changes in the Taxation of Savings Income   *
      *           functionality.                                      *
      *           - Choice of calculation method for fiscal price     *
      *           must take in account Tax Calculation Basis          *
      *           indicator from Country of Tax Codes file SDCTTXPD.  *
      *  236453 - Only consider Live or Matured records.              *
      *  236822 - Price incorrect on written records on PRICED        *
      *  235045 - Take-on after effective date                        *
      *  234675 - Change control for processing type 4 and Dividend   *
      *           EU tax calculation (Recompile).                     *
      *  234440 - Change Control 1 Part 4 - For Switzerland only,     *
      *           bonds at at a discount will have their fiscal price *
      *           calculated on a yield curve.                        *
      *  236823 - Need to update trailer file when add a new record   *
      *  233615 - Takeon programs for CGL031                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Function of Indicators                                       *
      *                                                               *
      *  90 - End of file for TRADS                                   *
      *  91 - Record not found in SDSECSL1                            *
      *  92 - Record not found in SECTY                               *
      *  93 - Record not found in INVTP                               *
      *  94 - End of file for PRICM                                   *
      *  99 - Error in update for TRADS                               *
      *                                                               *
      *  LR - Last record indicator (program termination)             *
      *  U7 and U8 - DB error processing indicator                    *
      *                                                               *
      *****************************************************************
      /SPACE
      *****************************************************************
      *                                                               *
      *  Subroutine Index                                             *
      *                                                               *
      *  SRFilter   - Determines if the fiscal price should be input  *
      *  SRFndBnd   - Determines if the security is a bond or fund    *
      *  SRFunds    - Calculate the Fund fiscal price                 *
      *  SRBonds    - Calculate the Bond fiscal price                 *
      *  SRPercent  - Convert the yield into percentage               *
      *  *PSSR      - Program exception error routine                 *
      *  *INZSR     - Initial First Cycle processing                  *
      *  SRERR      - File error                                      *
      *                                                               *
      *****************************************************************
 
      ** Midas SE Securities
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SE Investment Types
     FINVTP     IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SE Price
     FPRICM     UF A E           K DISK    INFSR(*PSSR)
     FPRICEA    UF   E           K DISK    INFSR(*PSSR)                                       236823
     FSECEO     IF   E           K DISK    INFSR(*PSSR)                                       236822
     F                                     RENAME(SNDEVDF:SNDEVDO)                            236822
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
 
     ** +--------------------------------------+
     ** ¦ Arrays and Data Structures           ¦
     ** ¦ ==========================           ¦
     ** +--------------------------------------+
 
      ** External DS for bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Securities Clients
     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)
 
      ** Security Details                                                                     234440
     D SECTYDS       E DS                  EXTNAME(SECTYD)                                    234440
     D   CDDS                183    230                                                       234440
     D   CRDS                231    242                                                       234440
                                                                                              234440
      ** Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters
     D PRtcd           S              7A
     D POptn           S              7A
     D PCust           S             10A
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
      ** Working Variables
     D WFPrice         S              1A
     D WBFClas         S              1A
     D WSetx           S              1A
     D WPtyp           S              2A
     D WSesn           S             10A
     D WPdat           S              5P 0
     D WPcst           S              6P 0
     D WMaty           S              5P 0
     D WPram           S             15P 8
     D WFspr           S             15P 8
     D WStbs           S              1A
     D SCUMEX          S              1A
     D WRkpi           S             15P 9
     D WIssd           S              5P 0
     D WIssp           S             15P 8
     D WTddt           S              5P 0
     D WTdvd           S              5P 0
     D WType           S              1A
     D WVlcy           S              3A
     D WSitp           S              3A
     D ZPRCOT          S             15P 8
     D ZYLDOK          S              1A
 
     D K_SESN          S             10A                                                      236822
     D K_PTYP          S              2A                                                      236822
     D K_PDAT          S              5  0                                                    236822
 
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - MAIN BODY                                              *
      *                                                               *
      *****************************************************************
 
     C                   Z-ADD     *ZEROS        WrkPEXI
      ** Set file pointer to start of file
 
     C     *LOVAL        SETLL     SECTY
     C                   READ      SECTY
     C
     C                   DOW       Not%EOF(SECTY)
 
     C************       IF        RECI = 'D'                                                 235058
     C                   If        RECI = 'D' or RECI = 'M' and MATY >= EWEDT1                236453
     C                   EXSR      SRInvtp
 
     C                   IF        PROT <> '2' AND PROT <> '4'
     C                             AND PROT <> '7'
 
     C                   IF        ISSP = 0 OR
     C                             ISSD = 0
 
     C                   Z-ADD     100           WrkPEXI
 
     C                   ELSE
 
     C*******************Z-ADD     100           WFspr                                        234440
     C                   Z-ADD     100           WPram                                        234440
 
      ** Choice of calculation method for fiscal price depends on Tax                         236137
      ** Calculation Basis indicator from Country of Tax Codes file.                          236137
                                                                                              236137
      ** Straight line basis:                                                                 236137
                                                                                              236137
     C*****BJCNCD        IFNE      'CH'                                                234440 236137
     C     EWTXCB        IFEQ      'B'                                                        236137
     C                   CALLB     'ZAINTPL2'
     C                   PARM                    ISSD
     C                   PARM                    EWEDT1
     C                   PARM                    MATY
     C                   PARM                    ISSP
     C                   PARM                    WPram                                        234440
     C                   PARM                    WFspr                                        234440
     C*******************PARM                    WFspr                                        234440
     C*******************PARM                    WPram                                        234440
     C*******************Z-ADD     WPram         WrkPEXI                                      234440
                                                                                              236137
      ** Analytical interpolation:                                                            236137
                                                                                              236137
     C                   ELSE                                                                 234440
     C                   CALL      'ZAACTUAR'                                                 234440
     C                   PARM      *BLANK        WRTCD            10                          234440
     C                   PARM                    ISSD                                         234440
     C                   PARM                    ISSP                                         234440
     C                   PARM                    MATY                                         234440
     C                   PARM                    WPram                                        234440
     C                   PARM                    DYBS                                         234440
     C                   PARM                    DVBS                                         234440
     C                   PARM                    CDDS             48                          234440
     C                   PARM                    CRDS             12                          234440
     C                   PARM                    LCPN                                       BUG11164
     C                   PARM                    EWEDT1                                       234440
     C                   PARM                    WFspr                                        234440
     C                   ENDIF                                                                234440
     C                   Z-ADD     WFspr         WrkPEXI                                      234440
 
     C                   ENDIF
 
 
      ** Read the Securities Prices
 
     C                   Z-ADD     EWEDT1        WPdat
     C                   MOVEL     SESN          WSesn
 
     C     SESN          SETLL     PRICM
     C     SESN          READE     PRICM                                  94
 
     C                   MOVE      'D'           RECI
     C                   EVAL      PNTV = 'PRICE ON EFFECTIVE DATE'
 
      ** Generate a timestamp for this transaction
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
     C                   MOVE      TimeStamp     PRTMST
 
     C     *IN94         IFEQ      '0'
     C     PVDT          ANDEQ     EWEDT1                                                     235045
     C                   Z-ADD     WrkPEXI       PEXI
     C                   MOVE      'A'           CHTP
 
     C*****PVDT          IFLT      EWEDT1                                                     235045
     C                   MOVE      EWEDT1        PVDT
     C*********          ENDIF                                                                235045
 
     C                   UPDATE    PRICEDF                              99
     C                   ADD       1             WSAMD             5 0                        236823
 
     C                   ELSE
 
     C                   Z-ADD     WrkPEXI       PEXI
     C                   MOVE      SESN          PSSN
     C                   MOVE      'V '          PPRT
     C                   MOVE      EWEDT1        PVDT
     C**********         Z-ADD     0             PCNM                                        CSD027A
     C                   Eval      PCNM = *Blanks                                            CSD027A
     C                   MOVE      *BLANK        PMKT
     C                   MOVE      *BLANKS       PBRA                       1117
     C                   MOVE      *BLANKS       PBOK
     C**********         Z-ADD     PEXI          PPRC                                         236822
                                                                                              236822
     C                   MOVE      SESN          K_SESN                                       236822
     C                   MOVE      EWEDT1        K_PDAT                                       236822
     C     KEYSC         SETLL     SNDEVDO                                                    236822
     C     KEYSCP        READE     SNDEVDO                                33                  236822
     C                   IF        *IN33 = *OFF AND RECI = 'D'                                236822
     C                   Z-ADD     SNPR          PPRC                                         236822
     C                   ELSE                                                                 236822
     C                   Z-ADD     0             PPRC                                         236822
     C                   ENDIF                                                                236822
                                                                                              236822
     C                   MOVE      BJRDNB        LCD
     C                   MOVE      'I'           CHTP
      * Transact.no of last update
     C                   Reset                   ReturnCode       10
     C                   CALLB     'ZTNLU1'
     C                   PARM                    ReturnCode
     C                   PARM                    TNLU
 
     C                   WRITE     PRICEDF
     C                   ADD       1             WSINS             5 0                        236823
     C                   ADD       1             WNORE             5 0                        236823
     C                   ENDIF
 
     C                   IF        *IN99 = '1'
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF
     C                   Z-ADD     *ZEROS        WrkPEXI
 
     C************       ENDIF                                                                235045
     C                   ENDIF                                                                236453
 
     C                   READ      SECTY
 
     C                   ENDDO
 
     C                   READ      PRICEA                                                     236823
     C                   ADD       WSAMD         SAMD                                         236823
     C                   ADD       WSINS         SINS                                         236823
     C                   ADD       WNORE         NORE                                         236823
     C                   UPDATE    PRICEAF                                                    236823
 
     C                   EVAL      *INLR = *ON
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInvtp  - Access Investment Type Details                     *
      *                                                               *
      *****************************************************************
     C     SRInvtp       BEGSR
 
     C                   MOVE      SITP          WSitp
     C                   MOVE      NMCY          WVlcy
 
     C     KEYIVT        CHAIN     INVTP                              93
 
     C                   IF        NOT%FOUND(INVTP)
     C                   EVAL      DBKEY = SITP + NMCY
     C                   EVAL      DBFILE = 'INVTPD'
     C                   EVAL      DBASE = 4
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Retrieve Tax Basket
      *
     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      BJCNCD        PCtrt             2
     C                   PARM      *BLANKS       PCtrr             2
     C     SDCTTX        PARM      SDCTTX        DSFDY
 
      ** Define key list for file
 
     C     KEYPT         KLIST
     C                   KFLD                    WPtyp
     C                   KFLD                    WSesn
     C                   KFLD                    WPdat
 
     C     KEYIVT        KLIST
     C                   KFLD                    WVlcy
     C                   KFLD                    WSitp
                                                                                              236822
     C     KEYSC         KLIST                                                                236822
     C                   KFLD                    K_SESN                                       236822
     C                   KFLD                    K_PTYP                                       236822
     C                   KFLD                    K_PDAT                                       236822
                                                                                              236822
     C     KEYSCP        KLIST                                                                236822
     C                   KFLD                    K_SESN                                       236822
     C                   KFLD                    K_PTYP                                       236822
 
     C     *LIKE         DEFINE    PEXI          WrkPEXI
 
     C                   MOVE      'PR'          K_PTYP                                       236822
                                                                                              236822
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SRERR - EXCEPTION ERRORS                                     *
      *                                                              *
      ****************************************************************
     C     SRERR         BEGSR
 
     C                   MOVEL     '*ERROR '     PRtcd
     C                   MOVEL     'SE008070'    DBPGM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
 
      ** TERMINATE THE PROGRAM
 
     C                   EXSR      *PSSR
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      ****************************************************************
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ****************************************************************
**  CPY@
(c) Finastra International Limited 2005
