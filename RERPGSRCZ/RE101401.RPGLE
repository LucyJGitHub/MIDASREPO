     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE COB Top Account Sweeping')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE101401 - COB Top Account Zero Balancing/Sweeping           *
      *                                                               *
      *  Function:  This program does the COB zero balancing/sweeping *
      *             of top accounts. All generated entries go to the  *
      *             postings in transit files for posting the next day*
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR676213           Date 19Nov10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 216106             Date 07Apr03               *
      *                 216421             Date 06Apr03               *
      *                 215675             Date 10Mar03               *
      *                 213569             Date 10Feb03               *
      *                 214360  *CREATE    Date 03Feb03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR676213 - Incorrect definition of CLGLAI field (Recompile)  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  216106 - Top a/c sweep freq must be 'D' for deferred posting *
      *  216421 - External tops are back-valued                       *
      *  215675 - Sweep is not stopped when account is inactive       *
      *  213569 - Charges errors                                      *
      *           Generate charges for external tops/sweeps           *
      *  214360 - Cash Management Deferred Posting                    *
      *                                                               *
      *****************************************************************
 
     FREZSHDJ1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REZSHDD0:REZSHDD1)
     FRECMHLL1  UF   E           K DISK    INFSR(*PSSR)
     FREZSHLL0  UF   E           K DISK    INFSR(*PSSR)
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     FRECMBRL1  IF   E           K DISK    INFSR(*PSSR)
     FREICSLPD  O  A E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
      * Cash Management Hierarchy Details
     D O_CMHD        E DS                  EXTNAME(RECMHDPD)
     D A_HIER                  1      9
      * Zero Balancing/Sweeping Hierarchy Details
     D O_ZSHD        E DS                  EXTNAME(REZSHDPD)
      * Group Account Hierarchy Details
     D O_GAHD        E DS                  EXTNAME(REGAHDPD)
 
 
      * Cash Management Hierarchy Links
     D O_CMHL        E DS                  EXTNAME(RECMHLPD)
     D A_LINK                 10     18
      * Zero Balancing/Sweeping Hierarchy Links
     D O_ZSHL        E DS                  EXTNAME(REZSHLPD)
      * Group Account Hierarchy Links
     D O_GAHL        E DS                  EXTNAME(REGAHLPD)
 
 
      * Account Status
     D                 DS
     D AccountSTAT             1     26
     D*AccountSTATX************1      4                                         215675
     D AccountSTATX            1      5                                         215675
     D Closed                  1      1
     D Bankrpt                 2      2
     D Baddebt                 3      3
     D BlockZBSW               4      4
     D Inactive                5      5                                         215675
     D ReferDR                11     11
     D ReferCR                12     12
     D BlockDR                13     13
     D BlockCR                14     14
     D AcType                 21     26
 
 
     D                 DS
     D I_ChildSTAT             1     26
     D I_ChildSTATX            1      5                                         215675
     D*I_ChildSTATX************1      4                                         215675
     D                 DS
     D I_ParentSTAT            1     26
     D I_ParentSTATX           1      5                                         215675
     D*I_ParentSTATX***********1      4                                         215675
 
 
      * Account ID
     D                 DS
     D***ACCID**                 1     18                                                     CGL029
     D ACCID                   1     24                                                       CGL029
     D BRC                     1      3
     D*CUS******               4      9S 0                                                    CSD027
     D CUS                     4      9A                                                      CSD027
     D CCY                    10     12
     D***ACD****                13     16S 0                                                  CGL029
     D***ASN****                17     18S 0                                                  CGL029
     D ACD                    13     22S 0                                                    CGL029
     D ASN                    23     24S 0                                                    CGL029
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** External DS for GENERAL LEDGER details
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
      ** External DS for RETAIL details
     D QQACD1        E                     EXTFLD(QQACCD)                                     CGL029
     D SDCMAN        E DS                  EXTNAME(SDCMANPD)
      ** External DS for cash management details
     D SDACOD        E DS                  EXTNAME(SDACODPD)
     D QQACD2        E                     EXTFLD(QQACCD)                                     CGL029
      ** A/C Code Details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs
 
 
 
      * Process all zero balancing/sweeping hierarchies
      * defined with 'External' = 'Yes' and 'Master Account' = 'No'
 
     C     *LOVAL        SETLL     REZSHDD1
     C                   READ      REZSHDD1                               60    *
 
     C     *IN60         DOWEQ     '0'
 
      * Access Hierarchy Detail
 
     C                   EXSR      ACS_HIER
 
      * Determine Top a/c Balance and Overdraft
 
     C                   EXSR      DET_TOP_BLOD
 
      * Read top account for current hierarchy
 
     C     HIERK         SETLL     RECMHLD0
     C     HIERK         READE     RECMHLD0                               60    *
 
     C     *IN60         IFEQ      '1'
     C     CLCCAT        ORNE      'T'
     C                   EVAL      X_ERMS = 'HIERARCHY MISSING TOP A/C:'
     C                                      + A_HIER
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Access Hierarchy Link
 
     C                   EXSR      ACS_LINK
 
      * Process top link in the hierarchy just read
      * (If cover is to be checked, do sweeps first then tops)
 
     C     ZDCHKC        IFEQ      'Y'
     C                   MOVEL     'S'           I_SWP_TOP
     C                   EXSR      PROC_LINK
     C                   MOVEL     'T'           I_SWP_TOP
     C                   EXSR      PROC_LINK
     C                   ELSE
     C                   MOVEL     'B'           I_SWP_TOP
     C                   EXSR      PROC_LINK
     C                   ENDIF
 
      * Read next zero balancing/sweeping hierarchy
      * defined with 'External' = 'Yes' and 'Master Account' = 'No'
 
     C                   READ      REZSHDD1                               60    *
     C                   ENDDO
 
      * Produce end of reports
      * ======================
 
     C                   MOVEL     '*END   '     X_OPTN
     C                   EXSR      SWEEP
 
      * Log event
      * =========
     C     EntriesGen    IFEQ      'Y'
     C                   EXSR      LOGEVENT
     C                   ENDIF
 
 
     C                   SETON                                        LR
     C                   RETURN
      /SPACE 5
      ********************************************************************
      * Process link
      ********************************************************************
     C     PROC_LINK     BEGSR
 
      * Set child a/c details
 
     C                   EXSR      SET_CHILD
 
      * Determine EXTERNAL Forward and Back Dates
 
     C*******************MOVEL     ZDEFVD        I_FVD                          216421
     C*******************MOVEL     ZDEBVD        I_BVD                          216421
     C                   EXSR      DET_FWDBCK
     C                   MOVEL     ZDEFVS        ExtnlFVS          1
     C                   Z-ADD     O_FVDate      ExtnlFVDT         5 0
     C                   Z-ADD     O_BVDate      ExtnlBVDT         5 0
 
      * EXTERNAL
     C                   Z-ADD     ExtnlFVDT     I_FVDT
     C                   Z-ADD     ExtnlBVDT     I_BVDT
 
      *   Determine destination a/c
      *   (This sets the parent a/c details to that of the destination a/c)
 
     C                   EXSR      DET_DESTAC
 
      * Initialize fields
 
     C                   Z-ADD     CLNASN        I_NASN
 
      * If exceptions, log them, otherwise
      *  Do Zero Balancing
      *  or Sweeping (if deferred posting)                                      216421
      ***or*Sweeping*(if*next*sweep*date is due)                                216421
 
     C                   SELECT
 
     C*****I_ChildSTATX**WHENNE    'NNNN'                                       215675
     C     I_ChildSTATX  WHENNE    'NNNNN'                                      215675
     C                   MOVEL     I_ChildSTAT   AccountSTAT
     C                   EXSR      LOG_CMX
 
     C*****I_ParentSTATX*WHENNE    'NNNN'                                       215675
     C     I_ParentSTATX WHENNE    'NNNNN'                                      215675
     C                   MOVEL     I_ParentSTAT  AccountSTAT
     C                   EXSR      LOG_CMX
 
     C     I_MODE        WHENEQ    'ASC'
     C     ZLSTYP        IFEQ      'Z'
     C     ZDDEFP        ANDNE     'Y'                                          216421
     C                   EXSR      ZEROBAL
     C                   ENDIF
 
     C     I_MODE        WHENEQ    '1  '
     C     ZLSCPI        ANDNE     'Y'
     C     I_MODE        OREQ      '5  '
     C     ZLSCPI        ANDNE     'Y'
     C     I_MODE        OREQ      '1PC'
     C     ZLSCPI        ANDEQ     'Y'
     C     I_MODE        OREQ      '5PC'
     C     ZLSCPI        ANDEQ     'Y'
     C     ZLSTYP        IFEQ      'Z'
     C                   EXSR      ZEROBAL
     C                   ENDIF
     C     ZDDEFP        IFEQ      'Y'                                          216421
     C                   EXSR      SWEEP                                        216421
     C                   ENDIF                                                  216421
     C*******************EXSR      SET_SweepDate                                216421
     C*****ZLSTYP********IFEQ      'S'                                          216421
     C*****SweepDate*****ANDLE     EvtCtlDat                                    216421
     C*****ZDDEFP********OREQ      'Y'                                          216421
     C*******************EXSR      SWEEP                                        216421
     C*******************ENDIF                                                  216421
 
     C                   ENDSL
 
      * Update sequence on RECMHLPD record
      * (It may have been updated in sweeping function)
 
     C                   Z-ADD     I_NASN        CLNASN
     C                   EXCEPT    U_RECMHL
 
      * Access zero balancing/sweeping record
 
     C     LINKK         CHAIN     REZSHLD0                           60
 
      * If sweeping
      * -----------
      *  If sweeping top, or both top & sweep
      *  Calculate Next Sweep Date (if next sweep date is due)
 
     C     ZLSTYP        IFEQ      'S'
     C     I_SWP_TOP     IFEQ      'T'
     C     I_SWP_TOP     OREQ      'B'
     C     I_MODE        IFEQ      '1PC'
     C     I_MODE        OREQ      '5PC'
     C     ZLNSDT        IFLE      EvtCtlDat
     C                   EXSR      CAL_NXTSWPDT
     C                   Z-ADD     ZLNSDT        ZLLSDT
     C                   Z-ADD     O_FSDT        ZLNSDT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * Update REZSHLPD record
 
     C                   EXCEPT    U_REZSHL
 
 
     C                   COMMIT
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Set child a/c details
      ********************************************************************
     C     SET_CHILD     BEGSR
 
     C                   MOVEL     CLCBRC        BRC
     C                   MOVEL     CLCCUS        CUS
     C                   MOVEL     CLCCCY        CCY
     C                   MOVEL     CLCACD        ACD
     C                   MOVEL     CLCASN        ASN
 
      * Access a/c and a/c code details:
 
     C                   MOVEL     'CHILD '      AcType
     C                   EXSR      ACS_ACCNT
     C                   EXSR      ACS_ACOD
 
      * Determine A/c Status
 
     C                   EXSR      DET_AC_STATUS
 
      * Child branch
      * Child customer
      * Child currency
      * Child a/c code
      * Child a/c seq.
     C                   MOVEL     CLCBRC        I_CBRC
     C**********         Z-ADD     CLCCUS        I_CCUS                                       CSD027
     C                   EVAL      I_CCUS = CLCCUS                                            CSD027
     C                   MOVEL     CLCCCY        I_CCCY
     C                   Z-ADD     CLCACD        I_CACD
     C                   Z-ADD     CLCASN        I_CASN
      * Child retail no.
      * Child a/c name
      * Child a/c profit centre
      * Child a/c account section
     C                   Z-ADD     ACNO          I_CRNO
     C                   MOVEL     ANAM          I_CANM
     C                   MOVEL     PRFC          I_CPRF
     C                   MOVEL     A5ACSC        I_CACS
      * Child a/c status
     C                   MOVEL     AccountSTAT   I_ChildSTAT
      * Child last cr cap date
      * Child last dr cap date
     C                   Z-ADD     LCID          ChildLCID         5 0
     C                   Z-ADD     LDID          ChildLDID         5 0
      * Child Ledger Balance
      * Child Cleared Balance
     C                   Z-ADD     LDBL          I_CLDBL
     C                   Z-ADD     CLBL          I_CCLBL
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Zero Balancing
      ********************************************************************
     C     ZEROBAL       BEGSR
 
     C                   CALLB     'RE100612'
 
      * Return code
      * Error Message
      * Option
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
     C                   PARM                    X_OPTN
 
      * INPUTS
      * Mode
     C                   PARM                    I_MODE            3
      * Time
     C                   PARM      ReqTIME       I_TIME            6
      * Hierarchy ID
      * Hierarchy Shortname
      * Hierarchy Branch                                                        213569
     C                   PARM      CDHIER        I_HIER            9 0
     C                   PARM      CDHISN        I_HISN           10
     C                   PARM      CDBRCA        I_BRCA            3            213569
      * Link ID
     C                   PARM      CLLINK        I_LINK            9 0
      * Child branch
      * Child customer
      * Child currency
      * Child a/c code
      * Child a/c seq.
     C                   PARM                    I_CBRC            3
     C**********         PARM                    I_CCUS            6 0                        CSD027
     C                   PARM                    I_CCUS            6                          CSD027
     C                   PARM                    I_CCCY            3
     C**********         PARM                    I_CACD            4 0                        CGL029
     C                   PARM                    I_CACD           10 0                        CGL029
     C                   PARM                    I_CASN            2 0
      * Child A/c Category
     C                   PARM      CLCCAT        I_CCAT            1
      * Child retail no.
      * Child a/c name
      * Child a/c profit centre
      * Child a/c account section
     C                   PARM                    I_CRNO           10 0
     C                   PARM                    I_CANM           20
     C                   PARM                    I_CPRF            4
     C                   PARM                    I_CACS            2
      * Child a/c status
     C                   PARM                    I_ChildSTAT      26
      * Child Ledger Balance
      * Child Cleared Balance
     C                   PARM                    I_CLDBL          15 0
     C                   PARM                    I_CCLBL          15 0
      * Level
     C                   PARM      CLLEVL        I_LEVL            2 0
      * Parent branch
      * Parent customer
      * Parent currency
      * Parent a/c code
      * Parent a/c seq.
     C                   PARM                    I_PBRC            3
     C**********         PARM                    I_PCUS            6 0                        CSD027
     C                   PARM                    I_PCUS            6                          CSD027
     C                   PARM                    I_PCCY            3
     C**********         PARM                    I_PACD            4 0                        CGL029
     C                   PARM                    I_PACD           10 0                        CGL029
     C                   PARM                    I_PASN            2 0
      * Parent retail no.
      * Parent a/c name
      * Parent a/c profit centre
      * Parent a/c account section
      * Parent a/c account type
     C                   PARM                    I_PRNO           10 0
     C                   PARM                    I_PANM           20
     C                   PARM                    I_PPRF            4
     C                   PARM                    I_PACS            2
     C                   PARM                    I_PATY            1
      * Parent a/c status
     C                   PARM                    I_ParentSTAT     26
      * Child Account Narrative
      * Parent Account Narrative
     C                   PARM      ZLCNAR        I_CNAR           30
     C                   PARM                    I_PNAR           30
      * Sweep/Top
     C                   PARM                    I_SWP_TOP         1
 
      * Forward value date
      * Back value date
     C                   PARM                    I_FVDT            5 0
     C                   PARM                    I_BVDT            5 0
 
      * Sweep capitalized interest
      * Sweep cleared balance on associaton date
      * Zero Balance - Net or Gross
      * Target balance
     C                   PARM      ZLSCPI        I_SCPI            1
     C                   PARM      ZLSCBD        I_SCBD            1
     C                   PARM      ZLZBNG        I_ZBNG            1
     C                   PARM      ZLTGBL        I_TGBL           15 0
      * Sweeping Holiday Convention                                             213196
     C                   PARM      ZDSHOC        I_SHOC            1            213196
 
      * Floor Limit for Top
      * Floor Limit for Sweep
      * Transaction Type - Top
      * Transaction Type - Sweep
     C                   PARM      ZLFLFT        I_FLFT           15 0
     C                   PARM      ZLFLFS        I_FLFS           15 0
     C                   PARM      ZDTYPT        I_TYPT            5
     C                   PARM      ZDTYPS        I_TYPS            5
 
      * Maximum Debit Value in a Day
      * Maximum Debit Count in a Day
     C                   PARM      ZLMDVD        I_MDVD           15 0
     C                   PARM      ZLMDCD        I_MDCD            3 0
      * Destination
      * Destination Type
      * Sender's Correspondent
      * Receiver's Correspondent
      * MT202 Cover Message Required
      * MT103 Value Date Offset
     C                   PARM      ZDDEST        I_DEST           18
     C                   PARM      ZDDSTT        I_DSTT            1
     C                   PARM      ZDSNDC        I_SNDC            2
     C                   PARM      ZDRCVC        I_RCVC           11
     C                   PARM      ZDMCMR        I_MCMR            1
     C                   PARM      ZDMVDO        I_MVDO            1
      * MT101 Charges
      * MT101 Charges Account
      * MT101 Charges Amount
      * MT101 Instruction Code
      * MT103 Charges
      * MT103 Charges Account
      * MT103 Charges Amount
      * MT103 Instruction Code
      * MT103 Bank Operation Code
     C                   PARM      ZDCHG1        I_CHG1            3
     C**********         PARM      ZDCAC1        I_CAC1           18                          CGL029
     C                   PARM      ZDCAC1        I_CAC1           24                          CGL029
     C                   PARM      ZDCAM1        I_CAM1           15 0
     C                   PARM      ZDICD1        I_ICD1            4
     C                   PARM      ZDCHG3        I_CHG3            3
     C**********         PARM      ZDCAC3        I_CAC3           18                          CGL029
     C                   PARM      ZDCAC3        I_CAC3           24                          CGL029
     C                   PARM      ZDCAM3        I_CAM3           15 0
     C                   PARM      ZDICD3        I_ICD3            4
     C                   PARM      ZDBOCD        I_BOCD            4
      * External Account 1
      * External Account 2
      * External Account 3
      * External Account 4
      * External Account 5
     C                   PARM      ZDEXA1        I_EXA1           35
     C                   PARM      ZDEXA2        I_EXA2           35
     C                   PARM      ZDEXA3        I_EXA3           35
     C                   PARM      ZDEXA4        I_EXA4           35
     C                   PARM      ZDEXA5        I_EXA5           35
      * Top a/c Sweep Type                                                      214360
      * Deferred Posting
      * Deferred Posting Zero Narrative
     C                   PARM      ZLSTYP        I_TAST            1            214360
     C                   PARM      ZDDEFP        I_DEFP            1
     C                   PARM      ZDDEFZ        I_DEFZ            1
      * Next Available Seq No.
     C                   PARM                    I_NASN            2 0
      * Top a/c balance
      * Top a/c overdraft
     C                   PARM                    I_TopBalance     15 0
     C                   PARM                    I_TopOverDft     15 0
 
      * Event Control date
     C                   PARM      EvtCtlDat     I_EvtCtlDat       5 0
 
      * OUTPUTS
      * Today's total dr value
      * Today's total dr count
     C                   PARM      *zero         O_TVDR           15 0
     C                   PARM      *zero         O_TCDR            3 0
      * Entries Y/N
     C                   PARM      'N'           O_Entries         1
 
      * End if error occurred in module
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ZERO BALANCING FAILED'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     O_Entries     IFEQ      'Y'
     C                   MOVEL     'Y'           EntriesGen        1
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      **Set*Sweep*Date***                                                       216421
      ********************************************************************
     C*****SET_SweepDate BEGSR                                                  216421
      *******************                                                       216421
     C*******************Z-ADD     ZLNSDT        SweepDate         5 0          216421
      *******************                                                       216421
      **Ensure*sweeping*is value dated after capitalized interest               216421
      *******************                                                       216421
     C*****I_MODE********IFEQ      '1PC'                                        216421
     C*****I_MODE********OREQ      '5PC'                                        216421
      *******************                                                       216421
     C*****ChildLCID*****IFGT      ChildLDID                                    216421
     C*******************Z-ADD     ChildLCID     ChildIntDate      5 0          216421
     C*******************ELSE                                                   216421
     C*******************Z-ADD     ChildLDID     ChildIntDate                   216421
     C*******************ENDIF                                                  216421
     C*****BMLDAI********IFEQ      'N'                                          216421
     C*******************ADD       1             ChildIntDate                   216421
     C*******************ENDIF                                                  216421
      *******************                                                       216421
     C*****ChildIntDate**IFGT      SweepDate                                    216421
     C*******************Z-ADD     ChildIntDate  SweepDate                      216421
     C*******************ENDIF                                                  216421
      *******************                                                       216421
     C*******************ENDIF                                                  216421
      *******************                                                       216421
     C*******************ENDSR                                                  216421
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Sweeping
      ********************************************************************
     C     SWEEP         BEGSR
 
     C                   CALLB     'RE100613'
 
      * Return code
      * Error Message
      * Option
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
     C                   PARM                    X_OPTN
 
      * INPUTS
      * Mode
     C                   PARM                    I_MODE            3
      * Time
     C                   PARM      ReqTIME       I_TIME            6
      * Hierarchy ID
      * Hierarchy Shortname
      * Hierarchy Branch                                                        213569
     C                   PARM      CDHIER        I_HIER            9 0
     C                   PARM      CDHISN        I_HISN           10
     C                   PARM      CDBRCA        I_BRCA            3            213569
      * Link ID
     C                   PARM      CLLINK        I_LINK            9 0
      * Child branch
      * Child customer
      * Child currency
      * Child a/c code
      * Child a/c seq.
     C                   PARM                    I_CBRC            3
     C**********         PARM                    I_CCUS            6 0                        CSD027
     C                   PARM                    I_CCUS            6                          CSD027
     C                   PARM                    I_CCCY            3
     C**********         PARM                    I_CACD            4 0                        CGL029
     C                   PARM                    I_CACD                                       CGL029
     C                   PARM                    I_CASN            2 0
      * Child A/c Category
     C                   PARM      CLCCAT        I_CCAT            1
      * Child retail no.
      * Child a/c name
      * Child a/c profit centre
      * Child a/c account section
     C                   PARM                    I_CRNO           10 0
     C                   PARM                    I_CANM           20
     C                   PARM                    I_CPRF            4
     C                   PARM                    I_CACS            2
      * Child a/c status
     C                   PARM                    I_ChildSTAT      26
      * Child Ledger Balance
      * Child Cleared Balance
     C                   PARM                    I_CLDBL          15 0
     C                   PARM                    I_CCLBL          15 0
      * Level
     C                   PARM      CLLEVL        I_LEVL            2 0
      * Parent branch
      * Parent customer
      * Parent currency
      * Parent a/c code
      * Parent a/c seq.
     C                   PARM                    I_PBRC            3
     C**********         PARM                    I_PCUS            6 0                        CSD027
     C                   PARM                    I_PCUS            6                          CSD027
     C                   PARM                    I_PCCY            3
     C**********         PARM                    I_PACD            4 0                        CGL029
     C                   PARM                    I_PACD                                       CGL029
     C                   PARM                    I_PASN            2 0
      * Parent retail no.
      * Parent a/c name
      * Parent a/c profit centre
      * Parent a/c account section
      * Parent a/c account type
     C                   PARM                    I_PRNO           10 0
     C                   PARM                    I_PANM           20
     C                   PARM                    I_PPRF            4
     C                   PARM                    I_PACS            2
     C                   PARM                    I_PATY            1
      * Parent a/c status
     C                   PARM                    I_ParentSTAT     26
      * Child Account Narrative
      * Parent Account Narrative
     C                   PARM      ZLCNAR        I_CNAR           30
     C                   PARM                    I_PNAR           30
      * Sweep/Top
     C                   PARM                    I_SWP_TOP         1
      * Sweep capitalized interest
     C                   PARM      ZLSCPI        I_SCPI            1
 
      * Minimum Balance
      * Minimum Level
      * Maximum Balance
      * Maximum Level
     C                   PARM      ZLMINB        I_MINB           15 0
     C                   PARM      ZLMINL        I_MINL           15 0
     C                   PARM      ZLMAXB        I_MAXB           15 0
     C                   PARM      ZLMAXL        I_MAXL           15 0
      * Sweeping Holiday Convention                                             213196
     C                   PARM      ZDSHOC        I_SHOC            1            213196
 
      * Floor Limit for Top
      * Floor Limit for Sweep
      * Transaction Type - Top
      * Transaction Type - Sweep
     C                   PARM      ZLFLFT        I_FLFT           15 0
     C                   PARM      ZLFLFS        I_FLFS           15 0
     C                   PARM      ZDTYPT        I_TYPT            5
     C                   PARM      ZDTYPS        I_TYPS            5
 
      * Maximum Debit Value in a Day
      * Maximum Debit Count in a Day
     C                   PARM      ZLMDVD        I_MDVD           15 0
     C                   PARM      ZLMDCD        I_MDCD            3 0
      * Destination
      * Destination Type
      * Sender's Correspondent
      * Receiver's Correspondent
      * MT202 Cover Message Required
      * MT103 Value Date Offset
     C                   PARM      ZDDEST        I_DEST           18
     C                   PARM      ZDDSTT        I_DSTT            1
     C                   PARM      ZDSNDC        I_SNDC            2
     C                   PARM      ZDRCVC        I_RCVC           11
     C                   PARM      ZDMCMR        I_MCMR            1
     C                   PARM      ZDMVDO        I_MVDO            1
      * MT101 Charges
      * MT101 Charges Account
      * MT101 Charges Amount
      * MT101 Instruction Code
      * MT103 Charges
      * MT103 Charges Account
      * MT103 Charges Amount
      * MT103 Instruction Code
      * MT103 Bank Operation Code
     C                   PARM      ZDCHG1        I_CHG1            3
     C**********         PARM      ZDCAC1        I_CAC1           18                          CGL029
     C                   PARM      ZDCAC1        I_CAC1           24                          CGL029
     C                   PARM      ZDCAM1        I_CAM1           15 0
     C                   PARM      ZDICD1        I_ICD1            4
     C                   PARM      ZDCHG3        I_CHG3            3
     C**********         PARM      ZDCAC3        I_CAC3           18                          CGL029
     C                   PARM      ZDCAC3        I_CAC3           24                          CGL029
     C                   PARM      ZDCAM3        I_CAM3           15 0
     C                   PARM      ZDICD3        I_ICD3            4
     C                   PARM      ZDBOCD        I_BOCD            4
      * External Account 1
      * External Account 2
      * External Account 3
      * External Account 4
      * External Account 5
     C                   PARM      ZDEXA1        I_EXA1           35
     C                   PARM      ZDEXA2        I_EXA2           35
     C                   PARM      ZDEXA3        I_EXA3           35
     C                   PARM      ZDEXA4        I_EXA4           35
     C                   PARM      ZDEXA5        I_EXA5           35
      * Top a/c Sweep Type                                                      214360
      * Deferred Posting
      * Deferred Posting Zero Narrative
     C                   PARM      ZLSTYP        I_TAST            1            214360
     C                   PARM      ZDDEFP        I_DEFP            1
     C                   PARM      ZDDEFZ        I_DEFZ            1
      * Next Available Seq No.
     C                   PARM                    I_NASN            2 0
      * Top a/c balance
      * Top a/c overdraft
     C                   PARM                    I_TopBalance     15 0
     C                   PARM                    I_TopOverDft     15 0
 
      * Sweep Date
      * Event Control date
     C                   PARM      BJRDNB        I_SweepDate       5 0
     C                   PARM      EvtCtlDat     I_EvtCtlDat       5 0
 
      * OUTPUTS
      * Today's total dr value
      * Today's total dr count
     C                   PARM      *zero         O_TVDR           15 0
     C                   PARM      *zero         O_TCDR            3 0
      * Entries Y/N
     C                   PARM      'N'           O_Entries         1
 
      * End if error occurred in module
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'SWEEPING FAILED'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     O_Entries     IFEQ      'Y'
     C                   MOVEL     'Y'           EntriesGen        1
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Calculate Next Sweep Date
      ********************************************************************
     C     CAL_NXTSWPDT  BEGSR
 
     C                   CALLB     'REZSWPSCH'
 
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * INPUTS
      * Link ID
      * Child Currency
      * Child A/c Category
      * Deferred Posting                                                        216106
     C                   PARM      CLLINK        I_LINK            9 0
     C                   PARM      CLCCCY        I_CCCY            3
     C                   PARM      CLCCAT        I_CCAT            1
     C                   PARM      ZDDEFP        I_DEFP            1            216106
      * Sweeping Frequency - COB
      * Sweeping Day - COB
      * Next Sweep Date - COB
     C                   PARM      ZLSFRQ        I_SSFRQ           1
     C                   PARM      *BLANK        I_SSDAY           2
     C                   PARM      *BLANK        I_SNSDT           6
 
      * External
      * Master Account
     C                   PARM      ZDEXTL        I_SEXTL           1
     C                   PARM      ZDMAST        I_SMAST           1
      * Sweeping Holiday Convention - COB
     C                   PARM      ZDSHOC        I_SSHOC           1
      * Sweeping Day - COB     (in numeric form)
      * Next Sweep Date - COB  (in numeric form)
     C                   PARM      ZLSDAY        I_SDAY            2 0
     C                   PARM      ZLNSDT        I_NSDT            5 0
 
      * SDBANKPD
      * SDGELRPD
     C                   PARM                    SDBANK
     C                   PARM                    SDGELR
 
      * OUTPUTS
      * Sweeping Day - COB
      * Next Sweep Date - COB
     C                   PARM                    O_SDAY            2 0
     C                   PARM                    O_NSDT            5 0
 
      * Following Sweep Date
     C                   PARM                    O_FSDT            5 0
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
 
     C     X_RTCD        IFEQ      '*ERROR'
     C     Ix            ORNE      0
     C                   EVAL      X_ERMS = 'ERROR IN SWEEPING SCHEDULE'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Access a/c details
      ********************************************************************
     C     ACS_ACCNT     BEGSR
 
     C     ACCNTK        CHAIN     ACCNTABF                           60        *
     C     *IN60         IFEQ      '1'
     C                   EVAL      X_ERMS = 'BAD ' + AcType + ' A/C:'
     C                                      + ACCID
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Access A/c code
      ********************************************************************
     C     ACS_ACOD      BEGSR
 
     C                   MOVEL     ACOD          X_ACCD
     C                   CALLB     'ZAACSACOD'
     C**********         PARM                    X_ACCD            4                          CGL029
     C                   PARM                    X_ACCD           10                          CGL029
     C                   PARM                    SDACOD
 
      * Database error if a/c code not found
 
     C     A5ACCD        IFEQ      *BLANK
     C                   EVAL      X_ERMS = 'BAD A/C CODE:' + X_ACCD
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Access Hierarchy Detail
      ********************************************************************
     C     ACS_HIER      BEGSR
 
     C                   CALLB     'RE100601'
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * Option
     C                   PARM      '*ALL   '     X_OPTN            7
      * Hierarchy ID
     C                   PARM      CDHIER        I_HIER            9 0
      * Hierarchy Type
     C                   PARM      CDHTYP        I_HTYP            2
 
     C                   PARM                    O_CMHD
     C                   PARM                    O_ZSHD
     C                   PARM                    O_GAHD
 
      * End if error occurred in module
      * or if no record found
 
     C     X_RTCD        IFEQ      '*ERROR'
     C     X_RTCD        OREQ      '*NOREC'
     C                   EVAL      X_ERMS = 'BAD HIERARCHY DETAIL:' + A_HIER
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Access Hierarchy Link
      ********************************************************************
     C     ACS_LINK      BEGSR
 
     C                   CALLB     'RE100602'
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * Option
     C                   PARM      '*ALL   '     X_OPTN            7
      * Hierarchy ID
     C                   PARM      CDHIER        I_HIER            9 0
      * Hierarchy Type
     C                   PARM      CDHTYP        I_HTYP            2
      * Link ID
     C                   PARM      CLLINK        I_LINK            9 0
      * Child branch
      * Child customer
      * Child currency
      * Child a/c code
      * Child a/c seq.
     C                   PARM      CLCBRC        I_CBRC            3
     C**********         PARM      CLCCUS        I_CCUS            6 0                        CSD027
     C                   PARM      CLCCUS        I_CCUS            6                          CSD027
     C                   PARM      CLCCCY        I_CCCY            3
     C**********         PARM      CLCACD        I_CACD            4 0                        CGL029
     C                   PARM      CLCACD        I_CACD                                       CGL029
     C                   PARM      CLCASN        I_CASN            2 0
 
     C                   PARM                    O_CMHL
     C                   PARM                    O_ZSHL
     C                   PARM                    O_GAHL
 
      * End if error occurred in module
      * or if no record found
 
     C     X_RTCD        IFEQ      '*ERROR'
     C     X_RTCD        OREQ      '*NOREC'
     C                   EVAL      X_ERMS = 'BAD HIERARCHY LINK:' +
     C                                       A_HIER + A_LINK
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Determine Top a/c Balance and Overdraft
      ********************************************************************
     C     DET_TOP_BLOD  BEGSR
 
      * If check for cover on top a/c is not done
      *  then top a/c balance & overdraft are not monitored
 
     C     ZDCHKC        IFNE      'Y'
     C                   Z-ADD     *ZERO         I_TopBalance
     C                   MOVE      *ALL'9'       I_TopOverDft
     C                   ELSE
 
     C                   CALLB     'RE100615'
 
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
 
      * INPUTS
      * Mode
     C                   PARM                    I_MODE            3
      * Hierarchy ID
      * Hierarchy Shortname
     C                   PARM      CDHIER        I_HIER            9 0
     C                   PARM      CDHISN        I_HISN           10
 
      * OUTPUTS
      * Top a/c balance
      * Top a/c overdraft
     C                   PARM      *ZERO         O_TopBalance     15 0
     C                   PARM      *ZERO         O_TopOverDft     15 0
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN DETERMINE TOP BALANCE'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   Z-ADD     O_TopBalance  I_TopBalance
     C                   MOVE      O_TopOverDft  I_TopOverDft
 
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Determine A/c Status
      ********************************************************************
     C     DET_AC_STATUS BEGSR
 
      * Initialise
     C                   MOVE      'N'           Closed
     C                   MOVE      'N'           BlockZBSW
     C                   MOVE      'N'           ReferDR
     C                   MOVE      'N'           ReferCR
     C                   MOVE      'N'           BlockDR
     C                   MOVE      'N'           BlockCR
     C                   MOVE      'N'           Inactive                       215675
     C                   MOVE      'N'           Bankrpt
     C                   MOVE      'N'           Baddebt
 
     C     RECI          IFNE      'D'
     C                   MOVE      'Y'           Closed
     C                   ENDIF
      * Sweeping Blocked?
     C     RECMBRK       CHAIN     RECMBRD0                           99        *
     C  N99              MOVE      'Y'           BlockZBSW
      * Test
     C                   TESTB     '0'           RETB                     99
     C   99              MOVE      'Y'           ReferDR
     C                   TESTB     '1'           RETB                     99
     C   99              MOVE      'Y'           ReferCR
     C                   TESTB     '2'           RETB                     99
     C   99              MOVE      'Y'           BlockDR
     C                   TESTB     '3'           RETB                     99
     C   99              MOVE      'Y'           BlockCR
     C                   TESTB     '4'           RETB                     99    215675
     C   99              MOVE      'Y'           Inactive                       215675
     C                   TESTB     '6'           RETB                     99
     C   99              MOVE      'Y'           Bankrpt
     C                   TESTB     '7'           RETB                     99
     C   99              MOVE      'Y'           Baddebt
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Log cash management exceptions
      ********************************************************************
     C     LOG_CMX       BEGSR
 
     C     ZLSTYP        IFEQ      'Z'
     C                   EVAL      I_EXCP = 'ZERO BALANCING NOT DONE.'
     C                   ELSE
     C                   EVAL      I_EXCP = 'SWEEPING NOT DONE.'
     C                   ENDIF
 
     C     Closed        IFEQ      'Y'
     C                   EVAL      I_REAS =  AcType + ' account is CLOSED.'
     C                   ENDIF
     C     Bankrpt       IFEQ      'Y'
     C                   EVAL      I_REAS = AcType + ' account is BANKRUPT.'
     C                   ENDIF
     C     Baddebt       IFEQ      'Y'
     C                   EVAL      I_REAS = AcType + ' account is BAD-DEBT.'
     C                   ENDIF
     C     BlockZBSW     IFEQ      'Y'
     C                   EVAL      I_REAS = AcType + ' account is BLOCKED.'
     C                   ENDIF
     C     Inactive      IFEQ      'Y'                                          215675
     C                   EVAL      I_REAS = AcType + ' account is INACTIVE.'    215675
     C                   ENDIF                                                  215675
 
      * Write to the cash management exception file
 
     C                   EXSR      WRT_CMX
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Write to the cash management exception file
      ********************************************************************
     C     WRT_CMX       BEGSR
 
     C                   CALLB     'REWRTCMX'
 
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
 
      * INPUTS
      * Hierarchy ID
      * Hierarchy Shortname
     C                   PARM      CDHIER        I_HIER            9 0
     C                   PARM      CDHISN        I_HISN           10
      * Link ID
     C                   PARM      CLLINK        I_LINK            9 0
      * Exception
      * Reason
     C                   PARM                    I_EXCP           60
     C                   PARM                    I_REAS           60
      * Zero Balancing/Sweeping Entry
      * Original Entry
     C                   PARM      *BLANK        I_ZSEN           60
     C                   PARM      *BLANK        I_OREN          330
      * Mode
      * Time
     C                   PARM                    I_MODE            3
     C                   PARM      ReqTIME       I_TIME            6
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN WRITE TO RECMEXPD'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      *  Determine destination a/c
      ********************************************************************
     C     DET_DESTAC    BEGSR
 
     C                   CALLB     'REZDESTAC'
 
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * INPUTS
      * Hierarchy ID
      * Child currency
     C                   PARM      CDHIER        I_HIER            9 0
     C                   PARM      CLCCCY        I_CCCY            3
      * Destination
      * Destination Type
      * Sender's Correspondent
     C                   PARM      ZDDEST        I_SDEST          18
     C                   PARM      ZDDSTT        I_SDSTT           1
     C                   PARM      ZDSNDC        I_SSNDC           2
 
      * OUTPUTS
      * Parent branch
      * Parent customer
      * Parent currency
      * Parent a/c code
      * Parent a/c seq.
     C                   PARM                    O_PBRC            3
     C**********         PARM                    O_PCUS            6 0                        CSD027
     C                   PARM                    O_PCUS            6                          CSD027
     C                   PARM                    O_PCCY            3
     C**********         PARM                    O_PACD            4 0                        CGL029
     C                   PARM                    O_PACD           10 0                        CGL029
     C                   PARM                    O_PASN            2 0
      * Parent retail no.
      * Parent a/c profit centre
      * Parent a/c account section
      * Parent a/c account type
     C                   PARM                    O_PRNO           10 0
     C                   PARM                    O_PPRF            4
     C                   PARM                    O_PACS            2
     C                   PARM                    O_PATY            1
      * Parent a/c status
     C                   PARM                    O_ParentSTAT     26
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Ix                3 0
 
     C     X_RTCD        IFEQ      '*ERROR'
     C     Ix            ORGT      0
     C                   EVAL      X_ERMS = 'ERROR IN DESTINATION A/C:'
     C                                      + ZDDEST + ZDDSTT
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Parent branch
      * Parent customer
      * Parent currency
      * Parent a/c code
      * Parent a/c seq.
     C                   MOVEL     O_PBRC        I_PBRC
     C**********         Z-ADD     O_PCUS        I_PCUS                                       CSD027
     C                   EVAL      I_PCUS =      O_PCUS                                       CSD027
     C                   MOVEL     O_PCCY        I_PCCY
     C                   Z-ADD     O_PACD        I_PACD
     C                   Z-ADD     O_PASN        I_PASN
      * Parent retail no.
      * Parent a/c name
      * Parent a/c profit centre
      * Parent a/c account section
      * Parent a/c account type
     C                   Z-ADD     O_PRNO        I_PRNO
     C                   MOVEL     *BLANK        I_PANM
     C                   MOVEL     O_PPRF        I_PPRF
     C                   MOVEL     O_PACS        I_PACS
     C                   MOVEL     O_PATY        I_PATY
      * Parent a/c status
     C                   MOVEL     O_ParentSTAT  I_ParentSTAT
      * Parent Account Narrative
     C                   MOVEL     ZDENAR        I_PNAR
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * Log an event
      ********************************************************************
     C     LOGEVENT      BEGSR
 
      * 'Cash management input cycle sweeping - executed for time &1'
     C                   EVAL      #MSGID = 'RE75427 '
     C                   EVAL      #MSGDT = %subst(ReqTIME :1:2) + ':' +
     C                                      %subst(ReqTIME :3:2) + ':' +
     C                                      %subst(ReqTIME :5:2)
 
      * Get the message details
 
     C                   CALLB     'ZAMSGRTVMS'
     C                   PARM      *BLANK        ReturnCode       10
     C                   PARM      *BLANK        CompMsg        3000
     C                   PARM                    #MSGID
     C                   PARM                    #MSGDT
     C                   PARM      'GBREUSRMSG'  #MSGF
     C                   PARM      '*LIBL  '     #MSGFL
     C                   PARM      '0'           Level             1
 
      * Write an INFORMATION record to the input cycle sweeps log file
 
     C                   Z-ADD     PSRunDate     ILDATE
     C                   TIME                    CurTIME           6 0
     C                   Z-ADD     CurTIME       ILTIME
     C                   MOVE      'I'           ILTYPE
     C                   MOVEL     CompMsg       ILNARR
     C                   MOVEL     PSJobName     ILJBNM
     C                   MOVEL     PSUser        ILJBUS
     C                   MOVEL     PSJobNo       ILJBNO
     C                   WRITE     REICSLD0
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Determine Forward and Back Days
      ********************************************************************
     C     DET_FWDBCK    BEGSR
 
      * COB Zero balancing on top account must not use hierarchy                216421
      * defaults for forward and back-value dates                               216421
      * (These are only used in input cycle zero balancing)                     216421
      * COB zero balancing is designed to catch any non-zero balanced           216421
      * entries whose value date has fallen due; i.e. only those entries        216421
      * with value date up to the event control date must be processed.         216421
      * Thus the forward value date is the event control date.                  216421
      * As entries are processed on the next working day in account             216421
      * and local currency, the back value date must be set to this date.       216421
                                                                                216421
     C                   Z-ADD     EvtCtlDat     O_FVDate          5 0          216421
                                                                                216421
     C     BJDNWD        SUB       1             ZDAYNO                         216421
     C     ZHOLID_Local  DOUEQ     'W'                                          216421
     C     ZHOLID_AccountANDEQ     'W'                                          216421
     C                   ADD       1             ZDAYNO                         216421
     C                   CALLB     'ZCHKH'                                      216421
     C                   PARM                    ZDAYNO            5 0          216421
     C                   PARM      BJLCCY        ZCCY              3            216421
     C                   PARM      *BLANK        ZLOC              3            216421
     C                   PARM      *BLANK        ZHOLID_Local      1            216421
     C                   CALLB     'ZCHKH'                                      216421
     C                   PARM                    ZDAYNO            5 0          216421
     C                   PARM      CLCCCY        ZCCY              3            216421
     C                   PARM      *BLANK        ZLOC              3            216421
     C                   PARM      *BLANK        ZHOLID_Account    1            216421
     C                   ENDDO                                                  216421
                                                                                216421
     C                   Z-ADD     ZDAYNO        O_BVDate          5 0          216421
                                                                                216421
     C*******************CALLB     'REZFWDBCK'                                  216421
      *******************                                                       216421
      **Return*code******                                                       216421
      **Error*Message****                                                       216421
     C*******************PARM      *BLANK        X_RTCD                         216421
     C*******************PARM      *BLANK        X_ERMS                         216421
      **INPUTS***********                                                       216421
      *******************                                                       216421
      **Forward*value*days                                                      216421
      **Back*value*days**                                                       216421
     C*******************PARM                    I_FVD             3            216421
     C*******************PARM                    I_BVD             3            216421
      *******************                                                       216421
      **SDBANKPD*********                                                       216421
     C*******************PARM                    SDBANK                         216421
      *******************                                                       216421
      **OUTPUTS**********                                                       216421
      **Forward*value*date                                                      216421
      **Back*value*date**                                                       216421
     C*******************PARM                    O_FVDate          5 0          216421
     C*******************PARM                    O_BVDate          5 0          216421
      *******************                                                       216421
      **End*if*error*occurred in module                                         216421
      *******************                                                       216421
     C*****X_RTCD********IFEQ      '*ERROR'                                     216421
     C*******************EVAL      X_ERMS = 'ERROR IN FORWARD AND BACK DAYS'    216421
     C*******************EXSR      *PSSR                                        216421
     C*******************ENDIF                                                  216421
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      * INPUTS
      * Mode
     C                   PARM                    I_MODE            3
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      *  Access General Ledger Details
 
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR  '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
      * Event Control Date
 
     C     BKAPDT        IFLT      BJDNWD
     C                   Z-ADD     BKAPDT        EvtCtlDat         5 0
     C                   ELSE
     C     BJDNWD        SUB       1             EvtCtlDat
     C                   ENDIF
 
      *  Access Retail Details
 
     C                   CALL      'AORETLR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDRETL        PARM      SDRETL        DSFDY
 
      *  Access Cash Management Details
 
     C                   CALLB     'AOCMANR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDCMAN        PARM      SDCMAN        DSSDY
 
      * Database Error
 
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      X_ERMS = 'Call to AOCMANR0 in error'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Clear data structures
 
     C                   CLEAR                   O_CMHD
     C                   CLEAR                   O_ZSHD
     C                   CLEAR                   O_GAHD
     C                   CLEAR                   O_CMHL
     C                   CLEAR                   O_ZSHL
     C                   CLEAR                   O_GAHL
 
      * Request Time
 
     C                   MOVEL     '000000'      ReqTIME           6
 
      * Key lists
 
     C     ACCNTK        KLIST
     C                   KFLD                    CUS
     C                   KFLD                    CCY
     C                   KFLD                    ACD
     C                   KFLD                    ASN
     C                   KFLD                    BRC
     C     RECMBRK       KLIST
     C                   KFLD                    CDHIER
     C                   KFLD                    BRC
     C                   KFLD                    CUS
     C                   KFLD                    CCY
     C                   KFLD                    ACD
     C                   KFLD                    ASN
     C     HIERK         KLIST
     C                   KFLD                    CDHIER
     C     LINKK         KLIST
     C                   KFLD                    CDHIER
     C                   KFLD                    CLLINK
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
     ORECMHLD0  E            U_RECMHL
     O                       CLNASN
     OREZSHLD0  E            U_REZSHL
     O                       ZLLSDT
     O                       ZLNSDT
