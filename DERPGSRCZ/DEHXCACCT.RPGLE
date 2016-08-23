     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Hist Ext Ctlr for Accounts')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Data Extract module                                  *
      *                                                               *
      *  DEHXCACCT - Historic Extract Controller for Accounts         *
      *                                                               *
      *  Function:  This module controls the extraction of Retail     *
      *             Accounts for the analysis of revenue within       *
      *             CCRM. It may run in two modes, the first will     *
      *             extract a single Retail Account as defined in     *
      *             an input parameter. The second will extract all   *
      *             Retail Accounts on File.                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CDE003             Date 11Dec02               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002  *CREATE    Date 05Dec00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CDE003 - Data Export - MCR Limits Phase II (Recompiled)      *
      *  208221 - Enable DEWRKEDTA to get info from data area         *
      *  CDE002 - Data Export - CCRM Revenue Analysis.                *
      *                                                               *
      *****************************************************************
 
      ** RE Retail Accounts File
     FACCNT     IF   E           K DISK
     F                                     PREFIX(AC_)
 
      ** RE Retail History Header Records
     FREHISBL   IF   E           K DISK
     F                                     PREFIX(BL_)
 
      ** DE Accounts Codes to be extracted
     FDEACEXPD  IF   E             DISK
     F
      *****************************************************************
      *
      ** Acount Code and Account description arrays
     D***ACC****         S              4  0 DIM(9999)                                        CGL029
     D ACC             S             10  0 DIM(9999)                                          CGL029
     D ACD             S             25    DIM(9999)
      *
      ** Report by Assoc. Cust. and Select by Postings Arrays
     D ACR             S              1    DIM(9999)
     D ACS             S              1    DIM(9999)
     D
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
     D PeriodEDT     E DS                  EXTNAME(DEPPERDPD)
 
     D ACCNTX        E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(AC_)
 
     D REHISBLX      E DS                  EXTNAME(REHISPD)
     D                                     PREFIX(BL_)
 
     D***I#TREF***       DS            20                                                     CGL029
     D***W#ACCT***               1     18                                                     CGL029
     D I#TREF          DS            26                                                       CGL029
     D W#ACCT                  1     24                                                       CGL029
     D W#BRCA                  1      3
     D*W#CNUM***               4      9  0                                                    CSD027
     D W#CNUM                  4      9A                                                      CSD027
     D W#CCY                  10     12
     D***W#ACOD***              13     16  0                                                  CGL029
     D***W#ACSQ***              17     18  0                                                  CGL029
     D W#ACOD                 13     22  0                                                    CGL029
     D W#ACSQ                 23     24  0                                                    CGL029
 
      *
     D K#BRCA          S              3
     D*K#CNUM***       S              6S 0                                                    CSD027
     D K#CNUM          S              6A                                                      CSD027
     D K#CCY           S              3
     D***K#ACOD***       S              4S 0                                                  CGL029
     D K#ACOD          S             10S 0                                                    CGL029
     D K#ACSQ          S              2S 0
      *
      ** Work parameters
     D PRepAsCus       S              1A
     D PSelPos         S              1A
      ********************************************************************
      * MAIN PROCESSING
      ********************************************************************
 
     C                   EXSR      XCINIT
 
     C                   EXSR      XCMAIN
 
     C/SPACE 5
      ********************************************************************
      * INITIAL PROCESSING
      ********************************************************************
     C     XCINIT        BEGSR
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUTS
     C                   PARM                    I#EXTT            4
     C                   PARM                    I#EOB             1
     C**********         PARM                    I#TREF           20                          CGL029
     C                   PARM                    I#TREF                                       CGL029
      *
      * This is an historic extract                                                           208221
                                                                                              208221
     C                   MOVE      'H'           I#PH                                         208221
                                                                                              208221
      * Get Extract control information                                                       208221
                                                                                              208221
      /COPY DECPYSRC,DEXTGTCT                                                                 208221
                                                                                              208221
     C************       CALLB     'DEGETEXCT'                                                208221
     C************       PARM                    I#RTCD            7            * RETURN CODE 208221
     C************       PARM                    I#ERMS           30            * ERROR MESSAG208221
      ************                                                                            208221
      **INPUTS****                                                                            208221
     C************       PARM      'H'           Proj_Hist         1                          208221
     C************       PARM      I#EOB         EndofBook         1                          208221
      **OUTPUTS***                                                                            208221
     C************       PARM      *Zeros        Run_Date          5 0                        208221
     C************       PARM      *Zeros        Date_NWD          5 0                        208221
      ************                                                                            208221
     C************       PARM      *Zeros        HistCO_Dat        5 0                        208221
     C************       PARM      *Zeros        EvtCtl_Dat        5 0                        208221
     C************       PARM      *Zeros        ProjCO_Dat        5 0                        208221
      ************                                                                            208221
     C************       PARM                    PeriodEDT                                    208221
      *
      ** Load all account codes to be extracted
     C     1             SETLL     DEACEXPD                               89
     C                   READ      DEACEXPD                               89
     C                   Z-ADD     0             A#ACN             4 0
     C*
     C** Do while records found
     C                   DOW       *IN89 = *Off
     C                   IF        A5IRVE = 'Y'
     C                   ADD       1             A#ACN
     C*
     C** Store account code and account description for later use
     C                   MOVE      A5ACCD        ACC(A#ACN)
     C                   MOVEL     A5ACCN        ACD(A#ACN)
      *
      ** Move Report by Associated Customer and Select Postings flags in arrays
      *
     C                   MOVE      A5ASOC        ACR(A#ACN)
     C                   MOVE      A5SELP        ACS(A#ACN)
     C                   ENDIF
     C                   READ      DEACEXPD                               89
     C                   ENDDO
     C
     C                   ENDSR
     C
     C/SPACE 5
      ********************************************************************
      * MAIN PROCESSING
      ********************************************************************
     C     XCMAIN        BEGSR
      *
      ** Extract all details or single details depending on Input Parameter
     C                   IF        I#EXTT = '*ALL'
     C                   EXSR      EXALL
     C*
     C                   ELSE
     C                   EXSR      EXSIN
     C*
     C                   ENDIF
     C
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * EXTRACT *ALL PROCESSES
      ********************************************************************
     C     EXALL         BEGSR
     C**********         Z-ADD     0             AC_CNUM                                      CSD027
     C                   EVAL      AC_CNUM = *BLANKS                                          CSD027
     C                   Z-ADD     0             AC_ACSQ
     C                   Z-ADD     0             AC_ACOD
     C                   MOVE      *Blanks       AC_CCY
     C                   MOVE      *Blanks       AC_BRCA
      *
     C                   READ      ACCNT                                  89
      *
      * Process while Retail History Header records found
      *
     C                   DOW       *IN89 = *Off
     C                   IF        AC_RECI = 'D' or AC_RECI = 'C'
      *
      ** Check if Account code is stored in array
     C                   Z-ADD     1             X                 4 0
     C     AC_ACOD       LOOKUP    ACC(X)                                 88
      *
      ** If found extract Record
     C                   IF        *IN88 = *On
     C                   MOVE      ACD(X)        I#ACCD
     C                   MOVE      ACR(X)        PRepAsCus
     C                   MOVE      ACS(X)        PSelPos
     C                   EXSR      PRSPEC
     C                   ENDIF
     C                   ENDIF
     C                   READ      ACCNT                                  89    *
     C                   ENDDO
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * EXTRACT SINGLE PROCESS
      ********************************************************************
     C     EXSIN         BEGSR
      *
      * Set up Keylist
     C
     C     K#ACCT        KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#CCY
     C                   KFLD                    K#ACOD
     C                   KFLD                    K#ACSQ
     C                   KFLD                    K#BRCA
     C
     C                   EVAL      K#CNUM = W#CNUM
     C                   EVAL      K#CCY = W#CCY
     C                   EVAL      K#ACOD = W#ACOD
     C                   EVAL      K#ACSQ = W#ACSQ
     C                   EVAL      K#BRCA = W#BRCA
     C
      *
      * Access ACCNT Using Key List
      *
     C
     C     K#ACCT        CHAIN     ACCNT                              89
      *
     C                   IF        *IN89 = *Off
      *
      ** Check if Account code is stored in array
     C                   Z-ADD     1             X                 4 0
     C     AC_ACOD       LOOKUP    ACC(X)                                 88
      *
      ** If found extract Record
     C                   IF        *IN88 = *On
     C                   MOVE      ACD(X)        I#ACCD
     C                   MOVE      ACR(X)        PRepAsCus
     C                   MOVE      ACS(X)        PSelPos
     C                   EXSR      PRSPEC
     C                   ENDIF
     C                   ENDIF
     C
     C                   ENDSR
      *
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Process Specific Extract
      ********************************************************************
     C     PRSPEC        BEGSR
      *
      ** Process Retail accounts
     C                   IF        AC_ATYP = 'R'
     C
     C                   EVAL      K#BRCA = AC_BRCA
     C                   EVAL      K#CNUM = AC_CNUM
     C                   EVAL      K#CCY = AC_CCY
     C                   EVAL      K#ACOD = AC_ACOD
     C                   EVAL      K#ACSQ = AC_ACSQ
      *
     C     K#ACCR        KLIST
     C                   KFLD                    K#BRCA            3
     C**********         KFLD                    K#CNUM            6 0                        CSD027
     C                   KFLD                    K#CNUM            6                          CSD027
     C                   KFLD                    K#CCY             3
     C**********         KFLD                    K#ACOD            4 0                        CGL029
     C                   KFLD                    K#ACOD                                       CGL029
     C                   KFLD                    K#ACSQ            2 0
     C
      *
      ** Check for Opening Balance Record
     C     K#ACCR        CHAIN     REHISBL                            89
 
     C                   IF        *IN89 = *Off
     C                   CALLB     'DEHXTACCR'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUTS
     C                   PARM      'I'           I#ACTN            1
     C                   PARM                    I#EXTT            4
     C*************      PARM      Proj_Hist     I#PH              1                          208221
     C                   PARM                    I#PH              1                          208221
     C                   PARM                    I#EOB             1
     C*************      PARM                    Run_Date          5 0                        208221
     C*************      PARM                    Date_NWD          5 0                        208221
     C*************      PARM                    HistCO_Dat        5 0                        208221
     C                   PARM                    I#RDNB                                       208221
     C                   PARM                    I#DNWD                                       208221
     C                   PARM                    I#HCOD                                       208221
     C                   PARM      *ZERO         Extrct_Dat        5 0
     C*************      PARM                    EvtCtl_Dat        5 0                        208221
     C*************      PARM                    ProjCO_Dat        5 0                        208221
     C                   PARM                    I#EVCD                                       208221
     C                   PARM                    I#PCOD                                       208221
     C                   PARM                    PeriodEDT
     C                   PARM                    I#ACCD           25
     C                   PARM                    ACCNTX
     C                   PARM                    REHISBLX
     C                   PARM                    Dataarea                                     208221
 
      *
      ** Write record to error log if error returned.
     C                   IF        I#RTCD = '*ERROR'
     C                   EXSR      XCWRITE
     C                   ENDIF
 
     C                   ENDIF
     C                   ELSE
     C                   CALLB     'DEHXTACCT'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUTS
     C                   PARM      'I'           I#ACTN            1
     C                   PARM                    I#EXTT            4
     C*************      PARM      Proj_Hist     I#PH              1                          208221
     C                   PARM                    I#PH              1                          208221
     C                   PARM                    I#EOB             1
     C*************      PARM                    Run_Date          5 0                        208221
     C*************      PARM                    Date_NWD          5 0                        208221
     C*************      PARM                    HistCO_Dat        5 0                        208221
     C                   PARM                    I#RDNB                                       208221
     C                   PARM                    I#DNWD                                       208221
     C                   PARM                    I#HCOD                                       208221
     C                   PARM      *ZERO         Extrct_Dat        5 0
     C*************      PARM                    EvtCtl_Dat        5 0                        208221
     C*************      PARM                    ProjCO_Dat        5 0                        208221
     C                   PARM                    I#EVCD                                       208221
     C                   PARM                    I#PCOD                                       208221
     C                   PARM                    PeriodEDT
     C                   PARM                    I#ACCD           25
     C                   PARM                    ACCNTX
     C                   PARM                    PRepAsCus
     C                   PARM                    PSelPos
     C                   PARM                    Dataarea                                     208221
      *
      ** Write record to error log if error returned.
     C                   IF        I#RTCD = '*ERROR'
     C                   EXSR      XCWRITE
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Write Error Log
      ********************************************************************
     C     XCWRITE       BEGSR
      * If data error encountered, log error
 
     C     I#RTCD        IFEQ      '*ERROR '
     C                   CLEAR                   BUFFER
     C*******************EVAL      BUFFER = Proj_hist + 'ACCT' + I#EXTT                       208221
     C                   EVAL      BUFFER = I#PH + 'ACCT' + I#EXTT                            208221
     C                             + W#ACCT + '  ' + I#RTCD + I#ERMS
     C                             + ACCNTX
     C                   CALLB     'DEWRTELOG'
     C                   PARM                    BUFFER         4000
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
