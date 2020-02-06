     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*OVR *: OVRDBF FILE(LETISPLX) TOFILE(LETISPL0) SHARE(*NO)          : *
/*OVR *: OVRDBF FILE(LETISPLY) TOFILE(LETISPL1) SHARE(*NO)          : *
/*OVR *: OVRDBF FILE(LETISPLV) TOFILE(LETISPL3) SHARE(*NO)          : *
/*OVR *: OVRDBF FILE(LETISPLW) TOFILE(LETISPL4) SHARE(*NO)          : *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Transaction Income Splits Maintenance')       *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE2080 - Transaction Income Splits Maintenance               *
      *                                                               *
      *  Function:  This module will be a new combined maintenance/   *
      *             enquiry function on Midas and a new combined      *
      *             maintenance/browser function on loan manager.     *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 10May06               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE035  *CREATE    Date 22Sep03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager.                               *
      *  CLE035 - Lending Enhancements for Nordea Phase 1 Priority 2: *
      *           Income Splits                                       *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas LE Loan Income Splits
     FLETISPL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LETISPD0:LETISP0)
     F                                     COMMIT
 
      ** Midas LE Fee Income Splits
     FLETISPL1  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LETISPD0:LETISP1)
     F                                     COMMIT
 
      ** Midas LE Loan Income Splits
     FLETISPL3  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LETISPD0:LETISP3)
     F                                     COMMIT
 
      ** Midas LE Loan Income Splits
     FLETISPL4  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LETISPD0:LETISP4)
     F                                     COMMIT
 
      ** Midas LE Loan Income Splits
     FLETISPLX  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LETISPD0:LETISPX)
 
      ** Midas LE Fee Income Splits
     FLETISPLY  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LETISPD0:LETISPY)
 
      ** Midas LE Loan Income Splits
     FLETISPLV  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LETISPD0:LETISPV)
 
      ** Midas LE Loan Income Splits
     FLETISPLW  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LETISPD0:LETISPW)
 
      ** Midas LE Facilities file
     FFCLTYL0   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(F_)
 
      ** Midas LE Fee details - active
     FLEFEEDL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas LE Loans File
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(C_)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
 
      ** API Invalid Log File by Type/FO Id/Timestamp
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN
     F                                     RENAME(APILOGD0:APILOG0)
     F                                     COMMIT
 
      ** API Invalid Log File
     FAPILOGPD  UF A E           K DISK    INFSR(*PSSR) USROPN
 
      ** API Valid Log File
     FAPVLOGPD  UF A E           K DISK    INFSR(*PSSR) USROPN
     F                                     COMMIT
 
      ** Midas LE Settlement Allocation Input Invalid Data
     FLEITISPD  UF A E           K DISK    INFSR(*PSSR)
 
      ** Settlements Allocation Input Display File
     FLE2080DF  CF   E             WORKSTN SFILE(LE2080S0:#0RLRN)
     F                                     USROPN
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition.
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all of the defined fields
      ** in the PSDS. They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D NUMERIC         C                   '0123456789'
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D ArrCNUM         S              6    DIM(100)
     D ArrISCN         S              6    DIM(100)
 
      ** Bank Details Data Structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Customer Details Data Structure
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Switchable Features Data Structure
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Branch Details Data Structure
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D QQDFACX       E                     EXTFLD(QQDFAC)                                     CLE106
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Access Object Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Midas LE PC Msg Trans. Income Splits
     D I1MFPD        E DS                  EXTNAME(LEI1MFPD)
 
      ** Midas LE PC Msg Trans. Income Splits Return
     D I2MFPD        E DS                  EXTNAME(LEI2MFPD)
 
      ** Rundate Details Data Structure
     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
 
      ** SD Layout Details Data Structure
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      ** Midas 24x7 Status Data Structure
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** Midas PF Reflecting Data Structure
     D*LEALLO***     E DS                  EXTNAME(LEALLO) DTAARA(LEALLO)                     CLE148
     D LEALLO        E DS                  EXTNAME(LEALLO)                                    CLE148
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters
     D PMode           S              1
     D PSplitType      S              1
 
      ** Access Object Parameters
     D PRetCode        S              7
     D POption         S              7
     D PSard           S              6
     D PCustomer       S             10
     D PKyst           S              7
     D PBranch         S              3
     D PBrowse         S              1
 
     D PZPgmQ          S             10
     D PZRelQ          S              5
 
      ** Y2SNMGC/Y2RVMGC Parameters
     D ZAPGMQ          S             10
     D ZAPGRL          S              5
     D ZAMSID          S              7
     D ERCD            S              3
     D ZAMSGF          S             10
     D ZAMSDA          S            132
     D ZAMSTP          S              7
     D ZAMSTX          S            132
 
      ** ZEDIT/ZALIGN Parameters
     D ZAlignOk        S              1
     D ZFLD16          S             16
     D ZSDEC           S              1  0
     D ZSDIG           S              2  0
 
      ** Working Variables
     D WLRCD           S              4  0
     D WRCTR           S              5  0
     D WSFPG           S              3  0
     D CSC011          S              1
     D WToggle         S              1
     D WErrFlag        S              1
     D WFileUpd        S              1
     D WReplace        S              1
     D WRepRec         S              1
     D WValidKey       S              1
     D WTotAlloc       S             12  9
     D WSavTotal       S             12  9
     D*WLoanRef*       S              6  0                                                    CLE148
     D WLoanRef        S              6                                                       CLE148
     D*WrkCNUM**       S              6  0                                                   CSD027A
     D WrkCNUM         S              6                                                      CSD027A
     D*WrkLNRF**       S              6  0                                                    CLE148
     D WrkLNRF         S              6                                                       CLE148
     D PRTCD           S              7A                                                      CLE148
     D PUPDT           S              1A                                                      CLE148
     D WrkFACL         S              5  0
     D WrkFESQ         S              2  0
     D*WrkISCN**       S              6  0                                                   CSD027A
     D WrkISCN         S              6                                                      CSD027A
     D WrkFACT         S              3  0
     D WrkFCNO         S              2  0
     D WrkIPAL         S             12  9
     D WSavPCRF        S             15
     D WrkTMST         S             26Z
     D WrkVar1         S              1
     D WRecCount       S              4  0
     D Ix              S              3  0
     D Iy              S              3  0
 
     D WLogValid       S              1A
     D*PCNEXT***       S              8  0                                                    CLE148
     D PCNEXT          S              8                                                       CLE148
     D PCNEXTA         S              8A
 
     D WTimeStamp      S             26Z
     D WMsgType        S              8A
     D WFrOffId        S             20
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Batch Processing (Loan Manager)
 
     C                   IF        PMode = 'B'
     C                   EXSR      SRBatch
     C                   IF        I1LAST = 'Y'
     C                   EVAL      *INLR = *ON
     C                   ENDIF
     C                   ENDIF
 
      ** Interactive Processing (Loan Manager)
 
     C                   IF        Pmode = 'I'
     C                   EXSR      SRInter
     C                   EVAL      *INLR = *ON
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInter - Interactive Processing                             *
      *                                                               *
      *****************************************************************
     C     SRInter       BEGSR
 
     C                   OPEN      LE2080DF
     C                   DOU       *INKC = *ON
     C                   EXSR      SRProcKey
 
     C                   IF        *INKC = *OFF  AND  WValidKey = 'Y'
     C                   EVAL      *IN81 = *ON
     C                   EVAL      *IN84 = *OFF
     C                   EXSR      SRReset
     C                   EXSR      SRClrScrn
 
     C                   IF        #0ACTN = 'A'
     C                   EVAL      WToggle = 'A'
     C                   ENDIF
 
      ** Display/process subfile screen
 
     C                   DOU       *INKC = *ON  OR  *INKL = *ON  OR
     C                             WFileUpd = 'Y'
     C                   EXSR      SRBuildSFL
     C                   EXSR      SRProcSFL
 
     C                   IF        WFileUpd = 'Y'
     C                   EXSR      SRUpdFile
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcKey - Process key screen                               *
      *                                                               *
      *****************************************************************
     C     SRProcKey     BEGSR
 
      ** Initialise indicators and screen fields
 
     C                   MOVEA     '0000000'     *IN(54)
     C                   EVAL      #0ACTN = *BLANKS
     C                   EVAL      #0LNRF = *BLANKS
     C                   EVAL      #0CNUM = *BLANKS
     C                   EVAL      #0FACL = *BLANKS
     C                   EVAL      #0LOAN = *BLANKS
     C                   EVAL      #0FESQ = *BLANKS
     C                   EVAL      WValidKey = 'N'
     C                   EVAL      WToggle = *BLANK
     C                   EVAL      WFileUpd = 'N'
     C                   EVAL      WReplace = 'N'
     C                   EVAL      *IN62 = *OFF
     C                   EVAL      *IN81 = *OFF
     C                   EXSR      SRRefresh
 
      ** Display key screen
 
     C                   DOU       *INKC = *ON  OR  WValidKey = 'Y'
 
     C                   TIME                    #0TIME
     C                   WRITE     LE2080F0
     C                   WRITE     LE2080F1
     C                   WRITE     LE2080C1
     C                   EXFMT     LE2080C0
 
     C                   MOVEA     '000000'      *IN(26)
     C                   EXSR      SRClrMsgQ
 
     C                   IF        *INKP = *ON
     C                   IF        PSplitType = 'L'
     C                   EVAL      PBrowse = '1'
     C                   ELSE
     C                   EVAL      PBrowse = '2'
     C                   ENDIF
 
     C                   CALL      'LE2082'
     C                   PARM                    PBrowse
 
     C                   IF        PBrowse = 'E'
     C                   EVAL      *INKC = *ON
     C                   ENDIF
 
     C                   ELSE
     C                   IF        *INKC <> *ON
     C                   EXSR      SRValKey
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValKey - Validate key fields                               *
      *                                                               *
      *****************************************************************
     C     SRValKey      BEGSR
 
      ** ACTION
      ** Must be 'I', 'A', 'E', or 'D'
 
     C                   IF        #0ACTN <> 'I'  AND  #0ACTN <> 'A'  AND
     C                             #0ACTN <> 'E'  AND  #0ACTN <> 'D'
     C                   EVAL      *IN26 = *ON
     C                   EVAL      ZAMSID = 'LEI0001'
     C                   EXSR      ZASNMS
     C                   ELSE
 
     C                   SELECT
     C                   WHEN      PSplitType = 'L'
 
      ** LOAN (loans income splits)
      ** Must be a valid loan in the system
 
     C                   IF        #0LNRF = *BLANKS
     C                   EVAL      *IN27 = *ON
     C                   EVAL      ZAMSID = 'LEI0002'
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   MOVE      #0LNRF        WLoanRef
     C     WLoanRef      CHAIN     CLOAN
     C                   IF        NOT %FOUND(CLOAN)  OR  %FOUND(CLOAN)  AND
     C                             C_RECI <> 'D'
     C                   EVAL      *IN27 = *ON
     C                   EVAL      ZAMSID = 'LEI0002'
     C                   EXSR      ZASNMS
 
     C                   ELSE
     C                   EVAL      WSavPCRF = C_PCRF
 
      ** Validate record
 
     C                   MOVE      #0LNRF        WrkLNRF
     C                   IF        #0ACTN = 'I'  OR  #0ACTN = 'A'  OR
     C                             #0ACTN = 'D'
     C     WrkLNRF       CHAIN     LETISPLX
 
      ** For insert, there must be no existing live record
 
     C                   IF        PMode = 'I'
     C                   IF        %FOUND(LETISPLX)  AND  #0ACTN = 'I'
     C                   EVAL      *IN27 = *ON
     C                   EVAL      ZAMSID = 'LEI0003'
     C                   EXSR      ZASNMS
     C                   ENDIF
 
      ** For insert, check if record exists but already deleted;
      ** if yes, set flag to replace these records
 
     C                   IF        NOT %FOUND(LETISPLX)  AND  #0ACTN = 'I'
     C     WrkLNRF       CHAIN     LETISPLV
     C                   IF        %FOUND(LETISPLV)
     C                   EVAL      WReplace = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** For amd/del, there must be an existing live record
 
     C                   IF        NOT %FOUND(LETISPLX)  AND  #0ACTN = 'A'  OR
     C                             NOT %FOUND(LETISPLX)  AND  #0ACTN = 'D'
     C                   EVAL      *IN27 = *ON
     C                   EVAL      ZAMSID = 'LEI0004'
     C                   EXSR      ZASNMS
     C                   ENDIF
 
      ** For enquire, live/deleted income spilts will be displayed
 
     C
     C                   IF        #0ACTN = 'E'  AND  PMode = 'I'
     C     WrkLNRF       CHAIN     LETISPLX
     C                   IF        NOT %FOUND(LETISPLX)
     C     WrkLNRF       CHAIN     LETISPLV
     C                   IF        %FOUND(LETISPLV)
     C                   EVAL      *IN62 = *ON
     C                   ELSE
     C                   EVAL      *IN27 = *ON
     C                   EVAL      ZAMSID = 'LEI0014'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   WHEN      PSplitType = 'F'
 
      ** CUSTOMER (fees income splits)
      ** Mandatory and must be an existing Midas customer
 
     C                   IF        #0CNUM = *BLANKS
     C                   EVAL      *IN28 = *ON
     C                   EVAL      ZAMSID = 'LEI0006'
     C                   EXSR      ZASNMS
     C                   ELSE
 
     C                   EVAL      PCustomer = #0CNUM
     C                   EVAL      WrkVar1 = #0CNUM
 
     C                   IF        PMode = 'B'  AND  WrkVar1 = '?'
     C                   EVAL      ZAMSID = 'LEI0006'
     C                   EXSR      ZASNMS
     C                   ELSE
 
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PCustomer
     C                   PARM      *BLANKS       PKyst
     C     SDCUST        PARM      *BLANKS       DSSDY
      *
     C                   IF        PRetCode <> *BLANKS  AND
     C                             PRetCode <> '*NRF   '  AND
     C                             PRetCode <> '*NOSEL '  AND
     C                             PRetCode <> '*KEY   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBKEY = PCustomer
     C                   EVAL      DBASE = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRetCode = '*NOSEL '  OR
     C                             PRetCode = '*NRF   '  OR
     C                             PRetCode = '*KEY   '
     C                   EVAL      *IN28 = *ON
     C                   EVAL      ZAMSID = 'LEI0006'
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   EVAL      #0CNUM = BBCUST
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** FACILITY (fees income splits)
      ** Must be blank if Loan (below) is specified
 
     C                   IF        #0FACL <> *BLANKS  AND  #0LOAN <> *BLANKS  OR
     C                             #0FACL = *BLANKS  AND  #0LOAN = *BLANKS
     C                   EVAL      *IN29 = *ON
     C                   EVAL      *IN30 = *ON
     C                   EVAL      ZAMSID = 'LEI0009'
     C                   EXSR      ZASNMS
     C                   ENDIF
 
      ** Together with the customer entered, they must refer
      ** to a live facility in the system
 
     C                   IF        #0FACL <> *BLANKS  AND  *IN29 = *OFF  AND
     C                             *IN28 = *OFF
     C                   MOVEL     #0CNUM        WrkCNUM
     C                   MOVEL     #0FACL        WrkFACT
     C                   MOVE      #0FACL        WrkFCNO
     C     KFCLT0        CHAIN     FCLTYL0
     C                   IF        NOT %FOUND(FCLTYL0)
     C                   EVAL      *IN28 = *ON
     C                   EVAL      *IN29 = *ON
     C                   EVAL      ZAMSID = 'LEI0011'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
 
      ** LOAN (fees income splits)
      ** Must be a valid loan in the system
 
     C                   IF        #0LOAN <> *BLANKS  AND  *IN30 = *OFF
     C                   MOVE      #0LOAN        WLoanRef
     C     WLoanRef      CHAIN     CLOAN
     C                   IF        %FOUND(CLOAN)  AND  C_RECI = 'D'
     C*************      EVAL      WSavPCRF = C_PCRF
     C                   ELSE
     C                   EVAL      *IN30 = *ON
     C                   EVAL      ZAMSID = 'LEI0002'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
 
      ** FEE SEQUENCE (fees income splits)
      ** Must be numeric
 
     C                   IF        %CHECK(NUMERIC:#0FESQ) = 1
     C                   EVAL      *IN31 = *ON
     C                   EVAL      ZAMSID = 'LEI0010'
     C                   EXSR      ZASNMS
     C                   ENDIF
 
      ** If key fields are valid (fee income splits), validate the record
 
     C                   IF        *IN28 = *OFF  AND  *IN29 = *OFF  AND
     C                             *IN30 = *OFF  AND  *IN31 = *OFF
     C                   MOVEL     #0CNUM        WrkCNUM
     C                   MOVE      #0LOAN        WrkLNRF
     C                   MOVE      #0FACL        WrkFACL
     C                   MOVE      #0FESQ        WrkFESQ
 
      ** Check if fee record exists in the system (LEFEED)
 
     C     KFEED1        CHAIN     LEFEEDL1
 
     C                   IF        NOT %FOUND(LEFEEDL1)
     C                   EVAL      *IN28 = *ON
     C                   EVAL      *IN31 = *ON
     C                   IF        #0FACL <> *BLANKS
     C                   EVAL      *IN29 = *ON
     C                   ELSE
     C                   EVAL      *IN30 = *ON
     C                   ENDIF
     C                   EVAL      ZAMSID = 'LEI0015'
     C                   EXSR      ZASNMS
 
     C                   ELSE
     C                   EVAL      WSavPCRF = PCRF
     C                   IF        #0ACTN = 'I'  OR  #0ACTN = 'A'  OR
     C                             #0ACTN = 'D'
 
     C     KTISP1B       CHAIN     LETISPLY
 
     C                   IF        PMode = 'I'
     C                   IF        %FOUND(LETISPLY)  AND  #0ACTN = 'I'
     C                   EVAL      *IN28 = *ON
     C                   EVAL      *IN31 = *ON
     C                   IF        #0FACL <> *BLANKS
     C                   EVAL      *IN29 = *ON
     C                   ELSE
     C                   EVAL      *IN30 = *ON
     C                   ENDIF
     C                   EVAL      ZAMSID = 'LEI0003'
     C                   EXSR      ZASNMS
     C                   ENDIF
 
     C                   IF        NOT %FOUND(LETISPLY)  AND  #0ACTN = 'I'
     C     KTISP1B       CHAIN     LETISPLW
     C                   IF        %FOUND(LETISPLW)
     C                   EVAL      WReplace = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        NOT %FOUND(LETISPLY)  AND  #0ACTN = 'A'  OR
     C                             NOT %FOUND(LETISPLY)  AND  #0ACTN = 'D'
     C                   EVAL      *IN28 = *ON
     C                   EVAL      *IN31 = *ON
     C                   IF        #0FACL <> *BLANKS
     C                   EVAL      *IN29 = *ON
     C                   ELSE
     C                   EVAL      *IN30 = *ON
     C                   ENDIF
     C                   EVAL      ZAMSID = 'LEI0004'
     C                   EXSR      ZASNMS
     C                   ENDIF
 
     C
     C                   IF        #0ACTN = 'E'  AND  PMode = 'I'
     C     KTISP1B       CHAIN     LETISPLY
 
     C                   IF        NOT %FOUND(LETISPLY)
     C     KTISP1B       CHAIN     LETISPLW
 
     C                   IF        %FOUND(LETISPLW)
     C                   EVAL      *IN62 = *ON
     C                   ELSE
     C                   EVAL      *IN28 = *ON
     C                   EVAL      *IN31 = *ON
 
     C                   IF        #0FACL <> *BLANKS
     C                   EVAL      *IN29 = *ON
     C                   ELSE
     C                   EVAL      *IN30 = *ON
     C                   ENDIF
 
     C                   EVAL      ZAMSID = 'LEI0004'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSL
     C                   ENDIF
 
     C                   IF        *IN26 = *OFF  AND  *IN27 = *OFF  AND
     C                             *IN28 = *OFF  AND  *IN29 = *OFF  AND
     C                             *IN30 = *OFF  AND  *IN31 = *OFF
     C                   EVAL      WValidKey = 'Y'
     C                   ELSE
     C                   EVAL      WValidKey = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBuildSFL - Build subfile                                   *
      *                                                               *
      *****************************************************************
     C     SRBuildSFL    BEGSR
 
      ** Start at previous highest record in SFL
 
     C                   Z-ADD     WLRCD         #0RLRN
     C                   Z-ADD     0             WRCTR
 
     C                   SELECT
 
      ** Insert (display blank subfile)
 
     C                   WHEN      #0ACTN = 'I'  OR  WToggle = 'I'
     C                   IF        #0ACTN = 'I'
     C                   EVAL      WTotAlloc = *ZERO
     C                   ENDIF
     C                   MOVEA     '100'         *IN(51)
     C                   MOVEA     '10010'       *IN(56)
     C                   EVAL      *IN82 = *OFF
     C                   IF        WToggle = 'I'
     C                   MOVE      *OFF          *IN55
     C                   MOVE      *ON           *IN57
     C                   ENDIF
     C                   EXSR      SRBldINS
 
      ** Amend
 
     C                   WHEN      #0ACTN = 'A'
     C                   EVAL      WTotAlloc = *ZERO
     C                   MOVEA     '010'         *IN(51)
     C                   MOVEA     '11011'       *IN(56)
     C                   IF        WToggle = 'A'
     C                   MOVE      *ON           *IN55
     C                   ELSE
     C                   MOVE      *OFF          *IN55
     C                   ENDIF
     C                   EXSR      SRBldAMD
 
      ** Enquire
 
     C                   WHEN      #0ACTN = 'E'
     C                   MOVEA     '111'         *IN(51)
     C                   MOVEA     '00010'       *IN(56)
     C                   EXSR      SRBldENQ
 
      ** Delete
 
     C                   WHEN      #0ACTN = 'D'
     C                   MOVEA     '111'         *IN(51)
     C                   MOVEA     '00110'       *IN(56)
     C                   EXSR      SRBldAMD
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldINS - Build INSERT subfile screen                       *
      *                                                               *
      *****************************************************************
     C     SRBldINS      BEGSR
 
      ** Display blank subfile
 
     C                   DOW       WRCTR < WSFPG
     C                   ADD       1             #0RLRN
     C                   ADD       1             WRCTR
     C                   WRITE     LE2080S0
     C                   ENDDO
 
     C                   Z-ADD     #0RLRN        WLRCD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldENQ - Build ENQUIRE subfile screen                      *
      *                                                               *
      *****************************************************************
     C     SRBldENQ      BEGSR
 
     C                   IF        *IN85 = *OFF
 
      ** Loan Income Splits
 
     C                   IF        PSplitType = 'L'
     C                   MOVE      #0LNRF        WrkLNRF
 
      ** Enquire LIVE loan income split records
 
     C                   IF        *IN62 = *OFF
     C     WrkLNRF       SETLL     LETISPLX
     C     WrkLNRF       READE     LETISPLX                               82
 
      ** Enquire ALL loan income split records
 
     C                   ELSE
     C     WrkLNRF       SETLL     LETISPLV
     C     WrkLNRF       READE     LETISPLV                               82
     C                   ENDIF
     C                   ENDIF
 
      ** Fee Income Splits
 
     C                   IF        PSplitType = 'F'
     C                   MOVEL     #0CNUM        WrkCNUM
     C                   MOVE      #0LOAN        WrkLNRF
     C                   MOVE      #0FACL        WrkFACL
     C                   MOVE      #0FESQ        WrkFESQ
 
      ** Enquire LIVE fee income split records only
 
     C                   IF        *IN62 = *OFF
     C     KTISP1B       SETLL     LETISPLY
     C     KTISP1B       READE     LETISPLY                               82
 
      ** Enquire ALL fee income split records
 
     C                   ELSE
     C     KTISP1B       SETLL     LETISPLW
     C     KTISP1B       READE     LETISPLW                               82
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Load next subfile page
 
     C                   DOW       *IN82 = *OFF  AND  WRCTR < WSFPG
 
      ** Clear subfile fields
 
     C                   EXSR      SRClrScrn
 
      ** Load subfile fields
 
     C                   EXSR      SRMove
 
      ** Output to subfile
 
     C                   ADD       1             #0RLRN
     C                   ADD       1             WRCTR
     C                   WRITE     LE2080S0
 
     C                   IF        PSplitType = 'L'
     C                   IF        *IN62 = *OFF
     C     WrkLNRF       READE     LETISPLX                               82
     C                   ELSE
     C     WrkLNRF       READE     LETISPLV                               82
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        PSplitType = 'F'
     C                   IF        *IN62 = *OFF
     C     KTISP1B       READE     LETISPLY                               82
     C                   ELSE
     C     KTISP1B       READE     LETISPLW                               82
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
 
     C                   Z-ADD     #0RLRN        WLRCD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldAMD - Build AMEND/DELETE subfile screen                 *
      *                                                               *
      *****************************************************************
     C     SRBldAMD      BEGSR
 
     C                   IF        *IN85 = *OFF
     C                   IF        PSplitType = 'L'
     C                   MOVE      #0LNRF        WrkLNRF
     C     WrkLNRF       SETLL     LETISPLX
     C     WrkLNRF       READE     LETISPLX                               82
     C                   ENDIF
 
     C                   IF        PSplitType = 'F'
     C                   MOVEL     #0CNUM        WrkCNUM
     C                   MOVE      #0LOAN        WrkLNRF
     C                   MOVE      #0FACL        WrkFACL
     C                   MOVE      #0FESQ        WrkFESQ
     C     KTISP1B       SETLL     LETISPLY
     C     KTISP1B       READE     LETISPLY                               82
     C                   ENDIF
     C                   ENDIF
 
      ** Load next subfile page
 
     C                   DOW       *IN82 = *OFF  AND  WRCTR < WSFPG
 
      ** Clear subfile fields
 
     C                   EXSR      SRClrScrn
 
      ** Load subfile fields
 
     C                   EXSR      SRMove
 
     C                   EVAL      WTotAlloc = WTotAlloc + IPAL
     C                   EVAL      WSavTotal = WTotAlloc
 
      ** Output to subfile
 
     C                   ADD       1             #0RLRN
     C                   ADD       1             WRCTR
     C                   WRITE     LE2080S0
 
     C                   IF        PSplitType = 'L'
     C     WrkLNRF       READE     LETISPLX                               82
     C                   ENDIF
 
     C                   IF        PSplitType = 'F'
     C     KTISP1B       READE     LETISPLY                               82
     C                   ENDIF
     C                   ENDDO
 
     C                   Z-ADD     #0RLRN        WLRCD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcSFL = Process subfile screen                           *
      *                                                               *
      *****************************************************************
     C     SRProcSFL     BEGSR
 
      ** Protect key fields
 
     C                   EVAL      *IN54 = *ON
 
     C                   DOU       *INKC = *ON  OR  *INKL = *ON  OR
     C                             *IN85 = *ON  OR  WFileUpd = 'Y'  OR
     C                             *INKI = *ON  OR  *INKE = *ON
 
      ** Display subfile
 
     C                   TIME                    #0TIME
     C                   WRITE     LE2080F0
     C                   WRITE     LE2080F1
     C                   WRITE     LE2080C1
     C                   EXFMT     LE2080C0
 
     C                   MOVEA     '000'         *IN(32)
 
      ** Clear messages from program message queue
 
     C                   EXSR      SRClrMsgQ
 
     C                   IF        #0ACTN = 'I'  OR  #0ACTN = 'A'
     C                   EVAL      WFileUpd = *BLANK
     C                   ENDIF
 
     C                   SELECT
     C                   WHEN      *INKC = *ON
     C                   LEAVE
 
     C                   WHEN      *INKE = *ON
     C                   EXSR      SRRefresh
 
     C                   WHEN      *INKI = *ON
     C                   EXSR      SRRefresh
     C                   IF        WToggle = 'A'
     C                   EVAL      WToggle = 'I'
     C                   ELSE
     C                   EVAL      WToggle = 'A'
     C                   ENDIF
 
     C                   WHEN      *INKJ = *ON
     C                   EVAL      WFileUpd = 'Y'
 
     C                   WHEN      *INKL = *ON
     C                   EXSR      SRCancel
 
     C                   WHEN      *IN85 = *ON
     C                   EXSR      SRRollup
 
     C                   OTHER
     C                   IF        #0ACTN <> 'D'  AND  #0ACTN <> 'E'
     C                   EXSR      SRValSFL
     C                   ENDIF
     C                   IF        #0ACTN = 'E'
     C                   EVAL      *INKL = *ON
     C                   ENDIF
     C                   IF        #0ACTN = 'D'
     C                   EVAL      ZAMSID = 'LEI0016'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDSL
 
     C                   IF        *INKC = *OFF  AND  *INKE = *OFF  AND
     C                             *INKI = *OFF  AND  *INKL = *OFF  AND
     C                             *IN85 = *OFF  AND  #0ACTN <> 'D'  AND
     C                             WErrFlag <> 'Y'
     C                   EVAL      WFileUpd = 'Y'
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValSFL = Validate subfile details                          *
      *                                                               *
      *****************************************************************
     C     SRValSFL      BEGSR
 
     C                   IF        #0ACTN = 'I'
     C                   EVAL      WTotAlloc = *ZERO
     C                   ELSE
     C                   EVAL      WTotAlloc = WSavTotal
     C                   ENDIF
     C                   EVAL      WRepRec = 'N'
     C                   EVAL      Ix = *ZERO
     C                   EVAL      Iy = *ZERO
     C                   CLEAR                   ArrCNUM
     C                   CLEAR                   ArrISCN
 
     C                   IF        PMode = 'I'
 
      ** Process all modified subfile records
 
     C                   READC     LE2080S0                               86
 
     C                   DOW       *IN86 = *OFF
 
     C                   EXSR      SRReset
 
      ** Process details according to action code.
 
     C                   SELECT
 
      ** Insert
 
     C                   WHEN      #0ACTN = 'I'  OR  WToggle = 'I'
     C                   IF        #0ISCN <> *BLANKS  OR  #0IPAL <> *BLANKS
     C                   EXSR      SRVSplitC
     C                   EXSR      SRVIPAlloc
     C                   ENDIF
 
      ** Amend
 
     C                   WHEN      #0ACTN = 'A'
     C                   EXSR      SRVSelect
     C                   EXSR      SRVIPAlloc
     C                   ENDSL
 
      ** Set screen conditioning indicators
 
     C                   EVAL      *IN84 = *ON
     C                   UPDATE    LE2080S0
     C                   EVAL      *IN84 = *OFF
 
     C                   READC     LE2080S0                               86
     C                   ENDDO
 
     C                   IF        #0ACTN = 'A'  AND  WTotAlloc > 100
     C                   EVAL      ZAMSID = 'LEI0012'
     C                   EXSR      ZASNMS
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVSelect - Validate selection field                         *
      *                                                               *
      *****************************************************************
     C     SRVSelect     BEGSR
 
     C                   IF        #0SELE <> *BLANKS  AND  #0SELE <> 'D'
     C                   EVAL      *IN32 = *ON
     C                   EVAL      ZAMSID = 'LEI0005'
     C                   EXSR      ZASNMS
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVSplitC - Validate split customer                          *
      *                                                               *
      *****************************************************************
     C     SRVSplitC     BEGSR
 
     C                   IF        #0ISCN = *BLANKS
     C                   EVAL      *IN33 = *ON
     C                   EVAL      ZAMSID = 'LEI0006'
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   EVAL      PCustomer = #0ISCN
     C                   EVAL      WrkVar1 = #0ISCN
 
     C                   IF        PMode = 'B'  AND  WrkVar1 = '?'
     C                   EVAL      ZAMSID = 'LEI0006'
     C                   EXSR      ZASNMS
     C                   ELSE
 
      ** Call to access pgm for Customer details
 
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PCustomer
     C                   PARM      *BLANKS       PKyst
     C     SDCUST        PARM      *BLANKS       DSSDY
 
     C                   IF        PRetCode <> *BLANKS  AND
     C                             PRetCode <> '*NRF   '  AND
     C                             PRetCode <> '*NOSEL '  AND
     C                             PRetCode <> '*KEY   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBKEY = PCustomer
     C                   EVAL      DBASE = 5
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRetCode = '*NOSEL '  OR
     C                             PRetCode = '*NRF   '  OR
     C                             PRetCode = '*KEY   '
     C                   EVAL      *IN33 = *ON
     C                   EVAL      ZAMSID = 'LEI0006'
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   EVAL      #0ISCN = BBCUST
 
      ** Check if split customer was specified more than once
 
     C                   IF        PMode = 'I'
     C     BBCUST        LOOKUP    ArrCNUM                                87
     C                   IF        *IN87 = *ON
     C                   EVAL      *IN33 = *ON
     C                   EVAL      ZAMSID = 'LEI0013'
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      ArrCNUM(Ix) = BBCUST
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *IN33 = *OFF  AND  WToggle = 'I'  OR
     C                             PMode = 'B'  AND  #0ACTN = 'I'
 
      ** Check if the split customer already exists (but deleted)
      ** for this loan
 
     C                   IF        PSplitType = 'L'
     C                   MOVE      #0LNRF        WrkLNRF
     C                   MOVEL     #0ISCN        WrkISCN
 
     C     KTISP3        CHAIN     LETISPLV                           89
     C                   ENDIF
 
      ** For fee
 
     C                   IF        PSplitType = 'F'
     C                   MOVEL     #0CNUM        WrkCNUM
     C                   MOVE      #0LOAN        WrkLNRF
     C                   MOVE      #0FACL        WrkFACL
     C                   MOVE      #0FESQ        WrkFESQ
     C                   MOVEL     #0ISCN        WrkISCN
 
     C     KTISP1A       CHAIN     LETISPLW                           89
     C                   ENDIF
 
     C                   IF        *IN89 = *OFF  AND  RECI = 'D'
     C                   EVAL      *IN33 = *ON
     C                   EVAL      ZAMSID = 'LEI0007'
     C                   EXSR      ZASNMS
     C                   ENDIF
 
     C                   IF        *IN89 = *OFF  AND  RECI = 'R'
     C                   EVAL      WRepRec = 'Y'
     C                   EVAL      Iy = Iy + 1
     C                   EVAL      ArrISCN(Iy) = #0ISCN
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVIPAlloc - Validate Income Percentage Allocation           *
      *                                                               *
      *****************************************************************
     C     SRVIPAlloc    BEGSR
 
     C                   IF        #0IPAL = *BLANKS
     C                   EVAL      *IN34 = *ON
     C                   EVAL      ZAMSID = 'LEI0008'
     C                   EXSR      ZASNMS
 
     C                   ELSE
     C                   MOVE      *BLANKS       ZFLD16
     C                   MOVEL     #0IPAL        ZFLD16
     C                   Z-ADD     9             ZSDEC
     C                   Z-ADD     3             ZSDIG
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZAlignOk
     C                   PARM                    ZFLD16
     C                   PARM                    ZSDEC
     C                   PARM                    ZSDIG
 
     C                   EVAL      WrkIPAL = *ZERO
     C                   MOVE      ZFLD16        WrkIPAL
 
     C                   IF        ZAlignOk = 'N'  OR  WrkIPAL = *ZERO
     C                   EVAL      *IN34 = *ON
     C                   EVAL      ZAMSID = 'LEI0008'
     C                   EXSR      ZASNMS
     C                   ELSE
 
     C                   Z-ADD     9             ZSDEC
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFLD16
     C                   PARM                    ZSDEC
 
     C                   MOVE      ZFLD16        #0IPAL
     C                   ENDIF
 
      ** Total income percentage allocation must not exceed 100%
 
     C                   SELECT
     C                   WHEN      PMode = 'I'
     C                   IF        *IN34 = *OFF
     C                   IF        #0ACTN <> 'A'
     C                   EVAL      WTotAlloc = WTotAlloc + WrkIPAL
 
     C                   IF        WTotAlloc > 100
     C                   EVAL      *IN34 = *ON
     C                   EVAL      ZAMSID = 'LEI0012'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ELSE
     C                   EVAL      WTotAlloc = WTotAlloc - #0IPAL#
     C                   EVAL      WTotAlloc = WTotAlloc + WrkIPAL
     C                   ENDIF
     C                   ENDIF
 
      ** If in batch mode, update the total IPA work field for every
      ** record being inserted or amended; after all incoming records
      ** for this batch has been processed, total IPA must not exceed 100%
 
     C                   WHEN      PMode = 'B'
     C                   IF        #0ACTN = 'I'
     C                   EVAL      WTotAlloc = WTotAlloc + WrkIPAL
     C                   ENDIF
 
     C                   IF        #0ACTN = 'A'
     C                   IF        PSplitType = 'L'
     C                   MOVE      #0LNRF        WrkLNRF
     C                   MOVEL     #0ISCN        WrkISCN
     C     KTISP0        CHAIN     LETISPLX
     C                   IF        %FOUND(LETISPLX)
     C                   EVAL      WTotAlloc = WTotAlloc - IPAL + WrkIPAL
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        PSplitType = 'F'
     C                   MOVEL     #0CNUM        WrkCNUM
     C                   MOVE      #0LOAN        WrkLNRF
     C                   MOVE      #0FACL        WrkFACL
     C                   MOVE      #0FESQ        WrkFESQ
     C                   MOVEL     #0ISCN        WrkISCN
     C     KTISP1A       CHAIN     LETISPLY
     C                   IF        %FOUND(LETISPLY)
     C                   EVAL      WTotAlloc = WTotAlloc - IPAL + WrkIPAL
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #0ACTN = 'D'
     C                   EVAL      WTotAlloc = WTotAlloc - WrkIPAL
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdFile - Update File                                      *
      *                                                               *
      *****************************************************************
     C     SRUpdFile     BEGSR
 
     C                   SELECT
     C                   WHEN      #0ACTN = 'I'  OR  WToggle = 'I'
     C                   IF        WReplace = 'Y'  OR  WRepRec = 'Y'
     C                   EXSR      SRReplace
     C                   ENDIF
 
     C                   IF        PMode = 'I'
     C                   READC     LE2080S0                               86
     C                   DOW       *IN86 = *OFF
     C                   IF        #0ISCN <> *BLANKS  AND  #0IPAL <> *BLANKS
     C                   EXSR      SRInsert
     C                   ENDIF
     C                   READC     LE2080S0                               86
     C                   ENDDO
     C                   ELSE
     C                   EVAL      #0SELE = *BLANKS
     C                   EXSR      SRInsert
     C                   ENDIF
 
     C                   WHEN      #0ACTN = 'D'
 
      ** Allow deletion of bulk/all income split records (SRDelete)
      ** of a loan/fee only in interactive mode
 
     C                   IF        PMode = 'I'
     C                   EXSR      SRDelete
 
      ** In batch mode, delete records one at a time (treat as if
      ** selection field is 'D' as in interactive mode)
 
     C                   ELSE
     C                   EVAL      #0SELE = 'D'
     C                   EXSR      SRAmend
     C                   ENDIF
 
     C                   WHEN      #0ACTN = 'A'
     C                   IF        PMode = 'I'
     C                   READC     LE2080S0                               86
     C                   DOW       *IN86 = *OFF
     C                   EXSR      SRAmend
     C                   READC     LE2080S0                               86
     C                   ENDDO
     C                   ELSE
     C                   EVAL      #0SELE = *BLANKS
     C                   EXSR      SRAmend
     C                   ENDIF
     C                   ENDSL
 
     C                   IF        PMode <> 'B'
     C                   IN        SDSTAT
     C                   IN        SC24X7
 
     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = 'LIBR'
     C                   EXSR      LOG247
     C                   EVAL      WLogValid = 'V'
     C                   EXSR      APLGTR
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        PMode <> 'B'
     C                   COMMIT
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInsert - Insert record(s) in LETISPPD                      *
      *                                                               *
      *****************************************************************
     C     SRInsert      BEGSR
 
     C                   EVAL      RECI = 'D'
     C                   MOVEL     #0CNUM        CNUM
     C                   MOVE      #0FACL        FACL
     C                   MOVE      #0FESQ        FESQ
     C                   MOVEL     #0ISCN        ISCN
 
     C                   MOVE      *BLANKS       ZFLD16
     C                   MOVEL     #0IPAL        ZFLD16
     C                   Z-ADD     9             ZSDEC
     C                   Z-ADD     3             ZSDIG
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZAlignOk
     C                   PARM                    ZFLD16
     C                   PARM                    ZSDEC
     C                   PARM                    ZSDIG
 
     C                   MOVE      ZFLD16        IPAL
 
     C                   IF        PSplitType = 'L'
     C                   MOVE      #0LNRF        LNRF
     C                   EVAL      BRCA = C_BRCA
     C                   EVAL      PBranch = C_BRCA
     C                   ELSE
     C                   MOVE      #0LOAN        LNRF
     C                   EVAL      BRCA = FEBRCA
     C                   EVAL      PBranch = FEBRCA
     C                   ENDIF
 
      ** Access Branch Code Details
 
     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PBranch
     C     SDBRCH        PARM      SDBRCH        DSFDY
 
     C                   IF        PRetCode <> *BLANKS  AND
     C                             PRetCode <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = PBranch
     C                   EVAL      DBASE  = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      LCD = BJRDNB
     C                   EVAL      CHTP = 'I'
 
     C                   IF        PMode <> 'B'
     C******LOCK         IN        LEALLO                                                     CLE148
     C**********         EVAL      PCNEXT = PCLAST + 1                                        CLE148
     C                   CALL      'LEALLO'                                                   CLE148
     C                   PARM      *BLANKS       PRTCD                                        CLE148
     C                   PARM      'Y'           PUPDT                                        CLE148
     C                   PARM      *BLANKS       PCLAST                                       CLE148
     C                   PARM      *BLANKS       PCNEXT                                       CLE148
      *                                                                                       CLE148
     C                   MOVE      PCNEXT        PCNEXTA
     C                   EVAL      %SUBST(PCRF:1:3) = %SUBST(A8MQSM:1:3)
     C                   EVAL      %SUBST(PCRF:4:8) = PCNEXTA
     C                   EVAL      %SUBST(PCRF:12:4) = '0001'
     C**********         EVAL      PCLAST = PCNEXT                                            CLE148
     C**********         OUT       LEALLO                                                     CLE148
     C************       EVAL      PPCR = C_PCRF
     C                   EVAL      PPCR = WSavPCRF
     C                   ELSE
     C                   EVAL      PCRF = I1PCRF
     C                   EVAL      PPCR = I1PPCR
     C                   ENDIF
 
     C                   WRITE     LETISP0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAmend - Amend/delete record in LETISPPD                    *
      *                                                               *
      *****************************************************************
     C     SRAmend       BEGSR
 
      ** LOAN
 
     C                   IF        PSplitType = 'L'
     C                   MOVE      #0LNRF        WrkLNRF
     C                   MOVEL     #0ISCN        WrkISCN
     C     KTISP0        CHAIN     LETISPL0                           89
     C                   ENDIF
 
      ** FEE
 
     C                   IF        PSplitType = 'F'
     C                   MOVEL     #0CNUM        WrkCNUM
     C                   MOVE      #0LOAN        WrkLNRF
     C                   MOVE      #0FACL        WrkFACL
     C                   MOVE      #0FESQ        WrkFESQ
     C                   MOVEL     #0ISCN        WrkISCN
     C     KTISP1A       CHAIN     LETISPL1                           89
     C                   ENDIF
 
      ** Update record if found
 
     C                   IF        *IN89 = *OFF
     C                   IF        #0SELE <> 'D'
     C                   MOVE      *BLANKS       ZFLD16
     C                   MOVEL     #0IPAL        ZFLD16
     C                   Z-ADD     9             ZSDEC
     C                   Z-ADD     3             ZSDIG
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZAlignOk
     C                   PARM                    ZFLD16
     C                   PARM                    ZSDEC
     C                   PARM                    ZSDIG
 
     C                   MOVE      ZFLD16        IPAL
     C                   EVAL      LCD = BJRDNB
     C                   EVAL      CHTP = 'A'
 
      ** Delete record
 
     C                   ELSE
     C                   EVAL      RECI = 'R'
     C                   EVAL      LCD = BJRDNB
     C                   EVAL      CHTP = 'D'
     C                   ENDIF
 
     C                   IF        PSplitType = 'L'
     C                   UPDATE    LETISP0
     C                   ENDIF
 
     C                   IF        PSplitType = 'F'
     C                   UPDATE    LETISP1
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDelete - Delete record(s) in LETISPPD                      *
      *                                                               *
      *****************************************************************
     C     SRDelete      BEGSR
 
      ** LOAN
 
     C                   IF        PSplitType = 'L'
     C                   MOVE      #0LNRF        WrkLNRF
 
     C     WrkLNRF       SETLL     LETISPL0
     C     WrkLNRF       READE     LETISPL0
 
     C                   DOW       NOT %EOF(LETISPL0)
     C                   EVAL      RECI = 'R'
     C                   EVAL      LCD = BJRDNB
     C                   EVAL      CHTP = 'D'
 
     C                   UPDATE    LETISP0
     C     WrkLNRF       READE     LETISPL0
     C                   ENDDO
     C                   ENDIF
 
      ** FEE
 
     C                   IF        PSplitType = 'F'
     C                   MOVEL     #0CNUM        WrkCNUM
     C                   MOVE      #0LOAN        WrkLNRF
     C                   MOVE      #0FACL        WrkFACL
     C                   MOVE      #0FESQ        WrkFESQ
 
     C     KTISP1B       SETLL     LETISPL1
     C     KTISP1B       READE     LETISPL1
 
     C                   DOW       NOT %EOF(LETISPL1)
     C                   EVAL      RECI = 'R'
     C                   EVAL      LCD = BJRDNB
     C                   EVAL      CHTP = 'D'
 
     C                   UPDATE    LETISP1
     C     KTISP1B       READE     LETISPL1
     C                   ENDDO
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReplace - Physically delete records in LETISPPD            *
      *                                                               *
      *****************************************************************
     C     SRReplace     BEGSR
 
      ** LOAN
 
     C                   IF        PSplitType = 'L'
     C                   MOVE      #0LNRF        WrkLNRF
 
      ** Delete all records for loan
 
     C                   IF        WReplace = 'Y'
     C     WrkLNRF       SETLL     LETISPL3
     C     WrkLNRF       READE     LETISPL3
 
     C                   DOW       NOT %EOF(LETISPL3)
 
     C                   IF        RECI = 'R'
     C                   DELETE    LETISP3
     C                   ENDIF
 
     C     WrkLNRF       READE     LETISPL3
     C                   ENDDO
     C                   ENDIF
 
      ** Delete certain records to be replaced
 
     C                   IF        WRepRec = 'Y'
     C                   EVAL      Iy = 1
 
     C                   DOW       ArrISCN(Iy) <> *BLANKS
     C                   MOVE      ArrISCN(Iy)   WrkISCN
 
     C     KTISP3        CHAIN     LETISPL3
 
     C                   IF        %FOUND  AND  RECI = 'R'
     C                   DELETE    LETISP3
     C                   ENDIF
     C                   EVAL      Iy = Iy + 1
     C                   ENDDO
 
     C                   ENDIF
     C                   ENDIF
 
      ** FEE
 
     C                   IF        PSplitType = 'F'
     C                   MOVEL     #0CNUM        WrkCNUM
     C                   MOVE      #0LOAN        WrkLNRF
     C                   MOVE      #0FACL        WrkFACL
     C                   MOVE      #0FESQ        WrkFESQ
 
      ** Delete all records for fee
 
     C                   IF        WReplace = 'Y'
     C     KTISP1B       SETLL     LETISPL4
     C     KTISP1B       READE     LETISPL4
 
     C                   DOW       NOT %EOF(LETISPL4)
 
     C                   IF        RECI = 'R'
     C                   DELETE    LETISP4
     C                   ENDIF
 
     C     KTISP1B       READE     LETISPL4
     C                   ENDDO
     C                   ENDIF
 
      ** Delete certain records to be replaced
 
     C                   IF        WRepRec = 'Y'
     C                   EVAL      Iy = 1
 
     C                   DOW       ArrISCN(Iy) <> *BLANKS
     C                   MOVE      ArrISCN(Iy)   WrkISCN
 
     C     KTISP1A       CHAIN     LETISPL4
 
     C                   IF        %FOUND  AND  RECI = 'R'
     C                   DELETE    LETISP4
     C                   ENDIF
     C                   EVAL      Iy = Iy + 1
     C                   ENDDO
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCancel - F12 pressed                                       *
      *                                                               *
      *****************************************************************
     C     SRCancel      BEGSR
 
      ** Reset number of records in subfile
 
     C                   EVAL      WLRCD = *ZERO
     C                   EVAL      #0RLRN = *ZERO
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SRRollup - Rollup requested                                  *
      *                                                               *
      *****************************************************************
     C     SRRollup      BEGSR
 
     C                   IF        #0ACTN = 'I'  OR  WToggle = 'I'
     C                   EXSR      SRReset
     C                   EXSR      SRClrScrn
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRefresh - F5 pressed                                       *
      *                                                               *
      *****************************************************************
     C     SRRefresh     BEGSR
 
      ** Reset number of records in subfile
 
     C                   EVAL      WLRCD = *ZERO
     C                   EVAL      #0RLRN = *ZERO
     C                   EVAL      #0IPAL# = *ZERO
     C                   EVAL      Ix = *ZERO
     C                   CLEAR                   ArrCNUM
     C                   EXSR      SRReset
     C                   EXSR      SRClrScrn
 
      ** Clear subfile
 
     C                   EVAL      *IN80 = *ON
     C                   WRITE     LE2080C0
     C                   EVAL      *IN80 = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBatch - Batch processing subroutine                        *
      *                                                               *
      *****************************************************************
     C     SRBatch       BEGSR
 
     C                   EVAL      #0LNRF = *BLANKS
     C                   EVAL      #0CNUM = *BLANKS
     C                   EVAL      #0FACL = *BLANKS
     C                   EVAL      #0LOAN = *BLANKS
     C                   EVAL      #0FESQ = *BLANKS
     C                   EVAL      #0ISCN = *BLANKS
 
     C                   EVAL      #0ACTN = I1ACTN
     C**********         IF        I1LNRF <> 0                                                CLE148
     C                   IF        I1LNRF <> *BLANKS                                          CLE148
     C                   IF        PSplitType = 'L'
     C                   MOVEL     I1LNRF        #0LNRF
     C                   ELSE
     C                   MOVEL     I1LNRF        #0LOAN
     C                   ENDIF
     C                   ENDIF
     C**********         IF        I1CNUM <> 0                                               CSD027A
     C                   IF        I1CNUM <> *Blanks                                         CSD027A
     C                   MOVEL     I1CNUM        #0CNUM
     C                   ENDIF
     C                   IF        I1FACL <> 0
     C                   MOVEL     I1FACL        #0FACL
     C                   ENDIF
     C                   IF        I1FESQ <> 0
     C                   MOVEL     I1FESQ        #0FESQ
     C                   ENDIF
     C**********         IF        I1ISCN <> 0                                               CSD027A
     C                   IF        I1ISCN <> *Blanks                                         CSD027A
     C                   MOVEL     I1ISCN        #0ISCN
     C                   ENDIF
     C                   EVAL      #0IPAL = I1IPAL
 
     C                   EVAL      I2MSGT = I1MSGT
     C                   EVAL      I2TRUS = I1TRUS
     C                   EVAL      I2TRWS = I1TRWS
     C                   EVAL      I2TNRF = I1TNRF
     C                   EVAL      I2TRSN = I1TRSN
     C                   EVAL      I2ACTN = I1ACTN
     C                   EVAL      I2TRDS = I1TRDS
     C                   EVAL      I2TRTS = I1TRTS
     C                   EVAL      I2NRBA = I1NRBA
 
     C                   EVAL      I2LNRF = I1LNRF
     C                   EVAL      I2LNRF = I1LNRF
     C                   EVAL      I2CNUM = I1CNUM
     C                   EVAL      I2FACL = I1FACL
     C                   EVAL      I2FESQ = I1FESQ
     C                   EVAL      I2ISCN = I1ISCN
 
     C                   EVAL      WToggle = *BLANK
 
     C                   EXSR      SRValKey
     C                   ADD       1             WRecCount
     C                   IF        WRecCount = 1
 
     C                   IF        PSplitType = 'L'
     C                   MOVE      #0LNRF        WrkLNRF
     C     WrkLNRF       SETLL     LETISPLX
     C     WrkLNRF       READE     LETISPLX
     C                   DOW       NOT %EOF(LETISPLX)
     C                   EVAL      WTotAlloc = WTotAlloc + IPAL
     C     WrkLNRF       READE     LETISPLX
     C                   ENDDO
     C                   ENDIF
 
     C                   IF        PSplitType = 'F'
     C                   MOVEL     #0CNUM        WrkCNUM
     C                   MOVE      #0LOAN        WrkLNRF
     C                   MOVE      #0FACL        WrkFACL
     C                   MOVE      #0FESQ        WrkFESQ
     C     KTISP1B       SETLL     LETISPLY
     C     KTISP1B       READE     LETISPLY
     C                   DOW       NOT %EOF(LETISPLY)
     C                   EVAL      WTotAlloc = WTotAlloc + IPAL
     C     KTISP1B       READE     LETISPLY
     C                   ENDDO
     C                   ENDIF
     C                   ENDIF
 
     C                   EXSR      SRVSplitC
     C                   EXSR      SRVIPAlloc
 
     C                   IF        I1LAST = 'Y'
     C                   IF        WTotAlloc > 100
     C                   EVAL      ZAMSID = 'LEI0012'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
 
     C                   EXSR      SRUpdFile
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClrScrn - Clear subfile fields                             *
      *                                                               *
      *****************************************************************
     C     SRClrScrn     BEGSR
 
     C                   EVAL      #0SELE = *BLANKS
     C                   EVAL      #0ISCN = *BLANKS
     C                   EVAL      #0IPAL = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMove - Move file fields to subfile fields                  *
      *                                                               *
      *****************************************************************
     C     SRMove        BEGSR
 
     C                   MOVEL     ISCN          #0ISCN
     C                   Z-ADD     IPAL          #0IPAL#
 
     C                   IF        IPAL <> 0
     C                   MOVE      *BLANKS       ZFLD16
     C                   MOVE      IPAL          ZFLD16
     C                   Z-ADD     9             ZSDEC
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFLD16
     C                   PARM                    ZSDEC
 
     C                   MOVE      ZFLD16        #0IPAL
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  LOGDEL - Delete record from 24x7 Midas Availability Log      *
      *                                                               *
      *****************************************************************
     C     LOGDEL        BEGSR
 
     C                   EVAL      WMsgType = 'LE' + 'STAL'
     C                   EVAL      WFrOffId = PCRF
 
     C                   OPEN      APILOGL0
 
     C     KFLDS4        CHAIN     APILOG0
 
     C                   IF        %FOUND(APILOGL0)
     C                   DELETE    APILOG0
     C                   ENDIF
 
     C                   CLOSE     APILOGL0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  LOG247 - Convert fields to the 24x7 Midas Availability Log   *
      *                                                               *
      *****************************************************************
     C     LOG247        BEGSR
 
     C                   EVAL      I1MSGT = *BLANKS
     C                   EVAL      I1TRUS = *BLANKS
     C                   EVAL      I1TRWS = *BLANKS
     C                   EVAL      I1TNRF = *BLANKS
     C                   EVAL      I1TRSN = *BLANKS
     C                   EVAL      I1ACTN = *BLANKS
     C                   EVAL      I1TRDS = *BLANKS
     C                   EVAL      I1TRTS = *BLANKS
     C                   EVAL      I1NRBA = *ZERO
 
     C                   MOVE      #0LNRF        I1LNRF
     C                   MOVEL     #0CNUM        I1CNUM
     C                   MOVE      #0FACL        I1FACL
     C                   MOVE      #0FESQ        I1FESQ
     C                   MOVEL     #0ISCN        I1ISCN
     C                   EVAL      I1IPAL = #0IPAL
     C                   EVAL      I1PCRF = *BLANKS
     C                   EVAL      I1PPCR = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  APLGTR - Write Transaction to 24x7 Midas Availability Log    *
      *                                                               *
      *****************************************************************
     C     APLGTR        BEGSR
 
     C                   EVAL      APTRAN = I1MFPD
     C                   EVAL      APMTYP = 'LE' + 'TISP'
     C                   EVAL      APSOFC = PCRF
 
      ** Generate timestamp
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    WrkTMST
 
     C                   MOVE      WrkTMST       APSTMS
 
     C                   IF        WLogValid = 'V'
     C                   OPEN      APVLOGPD
     C                   WRITE     APVLOGD0
     C                   CLOSE     APVLOGPD
     C                   ENDIF
 
     C                   IF        WLogValid = 'I'
     C                   OPEN      APILOGPD
     C                   WRITE     APILOGD0
     C                   CLOSE     APILOGPD
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClrMsgQ - Clear message queue                              *
      *                                                               *
      *****************************************************************
     C     SRClrMsgQ     BEGSR
 
     C                   EVAL      WErrFlag = 'N'
 
     C                   CALL      'Y2CLMSC'
     C                   PARM                    ZAPGMQ
     C                   PARM      '*SAME'       ZAPGRL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZASNMS - Send messages to the program's message queue        *
      *                                                               *
      *****************************************************************
     C     ZASNMS        BEGSR
 
     C                   EVAL      WErrFlag = 'Y'
 
     C                   IF        PMode = 'B'
     C                   EXSR      SRBERR
 
     C                   ELSE
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM                    ZAMSTP
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBERR - Set up Batch Error Details                          *
      *                                                               *
      *****************************************************************
     C     SRBERR        BEGSR
 
     C                   CALL      'Y2RVMGC'
     C                   PARM                    PRetCode
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM                    ZAMSTX
 
     C                   IF        I2MSGS = ' '
     C                   EVAL      I2MSGS = 'E'
     C                   ENDIF
 
     C                   IF        I1RPLC = 'B'
     C                   CALL      'LEC0215'
     C                   PARM                    XREPN
 
     C                   EVAL      XMSID = ZAMSID
     C                   EVAL      SACTN = #0ACTN
     C                   IF        PSplitType = 'L'
     C                   MOVE      #0LNRF        SNLON
     C                   ELSE
     C                   MOVE      #0LOAN        SNLON
     C                   ENDIF
     C                   MOVEL     #0CNUM        SNCUS
     C                   MOVE      #0FACL        SFACL
     C                   MOVE      #0FESQ        SFESQ
     C                   MOVEL     #0ISCN        SISCN
     C                   MOVE      #0IPAL        SIPAL
 
     C                   EVAL      SPCRF = I1PCRF
     C                   EVAL      SPPRF = I1PPCR
 
 
     C                   IN        SDSTAT
     C                   IN        SC24X7
 
     C                   IF        CSC011 = 'Y'  AND  S1SUPP = LIBR
     C                   EXSR      LOG247
     C                   EVAL      WLogValid = 'I'
     C                   EXSR      APLGTR
     C                   ENDIF
 
     C                   MOVE      WrkTMST       STMST
     C                   WRITE     LEITISD0
 
     C                   EVAL      I2MSGS = *BLANK
     C                   ENDIF
 
     C                   EVAL      I2MSGI = ZAMSID
     C                   EVAL      I2MSTX = ZAMSTX
 
     C                   IF        I1RPLC <> 'B'
     C                   DUMP
     C                   ENDIF
 
     C                   MOVE      *ON           *INLR
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReset - Reset error indicators                             *
      *                                                               *
      *****************************************************************
 
     C     SRReset       BEGSR
 
     C                   EVAL      *IN32 = *OFF
     C                   EVAL      *IN33 = *OFF
     C                   EVAL      *IN34 = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation subroutine.                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PMode
     C                   PARM                    PSplitType
     C                   PARM                    I1MFPD
     C                   PARM                    I2MFPD
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = '*CALL'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if CSC011 is on
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CSC011'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRetCode <> *BLANKS  AND
     C                             PRetCode <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY  = PSard
     C                   EVAL      DBASE  = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRetCode = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   ELSE
     C                   EVAL      CSC011 = 'N'
     C                   ENDIF
 
      ** Set the system information display fields
 
     C                   EVAL      #0RUNA = BJMRDT
     C                   EVAL      #0USER = PSUser
     C                   EVAL      #0WSID = PSJobName
     C                   EVAL      #1PGMQ = PSProcMod
     C                   EVAL      ZAPGMQ = PSProcName
     C                   EVAL      ZAMSGF = 'GBLERMSGF'
 
      ** Retrieve dataarea details
 
     C                   IN        RUNDAT
 
      ** Set display fields/narratives depending on split type (loan or fee)
 
     C                   IF        PSplitType = 'L'
     C                   EVAL      *IN61 = *ON
     C                   ENDIF
 
     C                   IF        PSplitType = 'F'
     C                   EVAL      *IN61 = *OFF
     C                   ENDIF
 
      ** Clear messages from program message queue
 
     C                   EXSR      SRClrMsgQ
 
     C                   Z-ADD     13            WSFPG
     C                   EVAL      WTotAlloc = *ZERO
     C                   EVAL      WRecCount = *ZERO
 
      ** Key list for LETISPL0/LETISPLX
 
     C     KTISP0        KLIST
     C                   KFLD                    WrkLNRF
     C                   KFLD                    WrkISCN
 
      ** First key list for LETISPL1 (complete keys)
 
     C     KTISP1A       KLIST
     C                   KFLD                    WrkCNUM
     C                   KFLD                    WrkLNRF
     C                   KFLD                    WrkFACL
     C                   KFLD                    WrkFESQ
     C                   KFLD                    WrkISCN
 
      ** Second key list for LETISPL1 (partial keys)
 
     C     KTISP1B       KLIST
     C                   KFLD                    WrkCNUM
     C                   KFLD                    WrkLNRF
     C                   KFLD                    WrkFACL
     C                   KFLD                    WrkFESQ
 
      ** Key list for LETISPL3/LETISPLV
 
     C     KTISP3        KLIST
     C                   KFLD                    WrkLNRF
     C                   KFLD                    WrkISCN
 
      ** Key list for FCLTYL0
 
     C     KFCLT0        KLIST
     C                   KFLD                    WrkCNUM
     C                   KFLD                    WrkFACT
     C                   KFLD                    WrkFCNO
 
      ** Key list for LEFEEDL1
 
     C     KFEED1        KLIST
     C                   KFLD                    WrkCNUM
     C                   KFLD                    WrkFACL
     C                   KFLD                    WrkLNRF
     C                   KFLD                    WrkFESQ
 
      ** API Invalid Log File Key List
 
     C     KFLDS4        KLIST
     C                   KFLD                    WMsgType
     C                   KFLD                    WFrOffId
     C                   KFLD                    WTimeStamp
 
      **---------------------------------------------------------------
      ** The following /COPY line sets the Program, Module, and
      ** Procedure names for Database Error Processing.
     C/COPY ZACPYSRC,DBFIELDS
      **---------------------------------------------------------------
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
      *****************************************************************
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   ENDIF
 
     C                   ROLBK
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
 
     C                   IF        PMode <> 'B'
     C                   ROLBK
     C                   CALL      'DBERRCTL'
     C                   ELSE
     C                   EVAL      I2MSGS = 'D'
     C                   EVAL      ZAMSID = 'LEI0035'
     C                   EXSR      ZASNMS
     C                   ENDIF
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2003
