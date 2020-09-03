     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Extract of accounts')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOXTACCT - Extract of Accounts                               *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE073             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP204             Date 09Feb10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG3860            Date 11Aug04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CAP204 - Teller Related APIs - Account Transfer (Recompile)  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG3860 - (recompile)                                        *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FGLPOSTL   IF   E           K DISK    INFSR(*PSSR) PREFIX(C_) USROPN
     F                                     INCLUDE(APOSTPDF)
     FRSACMTL6  IF   E           K DISK    INFSR(*PSSR) PREFIX(C_) INFDS(MINF)
     F                                     RENAME(APOSTPDF:CLEARPDF)
 
     FGPUTXGL1  UF   E           K DISK    INFSR(*PSSR) COMMIT
 
     FGPPOSNPD  O    E           K DISK    INFSR(*PSSR) USROPN  COMMIT
     F                                     RENAME(GOPOSND0:GPPOSND0)
     FGPPOSTPD  O    E           K DISK    INFSR(*PSSR) USROPN  COMMIT
     F                                     RENAME(GOPOSTD0:GPPOSTD0)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
     D ACCT          E DS                  EXTNAME(ACCNTAB)
 
 
      ** T R A N S A C T I O N    D E T A I L S
     D T_TRAP        E DS                  EXTNAME(GPTRAPPD)
      ** P O S I T I O N    D E T A I L S
     D P_POSN        E DS                  EXTNAME(GPPOSNPD)
     D CT_P_POSN     E DS                  EXTNAME(GPPOSNPD) PREFIX(CT_)
     D CV_P_POSN     E DS                  EXTNAME(GPPOSNPD) PREFIX(CV_)
      ** P O S T I N G   D E T A I L S
     D C_POSTX       E DS                  EXTNAME(GPPOSTPD)
 
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
 
     D MINF            DS
     D DB_RRN                397    400I 0
 
      ** Declared variable                                                                    CGL029
     D I#OTRF          S             21                                                       CGL029
 
     IAPOSTPDF
     I              ACOD                        ZZACOD
     I              ACSQ                        ZZACSQ
     I              PSTD                        C_PSTD
     I              VALD                        C_VALD
     I              PNAR                        C_PNAR
     I              PSTA                        C_PSTA
     I              DRCR                        C_DRCRI
 
     IRSACMTPO      01
     I              PTDT                        C_PSTD
     I              VUDT                        C_VALD
     I              NRTD                        C_PNAR
     I              MVAM                        C_PSTA
     I              DORC                        C_DRCRI
     IFFACMVDF      02
     I              PTDT                        C_PSTD
     I              VUDT                        C_VALD
     I              NRTD                        C_PNAR
     I              MVAM                        C_PSTA
     I              DORC                        C_DRCRI
     I              NRTC                        ZZNRTC
     ICLEARPDF      03
     I              ACOD                        ZZACOD
     I              ACSQ                        ZZACSQ
     I              PSTD                        C_PSTD
     I              VALD                        C_VALD
     I              PNAR                        C_PNAR
     I              PSTA                        C_PSTA
     I              DRCR                        C_DRCRI
 
 
      * ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    I#LOC             4
     C                   PARM                    I#CCID           10 0
 
     C                   PARM                    I#RDNB            5 0
     C                   PARM                    I#DNWD            5 0
     C                   PARM                    I#PCOD            5 0
     C                   PARM                    I#AMRD            5 0
     C                   PARM                    ACCT
 
      * SETUP TRANSACTION INDEX RECORD
 
     C                   EXSR      SETUP_TRAP
 
      * No extract
     C     W#RTCD        IFEQ      '*NOEXT*'
     C                   RETURN
     C                   ENDIF
 
      * Do position and posting extracts only in global environment
 
     C     I#LOC         IFEQ      'GLOB'
 
      * READ HISTORIC ACCOUNT MOVEMENTS
 
     C     T_PRRN        IFEQ      *ZERO
     C                   EXSR      READ_HIST_ACMV
     C                   ENDIF
 
      * READ PROJECTED ACCOUNT MOVEMENTS
 
     C                   Z-SUB     1             HighestDB_RRN     5 0
     C                   EXSR      READ_PROJ_ACMV
 
      * UPDATE UNIVERSAL TRANSACTION EXTENSION DATA - GL
 
     C                   EXSR      UPD_UTXG
 
 
      * WRITE TRADE DATE POSITION    (CLOSING LEDGER BALANCE)
      * -------------------------
 
     C                   MOVEL     'T'           Trade_Value       1
     C                   Z-ADD     I#RDNB        Position_Date     5 0
     C                   EXSR      WRITE_BAL
 
      * Set 'current' ledger balance
     C                   MOVEL     CT_P_POSN     P_POSN
     C                   MOVEL     P_ASLI        LedgerASLI        1
     C                   Z-ADD     P_NOML        LedgerNOML       15 0
 
 
      * WRITE VALUE DATE POSITION    (CLOSING CLEARED BALANCE)
      * -------------------------
 
     C                   MOVEL     'V'           Trade_Value
     C                   Z-ADD     PrevVALD      Position_Date
     C                   EXSR      WRITE_BAL
 
      * Set 'current' cleared balance
     C                   MOVEL     CV_P_POSN     P_POSN
     C                   MOVEL     P_ASLI        ClearedASLI       1
     C                   Z-ADD     P_NOML        ClearedNOML      15 0
 
 
      * WRITE 'CURRENT' TRADE DATE POSITION
      * -----------------------------------
 
     C                   MOVEL     CT_P_POSN     P_POSN
     C                   MOVEL     ClearedASLI   P_OASL
     C                   Z-ADD     ClearedNOML   P_ONOM
     C                   MOVEL     P_CCY         P_OCCY
     C                   WRITE     GPPOSND0
 
 
      * WRITE 'CURRENT' VALUE DATE POSITION
      * -----------------------------------
 
     C                   MOVEL     CV_P_POSN     P_POSN
     C                   MOVEL     LedgerASLI    P_OASL
     C                   Z-ADD     LedgerNOML    P_ONOM
     C                   MOVEL     P_CCY         P_OCCY
     C                   WRITE     GPPOSND0
 
     C                   ENDIF
 
      * WRITE TRANSACTION INDEX RECORD
      * Commitment Cycle ID
     C                   Z-ADD     I#CCID        T_CCID
     C                   EXSR      WRITE_TRAP
 
      * RETURN
 
     C                   RETURN
      *
      *****************************************************************
      * SETUP TRANSACTION INDEX RECORD
      *****************************************************************
     C     SETUP_TRAP    BEGSR
      *
     C                   CALLB     'GOSETACCT'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    ACCT
      * OUTPUTS
     C                   PARM                    T_TRAP
     C                   PARM      *ZERO         T_PRRN            5 0
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOSETACCT'
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * WRITE TRANSACTION INDEX RECORD
      *****************************************************************
     C     WRITE_TRAP    BEGSR
 
     C                   MOVEL     'Y'           I#CUSTDEFLT
 
      /COPY GOCPYSRC,GOWRTTRAP
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Read historic account movements
      *****************************************************************
     C     READ_HIST_ACMVBEGSR
 
      * Read a/c movements for a/c since 'a/c movement recovery date'
 
     C     APOSTKF       SETLL     GLPOSTL
     C     APOSTK        READE     GLPOSTL                                99    *
 
      * Do while a/c movements found
 
     C     *IN99         DOWEQ     '0'
 
      * If posting cleared
 
     C     ATYP          IFNE      'R'
     C     C_VALD        ORLT      I#RDNB
 
      * Determine posting details (module/sub-module/transaction reference)
 
     C                   SETOFF                                       0102
     C                   EXSR      DET_POSTDTS
 
      * 'Posted' and 'cleared' indicators
 
     C                   MOVE      'Y'           C_POST
     C                   MOVE      'Y'           C_CLER
 
      * debit/credit indicator
 
     C     C_DRCRI       IFEQ      0
     C                   MOVE      'D'           C_DRCR
     C                   ELSE
     C                   MOVE      'C'           C_DRCR
     C                   ENDIF
 
      * Write posting
 
     C                   MOVEL     T_ID          C_ID
     C                   WRITE     GPPOSTD0
 
     C                   ENDIF
 
     C     APOSTK        READE     GLPOSTL                                99    *
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Read projected account movements
      *****************************************************************
     C     READ_PROJ_ACMVBEGSR
 
      * Read a/c movements for a/c
 
     C     APOSTK        SETLL     RSACMTL6
     C                   SETOFF                                       010203
     C     APOSTK        READE     RSACMTL6                               99    *
 
     C                   Z-ADD     I#RDNB        PrevVALD          5 0
     C                   MOVEL     'Y'           First_ValDate     1
 
      * Do while a/c movements found
 
     C     *IN99         DOWEQ     '0'
 
      * Determine posting details (module/sub-module/transaction reference)
 
     C                   EXSR      DET_POSTDTS
 
      * Posting date and posting narrative
 
     C     *in01         IFEQ      '1'
     C     *in02         OREQ      '1'
     C     C_TRYP        IFEQ      'ME'
     C     C_VALD        ORLT      I#DNWD
     C                   Z-ADD     I#RDNB        C_PSTD
     C                   ELSE
     C                   Z-ADD     C_VALD        C_PSTD
     C                   ENDIF
     C     C_PNAR        IFEQ      *BLANK
     C                   EVAL      C_PNAR = C_TRYP + ' ' + C_TNMR
     C                   ENDIF
     C                   ENDIF
 
      * 'Posted' and 'cleared' indicators
 
     C     *in01         IFEQ      '1'
     C     *in02         OREQ      '1'
     C                   MOVE      'N'           C_POST
     C                   MOVE      'N'           C_CLER
     C                   ELSE
     C                   MOVE      'Y'           C_POST
     C                   MOVE      'N'           C_CLER
     C                   ENDIF
 
      * debit/credit indicator
 
     C     C_DRCRI       IFEQ      0
     C                   MOVE      'D'           C_DRCR
     C                   ELSE
     C                   MOVE      'C'           C_DRCR
     C                   ENDIF
 
      * If the value date has changed
      * Write a value date balance record
 
     C     C_VALD        IFGT      PrevVALD
     C                   MOVEL     'V'           Trade_Value
     C                   Z-ADD     PrevVALD      Position_Date
     C                   EXSR      WRITE_BAL
     C                   Z-ADD     C_VALD        PrevVALD
     C                   MOVEL     'N'           First_ValDate
     C                   ENDIF
 
      * Update running ledger balance
 
     C     C_POST        IFEQ      'N'
     C     C_PSTD        ANDLE     I#RDNB
     C     C_DRCR        IFEQ      'D'
     C                   ADD       C_PSTA        LDBL
     C                   ELSE
     C                   SUB       C_PSTA        LDBL
     C                   ENDIF
     C                   ENDIF
 
      * Update running cleared balance
 
     C     C_DRCR        IFEQ      'D'
     C                   ADD       C_PSTA        CLBL
     C                   ELSE
     C                   SUB       C_PSTA        CLBL
     C                   ENDIF
 
      * Write posting if not yet written
 
     C     DB_RRN        IFGT      T_PRRN
     C                   MOVEL     T_ID          C_ID
     C                   WRITE     GPPOSTD0
     C                   ENDIF
 
      * Maintain the highest RRN of postings read
 
     C     DB_RRN        IFGT      HighestDB_RRN
     C                   Z-ADD     DB_RRN        HighestDB_RRN
     C                   ENDIF
 
     C                   SETOFF                                       010203
     C     APOSTK        READE     RSACMTL6                               99    *
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * UPDATE UNIVERSAL TRANSACTION EXTENSION DATA - GL
      *****************************************************************
     C     UPD_UTXG      BEGSR
 
     C     GPUTXGK       CHAIN     GPUTXGD0                           99
     C  N99              Z-ADD     HighestDB_RRN XGPRRN
     C  N99              UPDATE    GPUTXGD0
 
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * WRITE BALANCE
      *****************************************************************
     C     WRITE_BAL     BEGSR
      *
      * Clear Position
      *
     C                   CLEAR                   P_POSN
 
      * Identifier
     C                   MOVEL     T_ID          P_ID
      * Trade/Value Date
     C                   MOVEL     Trade_Value   P_TVDI
      * Position Type
     C                   SELECT
     C     Position_Date WHENEQ    I#RDNB
     C     First_ValDate OREQ      'Y'
     C                   MOVEL     'C'           P_PSTP
     C                   OTHER
     C                   MOVEL     'F'           P_PSTP
     C                   ENDSL
      * Position Date
     C                   Z-ADD     Position_Date P_PDAT
      *
      * Asset/Liability
      * Nominal/Principal
     C     Trade_Value   IFEQ      'T'
     C     LDBL          IFGE      0
     C                   MOVEL     'A'           P_ASLI
     C                   Z-ADD     LDBL          P_NOML
     C                   ELSE
     C                   MOVEL     'L'           P_ASLI
     C                   Z-SUB     LDBL          P_NOML
     C                   ENDIF
     C                   ELSE
     C     CLBL          IFGE      0
     C                   MOVEL     'A'           P_ASLI
     C                   Z-ADD     CLBL          P_NOML
     C                   ELSE
     C                   MOVEL     'L'           P_ASLI
     C                   Z-SUB     CLBL          P_NOML
     C                   ENDIF
     C                   ENDIF
      *
      * Currency
     C                   MOVEL     CCY           P_CCY
     C                   MOVEL     CCY           @CYCD
     C                   EXSR      ACSCCY
      *
      * Nominal Dec Places
     C                   MOVEL     A6NBDP        P_NMDP
 
      * Market price & value
     C                   Z-ADD     1             P_MKPR
     C     LDBL          IFGE      0
     C                   Z-ADD     P_NOML        P_MKVL
     C                   ELSE
     C                   Z-SUB     P_NOML        P_MKVL
     C                   ENDIF
     C                   MOVEL     P_CCY         P_VCCY
      *
      * Write a 'forward' position record
      *
     C     P_PSTP        IFEQ      'F'
     C                   WRITE     GPPOSND0
      *
      * Store the 'current' positions
      *
     C                   ELSE
     C     Trade_Value   IFEQ      'T'
     C                   MOVEL     P_POSN        CT_P_POSN
     C                   ELSE
     C                   MOVEL     P_POSN        CV_P_POSN
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Determine posting details (module/sub-module/transaction reference)
      ********************************************************************
     C     DET_POSTDTS   BEGSR
 
     C     *in01         IFEQ      '1'
     C     *in02         OREQ      '1'
     C                   MOVEL     'Y'           I#OL
     C                   ELSE
     C                   MOVEL     'N'           I#OL
     C                   ENDIF
 
     C                   CALLB     'GOPOSTDTS'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    I#OL              1
     C                   PARM      C_TRYP        I#TRYP            2
     C                   PARM      C_TNMR        I#TNMR            6
     C                   PARM      C_PNAR        I#PNAR           30
     C                   PARM      C_SPOS        I#SPOS            7
     C                   PARM      C_OTTP        I#OTTP           10
     C**********         PARM      C_OTRF        I#OTRF           15                          CGL029
     C                   PARM      C_OTRF        I#OTRF                                       CGL029
      * OUTPUTS
     C                   PARM      *BLANK        C_TMOD
     C                   PARM      *BLANK        C_TSMD
     C                   PARM      *BLANK        C_TREF
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOPOSTDTS'
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * ACCESS CURRENCY DETAILS
      ********************************************************************
     C     ACSCCY        BEGSR
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM                    @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR
      ********************************************************************
     C     *INZSR        BEGSR
 
      * Open files
     C     I#LOC         IFEQ      'GLOB'
     C                   OPEN      GPPOSNPD
     C                   OPEN      GPPOSTPD
     C                   OPEN      GLPOSTL
     C                   ENDIF
 
      * key list
 
     C     APOSTK        KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C     APOSTKF       KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C                   KFLD                    I#AMRD
     C     GPUTXGK       KLIST
     C                   KFLD                    T_ZONE
     C                   KFLD                    T_CNUM
     C                   KFLD                    T_BRCA
     C                   KFLD                    T_ACCY
     C                   KFLD                    T_ACOD
     C                   KFLD                    T_ACSQ
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *********************************************************************
**  CPY@
(c) Finastra International Limited 2001
