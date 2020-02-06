     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CG Retail Advice for FF - Driver')               *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG003870 - Midas CG Retail Advice for FF - Driver            *
      *                                                               *
      *  Function:  This program drives the customer correspondence   *
      *             Retail Advice for FF                              *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL154             Date 13Oct14               *
      *                 CAP208             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
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
      *  MD046248 - Finastra Rebranding                               *
      *  CGL154 - FATCA Reporting (Recompile)                         *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
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
      *  SRIsRevAcc - Checks if the current account is a reversed     *
      *               account.                                        *
      *  SRPrtAdv   - Prints Transaction Advices.                     *
      *  SRCoB      - Handles Close of Business processing.           *
      *  SRSelAcc   - Selects accounts.                               *
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
      ** Midas RE Settled Transaction Index File by RPRGMN/RREFNO
 
     FRERSACL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Account Movements by TNMR/TRYP
 
     FGLJENPL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Journal Entry Posting Update by BTBTNB/BTBINB
 
     FREIAC     IF   E           K DISK    INFSR(*PSSR)
      ** Midas RE Interest & Charges File by CNUM/CCY/ACOD/ASEQ/BRCH
 
     FTRANS     IF   E           K DISK    INFSR(*PSSR)
      ** Midas FF Transaction Details
 
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
 
     D CGUDTA        E DS                  EXTNAME(CGUDTAPD)
      ** Extracted Data Details Data Structure
 
     D FFINTY        E DS                  EXTNAME(INTYPD)
     D  FFRECI       E                     EXTFLD(RECI)
     D  FFLCD        E                     EXTFLD(LCD)
     D  FFCHTP       E                     EXTFLD(CHTP)
     D  FFTNLU       E                     EXTFLD(TNLU)
      ** Instrument Type Details Data Structure
 
     D RNRSAC          DS
     D  WACNO                        10A
     D**WRSAC***                    145A                                                      CAP204
     D**WRSAC                       165A                                               CAP204 CAP205
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
     D PInsTyp         S              5A
     D PSysVal01       S             20A   INZ('ExerciseanOption    ')
     D PCurSet01       S            200A
     D PSysVal02       S             20A   INZ('ClosingTradesInput  ')
     D PCurSet02       S            200A
     D PSysVal03       S             20A   INZ('NoncurrencyOTCs     ')
     D PCurSet03       S            200A
     D PSysVal04       S             20A   INZ('OTCTransactions     ')
     D PCurSet04       S            200A
     D PSysVal05       S             20A   INZ('ExchangeTradedInstr ')
     D PCurSet05       S            200A
     D PSysVal06       S             20A
     D PCurSet06       S            200A
     D PSysVal07       S             20A
     D PCurSet07       S            200A
     D PSysVal08       S             20A
     D PCurSet08       S            200A
     D PSysVal09       S             20A
     D PCurSet09       S            200A
     D PSysVal10       S             20A
     D PCurSet10       S            200A
 
      ** Standard CG Utility Parameters
     D PZActn          S              8A
     D PZPath          S            256A
     D PZRtCd          S              7A
     D PZSeq           S              5A
     D PChgTyp         S              1A
 
      ** Working Variables
     D WRecCnt         S             15S 0
     D WValue          S             10A
     D WRetAcc         S              1A
     D WAcAPTrA        S              1A
     D WRevAcc         S              1A
     D WChkAcc         S              1A
     D WChar           S              1A
     D WTmp            S              2A
     D WMod            S              1A
     D WPrtAdv         S              1A
     D WExOpAdv        S              1A   INZ('N')
     D WClTrAdv        S              1A   INZ('N')
     D WNOtCAdv        S              1A   INZ('N')
     D WCOtCAdv        S              1A   INZ('N')
     D WExTrAdv        S              1A   INZ('N')
 
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
     D KTnBr           S                   LIKE(TNBR)
 
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
 
      ** Determine processing mode.
 
     C                   IF        PCtrlPgm <> 'REC000079'
     C                   EXSR      SRIC
     C                   ELSE
     C                   EXSR      SRCoB
     C                   ENDIF
 
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
 
      ** At this point, all Transaction Advices had been submitted if
      ** necessary.
 
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
     C                   EVALR     KTryp = %TRIM(RTRTYP)
 
     C     KRSAC         SETGT     RERSACL0
     C     KRSAC         READPE    RERSACL0
 
     C                   DOW       NOT %EOF
 
      ** Stop processing if Insert and record from RSACMTPD is reversal
 
     C                   MOVE      NRTD          WChar
     C                   IF        WChar = '*'  and
     C                             RCHTYP = 'I'
     C                   EXSR      SRPop
     C                   LEAVESR
     C                   ENDIF
 
     C                   EXSR      SRChkAcc
 
      ** Check first if this account is reversed.
 
     C                   EXSR      SRIsRevAcc
 
      ** Print the advice if necessary.
 
     C                   IF        WPrtAdv = 'Y'
     C                   EXSR      SRPrtAdv
     C                   EVAL      WRecCnt = WRecCnt + 1
     C                   ENDIF
 
      ** Stop processing if necessary.
 
     C                   IF        WRevAcc = 'Y'
     C                   LEAVE
     C                   ENDIF
 
     C     KRSAC         READPE    RERSACL0
     C                   ENDDO
 
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
     C                   EVAL      DBase = 3
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
      *  SRIsRevAcc - Checks if the current account is a reversed     *
      *               account.                                        *
      *                                                               *
      *****************************************************************
     C     SRIsRevAcc    BEGSR
 
     C                   EVAL      WValue = 'SRIsRevAcc'
     C                   EXSR      SRPush
 
     C                   EVAL      WRevAcc = 'N'
 
     C                   MOVE      NRTD          WChar
 
     C                   IF        WChar = '*'
     C                   EVAL      WRevAcc = 'Y'
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
 
     C                   IF        PCtrlPgm <> 'REC000079'
     C                   EVAL      PChgTyp = RCHTYP
     C                   ELSE
     C                   EVAL      PChgTyp = 'I'
     C                   ENDIF
 
     C                   MOVE      ACNO          WACNO
     C                   MOVE      GLACMT        WRSAC
 
     C                   CALL      'CG003871'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM                    PCommit
     C                   PARM                    RNRSAC
     C                   PARM                    CCG015
     C                   PARM                    PChgTyp
 
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
      *  SRCoB - Handles Close of Business processing.                *
      *                                                               *
      *****************************************************************
     C     SRCoB         BEGSR
 
     C                   EVAL      WValue = 'SRCoB'
     C                   EXSR      SRPush
 
     C                   EVAL      WRecCnt = *ZERO
 
     C     *LOVAL        SETLL     RERSACL0
     C                   READ      RERSACL0
 
     C                   DOW       NOT %EOF
 
      ** Select accounts.
 
     C                   EXSR      SRSelAcc
 
     C                   IF        WChkAcc <> 'Y'
     C                   READ      RERSACL0
     C                   ITER
     C                   ENDIF
 
      ** Check accounts.
 
     C                   EXSR      SRChkAcc
 
     C                   IF        WPrtAdv <> 'Y'
     C                   READ      RERSACL0
     C                   ITER
     C                   ENDIF
 
      ** Check first if this account is reversed.
 
     C                   EXSR      SRIsRevAcc
 
      ** Print the advice.
 
     C                   EXSR      SRPrtAdv
     C                   EVAL      WRecCnt = WRecCnt + 1
 
     C                   READ      RERSACL0
     C                   ENDDO
 
     C                   EXSR      SRPop
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSelAcc - Selects accounts.                                 *
      *                                                               *
      *****************************************************************
     C     SRSelAcc      BEGSR
 
     C                   EVAL      WValue = 'SRSelAcc'
     C                   EXSR      SRPush
 
     C                   EVAL      WChkAcc = 'N'
 
      ** Check first if the record was written by a FF maintenance.
 
     C                   MOVE      NRTD          WTmp
     C                   MOVEL     WTmp          WMod
 
     C                   IF        WMod <> 'F'
     C                   EXSR      SRPop
     C                   LEAVESR
     C                   ENDIF
 
     C                   MOVE      TNMR          KTnBr
 
     C     KTnBr         CHAIN     TRANS
 
     C                   IF        NOT %FOUND
     C                   EXSR      SRPop
     C                   LEAVESR
     C                   ENDIF
 
      ** Only select records of particular Transaction Types.
 
     C                   SELECT
 
     C                   WHEN      %TRIM(TRYP) = 'P' OR
     C                             %TRIM(TRYP) = 'S'
 
      ** Check the Closure Reference.
 
     C                   IF        CLSR = *ZERO
 
      ** Get Instrument Type details.
 
     C                   MOVE      ISTT          PInsTyp
 
     C                   CALL      'AOFFITR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PInsTyp
     C     FFINTY        PARM      FFINTY        DSSDY
 
     C                   IF        PRtCd = '*NRF'
     C                   EXSR      SRPop
     C                   LEAVESR
     C                   ENDIF
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'INTYPD'
     C                   EVAL      DBKey = PInsTyp
     C                   EVAL      DBase = 5
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Process OTC Trades (Instrument Indicator = 'Y').
 
     C                   IF        ISTI = 'Y'
 
      ** Non-currency OTCs.
 
     C                   IF        ISPT <> 5
 
      ** Exit the subroutine if advice is not necessary.
 
     C                   IF        WNOtCAdv <> 'Y'
     C                   EXSR      SRPop
     C                   LEAVESR
     C                   ENDIF
 
     C                   ELSE
 
      ** Currency OTCs.
 
     C                   IF        WCOtCAdv <> 'Y'
     C                   EXSR      SRPop
     C                   LEAVESR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
 
      ** Check if Exchange-Traded transactions require advices.
 
     C                   IF        WExTrAdv <> 'Y'
     C                   EXSR      SRPop
     C                   LEAVESR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
 
      ** Check if Closing Trades require advices.
 
     C                   IF        WClTrAdv <> 'Y'
     C                   EXSR      SRPop
     C                   LEAVESR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   WHEN      %TRIM(TRYP) = 'E'
 
      ** Check if Exercise an Option transactions require advices.
 
     C                   IF        WExOpAdv <> 'Y'
     C                   EXSR      SRPop
     C                   LEAVESR
     C                   ENDIF
 
     C                   ENDSL
 
      ** At this point, the current record is right for processing.
 
     C                   EVAL      WChkAcc = 'Y'
 
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
     C                   MOVEL     'CG003870'    I#REF
     C                   MOVEL     'CGD2625'     I#TITL
     C                   MOVEL     'CGD2626'     I#TUL
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
     C                   MOVEL     'CGD2625'     I#TITL
     C                   MOVEL     'CGD2626'     I#TUL
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
 
     C                   PARM                    W0RTN
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
 
     C                   EVAL      DBPgm = ##PGM
 
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
     C                   MOVEL     'CG003870AU'  I#SPLN
     C                   MOVEL     'CG003870'    I#REF
     C                   MOVEL     'CGD2625'     I#TITL
     C                   MOVEL     'CGD2626'     I#TUL
     C                   MOVEL     'CGUSRMSG'    I#FILE
 
     C                   CALL      'CGZAUDIT'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      '*OPEN   '    W0ACT
     C                   PARM                    I#DTA
     C                   PARM                    PZSeq
 
      ** Check for System Values.
 
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM                    PSysVal01
     C                   PARM                    PCurSet01
     C                   PARM                    PSysVal02
     C                   PARM                    PCurSet02
     C                   PARM                    PSysVal03
     C                   PARM                    PCurSet03
     C                   PARM                    PSysVal04
     C                   PARM                    PCurSet04
     C                   PARM                    PSysVal05
     C                   PARM                    PCurSet05
     C                   PARM                    PSysVal06
     C                   PARM                    PCurSet06
     C                   PARM                    PSysVal07
     C                   PARM                    PCurSet07
     C                   PARM                    PSysVal08
     C                   PARM                    PCurSet08
     C                   PARM                    PSysVal09
     C                   PARM                    PCurSet09
     C                   PARM                    PSysVal10
     C                   PARM                    PCurSet10
 
     C                   IF        PRtCd = *BLANKS
 
      ** Exercise an Option
      ** Closing Trades Input
      ** Non-currency OTCs
      ** Currency OTCs
      ** Exchange-Traded Instruments
 
     C                   MOVEL     PCurSet01     WExOpAdv
     C                   MOVEL     PCurSet02     WClTrAdv
     C                   MOVEL     PCurSet03     WNOtCAdv
     C                   MOVEL     PCurSet04     WCOtCAdv
     C                   MOVEL     PCurSet05     WExTrAdv
 
     C                   ELSE
 
     C                   IF        PRtCd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDSVALPD'
     C                   EVAL      DBase = 2
 
     C                   SELECT
     C                   WHEN      PCurSet01 = '*NRF'
     C                   EVAL      DBKey = PSysVal01
     C                   WHEN      PCurSet02 = '*NRF'
     C                   EVAL      DBKey = PSysVal02
     C                   WHEN      PCurSet03 = '*NRF'
     C                   EVAL      DBKey = PSysVal03
     C                   WHEN      PCurSet04 = '*NRF'
     C                   EVAL      DBKey = PSysVal04
     C                   WHEN      PCurSet05 = '*NRF'
     C                   EVAL      DBKey = PSysVal05
     C                   ENDSL
 
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
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
