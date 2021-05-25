     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Group Account Shadow Posting Generation')     *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100607 - Group Account Shadow Posting Generation           *
      *                                                               *
      *  Function:  This program is given a group a/c hierarchy chain *
      *             and an entry from RSACMTPD or FFACMVD to          *
      *             replicate.  It then replicates that entry up the  *
      *             chain and updates MEMOS and MEMOSME accordingly.  *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR980046           Date 25Feb13               *
      *                 AR679670           Date 26Nov10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205             Date 08Mar10               *
      *                 CAP204             Date 09Feb10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 216478             Date 24Apr03               *
      *                 CRE008  *CREATE    Date 22Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR980046 - MEMOS and RSACMTPD is not updated. Reversed       *
      *             255387 because MEMOS and RSACMTPD should be       *
      *             updated regardless of the BAIC value. Fix is      *
      *             patterned after 233451. (Child:AR980048)          *
      *  AR679670 - Apply fix 255837                                  *
      *  255837 - Fix Overdraft validation.  Update MEMOS and         *
      *           RSACMTPD if BAIC of sub-account = 'Y'               *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *  CAP204 - Teller Related APIs - Account Transfer (Recompile)  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  216478 - Allow update of forward valued postings             *
      *           on MEMOS ledger balance                             *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
      ** GL Account Movements
     FRSACMTPD  O  A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     PREFIX(OR_)
 
      ** Postings in Transit - Group Account Exts
     FGLPSTGAPD O  A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** GL Account Movements
     FFFACMVD   O  A E           K DISK    INFSR(*PSSR) USROPN
     F                                     COMMIT
     F                                     PREFIX(OF_)
 
      ** RE Shadow Balances
     FMEMOSL1   UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     PREFIX(S_)
 
      ** RE Shadow Balances
     FMEMOSM    UF A E           K DISK    INFSR(*PSSR) USROPN
     F                                     COMMIT
     F                                     PREFIX(M_)
 
      ** RE Group Account (Inter-Company) Cleared Balances
     FREGACBL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
      ** Chain Arrays
     D*I_GLAI***       S             18    DIM(99)                                            CGL029
     D I_GLAI          S             24    DIM(99)                                            CGL029
     D I_RAN           S             10    DIM(99)
     D I_AST           S              1    DIM(99)
     D I_PC            S              4    DIM(99)
     D I_ASC           S              2    DIM(99)
     D I_ODFT          S             15S 0 DIM(99)
     D I_BAIC          S              1    DIM(99)
     D I_ICTB          S             15S 0 DIM(99)
 
 
      * Entry To Replicate
     D I_RSACMT      E DS                  EXTNAME(RSACMTPD)
     D                                     PREFIX(R_)
 
      * Entry To Replicate
     D I_FFACMV      E DS                  EXTNAME(FFACMVD)
     D                                     PREFIX(F_)
 
      * Entry To Replicate
     D O_RSACMT      E DS                  EXTNAME(RSACMTPD)
     D                                     PREFIX(OR_)
     D***OR_PACC               1     15                                                       CGL029
 
      * Entry To Replicate
     D O_FFACMV      E DS                  EXTNAME(FFACMVD)
     D                                     PREFIX(OF_)
     D***OF_FACC               1     18                                                       CGL029
 
 
     D MEMOSL1DS     E DS                  EXTNAME(MEMOSL1)
     D                                     PREFIX(S_)
     D***S_PACC*               2     16                                                       CGL029
 
 
     D MEMOSMDS      E DS                  EXTNAME(MEMOSL1)
     D                                     PREFIX(M_)
     D***M_PACC*               2     16                                                       CGL029
 
 
      * CMDEXC array
     D CMD             S             50    DIM(2) PERRCD(1) CTDATA
 
     D TEXT            DS
     D  TXTMSG                 1     50
     D  TXTMBR                26     28
 
 
     D ACCID           DS
     D  BRCA                   1      3
     D**CNUM****               4      9S 0                                                    CSD027
     D  CNUM                   4      9A                                                      CSD027
     D  CCY                   10     12
     D  ACOD                  13     22S 0                                                    CGL029
     D  ACSQ                  23     24S 0                                                    CGL029
     D  PACC                   4     24                                                       CGL029
     D**ACOD****              13     16S 0                                                    CGL029
     D**ACSQ****              17     18S 0                                                    CGL029
     D**PACC****               4     18                                                       CGL029
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs
 
     D  @SARD          S              6A                                                      CAP205
     D  CAP205         S              1A                                                      CAP205
 
      * Clear outputs
 
     C                   MOVEL     *BLANK        X_RTCD
 
     C                   MOVEL     I_BAIC(1)     SV_BAIC           1
 
      * Do until no more hierarchy link records found
 
     C                   Z-ADD     1             C                 2 0
 
     C     I_GLAI(C)     DOWNE     *BLANK
     C     I_AST(C)      ANDNE     'C'
 
     C*****SV_BAIC       IFEQ      'Y'                                               255837 AR980046
     C**********         MOVEL     I_BAIC(C)     SV_BAIC                             255837 AR980046
     C**********         ENDIF                                                       255837 AR980046
      *****************************************************************              255837 AR980046
     C     I_FILE        IFEQ      'RSACMTPD  '
 
      * Get Next Available Ref. No.
 
     C                   EXSR      GET_APNA
 
      * Write extension record
 
     C                   EXSR      WRT_EXTSN
 
      *****************************************************************              255837 AR980046
      ***Update*RSACMTPD*and*MEMOS*only*if*the*BAIC*field*is*equal*to*'Y'.           255837 AR980046
      *****************************************************************              255837 AR980046
     C*****SV_BAIC       IFEQ      'Y'                                               255837 AR980046
      * Write to RSACMTPD
 
     C                   EXSR      WRT_RSACMT
 
      *  Update Memos
 
     C*****R_VUDT********IFLT      BJDNWD                                       216478
     C                   EXSR      UPD_MEMOS
     C*******************ENDIF                                                  216478
     C**********         ENDIF                                                       255837 AR980046
     C                   ENDIF
 
     C     I_FILE        IFEQ      'FFACMVD   '
 
      *  Write to FFACMVD
 
     C                   EXSR      WRT_FFACMV
 
      *  Update Memosm
 
     C     F_VUDT        IFLT      BJDNWD
     C                   EXSR      UPD_MEMOSM
     C                   ENDIF
     C                   ENDIF
 
 
      *  Update Group Account (Inter-Company) Cleared Balances
 
     C     SV_BAIC       IFEQ      'Y'
     C                   EXSR      UPD_REGACB
     C**********         MOVEL     I_BAIC(C)     SV_BAIC                                      255837
     C                   ENDIF
 
      * Advance to next element in the chain
 
     C                   ADD       1             C
 
     C                   ENDDO
     C
     C                   CLOSE     FFACMVD
     C                   CLOSE     MEMOSM
 
     C                   RETURN
 
      /SPACE 5
      ********************************************************************
      * Get Next Available Ref. No.
      ********************************************************************
     C     GET_APNA      BEGSR
 
     C                   CALLB     'ZAGETAPNA'
 
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
 
      * INPUTS
      * Ext.File Ref.ID
     C                   PARM      'GA '         I_XRFI            3
      * OUTPUTS
      * Ext.File Ref.No.
     C                   PARM      *ZERO         O_XRFN           10 0
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'NO NEXT NUMBER (APNA)'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Write Extension record
      ********************************************************************
     C     WRT_EXTSN     BEGSR
 
      * Ext.File Ref.ID
     C                   MOVEL     I_XRFI        AGXRFI
      * Ext.File Ref.No.
     C                   MOVEL     O_XRFN        AGXRFN
      * Link/Unlink
     C                   MOVEL     *BLANK        AGLKUL
      * Source branch
      * Source customer
      * Source currency
      * Source a/c code
      * Source a/c seq.
     C                   MOVEL     R_BRCA        AGSBRC
     C                   MOVEL     R_CUSN        AGSCUS
     C                   MOVEL     R_CCYD        AGSCCY
     C                   MOVEL     R_ACDE        AGSACD
     C                   MOVEL     R_ASNC        AGSASN
      * Source retail no.
     C                   MOVEL     I_ACNO        AGSRNO
      * Source a/c level
     C                   MOVEL     I_LEVL        AGSLVL
      * Mode of Origin
     C                   MOVEL     'I/C'         AGMODO
      * Date Generated
     C                   Z-ADD     BJRDNB        AGDATG
      * Zero Balancing/Sweeping Extension Ref No.
     C     R_XRFI        IFEQ      'ZS '
     C                   Z-ADD     R_XRFN        AGZSXR
     C                   ELSE
     C                   Z-ADD     *ZERO         AGZSXR
     C                   ENDIF
 
     C                   WRITE     GLAPGAD0
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      *****************************************************************
      * Write to RSACMTPD
      *****************************************************************
     C     WRT_RSACMT    BEGSR
 
     C                   MOVEL     I_RSACMT      O_RSACMT
     C                   MOVEL     I_GLAI(C)     ACCID
     C                   MOVEL     BRCA          OR_BRCA
     C**********         MOVEL     PACC          OR_PACC                                      CGL029
     C                   MOVE      CNUM          OR_CUSN                                      CGL029
     C                   MOVE      CCY           OR_CCYD                                      CGL029
     C                   MOVE      ACOD          OR_ACDE                                      CGL029
     C                   MOVE      ACSQ          OR_ASNC                                      CGL029
     C                   MOVEL     AGXRFI        OR_XRFI
     C                   Z-ADD     AGXRFN        OR_XRFN
     C                   IF        CAP205 = 'Y'                                               CAP205
     C                   EVAL      OR_CMOD = 'RE'                                             CAP205
     C                   EVAL      OR_MTYP = 'S'                                              CAP205
     C                   ELSE                                                                 CAP205
     C                   EVAL      OR_CMOD = *BLANKS                                          CAP205
     C                   EVAL      OR_MTYP = *BLANKS                                          CAP205
     C                   ENDIF                                                                CAP205
 
     C                   WRITE     RSACMTPO
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *  Update Memos
      *****************************************************************
     C     UPD_MEMOS     BEGSR
 
     C**********         Z-ADD     OR_CUSN       K_CNUM                                       CSD027
     C                   EVAL      K_CNUM = OR_CUSN                                           CSD027
     C                   MOVEL     OR_CCYD       K_CCY
     C                   Z-ADD     OR_ACDE       K_ACOD
     C                   Z-ADD     OR_ASNC       K_ACSQ
     C                   MOVEL     OR_BRCA       K_BRCA
 
     C     K_MEMOS       CHAIN     MEMOSL1                            81
 
     C     *IN81         IFEQ      *ON
     C                   EVAL      X_ERMS = 'BAD A/C:' + ACCID
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     OR_DORC       IFEQ      0
     C                   ADD       OR_MVAM       S_LDBLN
     C     R_VUDT        IFLT      BJDNWD                                       216478
     C                   ADD       OR_MVAM       S_CLBLN
     C                   ENDIF                                                  216478
     C                   ELSE
     C                   SUB       OR_MVAM       S_LDBLN
     C     R_VUDT        IFLT      BJDNWD                                       216478
     C                   SUB       OR_MVAM       S_CLBLN
     C                   ENDIF                                                  216478
     C                   ENDIF
 
     C                   UPDATE    MEMOSMDF                             82
 
     C     *IN82         IFEQ      *ON
     C                   EVAL      X_ERMS = 'NOT UPDATED A/C:' + ACCID
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *  Write to FFACMVD
      *****************************************************************
     C     WRT_FFACMV    BEGSR
 
     C                   MOVEL     I_FFACMV      O_FFACMV
     C                   MOVEL     I_GLAI(C)     ACCID
     C**********         MOVEL     ACCID         OF_FACC                                      CGL029
     C                   MOVE      BRCA          OF_BRCA                                      CGL029
     C                   MOVE      CNUM          OF_CUSN                                      CGL029
     C                   MOVE      CCY           OF_CCYD                                      CGL029
     C                   MOVE      ACOD          OF_ACDE                                      CGL029
     C                   MOVE      ACSQ          OF_ASNC                                      CGL029
     C                   MOVEL     AGXRFI        OF_XRFI
     C                   Z-ADD     AGXRFN        OF_XRFN
 
     C                   WRITE     FFACMVDF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *  Update Memosm
      *****************************************************************
     C     UPD_MEMOSM    BEGSR
 
     C                   MOVEL     OF_BRCA       K_BRCA
     C**********         Z-ADD     OF_CUSN       K_CNUM                                       CSD027
     C                   EVAL      K_CNUM  = OF_CUSN                                          CSD027
     C                   MOVEL     OF_CCYD       K_CCY
     C                   Z-ADD     OF_ACDE       K_ACOD
     C                   Z-ADD     OF_ASNC       K_ACSQ
 
     C     K_MEMOM       CHAIN     MEMOSM                             83
 
     C     *IN83         IFEQ      *ON
     C                   MOVEL     'D'           M_RECI
     C**********         MOVEL     PACC          M_PACC                                       CGL029
     C                   MOVE      CNUM          M_CNUM                                       CGL029
     C                   MOVE      CCY           M_CCY                                        CGL029
     C                   MOVE      ACOD          M_ACOD                                       CGL029
     C                   MOVE      ACSQ          M_ACSQ                                       CGL029
     C                   MOVEL     BRCA          M_BRCA
     C                   Z-ADD     0             M_LDBL
     C                   Z-ADD     0             M_CLBL
     C                   ENDIF
 
     C     OF_DORC       IFEQ      0
     C                   ADD       OF_MVAM       M_LDBL
     C                   ADD       OF_MVAM       M_CLBL
     C                   ELSE
     C                   SUB       OF_MVAM       M_LDBL
     C                   SUB       OF_MVAM       M_CLBL
     C                   ENDIF
 
     C     *IN83         IFEQ      *ON
     C                   WRITE     MEMOSMEF
     C                   ELSE
     C                   UPDATE    MEMOSMEF                             84
     C                   ENDIF
 
     C     *IN84         IFEQ      *ON
     C                   EVAL      X_ERMS = 'NOT UPDATED FF A/C:' + ACCID
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *  Update Group Account (Inter-Company) Cleared Balances
      *****************************************************************
     C     UPD_REGACB    BEGSR
 
     C     I_FILE        IFEQ      'RSACMTPD  '
     C     R_VUDT        ANDLT     BJDNWD
     C     I_FILE        OREQ      'FFACMVD   '
     C     F_VUDT        ANDLT     BJDNWD
 
     C     I_FILE        IFEQ      'RSACMTPD  '
     C                   MOVEL     OR_BRCA       K_BRCA
     C**********         Z-ADD     OR_CUSN       K_CNUM                                       CSD027
     C                   EVAL      K_CNUM = OR_CUSN                                           CSD027
     C                   MOVEL     OR_CCYD       K_CCY
     C                   Z-ADD     OR_ACDE       K_ACOD
     C                   Z-ADD     OR_ASNC       K_ACSQ
     C                   ELSE
     C                   MOVEL     OF_BRCA       K_BRCA
     C**********         Z-ADD     OF_CUSN       K_CNUM                                       CSD027
     C                   EVAL      K_CNUM = OF_CUSN                                           CSD027
     C                   MOVEL     OF_CCYD       K_CCY
     C                   Z-ADD     OF_ACDE       K_ACOD
     C                   Z-ADD     OF_ASNC       K_ACSQ
     C                   ENDIF
 
     C     K_MEMOM       CHAIN     REGACBL0                           85
 
     C     *IN85         IFEQ      *ON
     C                   MOVEL     BRCA          GCBRCA
     C**********         Z-ADD     CNUM          GCCNUM                                       CSD027
     C                   EVAL      GCCNUM = CNUM                                              CSD027
     C                   MOVEL     CCY           GCCCY
     C                   Z-ADD     ACOD          GCACOD
     C                   Z-ADD     ACSQ          GCACSQ
     C                   Z-ADD     0             GCICCB
     C                   Z-ADD     0             GCSLTB
     C                   ENDIF
 
     C     I_FILE        IFEQ      'RSACMTPD  '
     C     OR_DORC       IFEQ      0
     C                   ADD       OR_MVAM       GCICCB
     C                   ELSE
     C                   SUB       OR_MVAM       GCICCB
     C                   ENDIF
     C                   ENDIF
 
     C     I_FILE        IFEQ      'FFACMVD   '
     C     OF_DORC       IFEQ      0
     C                   ADD       OF_MVAM       GCICCB
     C                   ELSE
     C                   SUB       OF_MVAM       GCICCB
     C                   ENDIF
     C                   ENDIF
 
     C     *IN85         IFEQ      *ON
     C                   WRITE     REGACBD0
     C                   ELSE
     C                   UPDATE    REGACBD0                             86
     C                   ENDIF
 
     C     *IN86         IFEQ      *ON
     C                   EVAL      X_ERMS = 'NOT UPDATED A/C:' + ACCID
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      * Return code
      * Error Message
     C                   PARM                    X_RTCD
     C                   PARM                    X_ERMS
 
      * INPUTS
      * RSAMCTPD Entry To Replicate
      * FFACMVD Entry To Replicate
     C                   PARM                    I_RSACMT
     C                   PARM                    I_FFACMV
      * File Name
      * Member Name
     C                   PARM                    I_FILE           10
     C                   PARM                    I_MEMBER         10
      * Hierarchy ID
     C                   PARM                    I_HIER            9 0
      * Retail a/c number
      * Level
     C                   PARM                    I_ACNO           10 0
     C                   PARM                    I_LEVL            2 0
      * CHAINS FOR:
      * GL Account ID
      * Retail A/c No.
      * A/c Status
      * Profit Centre
      * A/c Section
      * Overdraft
      * Balance Available for I/C Overdraft
      * I/C Threshold Balance
     C                   PARM                    I_GLAI
     C                   PARM                    I_RAN
     C                   PARM                    I_AST
     C                   PARM                    I_PC
     C                   PARM                    I_ASC
     C                   PARM                    I_ODFT
     C                   PARM                    I_BAIC
     C                   PARM                    I_ICTB
      * Count in chain
     C                   PARM                    I_CNTCH           2 0
 
     C     K_MEMOS       KLIST
     C**********         KFLD                    K_CNUM            6 0                        CSD027
     C                   KFLD                    K_CNUM            6                          CSD027
     C                   KFLD                    K_CCY             3
     C**********         KFLD                    K_ACOD            4 0                        CGL029
     C                   KFLD                    K_ACOD           10 0                        CGL029
     C                   KFLD                    K_ACSQ            2 0
     C                   KFLD                    K_BRCA            3
 
     C     K_MEMOM       KLIST
     C                   KFLD                    K_BRCA
     C                   KFLD                    K_CNUM
     C                   KFLD                    K_CCY
     C                   KFLD                    K_ACOD
     C                   KFLD                    K_ACSQ
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C     I_FILE        IFEQ      'FFACMVD   '
     C                   MOVEL     *BLANKS       TXTMSG
     C                   MOVEL     CMD(1)        TXTMSG
     C                   MOVEL     I_MEMBER      TXTMBR
     C                   CALL      'QCMDEXC'
     C                   PARM                    TEXT
     C                   PARM      50            LEN              15 5
 
     C                   MOVEL     *BLANKS       TXTMSG
     C                   MOVEL     CMD(2)        TXTMSG
     C                   MOVEL     I_MEMBER      TXTMBR
     C                   CALL      'QCMDEXC'
     C                   PARM                    TEXT
     C                   PARM      50            LEN              15 5
 
     C                   OPEN      FFACMVD
     C                   OPEN      MEMOSM
 
     C                   ENDIF
 
      ** Access SAR details file to determine if CAP205 is ON.                                CAP205
                                                                                              CAP205
     C                   EVAL      CAP205 = 'N'                                               CAP205
     C                   CALLB     'AOSARDR0'                                                 CAP205
     C                   PARM      *BLANKS       @RTCD                                        CAP205
     C                   PARM      '*VERIFY'     @OPTN                                        CAP205
     C                   PARM      'CAP205'      @SARD                                        CAP205
      *                                                                                       CAP205
     C                   IF        @RTCD = *BLANKS                                            CAP205
     C                   EVAL      CAP205 = 'Y'                                               CAP205
     C                   ENDIF                                                                CAP205
                                                                                              CAP205
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
** CMD
OVRDBF FILE(FFACMVD) MBR(   )
OVRDBF FILE(MEMOSM)  MBR(   )
