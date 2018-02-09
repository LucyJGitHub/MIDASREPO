     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Initialization Program for CER020')           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SD000900 - Midas Initialization Program for CER020 (New)     *
      *                                                               *
      *  Function: This program wil initialize the new alphanumeric   *
      *            Local Industry Code field on the specified         *
      *            filess function                                    *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE141             Date 08Feb16               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23967A          Date 18May09               *
      *                 BUG23967           Date 14May09               *
      *                 CER020  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE141 - Currency and Location Business Day Convention       *
      *           (Recompile)                                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23967A - Add Local Industry Code Field.                   *
      *  BUG23967 - Add Local Industry Code Field.                    *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus                                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRPop01 - Initialize new Local Industry Code field on file   *
      *            LEYTDYT                                            *
      *  SRPop02 - Initialize new Local Industry Code field on file   *
      *            MCLONCL                                            *
      *  SRPop03 - Initialize new Local Industry Code field on file   *
      *            INDUSIN                                            *
      *  SRPop04 - Initialize new Local Industry Code field on file   *
      *            LEN1MFPD                                           *
      *  SRPop05 - Initialize new Local Industry Code field on file   *
      *            MATLNMT                                            *
      *  SRPop06 - Initialize new Local Industry Code field on file   *
      *            CLINTCB                                            *
      *  SRPop07 - Initialize new Local Industry Code field on file   *
      *            EMDEXX4                                            *
      *  SRPop08 - Initialize new Local Industry Code field on file   *
      *            EMDEXX5                                            *
      *  SRPop09 - Initialize new Local Industry Code field on file   *
      *            EMDEXX6                                            *
      *  SRPop010 - Initialize new Local Industry Code field on       *
      *             file PMCDIPPD                                     *
      *  SRPop011 - Initialize new Local Industry Code field on       *
      *             file PMCHTVPD                                     *
      *  SRPop012 - Initialize new Local Industry Code field on       *
      *             file PMHOLDPD                                     *
      *  SRPop013 - Initialize new Local Industry Code field on       *
      *             file PMPGDDPD                                     *
      *  SRPop014 - Initialize new Local Industry Code field on       *
      *             file PMHOLDPD                                     *
      *  SRPop015 - Initialize new Local Industry Code field on       *
      *             file PMPMIMPD                                     *
      *  SRPop016 - Initialize new Local Industry Code field on       *
      *             file PMPSTCPD                                     *
      *  SRPop017 - Initialize new Local Industry Code field on       *
      *             file PMCUTVPD                                     *
      *  SRPop018 - Initialize new Local Industry Code field on       *
      *             file PMHITVPD                                     *
      *  SRPop019 - Initialize new Local Industry Code field on       *
      *             file EMXT6D1                                      *
      *  SRPop020 - Initialize new Local Industry Code field on       *
      *             file EMXT1D1                                      *
      *  SRPop021 - Initialize new Local Industry Code field on       *
      *             file EMXT1R1                                      *
      *  SRPop022 - Initialize new Local Industry Code field on       *
      *             file TABLETN                                      *
      *  SRPop023 - Initialize new Local Industry Code field on       *
      *             file ILCLNCL                                      *
      *  SRPop024 - Initialize new Local Industry Code field on       *
      *             file PMHOLDQ0                                     *
      *  SRPop025 - Initialize new Local Industry Code field on       *
      *             file PMHOLDQ1                                     *
      *  SRPop026 - Initialize new Local Industry Code field on       *
      *             file PMHOLDQ2                                     *
      *  SRPop027 - Initialize new Local Industry Code field on       *
      *             file PMHOLDQ3                                     *
      *  SRPop028 - Initialize new Local Industry Code field on       *
      *             file PMINDTPD                                     *
      *  SRPop029 - Initialize new Local Industry Code field on       *
      *             file PMINDWPD                                     *
      *  SRPop030 - Initialize new Local Industry Code field on       *
      *             file PMPIMTPD                                     *
      *  SRPop031 - Initialize new Local Industry Code field on       *
      *             file PMPPTHQ1                                     *
      *  SRPop032 - Initialize new Local Industry Code field on       *
      *             file PMBDIPPD                                     *
      *  SRPop033 - Initialize new Local Industry Code field on       *
      *             file LEVCLILPD                                    *
      *  SRPop034 - Initialize new Local Industry Code field on       *
      *             file BYEXDTPP                                     *
      *  SRPop035 - Initialize new Local Industry Code field on       *
      *             file BYEXIEPP                                     *
      *  SRPop036 - Initialize new Local Industry Code field on       *
      *             file SECORBPD                                     *
      *  SRPop037 - Initialize new Local Industry Code field on       *
      *             file SEVSECSPD                                    *
      *  SRPop038 - Initialize new Local Industry Code field on       *
      *             file SECTYD                                       *
      *  SRPop039 - Initialize new Local Industry Code field on       *
      *             file CLOANCL                                      *
      *                                                               *
      *  *INZSR - Program initialization routine                      *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialization only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas LE Matured Loans Y.T.D.
      *
     FLEYTDYT   UF   E             DISK    PREFIX(A)
     F**********                           COMMIT                                           BUG23967
     F                                     USROPN
      *
      ** New Matured Loans File
      *
     FMCLONCL   UF   E             DISK    PREFIX(B)
     F**********                           COMMIT                                           BUG23967
     F                                     RENAME(CLOANCLF: CLOANCLF1)
     F                                     USROPN
      *
      ** Loans and Industry Details
      *
     FINDUSIN   UF   E             DISK    PREFIX(C)
     F**********                           COMMIT                                           BUG23967
     F                                     USROPN
      *
      ** LE PC Message Format
      *
     FLEN1MFPD  UF   E             DISK    PREFIX(D)
     F**********                           COMMIT                                           BUG23967
     F                                     USROPN
      *
      ** Matured Loans Details
      *
     FMATLNMT   UF   E             DISK    PREFIX(E)
     F**********                           COMMIT                                           BUG23967
     F                                     USROPN
      *
      ** Customer Master Details
      *
     FCLINTCB   UF   E             DISK    PREFIX(F)
     F**********                           COMMIT                                           BUG23967
     F                                     USROPN
      *
      ** EM End of Day Exposure File Header
      *
     FEMDEXX4   UF   E             DISK    PREFIX(G)
     F**********                           COMMIT                                           BUG23967
     F                                     USROPN
      *
      ** EM End of Day Exposure File Detail
      *
     FEMDEXX5   UF   E             DISK    PREFIX(H)
     F**********                           COMMIT                                           BUG23967
     F                                     USROPN
      *
      ** EM End of Day Exposure File Trailer
      *
     FEMDEXX6   UF   E             DISK    PREFIX(I)
     F**********                           COMMIT                                           BUG23967
     F                                     USROPN
      *
      ** Customer Industry Investment Policy
      *
     FPMCDIPPD  UF   E             DISK    PREFIX(J)
     F**********                           COMMIT                                           BUG23967
     F                                     USROPN
      *
      ** PM - Changes to Historic Turnover
      *
     FPMCHTVPD  UF   E             DISK    PREFIX(K)
     F**********                           COMMIT                                           BUG23967
     F                                     USROPN
      *
      ** PM Holdings Report File
      *
     FPMHOLDPD  UF   E             DISK    PREFIX(L)
     F**********                           COMMIT                                           BUG23967
     F                                     USROPN
      *
      ** PM Industry Group Details
      *
     FPMPGDDPD  UF   E             DISK    PREFIX(M)
     F**********                           COMMIT                                           BUG23967
     F                                     USROPN
      *
      ** PM Performance Mid Month Positions
      *
     FPMPMIMPD  UF   E             DISK    PREFIX(N)
     F**********                           COMMIT                                           BUG23967
     F                                     USROPN
      *
      ** PM Start of Month Positions
      *
     FPMPSTCPD  UF   E             DISK    PREFIX(O)
     F**********                           COMMIT                                           BUG23967
     F                                     USROPN
      *
      ** PM Performance Start of Month Positions
      *
     FPMPSTMQ0  UF   E             DISK    PREFIX(P)
     F**********                           COMMIT                                           BUG23967
     F                                     USROPN
      *
      ** PM Current Turnover
      *
     FPMCUTVPD  UF   E             DISK    PREFIX(Q)
     F**********                           COMMIT                                           BUG23967
     F                                     USROPN
      *
      ** PM Historic Turnover
      *
     FPMHITVPD  UF   E             DISK    PREFIX(R)
     F**********                           COMMIT                                           BUG23967
     F                                     USROPN
      *
      ** EM Securities Trading
      *
     FEMXT6D1   UF   E             DISK    PREFIX(S)
     F**********                           COMMIT                                           BUG23967
     F                                     USROPN
      *
      ** Cust Lend Master File Ext Dta
      *
     FEMXT1D1   UF   E             DISK    PREFIX(T)
     F**********                           COMMIT                                           BUG23967
     F                                     USROPN
      *
      ** Cust Lend Master File
      *
     FEMXT1R1   UF   E             DISK    PREFIX(U)
     F**********                           COMMIT                                           BUG23967
     F                                     USROPN
      *
      ** SD Tables File - Industry Code
      *
     FTABLETN   UF   E             DISK    PREFIX(V)
     F**********                           COMMIT                                           BUG23967
     F                                     USROPN
      *
      ** IBLC 2002 Reversed Loans file
      *
     FILCLNCL   UF   E             DISK    PREFIX(W)
     F**********                           COMMIT                                           BUG23967
     F                                     USROPN
      *
      ** Holdings extension file
      *
     FPMHOLDQ0  UF   E             DISK    PREFIX(X)
     F**********                           COMMIT                                           BUG23967
     F                                     USROPN
      *
      ** Holdings extension file
      *
     FPMHOLDQ1  UF   E             DISK    PREFIX(Y)
     F**********                           COMMIT                                           BUG23967
     F                                     USROPN
      *
      ** Holdings extension file
      *
     FPMHOLDQ2  UF   E             DISK    PREFIX(Z)
     F**********                           COMMIT                                           BUG23967
     F                                     USROPN
      *
      ** Holdings extension file
      *
     FPMHOLDQ3  UF   E             DISK    PREFIX(AA)
     F**********                           COMMIT                                           BUG23967
     F                                     USROPN
      *
      ** PM Industry Total
      *
     FPMINDTPD  UF   E             DISK    PREFIX(AB)
     F**********                           COMMIT                                           BUG23967
     F                                     USROPN
      *
      ** PM Industry Total
      *
     FPMINDWPD  UF   E             DISK    PREFIX(AC)
     F**********                           COMMIT                                           BUG23967
     F                                     RENAME(PMINDTP0:ACINDTP0)
     F                                     USROPN
      *
      ** Performance Interim Monthly Totals
      *
     FPMPIMTPD  UF   E             DISK    PREFIX(AD)
     F**********                           COMMIT                                           BUG23967
     F                                     USROPN
      *
      ** PM Pool Portf Holdings
      *
     FPMPPTHQ1  UF   E             DISK    PREFIX(AE)
     F**********                           COMMIT                                           BUG23967
     F                                     USROPN
      *
      ** Bank Industry Investment Policy
      *
     FPMBDIPPD  UF   E             DISK    PREFIX(AF)
     F**********                           COMMIT                                           BUG23967
     F                                     USROPN
      *
      ** LE API Customer loans CL - Valid
      *
     FLEVCLILPD UF   E             DISK    PREFIX(AG)
     F**********                           COMMIT                                           BUG23967
     F                                     USROPN
      *
      ** Extracted Details For Bank
      *
     FBYEXDTPP  UF   E             DISK    PREFIX(AH)
     F**********                           COMMIT                                           BUG23967
     F                                     USROPN
      *
      ** Extracted PL Details For Bank of England Reporting
      *
     FBYEXIEPP  UF   E             DISK    PREFIX(AI)
     F**********                           COMMIT                                           BUG23967
     F                                     USROPN
      *
      ** SE Securities Redenomination Bulk Details
      *
     FSECORBPD  UF   E             DISK    PREFIX(AJ)
     F**********                           COMMIT                                           BUG23967
     F                                     USROPN
      *
      ** SE Valid securities
      *
     FSEVSECSPD UF   E             DISK    PREFIX(AK)
     F**********                           COMMIT                                           BUG23967
     F                                     USROPN
      *
      ** SE Securities detail
      *
     FSECTYD    UF   E             DISK    PREFIX(AL)
     F**********                           COMMIT                                           BUG23967
     F                                     USROPN
      *
      ** LE Customer loans
      *
     FCLOANCL   UF   E             DISK    PREFIX(AM)
     F**********                           COMMIT                                           BUG23967
     F                                     USROPN
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
     DLDA            E DS                  EXTNAME(LDA)
      *
     D**********       DS                                                                   BUG23967
     D*WLocaIndCd              1      3  0                                                  BUG23967
     D*ALOIC****               1      3                                                     BUG23967
     D*BLOIC****               1      3                                                     BUG23967
     D*CLOIC****               1      3                                                     BUG23967
     D*DN1LOIC**               1      3                                                     BUG23967
     D*ELOIC****               1      3                                                     BUG23967
     D*FLOIC****               1      3                                                     BUG23967
     D*GEMLOIC**               1      3                                                     BUG23967
     D*HEMLOIC**               1      3                                                     BUG23967
     D*IEMLOIC**               1      3                                                     BUG23967
     D*JP1LOIC**               1      3                                                     BUG23967
     D*KSCLOIC**               1      3                                                     BUG23967
     D*LQFLOIC**               1      3                                                     BUG23967
     D*MPMLOIC**               1      3                                                     BUG23967
     D*NGELOIC**               1      3                                                     BUG23967
     D*OGFLOIC**               1      3                                                     BUG23967
     D*PQFLOIC**               1      3                                                     BUG23967
     D*QSBLOIC**               1      3                                                     BUG23967
     D*RQJLOIC**               1      3                                                     BUG23967
     D*SEMLOIC**               1      3                                                     BUG23967
     D*TEMLOIC**               1      3                                                     BUG23967
     D*UEMLOIC**               1      3                                                     BUG23967
     D*VLOIC****               1      3                                                     BUG23967
     D*WLOIC****               1      3                                                     BUG23967
     D*XQFLOIC**               1      3                                                     BUG23967
     D*YQFLOIC**               1      3                                                     BUG23967
     D*ZQFLOIC**               1      3                                                     BUG23967
     D*AAQFLOIC*               1      3                                                     BUG23967
     D*ABQILOIC*               1      3                                                     BUG23967
     D*ACWILOIC*               1      3                                                     BUG23967
     D*ADQTLOIC*               1      3                                                     BUG23967
     D*AEQFLOIC*               1      3                                                     BUG23967
     D*AFPWLOIC*               1      3                                                     BUG23967
     D*AGCLLOIC*               1      3                                                     BUG23967
     D*AHL8LOIC*               1      3                                                     BUG23967
     D*AIL8LOIC*               1      3                                                     BUG23967
     D*AJNBLOIC*               1      3                                                     BUG23967
     D*AKS1LOIC*               1      3                                                     BUG23967
     D*ALLOIC***               1      3                                                     BUG23967
     D*AMLOIC***               1      3                                                     BUG23967
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     DPFileName        S             10A
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the         ¦
      ** ¦ *inzsr is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Initialize the new Alpha Local Industry Code field
      *
     C                   EXSR      SRPop01
      *
     C                   EXSR      SRPop02
      *
     C                   EXSR      SRPop03
      *
     C                   EXSR      SRPop04
      *
     C                   EXSR      SRPop05
      *
     C                   EXSR      SRPop06
      *
     C                   EXSR      SRPop07
      *
     C                   EXSR      SRPop08
      *
     C                   EXSR      SRPop09
      *
     C                   EXSR      SRPop10
      *
     C                   EXSR      SRPop11
      *
     C                   EXSR      SRPop12
      *
     C                   EXSR      SRPop13
      *
     C                   EXSR      SRPop14
      *
     C                   EXSR      SRPop15
      *
     C                   EXSR      SRPop16
      *
     C                   EXSR      SRPop17
      *
     C                   EXSR      SRPop18
      *
     C                   EXSR      SRPop19
      *
     C                   EXSR      SRPop20
      *
     C                   EXSR      SRPop21
      *
     C                   EXSR      SRPop22
      *
     C                   EXSR      SRPop23
      *
     C                   EXSR      SRPop24
      *
     C                   EXSR      SRPop25
      *
     C                   EXSR      SRPop26
      *
     C                   EXSR      SRPop27
      *
     C                   EXSR      SRPop28
      *
     C                   EXSR      SRPop29
      *
     C                   EXSR      SRPop30
      *
     C                   EXSR      SRPop31
      *
     C                   EXSR      SRPop32
      *
     C                   EXSR      SRPop33
      *
     C                   EXSR      SRPop34
      *
     C                   EXSR      SRPop35
      *
     C                   EXSR      SRPop36
      *
     C                   EXSR      SRPop37
      *
     C                   EXSR      SRPop38
      *
     C                   EXSR      SRPop39
      *
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop01:  Initialize new Local Industry Code field on file   *
      *            LEYTDYT                                            *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPop01       BEGSR
      *
     C                   OPEN      LEYTDYT
      *
     C     1             SETLL     LEYTDYT
      *
     C                   READ      LEYTDYT
      *
     C                   DOW       NOT(%EOF)
      *
     C**********         IF        ALOIC = *BLANKS                                          BUG23967
      *
     C**********         IF        ALIND <> *ZEROS                                          BUG23967
      *
     C**********         EVAL      WLocaIndCd = ALIND                                       BUG23967
     C**********         ELSE                                                               BUG23967
     C**********         EVAL      ALOIC = *BLANKS                                          BUG23967
     C     ALOIC         IFEQ      *BLANKS                                                 BUG23967A
     C     ALIND         IFEQ      *ZERO                                                   BUG23967A
     C                   MOVE      *BLANKS       ALOIC                                     BUG23967A
     C                   ELSE                                                              BUG23967A
     C                   MOVE      ALIND         ALOIC                                      BUG23967
     C                   Z-ADD     *ZEROS        ALIND                                     BUG23967A
     C                   ENDIF                                                             BUG23967A
     C                   ENDIF                                                             BUG23967A
      *
     C**********         ENDIF                                                              BUG23967
      *
     C**********         ENDIF                                                              BUG23967
      *
      ** Update file LEYTDYTF
      *
     C                   UPDATE    LEYTDYTF
      *
      ** Read file LEYTDYTF
      *
     C                   READ      LEYTDYT
      *
     C                   ENDDO
      *
      ** Close file LEYTDYTF
      *
     C                   CLOSE     LEYTDYT
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop02:  Initialize new Local Industry Code field on file   *
      *            MCLONCL                                            *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPop02       BEGSR
      *
     C                   OPEN      MCLONCL
      *
     C     1             SETLL     MCLONCL
      *
     C                   READ      MCLONCL
      *
     C                   DOW       NOT(%EOF)
      *
     C**********         IF        BLOIC = *BLANKS                                          BUG23967
      *
     C**********         IF        BLIND <> *ZEROS                                          BUG23967
      *
     C**********         EVAL      WLocaIndCd = BLIND                                       BUG23967
     C**********         ELSE                                                               BUG23967
     C**********         EVAL      BLOIC = *BLANKS                                          BUG23967
     C     BLOIC         IFEQ      *BLANKS                                                 BUG23967A
     C     BLIND         IFEQ      *ZERO                                                   BUG23967A
     C                   MOVE      *BLANKS       BLOIC                                     BUG23967A
     C                   ELSE                                                              BUG23967A
     C                   MOVE      BLIND         BLOIC                                      BUG23967
     C                   Z-ADD     *ZEROS        BLIND                                     BUG23967A
     C                   ENDIF                                                             BUG23967A
     C                   ENDIF                                                             BUG23967A
      *
     C**********         ENDIF                                                              BUG23967
      *
     C**********         ENDIF                                                              BUG23967
      *
      ** Update file CLOANCLF1
      *
     C                   UPDATE    CLOANCLF1
      *
      ** Read file MCLONCL
      *
     C                   READ      MCLONCL
      *
     C                   ENDDO
      *
      ** Close file MCLONCL
      *
     C                   CLOSE     MCLONCL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop03 : Initialize new Local Industry Code field on file   *
      *            INDUSIN                                            *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPop03       BEGSR
      *
     C                   OPEN      INDUSIN
      *
     C     1             SETLL     INDUSIN
      *
     C                   READ      INDUSIN
      *
     C                   DOW       NOT(%EOF)
      *
     C**********         IF        CLOIC = *BLANKS                                          BUG23967
      *
     C**********         IF        CLIND <> *ZEROS                                          BUG23967
      *
     C**********         EVAL      WLocaIndCd = CLIND                                       BUG23967
     C**********         ELSE                                                               BUG23967
     C**********         EVAL      CLOIC = *BLANKS                                          BUG23967
     C     CLOIC         IFEQ      *BLANKS                                                 BUG23967A
     C     CLIND         IFEQ      *ZERO                                                   BUG23967A
     C                   MOVE      *BLANKS       CLOIC                                     BUG23967A
     C                   ELSE                                                              BUG23967A
     C                   MOVE      CLIND         CLOIC                                      BUG23967
     C                   Z-ADD     *ZEROS        CLIND                                     BUG23967A
     C                   ENDIF                                                             BUG23967A
     C                   ENDIF                                                             BUG23967A
      *
     C**********         ENDIF                                                              BUG23967
      *
     C**********         ENDIF                                                              BUG23967
      *
      ** Update file INDUSINF
      *
     C                   UPDATE    INDUSINF
      *
      ** Read file INDUSIN
      *
     C                   READ      INDUSIN
      *
     C                   ENDDO
      *
      ** Close file INDUSIN
      *
     C                   CLOSE     INDUSIN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop04:  Initialize new Local Industry Code field on file   *
      *            LEN1MFPD                                           *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPop04       BEGSR
      *
     C                   OPEN      LEN1MFPD
      *
     C     1             SETLL     LEN1MFPD
      *
     C                   READ      LEN1MFPD
      *
     C                   DOW       NOT(%EOF)
      *
     C**********         IF        DN1LOIC = *BLANKS                                        BUG23967
      *
     C**********         IF        DN1LIND <> *ZEROS                                        BUG23967
      *
     C**********         EVAL      WLocaIndCd = DN1LIND                                     BUG23967
     C**********         ELSE                                                               BUG23967
     C**********         EVAL      DN1LOIC = *BLANKS                                        BUG23967
     C     DN1LOIC       IFEQ      *BLANKS                                                 BUG23967A
     C     DN1LIND       IFEQ      *ZERO                                                   BUG23967A
     C                   MOVE      *BLANKS       DN1LOIC                                   BUG23967A
     C                   ELSE                                                              BUG23967A
     C                   MOVE      DN1LIND       DN1LOIC                                    BUG23967
     C                   Z-ADD     *ZERO         DN1LIND                                   BUG23967A
     C                   ENDIF                                                             BUG23967A
     C                   ENDIF                                                             BUG23967A
      *
     C**********         ENDIF                                                              BUG23967
      *
     C**********         ENDIF                                                              BUG23967
      *
      ** Update file LEN1MFD0
      *
     C                   UPDATE    LEN1MFD0
      *
      ** Read file LEN1MFPD
      *
     C                   READ      LEN1MFPD
      *
     C                   ENDDO
      *
      ** Close file LEN1MFPD
      *
     C                   CLOSE     LEN1MFPD
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop05:  Initialize new Local Industry Code field on file   *
      *            MATLNMT                                            *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPop05       BEGSR
      *
     C                   OPEN      MATLNMT
      *
     C     1             SETLL     MATLNMT
      *
     C                   READ      MATLNMT
      *
     C                   DOW       NOT(%EOF)
      *
     C**********         IF        ELOIC = *BLANKS                                          BUG23967
      *
     C**********         IF        ELIND <> *ZEROS                                          BUG23967
      *
     C**********         EVAL      WLocaIndCd = ELIND                                       BUG23967
     C**********         ELSE                                                               BUG23967
     C**********         EVAL      ELOIC = *BLANKS                                          BUG23967
     C     ELOIC         IFEQ      *BLANKS                                                 BUG23967A
     C     ELIND         IFEQ      *ZERO                                                   BUG23967A
     C                   MOVE      *BLANKS       ELOIC                                     BUG23967A
     C                   ELSE                                                              BUG23967A
     C                   MOVE      ELIND         ELOIC                                      BUG23967
     C                   Z-ADD     *ZEROS        ELIND                                     BUG23967A
     C                   ENDIF                                                             BUG23967A
     C                   ENDIF                                                             BUG23967A
      *
     C**********         ENDIF                                                              BUG23967
      *
     C**********         ENDIF                                                              BUG23967
      *
      ** Update file MATLNMTF
      *
     C                   UPDATE    MATLNMTF
      *
      ** Read file MATLNMT
      *
     C                   READ      MATLNMT
      *
     C                   ENDDO
      *
      ** Close file MATLNMT
      *
     C                   CLOSE     MATLNMT
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop06:  Initialize new Local Industry Code field on file   *
      *            CLINTCB                                            *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPop06       BEGSR
      *
     C                   OPEN      CLINTCB
      *
     C     1             SETLL     CLINTCB
      *
     C                   READ      CLINTCB
      *
     C                   DOW       NOT(%EOF)
      *
     C**********         IF        FLOIC = *BLANKS                                          BUG23967
      *
     C**********         IF        FLIND <> *ZEROS                                          BUG23967
      *
     C**********         EVAL      WLocaIndCd = FLIND                                       BUG23967
     C**********         ELSE                                                               BUG23967
     C**********         EVAL      FLOIC = *BLANKS                                          BUG23967
     C     FLOIC         IFEQ      *BLANKS                                                 BUG23967A
     C     FLIND         IFEQ      *ZERO                                                   BUG23967A
     C                   MOVE      *BLANKS       FLOIC                                     BUG23967A
     C                   ELSE                                                              BUG23967A
     C                   MOVE      FLIND         FLOIC                                      BUG23967
     C                   Z-ADD     *ZEROS        FLIND                                     BUG23967A
     C                   ENDIF                                                             BUG23967A
     C                   ENDIF                                                             BUG23967A
      *
     C**********         ENDIF                                                              BUG23967
      *
     C**********         ENDIF                                                              BUG23967
      *
      ** Update file CLINTCBF
      *
     C                   UPDATE    CLINTCBF
      *
      ** Read file CLINTCB
      *
     C                   READ      CLINTCB
      *
     C                   ENDDO
      *
      ** Close file CLINTCB
      *
     C                   CLOSE     CLINTCB
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop07:  Initialize new Local Industry Code field on file   *
      *            EMDEXX4                                            *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPop07       BEGSR
      *
     C                   OPEN      EMDEXX4
      *
     C     1             SETLL     EMDEXX4
      *
     C                   READ      EMDEXX4
      *
     C                   DOW       NOT(%EOF)
      *
     C**********         IF        GEMLOIC = *BLANKS                                        BUG23967
      *
     C**********         IF        GEMIND <> *ZEROS                                         BUG23967
      *
     C**********         EVAL      WLocaIndCd = GEMIND                                      BUG23967
     C**********         ELSE                                                               BUG23967
     C**********         EVAL      GEMLOIC = *BLANKS                                        BUG23967
     C     GEMLOIC       IFEQ      *BLANKS                                                 BUG23967A
     C     GEMIND        IFEQ      *ZERO                                                   BUG23967A
     C                   MOVE      *BLANKS       GEMLOIC                                   BUG23967A
     C                   ELSE                                                              BUG23967A
     C                   MOVE      GEMIND        GEMLOIC                                    BUG23967
     C                   Z-ADD     *ZEROS        GEMIND                                    BUG23967A
     C                   ENDIF                                                             BUG23967A
     C                   ENDIF                                                             BUG23967A
      *
     C**********         ENDIF                                                              BUG23967
      *
     C**********         ENDIF                                                              BUG23967
      *
      ** Update file EMDEXX4F
      *
     C                   UPDATE    EMDEXX4F
      *
      ** Read file EMDEXX4
      *
     C                   READ      EMDEXX4
      *
     C                   ENDDO
      *
      ** Close file EMDEXX4
      *
     C                   CLOSE     EMDEXX4
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop08:  Initialize new Local Industry Code field on file   *
      *            EMDEXX5                                            *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPop08       BEGSR
      *
     C                   OPEN      EMDEXX5
      *
     C     1             SETLL     EMDEXX5
      *
     C                   READ      EMDEXX5
      *
     C                   DOW       NOT(%EOF)
      *
     C**********         IF        HEMLOIC = *BLANKS                                        BUG23967
      *
     C**********         IF        HEMIND <> *ZEROS                                         BUG23967
      *
     C**********         EVAL      WLocaIndCd = HEMIND                                      BUG23967
     C**********         ELSE                                                               BUG23967
     C**********         EVAL      HEMLOIC = *BLANKS                                        BUG23967
     C     HEMLOIC       IFEQ      *BLANKS                                                 BUG23967A
     C     HEMIND        IFEQ      *ZERO                                                   BUG23967A
     C                   MOVE      *BLANKS       HEMLOIC                                   BUG23967A
     C                   ELSE                                                              BUG23967A
     C                   MOVE      HEMIND        HEMLOIC                                    BUG23967
     C                   Z-ADD     *ZEROS        HEMIND                                    BUG23967A
     C                   ENDIF                                                             BUG23967A
     C                   ENDIF                                                             BUG23967A
      *
     C**********         ENDIF                                                              BUG23967
      *
     C**********         ENDIF                                                              BUG23967
      *
      ** Update file EMDEXX5F
      *
     C                   UPDATE    EMDEXX5F
      *
      ** Read file EMDEXX5
      *
     C                   READ      EMDEXX5
      *
     C                   ENDDO
      *
      ** Close file EMDEXX5
      *
     C                   CLOSE     EMDEXX5
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop09:  Initialize new Local Industry Code field on file   *
      *            EMDEXX6                                            *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPop09       BEGSR
      *
     C                   OPEN      EMDEXX6
      *
     C     1             SETLL     EMDEXX6
      *
     C                   READ      EMDEXX6
      *
     C                   DOW       NOT(%EOF)
      *
     C**********         IF        IEMLOIC = *BLANKS                                        BUG23967
      *
     C**********         IF        IEMIND <> *ZEROS                                         BUG23967
      *
     C**********         EVAL      WLocaIndCd = IEMIND                                      BUG23967
     C**********         ELSE                                                               BUG23967
     C**********         EVAL      IEMLOIC = *BLANKS                                        BUG23967
     C     IEMLOIC       IFEQ      *BLANKS                                                 BUG23967A
     C     IEMIND        IFEQ      *ZERO                                                   BUG23967A
     C                   MOVE      *BLANKS       IEMLOIC                                   BUG23967A
     C                   ELSE                                                              BUG23967A
     C                   MOVE      IEMIND        IEMLOIC                                    BUG23967
     C                   Z-ADD     *ZEROS        IEMIND                                    BUG23967A
     C                   ENDIF                                                             BUG23967A
     C                   ENDIF                                                             BUG23967A
      *
     C**********         ENDIF                                                              BUG23967
      *
     C**********         ENDIF                                                              BUG23967
      *
      ** Update file EMDEXX6F
      *
     C                   UPDATE    EMDEXX6F
      *
      ** Read file EMDEXX6
      *
     C                   READ      EMDEXX6
      *
     C                   ENDDO
      *
      ** Close file EMDEXX6
      *
     C                   CLOSE     EMDEXX6
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop10: Initialize new Local Industry Code field on file    *
      *            PMCDIPPD                                           *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPop10       BEGSR
      *
     C                   OPEN      PMCDIPPD
      *
     C     1             SETLL     PMCDIPPD
      *
     C                   READ      PMCDIPPD
      *
     C                   DOW       NOT(%EOF)
      *
     C**********         IF        JP1LOIC = *BLANKS                                        BUG23967
      *
     C**********         IF        JP1LIND <> *ZEROS                                        BUG23967
      *
     C**********         EVAL      WLocaIndCd = JP1LIND                                     BUG23967
     C**********         ELSE                                                               BUG23967
     C**********         EVAL      JP1LOIC = *BLANKS                                        BUG23967
     C     JP1LOIC       IFEQ      *BLANKS                                                 BUG23967A
     C     JP1LIND       IFEQ      *ZERO                                                   BUG23967A
     C                   MOVE      *BLANKS       JP1LOIC                                   BUG23967A
     C                   ELSE                                                              BUG23967A
     C                   MOVE      JP1LIND       JP1LOIC                                    BUG23967
     C                   Z-ADD     *ZEROS        JP1LIND                                   BUG23967A
     C                   ENDIF                                                             BUG23967A
     C                   ENDIF                                                             BUG23967A
      *
     C**********         ENDIF                                                              BUG23967
      *
     C**********         ENDIF                                                              BUG23967
      *
      ** Update file PMCDIPP0
      *
     C                   UPDATE    PMCDIPP0
      *
      ** Read file PMCDIPPD
      *
     C                   READ      PMCDIPPD
      *
     C                   ENDDO
      *
      ** Close file PMCDIPPD
      *
     C                   CLOSE     PMCDIPPD
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop11: Initialize new Local Industry Code field on file    *
      *           PMCHTVPD                                            *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPop11       BEGSR
      *
     C                   OPEN      PMCHTVPD
      *
     C     1             SETLL     PMCHTVPD
      *
     C                   READ      PMCHTVPD
      *
     C                   DOW       NOT(%EOF)
      *
     C**********         IF        KSCLOIC = *BLANKS                                        BUG23967
      *
     C**********         IF        KSCLIND <> *ZEROS                                        BUG23967
      *
     C**********         EVAL      WLocaIndCd = KSCLIND                                     BUG23967
     C**********         ELSE                                                               BUG23967
     C**********         EVAL      KSCLOIC = *BLANKS                                        BUG23967
     C     KSCLOIC       IFEQ      *BLANKS                                                 BUG23967A
     C     KSCLIND       IFEQ      *ZERO                                                   BUG23967A
     C                   MOVE      *BLANKS       KSCLOIC                                   BUG23967A
     C                   ELSE                                                              BUG23967A
     C                   MOVE      KSCLIND       KSCLOIC                                    BUG23967
     C                   Z-ADD     *ZEROS        KSCLIND                                   BUG23967A
     C                   ENDIF                                                             BUG23967A
     C                   ENDIF                                                             BUG23967A
      *
     C**********         ENDIF                                                              BUG23967
      *
     C**********         ENDIF                                                              BUG23967
      *
      ** Update file PMCHTVP0
      *
     C                   UPDATE    PMCHTVP0
      *
      ** Read file PMCHTVPD
      *
     C                   READ      PMCHTVPD
      *
     C                   ENDDO
      *
      ** Close file PMCHTVPD
      *
     C                   CLOSE     PMCHTVPD
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop12: Itnitialize new Local Industry Code field on file   *
      *           PMHOLDPD                                            *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPop12       BEGSR
      *
     C                   OPEN      PMHOLDPD
      *
     C     1             SETLL     PMHOLDPD
      *
     C                   READ      PMHOLDPD
      *
     C                   DOW       NOT(%EOF)
      *
     C**********         IF        LQFLOIC = *BLANKS                                        BUG23967
      *
     C**********         IF        LQFLIND <> *ZEROS                                        BUG23967
      *
     C**********         EVAL      WLocaIndCd = LQFLIND                                     BUG23967
     C**********         ELSE                                                               BUG23967
     C**********         EVAL      LQFLOIC = *BLANKS                                        BUG23967
     C     LQFLOIC       IFEQ      *BLANKS                                                 BUG23967A
     C     LQFLIND       IFEQ      *ZERO                                                   BUG23967A
     C                   MOVE      *BLANKS       LQFLOIC                                   BUG23967A
     C                   ELSE                                                              BUG23967A
     C                   MOVE      LQFLIND       LQFLOIC                                    BUG23967
     C                   Z-ADD     *ZEROS        LQFLIND                                   BUG23967A
     C                   ENDIF                                                             BUG23967A
     C                   ENDIF                                                             BUG23967A
      *
     C**********         ENDIF                                                              BUG23967
      *
     C**********         ENDIF                                                              BUG23967
      *
      ** Update file PMHOLDP0
      *
     C                   UPDATE    PMHOLDP0
      *
      ** Read file PMHOLDPD
      *
     C                   READ      PMHOLDPD
      *
     C                   ENDDO
      *
      ** Close file PMHOLDPD
      *
     C                   CLOSE     PMHOLDPD
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop13: Initialize new Local Industry Code field on file    *
      *           PMPGDDPD                                            *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPop13       BEGSR
      *
     C                   OPEN      PMPGDDPD
      *
     C     1             SETLL     PMPGDDPD
      *
     C                   READ      PMPGDDPD
      *
     C                   DOW       NOT(%EOF)
      *
     C**********         IF        MPMLOIC = *BLANKS                                        BUG23967
      *
     C**********         IF        MPMLIND <> *ZEROS                                        BUG23967
      *
     C**********         EVAL      WLocaIndCd = MPMLIND                                     BUG23967
     C**********         ELSE                                                               BUG23967
     C**********         EVAL      MPMLOIC = *BLANKS                                        BUG23967
     C     MPMLOIC       IFEQ      *BLANKS                                                 BUG23967A
     C     MPMLIND       IFEQ      *ZERO                                                   BUG23967A
     C                   MOVE      *BLANKS       MPMLOIC                                   BUG23967A
     C                   ELSE                                                              BUG23967A
     C                   MOVE      MPMLIND       MPMLOIC                                    BUG23967
     C                   Z-ADD     *ZEROS        MPMLIND                                   BUG23967A
     C                   ENDIF                                                             BUG23967A
     C                   ENDIF                                                             BUG23967A
      *
     C**********         ENDIF                                                              BUG23967
      *
     C**********         ENDIF                                                              BUG23967
      *
      ** Update file PMPGDDP0
      *
     C                   UPDATE    PMPGDDP0
      *
      ** Read file PMPGDDPD
      *
     C                   READ      PMPGDDPD
      *
     C                   ENDDO
      *
      ** Close file PMPGDDPD
      *
     C                   CLOSE     PMPGDDPD
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop14: Initialize new Local Industry Code field on file    *
      *           PMPMIMPD                                            *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPop14       BEGSR
      *
     C                   OPEN      PMPMIMPD
      *
     C     1             SETLL     PMPMIMPD
      *
     C                   READ      PMPMIMPD
      *
     C                   DOW       NOT(%EOF)
      *
     C***********        IF        NGELOIC = *BLANKS                                        BUG23967
      *
     C***********        IF        NGELIND <> *ZEROS                                        BUG23967
      *
     C***********        EVAL      WLocaIndCd = NGELIND                                     BUG23967
     C***********        ELSE                                                               BUG23967
     C***********        EVAL      NGELOIC = *BLANKS                                        BUG23967
     C     NGELOIC       IFEQ      *BLANKS                                                 BUG23967A
     C     NGELIND       IFEQ      *ZERO                                                   BUG23967A
     C                   MOVE      *BLANKS       NGELOIC                                   BUG23967A
     C                   ELSE                                                              BUG23967A
     C                   MOVE      NGELIND       NGELOIC                                    BUG23967
     C                   Z-ADD     *ZEROS        NGELIND                                   BUG23967A
     C                   ENDIF                                                             BUG23967A
     C                   ENDIF                                                             BUG23967A
      *
     C***********        ENDIF                                                              BUG23967
      *
     C***********        ENDIF                                                              BUG23967
      *
      ** Update file PMPMIMP0
      *
     C                   UPDATE    PMPMIMP0
      *
      ** Read file PMPMIMPD
      *
     C                   READ      PMPMIMPD
      *
     C                   ENDDO
      *
      ** Close file PMPMIMPD
      *
     C                   CLOSE     PMPMIMPD
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop15 :Initialize new Local Industry Code field on file    *
      *           PMPSTCPD                                            *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPop15       BEGSR
      *
     C                   OPEN      PMPSTCPD
      *
     C     1             SETLL     PMPSTCPD
      *
     C                   READ      PMPSTCPD
      *
     C                   DOW       NOT(%EOF)
     C**********         IF        OGFLOIC = *BLANKS                                        BUG23967
      *
     C**********         IF        OGFLIND <> *ZEROS                                        BUG23967
      *
     C**********         EVAL      WLocaIndCd = OGFLIND                                     BUG23967
     C**********         ELSE                                                               BUG23967
     C**********         EVAL      OGFLOIC = *BLANKS                                        BUG23967
     C     OGFLOIC       IFEQ      *BLANKS                                                 BUG23967A
     C     OGFLIND       IFEQ      *ZERO                                                   BUG23967A
     C                   MOVE      *BLANKS       OGFLOIC                                   BUG23967A
     C                   ELSE                                                              BUG23967A
     C                   MOVE      OGFLIND       OGFLOIC                                    BUG23967
     C                   Z-ADD     *ZEROS        OGFLIND                                   BUG23967A
     C                   ENDIF                                                             BUG23967A
     C                   ENDIF                                                             BUG23967A
      *
     C**********         ENDIF                                                              BUG23967
      *
     C**********         ENDIF                                                              BUG23967
      *
      ** Update file PMPSTCP0
      *
     C                   UPDATE    PMPSTCP0
      *
      ** Read file PMPSTCPD
      *
     C                   READ      PMPSTCPD
      *
     C                   ENDDO
      *
      ** Close file PMPSTCPD
      *
     C                   CLOSE     PMPSTCPD
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop16: Initialize new Local Industry Code field on file    *
      *           PMPSTMQ0                                            *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPop16       BEGSR
      *
     C                   OPEN      PMPSTMQ0
      *
     C     1             SETLL     PMPSTMQ0
      *
     C                   READ      PMPSTMQ0
      *
     C                   DOW       NOT(%EOF)
      *
     C**********         IF        PQFLOIC = *BLANKS                                        BUG23967
      *
     C**********         IF        PQFLIND <> *ZEROS                                        BUG23967
      *
     C**********         EVAL      WLocaIndCd = PQFLIND                                     BUG23967
     C**********         ELSE                                                               BUG23967
     C**********         EVAL      PQFLOIC = *BLANKS                                        BUG23967
     C     PQFLOIC       IFEQ      *BLANKS                                                 BUG23967A
     C     PQFLIND       IFEQ      *ZERO                                                   BUG23967A
     C                   MOVE      *BLANKS       PQFLOIC                                   BUG23967A
     C                   ELSE                                                              BUG23967A
     C                   MOVE      PQFLIND       PQFLOIC                                    BUG23967
     C                   Z-ADD     *ZEROS        PQFLIND                                   BUG23967A
     C                   ENDIF                                                             BUG23967A
     C                   ENDIF                                                             BUG23967A
      *
     C**********         ENDIF                                                              BUG23967
      *
     C**********         ENDIF                                                              BUG23967
      *
      ** Update file PMPSTMP0
      *
     C                   UPDATE    PMPSTMP0
      *
      ** Read file PMPSTMQ0
      *
     C                   READ      PMPSTMQ0
      *
     C                   ENDDO
      *
      ** Close file PMPSTMQ0
      *
     C                   CLOSE     PMPSTMQ0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop17: Initialize new Local Industry Code field on file    *
      *           PMCUTVPD                                            *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPop17       BEGSR
      *
     C                   OPEN      PMCUTVPD
      *
     C     1             SETLL     PMCUTVPD
      *
     C                   READ      PMCUTVPD
      *
     C                   DOW       NOT(%EOF)
      *
     C**********         IF        QSBLOIC = *BLANKS                                        BUG23967
      *
     C**********         IF        QSBLIND <> *ZEROS                                        BUG23967
      *
     C**********         EVAL      WLocaIndCd = QSBLIND                                     BUG23967
     C**********         ELSE                                                               BUG23967
     C**********         EVAL      QSBLOIC = *BLANKS                                        BUG23967
     C     QSBLOIC       IFEQ      *BLANKS                                                 BUG23967A
     C     QSBLIND       IFEQ      *ZERO                                                   BUG23967A
     C                   MOVE      *BLANKS       QSBLOIC                                   BUG23967A
     C                   ELSE                                                              BUG23967A
     C                   MOVE      QSBLIND       QSBLOIC                                    BUG23967
     C                   Z-ADD     *ZEROS        QSBLIND                                   BUG23967A
     C                   ENDIF                                                             BUG23967A
     C                   ENDIF                                                             BUG23967A
      *
     C**********         ENDIF                                                              BUG23967
      *
     C**********         ENDIF                                                              BUG23967
      *
      ** Update file PMCUTVP0
      *
     C                   UPDATE    PMCUTVP0
      *
      ** Read file PMCUTVPD
      *
     C                   READ      PMCUTVPD
      *
     C                   ENDDO
      *
      ** Close file PMCUTVPD
      *
     C                   CLOSE     PMCUTVPD
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop18: Initialize new Local Industry Code field on file    *
      *           PMHITVPD                                            *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPop18       BEGSR
      *
     C                   OPEN      PMHITVPD
      *
     C     1             SETLL     PMHITVPD
      *
     C                   READ      PMHITVPD
      *
     C                   DOW       NOT(%EOF)
      *
     C**********         IF        RQJLOIC = *BLANKS                                        BUG23967
      *
     C**********         IF        RQJLIND <> *ZEROS                                        BUG23967
      *
     C**********         EVAL      WLocaIndCd = RQJLIND                                     BUG23967
     C**********         ELSE                                                               BUG23967
     C**********         EVAL      RQJLOIC = *BLANKS                                        BUG23967
     C     RQJLOIC       IFEQ      *BLANKS                                                 BUG23967A
     C     RQJLIND       IFEQ      *ZERO                                                   BUG23967A
     C                   MOVE      *BLANKS       RQJLOIC                                   BUG23967A
     C                   ELSE                                                              BUG23967A
     C                   MOVE      RQJLIND       RQJLOIC                                    BUG23967
     C                   Z-ADD     *ZEROS        RQJLIND                                   BUG23967A
     C                   ENDIF                                                             BUG23967A
     C                   ENDIF                                                             BUG23967A
      *
     C**********         ENDIF                                                              BUG23967
      *
     C**********         ENDIF                                                              BUG23967
      *
      ** Update file PMHITVP0
      *
     C                   UPDATE    PMHITVP0
      *
      ** Read file PMHITVPD
      *
     C                   READ      PMHITVPD
      *
     C                   ENDDO
      *
      ** Close file PMHITVPD
      *
     C                   CLOSE     PMHITVPD
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop19: Initialize new Local Industry Code field on file    *
      *           EMXT6D1                                             *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPop19       BEGSR
      *
     C                   OPEN      EMXT6D1
      *
     C     1             SETLL     EMXT6D1
      *
     C                   READ      EMXT6D1
      *
     C                   DOW       NOT(%EOF)
      *
     C**********         IF        SEMLOIC = *BLANKS                                        BUG23967
      *
     C**********         IF        SEMIND <> *ZEROS                                         BUG23967
      *
     C**********         EVAL      WLocaIndCd = SEMIND                                      BUG23967
     C**********         ELSE                                                               BUG23967
     C**********         EVAL      SEMLOIC = *BLANKS                                        BUG23967
     C     SEMLOIC       IFEQ      *BLANKS                                                 BUG23967A
     C     SEMIND        IFEQ      *ZERO                                                   BUG23967A
     C                   MOVE      *BLANKS       SEMLOIC                                   BUG23967A
     C                   ELSE                                                              BUG23967A
     C                   MOVE      SEMIND        SEMLOIC                                    BUG23967
     C                   Z-ADD     *ZEROS        SEMIND                                    BUG23967A
     C                   ENDIF                                                             BUG23967A
     C                   ENDIF                                                             BUG23967A
      *
     C**********         ENDIF                                                              BUG23967
      *
     C**********         ENDIF                                                              BUG23967
      *
      ** Update file EMXT6D1F
      *
     C                   UPDATE    EMXT6D1F
      *
      ** Read file EMXT6D1
      *
     C                   READ      EMXT6D1
      *
     C                   ENDDO
      *
      ** Close file EMXT6D1
      *
     C                   CLOSE     EMXT6D1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop20: Initialize new Local Industry Code field on file    *
      *           EMXT1D1                                             *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPop20       BEGSR
      *
     C                   OPEN      EMXT1D1
      *
     C     1             SETLL     EMXT1D1
      *
     C                   READ      EMXT1D1
      *
     C                   DOW       NOT(%EOF)
      *
     C**********         IF        TEMLOIC = *BLANKS                                        BUG23967
      *
     C**********         IF        TEMIND <> *ZEROS                                         BUG23967
      *
     C**********         EVAL      WLocaIndCd = TEMIND                                      BUG23967
     C**********         ELSE                                                               BUG23967
     C**********         EVAL      TEMLOIC = *BLANKS                                        BUG23967
     C     TEMLOIC       IFEQ      *BLANKS                                                 BUG23967A
     C     TEMIND        IFEQ      *ZERO                                                   BUG23967A
     C                   MOVE      *BLANKS       TEMLOIC                                   BUG23967A
     C                   ELSE                                                              BUG23967A
     C                   MOVE      TEMIND        TEMLOIC                                    BUG23967
     C                   Z-ADD     *ZEROS        TEMIND                                    BUG23967A
     C                   ENDIF                                                             BUG23967A
     C                   ENDIF                                                             BUG23967A
      *
     C**********         ENDIF                                                              BUG23967
      *
     C**********         ENDIF                                                              BUG23967
      *
      ** Update file EMXT1D1F
      *
     C                   UPDATE    EMXT1D1F
      *
      ** Read file EMXT1D1
      *
     C                   READ      EMXT1D1
      *
     C                   ENDDO
      *
      ** Close file EMXT1D1
      *
     C                   CLOSE     EMXT1D1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop21: Initialize new Local Industry Code field on file    *
      *           EMXT1R1                                             *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPop21       BEGSR
      *
     C                   OPEN      EMXT1R1
      *
     C     1             SETLL     EMXT1R1
      *
     C                   READ      EMXT1R1
      *
     C                   DOW       NOT(%EOF)
      *
     C**********         IF        UEMLOIC = *BLANKS                                        BUG23967
      *
     C**********         IF        UEMIND <> *ZEROS                                         BUG23967
      *
     C**********         EVAL      WLocaIndCd = UEMIND                                      BUG23967
     C**********         ELSE                                                               BUG23967
     C**********         EVAL      UEMLOIC = *BLANKS                                        BUG23967
     C     UEMLOIC       IFEQ      *BLANKS                                                 BUG23967A
     C     UEMIND        IFEQ      *ZERO                                                   BUG23967A
     C                   MOVE      *BLANKS       UEMLOIC                                   BUG23967A
     C                   ELSE                                                              BUG23967A
     C                   MOVE      UEMIND        UEMLOIC                                    BUG23967
     C                   Z-ADD     *ZEROS        UEMIND                                    BUG23967A
     C                   ENDIF                                                             BUG23967A
     C                   ENDIF                                                             BUG23967A
      *
     C**********         ENDIF                                                              BUG23967
      *
     C**********         ENDIF                                                              BUG23967
      *
      ** Update file EMXT1R1F
      *
     C                   UPDATE    EMXT1R1F
      *
      ** Read file EMXT1R1
      *
     C                   READ      EMXT1R1
      *
     C                   ENDDO
      *
      ** Close file EMXT1R1
      *
     C                   CLOSE     EMXT1R1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop22: Initialize new Local Industry Code field on file    *
      *           TABLETN                                             *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPop22       BEGSR
      *
     C                   OPEN      TABLETN
      *
     C     1             SETLL     TABLETN
      *
     C                   READ      TABLETN
      *
     C                   DOW       NOT(%EOF)
      *
     C**********         IF        VLOIC = *BLANKS                                          BUG23967
      *
     C**********         IF        VLIND <> *ZEROS                                          BUG23967
      *
     C**********         EVAL      WLocaIndCd = VLIND                                       BUG23967
     C**********         ELSE                                                               BUG23967
     C**********         EVAL      VLOIC = *BLANKS                                          BUG23967
     C     VLOIC         IFEQ      *BLANKS                                                 BUG23967A
     C     VLIND         IFEQ      *ZERO                                                   BUG23967A
     C                   MOVE      *BLANKS       VLOIC                                     BUG23967A
     C                   ELSE                                                              BUG23967A
     C                   MOVE      VLIND         VLOIC                                      BUG23967
     C                   Z-ADD     *ZEROS        VLIND                                     BUG23967A
     C                   ENDIF                                                             BUG23967A
     C                   ENDIF                                                             BUG23967A
      *
     C**********         ENDIF                                                              BUG23967
      *
     C**********         ENDIF                                                              BUG23967
      *
      ** Update file TABLETNF
      *
     C                   UPDATE    TABLETNF
      *
      ** Read file TABLETN
      *
     C                   READ      TABLETN
      *
     C                   ENDDO
      *
      ** Close file TABLETN
      *
     C                   CLOSE     TABLETN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop23: Initialize new Local Industry Code field on file    *
      *           ILCLNCL                                             *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPop23       BEGSR
      *
     C                   OPEN      ILCLNCL
      *
     C     1             SETLL     ILCLNCL
      *
     C                   READ      ILCLNCL
      *
     C                   DOW       NOT(%EOF)
      *
     C**********         IF        WLOIC = *BLANKS                                          BUG23967
      *
     C**********         IF        WLIND <> *ZEROS                                          BUG23967
      *
     C**********         EVAL      WLocaIndCd = WLIND                                       BUG23967
     C**********         ELSE                                                               BUG23967
     C**********         EVAL      WLOIC = *BLANKS                                          BUG23967
     C     WLOIC         IFEQ      *BLANKS                                                 BUG23967A
     C     WLIND         IFEQ      *ZERO                                                   BUG23967A
     C                   MOVE      *BLANKS       WLOIC                                     BUG23967A
     C                   ELSE                                                              BUG23967A
     C                   MOVE      WLIND         WLOIC                                      BUG23967
     C                   Z-ADD     *ZEROS        WLIND                                     BUG23967A
     C                   ENDIF                                                             BUG23967A
     C                   ENDIF                                                             BUG23967A
      *
     C**********         ENDIF                                                              BUG23967
      *
     C**********         ENDIF                                                              BUG23967
      *
      ** Update file BLCLNCLF
      *
     C                   UPDATE    BLCLNCLF
      *
      ** Read file ILCLNCL
      *
     C                   READ      ILCLNCL
      *
     C                   ENDDO
      *
      ** Close file ILCLNCL
      *
     C                   CLOSE     ILCLNCL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop24: Initialize new Local Industry Code field on file    *
      *           PMHOLDQ0                                            *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPop24       BEGSR
      *
     C                   OPEN      PMHOLDQ0
      *
     C     1             SETLL     PMHOLDQ0
      *
     C                   READ      PMHOLDQ0
      *
     C                   DOW       NOT(%EOF)
      *
     C**********         IF        XQFLOIC = *BLANKS                                        BUG23967
      *
     C**********         IF        XQFLIND <> *ZEROS                                        BUG23967
      *
     C**********         EVAL      WLocaIndCd = XQFLIND                                     BUG23967
     C**********         ELSE                                                               BUG23967
     C**********         EVAL      XQFLOIC = *BLANKS                                        BUG23967
     C     XQFLOIC       IFEQ      *BLANKS                                                 BUG23967A
     C     XQFLIND       IFEQ      *ZERO                                                   BUG23967A
     C                   MOVE      *BLANKS       XQFLOIC                                   BUG23967A
     C                   ELSE                                                              BUG23967A
     C                   MOVE      XQFLIND       XQFLOIC                                    BUG23967
     C                   Z-ADD     *ZEROS        XQFLIND                                   BUG23967A
     C                   ENDIF                                                             BUG23967A
     C                   ENDIF                                                             BUG23967A
      *
     C**********         ENDIF                                                              BUG23967
      *
     C**********         ENDIF                                                              BUG23967
      *
      ** Update file PMHOLDD0
      *
     C                   UPDATE    PMHOLDD0
      *
      ** Read file PMHOLDQ0
      *
     C                   READ      PMHOLDQ0
      *
     C                   ENDDO
      *
      ** Close file PMHOLDQ0
      *
     C                   CLOSE     PMHOLDQ0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop25: Initialize new Local Industry Code field on file    *
      *           PMHOLDQ1                                            *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPop25       BEGSR
      *
     C                   OPEN      PMHOLDQ1
      *
     C     1             SETLL     PMHOLDQ1
      *
     C                   READ      PMHOLDQ1
      *
     C                   DOW       NOT(%EOF)
      *
     C**********         IF        YQFLOIC = *BLANKS                                        BUG23967
      *
     C**********         IF        YQFLIND <> *ZEROS                                        BUG23967
      *
     C**********         EVAL      WLocaIndCd = YQFLIND                                     BUG23967
     C**********         ELSE                                                               BUG23967
     C**********         EVAL      YQFLOIC = *BLANKS                                        BUG23967
     C     YQFLOIC       IFEQ      *BLANKS                                                 BUG23967A
     C     YQFLIND       IFEQ      *ZERO                                                   BUG23967A
     C                   MOVE      *BLANKS       YQFLOIC                                   BUG23967A
     C                   ELSE                                                              BUG23967A
     C                   MOVE      YQFLIND       YQFLOIC                                    BUG23967
     C                   Z-ADD     *ZEROS        YQFLIND                                   BUG23967A
     C                   ENDIF                                                             BUG23967A
     C                   ENDIF                                                             BUG23967A
      *
     C**********         ENDIF                                                              BUG23967
      *
     C**********         ENDIF                                                              BUG23967
      *
      ** Update file PMHOLDD1
      *
     C                   UPDATE    PMHOLDD1
      *
      ** Read file PMHOLDQ1
      *
     C                   READ      PMHOLDQ1
      *
     C                   ENDDO
      *
      ** close file PMHOLDQ1
      *
     C                   CLOSE     PMHOLDQ1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop26: Initialize new Local Industry Code field on file    *
      *           PMHOLDQ2                                            *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPop26       BEGSR
      *
     C                   OPEN      PMHOLDQ2
      *
     C     1             SETLL     PMHOLDQ2
      *
     C                   READ      PMHOLDQ2
      *
     C                   DOW       NOT(%EOF)
      *
     C**********         IF        ZQFLOIC = *BLANKS                                        BUG23967
      *
     C**********         IF        ZQFLIND <> *ZEROS                                        BUG23967
      *
     C**********         EVAL      WLocaIndCd = ZQFLIND                                     BUG23967
     C**********         ELSE                                                               BUG23967
     C**********         EVAL      ZQFLOIC = *BLANKS                                        BUG23967
     C     ZQFLOIC       IFEQ      *BLANKS                                                 BUG23967A
     C     ZQFLIND       IFEQ      *ZERO                                                   BUG23967A
     C                   MOVE      *BLANKS       ZQFLOIC                                   BUG23967A
     C                   ELSE                                                              BUG23967A
     C                   MOVE      ZQFLIND       ZQFLOIC                                    BUG23967
     C                   Z-ADD     *ZEROS        ZQFLIND                                   BUG23967A
     C                   ENDIF                                                             BUG23967A
     C                   ENDIF                                                             BUG23967A
      *
     C**********         ENDIF                                                              BUG23967
      *
     C**********         ENDIF                                                              BUG23967
      *
      ** Update file PMHOLDD2
      *
     C                   UPDATE    PMHOLDD2
      *
      ** Read file PMHOLDQ2
      *
     C                   READ      PMHOLDQ2
      *
     C                   ENDDO
      *
      ** Close file PMHOLDQ2
      *
     C                   CLOSE     PMHOLDQ2
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop27: Initialize new Local Industry Code field on file    *
      *           PMHOLDQ3                                            *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPop27       BEGSR
      *
     C                   OPEN      PMHOLDQ3
      *
     C     1             SETLL     PMHOLDQ3
      *
     C                   READ      PMHOLDQ3
      *
     C                   DOW       NOT(%EOF)
      *
     C**********         IF        AAQFLOIC = *BLANKS                                       BUG23967
      *
     C**********         IF        AAQFLIND <> *ZEROS                                       BUG23967
      *
     C**********         EVAL      WLocaIndCd = AAQFLIND                                    BUG23967
     C**********         ELSE                                                               BUG23967
     C**********         EVAL      AAQFLOIC = *BLANKS                                       BUG23967
     C     AAQFLOIC      IFEQ      *BLANKS                                                 BUG23967A
     C     AAQFLIND      IFEQ      *ZERO                                                   BUG23967A
     C                   MOVE      *BLANKS       AAQFLOIC                                  BUG23967A
     C                   ELSE                                                              BUG23967A
     C                   MOVE      AAQFLIND      AAQFLOIC                                   BUG23967
     C                   Z-ADD     *ZEROS        AAQFLIND                                  BUG23967A
     C                   ENDIF                                                             BUG23967A
     C                   ENDIF                                                             BUG23967A
      *
     C**********         ENDIF                                                              BUG23967
      *
     C**********         ENDIF                                                              BUG23967
      *
      ** Update file PMHOLDD3
      *
     C                   UPDATE    PMHOLDD3
      *
      ** Read file PMHOLDQ3
      *
     C                   READ      PMHOLDQ3
      *
     C                   ENDDO
      *
      ** Close file PMHOLDQ3
      *
     C                   CLOSE     PMHOLDQ3
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop28: Initialize new Local Industry Code field on file    *
      *            PMINDTPD                                           *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPop28       BEGSR
      *
     C                   OPEN      PMINDTPD
      *
     C     1             SETLL     PMINDTPD
      *
     C                   READ      PMINDTPD
      *
     C                   DOW       NOT(%EOF)
      *
     C**********         IF        ABQILOIC = *BLANKS                                       BUG23967
      *
     C**********         IF        ABQILIND <> *ZEROS                                       BUG23967
      *
     C**********         EVAL      WLocaIndCd = ABQILIND                                    BUG23967
     C**********         ELSE                                                               BUG23967
     C**********         EVAL      ABQILOIC = *BLANKS                                       BUG23967
     C     ABQILOIC      IFEQ      *BLANKS                                                 BUG23967A
     C     ABQILIND      IFEQ      *ZERO                                                   BUG23967A
     C                   MOVE      *BLANKS       ABQILOIC                                  BUG23967A
     C                   ELSE                                                              BUG23967A
     C                   MOVE      ABQILIND      ABQILOIC                                   BUG23967
     C                   Z-ADD     *ZEROS        ABQILIND                                  BUG23967A
     C                   ENDIF                                                             BUG23967A
     C                   ENDIF                                                             BUG23967A
      *
     C**********         ENDIF                                                              BUG23967
      *
     C**********         ENDIF                                                              BUG23967
      *
      ** Update file PMINDTP0
      *
     C                   UPDATE    PMINDTP0
      *
      ** Read file PMINDTPD
      *
     C                   READ      PMINDTPD
      *
     C                   ENDDO
      *
      ** Close file PMINDTPD
      *
     C                   CLOSE     PMINDTPD
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop29: Initialize new Local Industry Code field on file    *
      *            PMINDWPD                                           *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPop29       BEGSR
      *
     C                   OPEN      PMINDWPD
      *
     C     1             SETLL     PMINDWPD
      *
     C                   READ      PMINDWPD
      *
     C                   DOW       NOT(%EOF)
      *
     C**********         IF        ACWILOIC = *BLANKS                                       BUG23967
      *
     C**********         IF        ACWILIND <> *ZEROS                                       BUG23967
      *
     C**********         EVAL      WLocaIndCd = ACWILIND                                    BUG23967
     C**********         ELSE                                                               BUG23967
     C**********         EVAL      ACWILOIC = *BLANKS                                       BUG23967
     C     ACWILOIC      IFEQ      *BLANKS                                                 BUG23967A
     C     ACWILIND      IFEQ      *ZERO                                                   BUG23967A
     C                   MOVE      *BLANKS       ACWILOIC                                  BUG23967A
     C                   ELSE                                                              BUG23967A
     C                   MOVE      ACWILIND      ACWILOIC                                   BUG23967
     C                   Z-ADD     *ZEROS        ACWILIND                                  BUG23967A
     C                   ENDIF                                                             BUG23967A
     C                   ENDIF                                                             BUG23967A
      *
     C**********         ENDIF                                                              BUG23967
      *
     C**********         ENDIF                                                              BUG23967
      *
      ** Update file ACINDTP0
      *
     C                   UPDATE    ACINDTP0
      *
      ** Read file PMINDWPD
      *
     C                   READ      PMINDWPD
      *
     C                   ENDDO
      *
      ** Close file PMINDWPD
      *
     C                   CLOSE     PMINDWPD
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop30: Initialize new Local Industry Code field on file    *
      *           PMPIMTPD                                            *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPop30       BEGSR
      *
     C                   OPEN      PMPIMTPD
      *
     C     1             SETLL     PMPIMTPD
      *
     C                   READ      PMPIMTPD
      *
     C                   DOW       NOT(%EOF)
      *
     C**********         IF        ADQTLOIC = *BLANKS                                       BUG23967
      *
     C**********         IF        ADQTLIND <> *ZEROS                                       BUG23967
      *
     C**********         EVAL      WLocaIndCd = ADQTLIND                                    BUG23967
     C**********         ELSE                                                               BUG23967
     C**********         EVAL      ADQTLOIC = *BLANKS                                       BUG23967
     C     ADQTLOIC      IFEQ      *BLANKS                                                 BUG23967A
     C     ADQTLIND      IFEQ      *ZERO                                                   BUG23967A
     C                   MOVE      *BLANKS       ADQTLOIC                                  BUG23967A
     C                   ELSE                                                              BUG23967A
     C                   MOVE      ADQTLIND      ADQTLOIC                                   BUG23967
     C                   Z-ADD     *ZEROS        ADQTLIND                                  BUG23967A
     C                   ENDIF                                                             BUG23967A
     C                   ENDIF                                                             BUG23967A
      *
     C**********         ENDIF                                                              BUG23967
      *
     C**********         ENDIF                                                              BUG23967
      *
      ** Update file PMPIMTP0
      *
     C                   UPDATE    PMPIMTP0
      *
      ** Read file PMPIMTPD
      *
     C                   READ      PMPIMTPD
      *
     C                   ENDDO
      *
      ** Close file PMPIMTPD
      *
     C                   CLOSE     PMPIMTPD
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop31: Initialize new Local Industry Code field on file    *
      *           PMPPTHQ1                                            *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPop31       BEGSR
      *
     C                   OPEN      PMPPTHQ1
      *
     C     1             SETLL     PMPPTHQ1
      *
     C                   READ      PMPPTHQ1
      *
     C                   DOW       NOT(%EOF)
      *
     C**********         IF        AEQFLOIC = *BLANKS                                       BUG23967
      *
     C**********         IF        AEQFLIND <> *ZEROS                                       BUG23967
      *
     C**********         EVAL      WLocaIndCd = AEQFLIND                                    BUG23967
     C**********         ELSE                                                               BUG23967
     C**********         EVAL      ALOIC = *BLANKS                                          BUG23967
     C     AEQFLOIC      IFEQ      *BLANKS                                                 BUG23967A
     C     AEQFLIND      IFEQ      *ZERO                                                   BUG23967A
     C                   MOVE      *BLANKS       AEQFLOIC                                  BUG23967A
     C                   ELSE                                                              BUG23967A
     C                   MOVE      AEQFLIND      AEQFLOIC                                   BUG23967
     C                   Z-ADD     *ZEROS        AEQFLIND                                  BUG23967A
     C                   ENDIF                                                             BUG23967A
     C                   ENDIF                                                             BUG23967A
      *
     C**********         ENDIF                                                              BUG23967
      *
     C**********         ENDIF                                                              BUG23967
      *
      ** Update file PMPPTHQ0
      *
     C                   UPDATE    PMPPTHQ0
      *
      ** Read file PMPPTHQ1
      *
     C                   READ      PMPPTHQ1
      *
     C                   ENDDO
      *
      ** Close file PMPPTHQ1
      *
     C                   CLOSE     PMPPTHQ1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop32: Initialize new Local Industry Code field on file    *
      *           PMBDIPPD                                            *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPop32       BEGSR
      *
     C                   OPEN      PMBDIPPD
      *
     C     1             SETLL     PMBDIPPD
      *
     C                   READ      PMBDIPPD
      *
     C                   DOW       NOT(%EOF)
      *
     C**********         IF        AFPWLOIC = *BLANKS                                       BUG23967
      *
     C**********         IF        AFPWLIND <> *ZEROS                                       BUG23967
      *
     C**********         EVAL      WLocaIndCd = AFPWLIND                                    BUG23967
     C**********         ELSE                                                               BUG23967
     C**********         EVAL      AFPWLOIC = *BLANKS                                       BUG23967
     C     AFPWLOIC      IFEQ      *BLANKS                                                 BUG23967A
     C     AFPWLIND      IFEQ      *ZERO                                                   BUG23967A
     C                   MOVE      *BLANKS       AFPWLOIC                                  BUG23967A
     C                   ELSE                                                              BUG23967A
     C                   MOVE      AFPWLIND      AFPWLOIC                                   BUG23967
     C                   Z-ADD     *ZEROS        AFPWLIND                                  BUG23967A
     C                   ENDIF                                                             BUG23967A
     C                   ENDIF                                                             BUG23967A
      *
     C**********         ENDIF                                                              BUG23967
      *
     C**********         ENDIF                                                              BUG23967
      *
      ** Update file PMBDIPP0
      *
     C                   UPDATE    PMBDIPP0
      *
      ** Read file PMBDIPPD
      *
     C                   READ      PMBDIPPD
      *
     C                   ENDDO
      *
      ** Close file PMBDIPPD
      *
     C                   CLOSE     PMBDIPPD
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop33: Initialize new Local Industry Code field on file    *
      *           LEVCLILPD                                           *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPop33       BEGSR
      *
     C                   OPEN      LEVCLILPD
      *
     C     1             SETLL     LEVCLILPD
      *
     C                   READ      LEVCLILPD
      *
     C                   DOW       NOT(%EOF)
      *
     C**********         IF        AGCLLOIC = *BLANKS                                       BUG23967
      *
     C**********         IF        AGCLLIND <> *ZEROS                                       BUG23967
      *
     C**********         EVAL      WLocaIndCd = AGCLLIND                                    BUG23967
     C**********         ELSE                                                               BUG23967
     C**********         EVAL      AGCLLOIC = *BLANKS                                       BUG23967
     C     AGCLLOIC      IFEQ      *BLANKS                                                 BUG23967A
     C     AGCLLIND      IFEQ      *ZERO                                                   BUG23967A
     C                   MOVE      *BLANKS       AGCLLOIC                                  BUG23967A
     C                   ELSE                                                              BUG23967A
     C                   MOVE      AGCLLIND      AGCLLOIC                                   BUG23967
     C                   Z-ADD     *ZEROS        AGCLLIND                                  BUG23967A
     C                   ENDIF                                                             BUG23967A
     C                   ENDIF                                                             BUG23967A
      *
     C**********         ENDIF                                                              BUG23967
      *
     C**********         ENDIF                                                              BUG23967
      *
      ** Update file LEVCLILD0
      *
     C                   UPDATE    LEVCLILD0
      *
      ** Read file LEVCLILPD
      *
     C                   READ      LEVCLILPD
      *
     C                   ENDDO
      *
      ** Close file LEVCLILPD
      *
     C                   CLOSE     LEVCLILPD
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop34: Initialize new Local Industry Code field on file    *
      *           BYEXDTPP                                            *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPop34       BEGSR
      *
     C                   OPEN      BYEXDTPP
      *
     C     1             SETLL     BYEXDTPP
      *
     C                   READ      BYEXDTPP
      *
     C                   DOW       NOT(%EOF)
      *
     C**********         IF        AHL8LOIC = *BLANKS                                       BUG23967
      *
     C**********         IF        AHL8LIND <> *ZEROS                                       BUG23967
      *
     C**********         EVAL      WLocaIndCd = AHL8LIND                                    BUG23967
     C**********         ELSE                                                               BUG23967
     C**********         EVAL      AHL8LOIC = *BLANKS                                       BUG23967
     C     AHL8LOIC      IFEQ      *BLANKS                                                 BUG23967A
     C     AHL8LIND      IFEQ      *ZERO                                                   BUG23967A
     C                   MOVE      *BLANKS       AHL8LOIC                                  BUG23967A
     C                   ELSE                                                              BUG23967A
     C                   MOVE      AHL8LIND      AHL8LOIC                                   BUG23967
     C                   Z-ADD     *ZEROS        AHL8LIND                                  BUG23967A
     C                   ENDIF                                                             BUG23967A
     C                   ENDIF                                                             BUG23967A
      *
     C**********         ENDIF                                                              BUG23967
      *
     C**********         ENDIF                                                              BUG23967
      *
      ** Update file BYEXDTD0
      *
     C                   UPDATE    BYEXDTD0
      *
      ** Read file BYEXDTPP
      *
     C                   READ      BYEXDTPP
      *
     C                   ENDDO
      *
      ** Close file BYEXDTPP
      *
     C                   CLOSE     BYEXDTPP
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop35: Initialize new Local Industry Code field on file    *
      *           BYEXIEPP                                            *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPop35       BEGSR
      *
     C                   OPEN      BYEXIEPP
      *
     C     1             SETLL     BYEXIEPP
      *
     C                   READ      BYEXIEPP
      *
     C                   DOW       NOT(%EOF)
      *
     C**********         IF        AIL8LOIC = *BLANKS                                       BUG23967
      *
     C**********         IF        AIL8LIND <> *ZEROS                                       BUG23967
      *
     C**********         EVAL      WLocaIndCd = AIL8LIND                                    BUG23967
     C**********         ELSE                                                               BUG23967
     C**********         EVAL      AIL8LOIC = *BLANKS                                       BUG23967
     C     AIL8LOIC      IFEQ      *BLANKS                                                 BUG23967A
     C     AIL8LIND      IFEQ      *ZERO                                                   BUG23967A
     C                   MOVE      *BLANKS       AIL8LOIC                                  BUG23967A
     C                   ELSE                                                              BUG23967A
     C                   MOVE      AIL8LIND      AIL8LOIC                                   BUG23967
     C                   Z-ADD     *ZEROS        AIL8LIND                                  BUG23967A
     C                   ENDIF                                                             BUG23967A
     C                   ENDIF                                                             BUG23967A
      *
     C**********         ENDIF                                                              BUG23967
      *
     C**********         ENDIF                                                              BUG23967
      *
      ** Update file BYEXIED0
      *
     C                   UPDATE    BYEXIED0
      *
      ** Read file BYEXIEPP
      *
     C                   READ      BYEXIEPP
      *
     C                   ENDDO
      *
      ** Close file BYEXIEPP
      *
     C                   CLOSE     BYEXIEPP
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop36: Initialize new Local Industry Code field on file    *
      *           SECORBPD                                            *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPop36       BEGSR
      *
     C                   OPEN      SECORBPD
      *
     C     1             SETLL     SECORBPD
      *
     C                   READ      SECORBPD
      *
     C                   DOW       NOT(%EOF)
      *
     C**********         IF        AJNBLOIC = *BLANKS                                       BUG23967
      *
     C**********         IF        AJNBSIDY <> *ZEROS                                       BUG23967
      *
     C**********         EVAL      WLocaIndCd = AJNBSIDY                                    BUG23967
     C**********         ELSE                                                               BUG23967
     C**********         EVAL      AJNBLOIC = *BLANKS                                       BUG23967
     C     AJNBLOIC      IFEQ      *BLANKS                                                 BUG23967A
     C     AJNBSIDY      IFEQ      *ZERO                                                   BUG23967A
     C                   MOVE      *BLANKS       AJNBLOIC                                  BUG23967A
     C                   ELSE                                                              BUG23967A
     C                   MOVE      AJNBSIDY      AJNBLOIC                                   BUG23967
     C                   Z-ADD     *ZEROS        AJNBSIDY                                  BUG23967A
     C                   ENDIF                                                             BUG23967A
     C                   ENDIF                                                             BUG23967A
      *
     C**********         ENDIF                                                              BUG23967
      *
     C**********         ENDIF                                                              BUG23967
      *
      ** Update file SECORBD0
      *
     C                   UPDATE    SECORBD0
      *
      ** Read file SECORBPD
      *
     C                   READ      SECORBPD
      *
     C                   ENDDO
      *
      ** Close file SECORBPD
      *
     C                   CLOSE     SECORBPD
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop37: Initialize new Local Industry Code field on file    *
      *           SEVSECSPD                                           *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPop37       BEGSR
      *
     C                   OPEN      SEVSECSPD
      *
     C     1             SETLL     SEVSECSPD
      *
     C                   READ      SEVSECSPD
      *
     C                   DOW       NOT(%EOF)
      *
     C**********         IF        AKS1LOIC = *BLANKS                                       BUG23967
      *
     C**********         IF        AKS1SIDY <> *ZEROS                                       BUG23967
      *
     C**********         EVAL      WLocaIndCd = AKS1SIDY                                    BUG23967
     C**********         ELSE                                                               BUG23967
     C**********         EVAL      AKS1LOIC = *BLANKS                                       BUG23967
     C     AKS1LOIC      IFEQ      *BLANKS                                                 BUG23967A
     C     AKS1SIDY      IFEQ      *ZERO                                                   BUG23967A
     C                   MOVE      *BLANKS       AKS1LOIC                                  BUG23967A
     C                   ELSE                                                              BUG23967A
     C                   MOVE      AKS1SIDY      AKS1LOIC                                   BUG23967
     C                   Z-ADD     *ZEROS        AKS1SIDY                                  BUG23967A
     C                   ENDIF                                                             BUG23967A
     C                   ENDIF                                                             BUG23967A
      *
     C**********         ENDIF                                                              BUG23967
      *
     C**********         ENDIF                                                              BUG23967
      *
      ** Update file SEVSECSD0
      *
     C                   UPDATE    SEVSECSD0
      *
      ** Read file SEVSECSPD
      *
     C                   READ      SEVSECSPD
      *
     C                   ENDDO
      *
      ** Close file SEVSECSPD
      *
     C                   CLOSE     SEVSECSPD
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop38: Initialize new Local Industry Code field on file    *
      *           SECTYD                                              *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPop38       BEGSR
      *
     C                   OPEN      SECTYD
      *
     C     1             SETLL     SECTYD
      *
     C                   READ      SECTYD
      *
     C                   DOW       NOT(%EOF)
      *
     C**********         IF        ALLOIC = *BLANKS                                         BUG23967
      *
     C**********         IF        ALSIDY <> *ZEROS                                         BUG23967
      *
     C**********         EVAL      WLocaIndCd = ALSIDY                                      BUG23967
     C**********         ELSE                                                               BUG23967
     C**********         EVAL      ALLOIC = *BLANKS                                         BUG23967
     C     ALLOIC        IFEQ      *BLANKS                                                 BUG23967A
     C     ALSIDY        IFEQ      *ZERO                                                   BUG23967A
     C                   MOVE      *BLANKS       ALLOIC                                    BUG23967A
     C                   ELSE                                                              BUG23967A
     C                   MOVE      ALSIDY        ALLOIC                                     BUG23967
     C                   Z-ADD     *ZEROS        ALSIDY                                    BUG23967A
     C                   ENDIF                                                             BUG23967A
     C                   ENDIF                                                             BUG23967A
      *
     C**********         ENDIF                                                              BUG23967
      *
     C**********         ENDIF                                                              BUG23967
      *
      ** Update file SECTYDF
      *
     C                   UPDATE    SECTYDF
      *
      ** Read file SECTYD
      *
     C                   READ      SECTYD
      *
     C                   ENDDO
      *
      ** Close file SECTYD
      *
     C                   CLOSE     SECTYD
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRPop39: Initialize new Local Industry Code field on file    *
      *           CLOANCL                                             *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRPop39       BEGSR
      *
     C                   OPEN      CLOANCL
      *
     C     1             SETLL     CLOANCL
      *
     C                   READ      CLOANCL
      *
     C                   DOW       NOT(%EOF)
      *
     C**********         IF        AMLOIC = *BLANKS                                         BUG23967
      *
     C**********         IF        AMLIND <> *ZEROS                                         BUG23967
      *
     C**********         EVAL      WLocaIndCd = AMLIND                                      BUG23967
     C**********         ELSE                                                               BUG23967
     C**********         EVAL      AMLOIC = *BLANKS                                         BUG23967
     C     AMLOIC        IFEQ      *BLANKS                                                 BUG23967A
     C     AMLIND        IFEQ      *ZERO                                                   BUG23967A
     C                   MOVE      *BLANKS       AMLOIC                                    BUG23967A
     C                   ELSE                                                              BUG23967A
     C                   MOVE      AMLIND        AMLOIC                                     BUG23967
     C                   Z-ADD     *ZEROS        AMLIND                                    BUG23967A
     C                   ENDIF                                                             BUG23967A
     C                   ENDIF                                                             BUG23967A
      *
     C**********         ENDIF                                                              BUG23967
      *
     C**********         ENDIF                                                              BUG23967
      *
      ** Update file CLOANCLF
      *
     C                   UPDATE    CLOANCLF
      *
      ** Read file CLOANCL
      *
     C                   READ      CLOANCL
      *
     C                   ENDDO
      *
      ** Close file CLOANCL
      *
     C                   CLOSE     CLOANCL
      *
     C                   ENDSR
      *****************************************************************
