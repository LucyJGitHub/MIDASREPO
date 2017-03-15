     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CG Retail Advice for GL - Driver')               *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG003810 - Midas CG Retail Advice for GL - Driver            *
      *                                                               *
      *  Function:  This program drives the customer correspondence   *
      *             Retail Advice for GL                              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CGL154             Date 13Oct14               *
      *  Prev Amend No. CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205             Date 23Feb10               *
      *                 CAP204             Date 09Feb10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CRE020  *CREATE    Date 20Jan04               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CGL154 - FATCA Reporting (Recompile)                         *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *  CAP204 - Teller Related APIs - Account Transfer              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Function of Indicators                                       *
      *                                                               *
      *  U7+U8 - Database Error                                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRMain     - Handles main program execution.                 *
      *  SRIC       - Handles Input Cycle processing.                 *
      *  SRChkAdv   - Checks the advice index file.                   *
      *  SRChkAcc   - Checks the current account.                     *
      *  SRIsRetAcc - Checks if the current account is a RE Account.  *
      *  SRAcAPTrA  - Checks if the current account allows the        *
      *               printing of Transaction Advices.                *
      *  SRRTAPTrA  - Checks if the current Retail Transaction Type   *
      *               allows the printing of Transaction Advices.     *
      *  SRPrtAdv   - Prints Transaction Advices.                     *
      *  SRPush     - Pushes values on the stack.                     *
      *  SRPop      - Pops (unwinds) values off the stack.            *
      *  SRClear    - Clears the stack.                               *
      *  SRAudit    - Handles auditing via CG9020 and CGZAUDIT.       *
      *  *INZSR     - Program Initialisation Subroutine               *
      *  *PSSR      - Program Exception Subroutine                    *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FREADVCL0  UF   E           K DISK    INFSR(*PSSR)
      ** Midas RE Settled Transaction Index File by RPRGMN
 
     FRERSACL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Account Movements by TNMR
 
     FGLJENPL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Journal Entry Posting Update by BTBTNB/BTBINB
 
     FREIAC     IF   E           K DISK    INFSR(*PSSR)
      ** Midas RE Interest & Charges File by CNUM/CCY/ACOD/ASEQ/BRCH
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details Data Structure
 
     D SDRETR        E DS                  EXTNAME(SDRETRPD)
      ** Retail Transaction Type Details Data Structure
 
     D GLACNT        E DS                  EXTNAME(ACCNTAB)
     D  BRCH         E                     EXTFLD(BRCA)
      ** Account Details Data Structure
 
     D GLACMT        E DS                  EXTNAME(RSACMTPD)
      ** Account Details Data Structure
 
     D RNRSAC          DS
     D  WACNO                        10A
     D**WRSAC***                    145A                                                      CAP204
     D**WRSAC***                    165A                                               CAP204 CAP205
     D  WRSAC                       172A                                                      CAP205
      ** Retail A/C Number and Account Movement Details Data Structure
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short Access Object Data Structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long Access Object Data Structure
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Program Parameters
     D PRetCde         S              7A
     D PCommit         S              3A
     D PCtrlPgm        S             10A
 
      ** Access Object Parameters
     D PRtCd           S              7A
     D POptn           S              7A
     D PRetAcc         S             10A
     D PCNum           S              6A
     D PCcy            S              3A
     D PACod           S             10A
     D PASeq           S              2A
     D PBrch           S              3A
     D PRTTyp          S              5A
 
      ** Standard CG Utility Parameters
     D PZSeq           S              5A
     D PChgTyp         S              1A
 
      ** Working Variables
     D WRecCnt         S             15S 0
     D WValue          S             10A
     D WRetAcc         S              1A
     D WAcAPTrA        S              1A
     D WRTAPTrA        S              1A
     D WPrtAdv         S              1A
 
      ** Key Fields
     D KCNum           S                   LIKE(CNUM)
     D KCcy            S                   LIKE(CCY)
     D KACod           S                   LIKE(ACOD)
     D KAcSq           S                   LIKE(ACSQ)
     D KBrch           S                   LIKE(BRCA)
     D KPrgMn          S                   LIKE(RPRGMN)
     D KBatchNo        S                   LIKE(BTBTNB)
     D KItemNo         S                   LIKE(BTBINB)
     D KTNmr           S                   LIKE(TNMR)
     D KTryp           S                   LIKE(TRYP)
 
      ** Switchable Features
     D CCG015          S              1A
 
     D/COPY CGCPYSRC,SRERRDLE
      ** Fields, Data Structures, and Arrays Definition for CG Error Processing
 
     D/COPY CGCPYSRC,CGAUDTDLE
      ** Fields, Data Structures, and Arrays Definition for CG Audit Processing
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------- Start of Main Processing -------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Push the currently running routine into the stack.
 
     C                   EVAL      WValue = 'Main'
     C                   EXSR      SRPush
 
      ** Main Processing
      ** ===============
 
     C                   EXSR      SRMain
 
      ** Audit Processing
      ** ================
 
     C                   EXSR      SRAudit
 
      ** Pop values off the stack.
 
     C                   EXSR      SRPop
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMain - Handles main program execution.                     *
      *                                                               *
      *****************************************************************
     C     SRMain        BEGSR
 
     C                   EVAL      WValue = 'SRMain'
     C                   EXSR      SRPush
 
     C                   EXSR      SRIC
 
     C                   EXSR      SRPop
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRIC - Handles Input Cycle processing.                       *
      *                                                               *
      *****************************************************************
     C     SRIC          BEGSR
 
     C                   EVAL      WValue = 'SRIC'
     C                   EXSR      SRPush
 
     C                   EVAL      WRecCnt = *ZERO
 
     C                   EVAL      KPrgMn = PCtrlPgm
 
     C     KPrgMn        SETLL     READVCL0
     C     KPrgMn        READE     READVCL0
 
     C                   DOW       NOT %EOF
 
      ** Check the current advice.
 
     C                   EXSR      SRChkAdv
 
      ** At this point, all Transaction Advices had been submitted
      ** if necessary.
 
     C                   EVAL      RSAPIN = 'Y'
     C                   UPDATE    READVCD0
 
     C     KPrgMn        READE     READVCL0
 
     C                   ENDDO
 
     C                   EXSR      SRPop
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkAdv - Checks the advice index file.                     *
      *                                                               *
      *****************************************************************
     C     SRChkAdv      BEGSR
 
     C                   EVAL      WValue = 'SRChkAdv'
     C                   EXSR      SRPush
 
     C                   MOVEL     RREFNO        KTNmr
     C                   MOVE      RTRTYP        KTryp
 
     C     KRSAC         SETGT     RERSACL0
     C     KRSAC         READPE    RERSACL0
 
     C                   IF        NOT %EOF
 
     C                   EXSR      SRChkAcc
 
      ** Print the advice if necessary.
 
     C                   IF        WPrtAdv = 'Y'
     C                   EXSR      SRPrtAdv
     C                   EVAL      WRecCnt = WRecCnt + 1
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EXSR      SRPop
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkAcc - Checks the current account.                       *
      *                                                               *
      *****************************************************************
     C     SRChkAcc      BEGSR
 
     C                   EVAL      WValue = 'SRChkAcc'
     C                   EXSR      SRPush
 
     C                   EVAL      WPrtAdv = 'N'
 
      ** Check if the current account is a Retail Account.
 
     C                   EXSR      SRIsRetAcc
 
     C                   IF        WRetAcc <> 'Y'
     C                   EXSR      SRPop
     C                   LEAVESR
     C                   ENDIF
 
      ** Check if the current account allows printing of advices.
 
     C                   EXSR      SRAcAPTrA
 
     C                   IF        WAcAPTrA <> 'Y'
     C                   EXSR      SRPop
     C                   LEAVESR
     C                   ENDIF
 
      ** Check if the current RE Transaction Type allows the printing
      ** of advices.
 
     C                   EXSR      SRRTAPTrA
 
     C                   IF        WRTAPTrA <> 'Y'
     C                   EXSR      SRPop
     C                   LEAVESR
     C                   ENDIF
 
     C                   EVAL      WPrtAdv = 'Y'
 
     C                   EXSR      SRPop
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRIsRetAcc - Checks if the current account is a Retail       *
      *               Account via AOACCTR0.                           *
      *                                                               *
      *****************************************************************
     C     SRIsRetAcc    BEGSR
 
     C                   EVAL      WValue = 'SRIsRetAcc'
     C                   EXSR      SRPush
 
     C                   EVAL      WRetAcc = 'N'
 
     C                   MOVE      CUSN          PCNum
     C                   MOVE      CCYD          PCcy
     C                   MOVE      ACDE          PACod
     C                   MOVE      ASNC          PASeq
     C                   MOVE      BRCA          PBrch
 
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      *BLANKS       PRetAcc
     C                   PARM                    PCNum
     C                   PARM                    PCcy
     C                   PARM                    PACod
     C                   PARM                    PASeq
     C                   PARM                    PBrch
     C     GLACNT        PARM      GLACNT        DSSDY
 
     C                   IF        PRtCd = *BLANKS
 
     C                   IF        ATYP = 'R'
     C                   EVAL      WRetAcc = 'Y'
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        PRtCd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'ACCNTAB'
     C                   EVAL      DBKey = PCNum + PCcy + PACod +
     C                                     PASeq + PBrch
     C                   EVAL      DBase = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EXSR      SRPop
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAcAPTrA - Checks if the current account allows the         *
      *              printing of Transaction Advices.                 *
      *                                                               *
      *****************************************************************
     C     SRAcAPTrA     BEGSR
 
     C                   EVAL      WValue = 'SRAcAPTrA'
     C                   EXSR      SRPush
 
     C                   EVAL      WAcAPTrA = 'N'
 
     C                   EVAL      KCnum = CUSN
     C                   EVAL      KCcy = CCYD
     C                   EVAL      KACod = ACDE
     C                   EVAL      KAcSq = ASNC
     C                   EVAL      KBrch = BRCA
 
     C     KIAC          CHAIN     REIAC
 
     C                   IF        %FOUND AND
     C                             PTRA = 'Y'
     C                   EVAL      WAcAPTrA = 'Y'
     C                   ENDIF
 
     C                   EXSR      SRPop
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRTAPTrA - Checks if the current Retail Transaction Type    *
      *              allows the printing of Transaction Advices via   *
      *              AORETRR0.                                        *
      *                                                               *
      *****************************************************************
     C     SRRTAPTrA     BEGSR
 
     C                   EVAL      WValue = 'SRRTAPTrA'
     C                   EXSR      SRPush
 
     C                   EVAL      WRTAPTrA = 'N'
 
     C                   MOVEL     TNMR          KBatchNo
     C                   MOVE      TNMR          KItemNo
 
     C     KJENP         CHAIN     GLJENPL0
 
     C                   IF        %FOUND
 
     C                   IF        BTTRTY = *BLANKS
     C                   EVAL      WRTAPTrA = 'Y'
     C                   ELSE
 
     C                   EVAL      PRTTyp = BTTRTY
 
     C                   CALL      'AORETRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PRTTyp
     C     SDRETR        PARM      SDRETR        DSFDY
 
     C                   IF        PRtCd = *BLANKS
 
     C                   IF        A1PADI = 'Y'
     C                   EVAL      WRTAPTrA = 'Y'
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        PRtCd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDRETRPD'
     C                   EVAL      DBKey = PRTTyp
     C                   EVAL      DBase = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EXSR      SRPop
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrtAdv - Prints Transaction Advices.                       *
      *                                                               *
      *****************************************************************
     C     SRPrtAdv      BEGSR
 
     C                   EVAL      WValue = 'SRPrtAdv'
     C                   EXSR      SRPush
 
     C                   MOVE      ACNO          WACNO
     C                   MOVE      GLACMT        WRSAC
 
     C                   CALL      'CG003811'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM                    PCommit
     C                   PARM                    RNRSAC
     C                   PARM                    CCG015
     C                   PARM      'I'           PChgTyp
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'ACCNTAB'
     C                   EVAL      DBKey = *BLANKS
     C                   EVAL      DBase = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EXSR      SRPop
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPush - Pushes values on the stack.                         *
      *                                                               *
      *****************************************************************
     C     SRPush        BEGSR
 
     C                   EVAL      Q = Q + 1
     C                   EVAL      @STK(Q) = WValue
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop - Pops (unwinds) values off the stack.                 *
      *                                                               *
      *****************************************************************
     C     SRPop         BEGSR
 
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   EVAL      Q = Q - 1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClear - Clears the stack.                                  *
      *                                                               *
      *****************************************************************
     C     SRClear       BEGSR
 
     C                   MOVEA     *BLANKS       @STK(1)
     C                   EVAL      Q = *ZERO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Handles auditing via CG9020 and CGZAUDIT.          *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR
 
     C                   EVAL      WValue = 'SRAudit'
     C                   EXSR      SRPush
 
      ** Output the count of records read.
 
     C                   CLEAR                   I#DTA
     C                   MOVEL     'CG003810'    I#REF
     C                   MOVEL     'CGD1678'     I#TITL
     C                   MOVEL     'CGD1679'     I#TUL
     C                   MOVEL     'CGUSRMSG'    I#FILE
     C                   MOVEL     *BLANKS       I#SUB
     C                   MOVEL     'RSACMTPD'    I#SUB
     C                   MOVEL     'CAD1021'     I#TEXT
     C                   Z-ADD     WRecCnt       I#QTY
     C                   Z-ADD     *ZERO         I#DECS
     C                   MOVEL     '1'           I#EDIT
 
      ** Write a line of text.
 
     C                   CALL      'CGZAUDIT'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      '*LINE   '    W0ACT
     C                   PARM                    I#DTA
     C                   PARM                    PZSeq
 
      ** Skip a line.
 
     C                   CALL      'CGZAUDIT'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      '*SKIP   '    W0ACT
     C                   PARM                    I#DTA
     C                   PARM                    PZSeq
 
      ** Close the Audit printer file.
 
     C                   CLEAR                   I#DTA
     C                   MOVEL     'CG003870'    I#REF
     C                   MOVEL     'CGD1678'     I#TITL
     C                   MOVEL     'CGD1679'     I#TUL
     C                   MOVEL     'CGUSRMSG'    I#FILE
     C                   MOVEL     'CAD1008'     I#TEXT
 
     C                   CALL      'CGZAUDIT'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      '*CLOSE  '    W0ACT
     C                   PARM                    I#DTA
     C                   PARM                    PZSeq
 
     C                   EXSR      SRPop
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Subroutine                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Entry Parameters
      ** ================
 
     C     *ENTRY        PLIST
 
      ** Return Code
      ** Commit Indicator
      ** Control Program
 
     C                   PARM                    PRetCde
     C                   PARM                    PCommit
     C                   PARM                    PCtrlPgm
 
      ** Switchable Features
      ** -------------------
 
      ** Correspondence Manager Phase 1
 
     C                   PARM                    CCG015
 
      ** Midas GL Journal Entry Posting Update Key List
 
     C     KJENP         KLIST
     C                   KFLD                    KBatchNo
     C                   KFLD                    KItemNo
 
      ** Midas RE Interest & Charges File Key List
 
     C     KIAC          KLIST
     C                   KFLD                    KCNum
     C                   KFLD                    KCcy
     C                   KFLD                    KACod
     C                   KFLD                    KAcSq
     C                   KFLD                    KBrch
 
      ** Midas GL Account Movements Key List
 
     C     KRSAC         KLIST
     C                   KFLD                    KTNmr
     C                   KFLD                    KTryp
 
      ** Set the program name.
 
     C                   MOVEL     ##PGM         DBPgm
 
      ** Get bank details.
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBase = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Open the Audit printer file.
 
     C                   CLEAR                   I#DTA
     C                   MOVEL     'CG003810AU'  I#SPLN
     C                   MOVEL     'CG003810'    I#REF
     C                   MOVEL     'CGD1678'     I#TITL
     C                   MOVEL     'CGD1679'     I#TUL
     C                   MOVEL     'CGUSRMSG'    I#FILE
 
     C                   CALL      'CGZAUDIT'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      '*OPEN   '    W0ACT
     C                   PARM                    I#DTA
     C                   PARM                    PZSeq
 
      ** Clear the stack.
 
     C                   EXSR      SRClear
 
     C                   ENDSR
      *****************************************************************
      /EJECT
     C/COPY CGCPYSRC,SRERRCLE
      /EJECT
     C/COPY CGCPYSRC,SRERRPSSRL
      /EJECT
      *****************************************************************
