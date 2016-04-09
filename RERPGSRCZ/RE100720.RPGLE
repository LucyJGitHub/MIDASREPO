     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Create Group Account Cleared Balances')       *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100720  - Create Group Account Cleared Balances File       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. AR679670           Date 26Nov10               *
      *  Prev Amend No. AR676213           Date 19Nov10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR679670 - Apply fix 255837                                  *
      *  255837 - Fix overdraft validation.  Correct calculation of   *
      *           GCICCB                                              *
      *  AR676213 - Incorrect definition of CLGLAI field (Recompile)  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *     86        No find on chain to REGACBL0                    *
      *     87        No find on chain to MEMOSL1                     *
      *     88        End of file for RECMHLL2                        *
      *     89        End of file for REGAHDPD                        *
      *                                                               *
      *     LR        Last Record Indicator (Program Termination)     *
      *     U7 and U8 DB Error Processing Indicator                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRProcess - Subroutine to update the cleared balances on file *
      * SRAudit   - Subroutine to Output Audit Report                 *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
 
      ** RE Group Accont Hierarchy Details
     FREGAHDPD  IF   E             DISK    INFSR(*PSSR)
 
      ** RE Cash Management Hierarchy Links by Level
     FRECMHLL2  IF   E           K DISK    INFSR(*PSSR)
 
      ** RE Shadow Balances
     FMEMOSL1   IF   E           K DISK    INFSR(*PSSR)
 
      ** RE Group Account (Inter-Company) Cleared Balances
     FREGACBL0  UF A E           K DISK    INFSR(*PSSR)
 
      ** RE Create Group Account Cleared Balances File - Audit
     FRE100720AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
      ** Cash Management Hierarchy Links
     D O_CMHL        E DS                  EXTNAME(RECMHLPD)
     D                                     PREFIX(O_)
     D A_HIER                  1      9
     D A_LINK                 10     18
      ** Zero Balancing/Sweeping Hierarchy Links
     D O_ZSHL        E DS                  EXTNAME(REZSHLPD)
     D                                     PREFIX(O_)
      ** Group Account Hierarchy Links
     D O_GAHL        E DS                  EXTNAME(REGAHLPD)
     D                                     PREFIX(O_)
 
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
      ** File Information Data Structure for RE100720AU
     D SPOOLU          DS
     D  PSFileU               83     92
     D  PSFNumU              123    124B 0
 
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PEnty           S              3
     D ZSnum           S              6  0
     D ZSerr           S              1
 
 
      ** Key Fields
     D KPBrnch         S              3
     D*KPCust***       S              6  0                                                    CSD027
     D KPCust          S              6                                                       CSD027
     D KPCurr          S              3
     D***KPACode         S              4  0                                                  CGL029
     D KPACode         S             10  0                                                    CGL029
     D KPASeq          S              2  0
     D*KCCust***       S              6  0                                                    CSD027
     D KCCust          S              6                                                       CSD027
     D KCCurr          S              3
     D***KCACde*         S              4  0                                                  CGL029
     D KCACde          S             10  0                                                    CGL029
     D KCASeq          S              2  0
     D KCBrnc          S              3
 
     D WPEffClrBal     S             17  0
     D WCEffClrBal     S             17  0
 
 
      /SPACE 5
 
 
      ** Initialize Counters
 
     C                   EVAL      RCNINS = *ZEROS
     C                   EVAL      RCNAMD = *ZEROS
 
      ** Read all records
 
     C                   READ      REGAHDPD                               89
 
     C                   DOW       *IN89 = *OFF
 
      ** Access record in RECMHLL2
 
     C     GDHIER        SETLL     RECMHLL2
     C     GDHIER        READE     RECMHLL2                               88
 
     C                   DOW       *IN88 = *OFF
 
      * Access Hierarchy Link
 
     C                   EXSR      ACS_LINK
 
      ** Set up Key Fields
 
     C                   EVAL      KPBrnch = CLPBRC
     C                   EVAL      KPCust  = CLPCUS
     C                   EVAL      KPCurr  = CLPCCY
     C                   EVAL      KPACode = CLPACD
     C                   EVAL      KPASeq  = CLPASN
     C                   EVAL      KCCust  = CLCCUS
     C                   EVAL      KCCurr  = CLCCCY
     C                   EVAL      KCACde  = CLCACD
     C                   EVAL      KCASeq  = CLCASN
     C                   EVAL      KCBrnc  = CLCBRC
 
     C                   EXSR      SRProcess
 
     C     GDHIER        READE     RECMHLL2                               88
     C                   ENDDO
 
     C                   READ      REGAHDPD                               89
     C                   ENDDO
 
     C                   EXSR      SRAudit
 
      ** End Program
 
     C                   EVAL      *INLR = *On
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SRProcess - Subroutine to update the cleared balance on file  *
      *****************************************************************
     C     SRProcess     BEGSR
 
      ** Initialize the Effective Cleared Balance for the Child Account
 
     C                   EVAL      WCEffClrBal = *Zeros
 
      ** Ignore Record if the 'Balance Available for Inter Company
      ** Overdraft Indicator' is not 'Y' or if the Child Account
      ** Category is 'T'
 
     C                   SELECT
     C                   WHEN      O_GLBAIC <> 'Y' or CLCCAT = 'T'
     C                   GOTO      EndProc
 
      ** If the Category of the Child Account is Sub account
 
     C                   WHEN      CLCCAT = 'S'
     C     KChldAccnt    CHAIN     MEMOSL1                            87
     C                   IF        *IN87 = *Off
     C**********         EVAL      WCEffclrBal = CLBLN                                        255837
     C                   EVAL      WCEffclrBal = CLBLN - O_GLICTB                             255837
     C                   ENDIF
 
     C                   OTHER
     C*****KPrntAccnt    CHAIN     REGACBL0                           86                      255837
     C     KChldAccnt2   CHAIN     REGACBL0                           86                      255837
                                                                                              255837
     C                   IF        *IN86 = *Off
     C                   EVAL      WCEffclrBal = GCICCB
     C                   ENDIF
     C                   ENDSL
 
      ** Initialize the Effective Cleared Balance for the Parent Account
 
     C                   EVAL      WPEffClrBal = *Zeros
 
      ** Get the Cleared Balance for the Parent Account
 
     C     KPrntAccnt    CHAIN     REGACBL0                           85
 
      ** Update or write the Record where the cleared balance will equal to
      ** the currenct effective cleared balance of the parent account
      ** plus the effective cleared balance of the child account
 
     C                   IF        *IN85 = *Off
     C                   EVAL      WPEffClrBal = GCICCB
     C                   EVAL      GCICCB = WPEffClrBal + WCEffClrBal
     C                   UPDATE    REGACBD0
     C                   EVAL      RCNAMD = RCNAMD + 1
     C                   ELSE
     C                   EVAL      GCBRCA = KPBrnch
     C                   EVAL      GCCNUM = KPCust
     C                   EVAL      GCCCY  = KPCurr
     C                   EVAL      GCACOD = KPACode
     C                   EVAL      GCACSQ = KPASeq
     C                   EVAL      GCICCB = WPEffClrBal + WCEffClrBal
     C                   WRITE     REGACBD0
     C                   EVAL      RCNINS = RCNINS + 1
     C                   ENDIF
 
     C     EndProc       ENDSR
      *****************************************************************
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
     C                   PARM      CLHIER        I_HIER            9 0
      * Hierarchy Type
     C                   PARM      'GA'          I_HTYP            2
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
     C                   PARM      CLCACD        I_CACD           10 0                        CGL029
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
      *****************************************************************
      * SRAudit - Write the Audit Report                              *
      *****************************************************************
     C     SRAudit       BEGSR
 
      ** Ensure Detail Spool File recorded by RCF.
 
     C                   EVAL      ZSnum = PSFNumU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFileU
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSErr
 
      ** If Error occurs during ZSFILE processing, then end abnormally
 
     C                   IF        ZSErr = 'Y'
     C                   EVAL      X_ERMS = 'Call to ZSFILE in error'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   WRITE     HEADAU
     C                   WRITE     HASRUN
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C/COPY ZACPYSRC,DBFIELDS
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Key List for Child Account
 
     C     KChldAccnt    KLIST
     C                   KFLD                    KCCust
     C                   KFLD                    KCCurr
     C                   KFLD                    KCACde
     C                   KFLD                    KCASeq
     C                   KFLD                    KCBrnc
 
      ** Key List for Parent Account
 
     C     KPrntAccnt    KLIST
     C                   KFLD                    KPBrnch
     C                   KFLD                    KPCust
     C                   KFLD                    KPCurr
     C                   KFLD                    KPAcode
     C                   KFLD                    KPASeq
 
     C     KChldAccnt2   KLIST                                                                255837
     C                   KFLD                    KCBrnc                                       255837
     C                   KFLD                    KCCust                                       255837
     C                   KFLD                    KCCurr                                       255837
     C                   KFLD                    KCACde                                       255837
     C                   KFLD                    KCAseq                                       255837
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      ********************************************************************
