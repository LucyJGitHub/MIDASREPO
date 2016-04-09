     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Reverse Sweeping/Target Balancing List')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100503  - Reverse Sweeping/Target Balancing List           *
      *                                                               *
      *  Function: This module lists the Reverse Sweeping/Target      *
      *            Balancing.                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 212367             Date 10Dec02               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  212367 - Various reporting errors                            *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *  84 - No find for Chain to ACCNT                              *
      *  86 - No find for Chain to RECMHDL0                           *
      *  87 - No find for Chain to GLPSTTL0                           *
      *  88 - End of file for RERSTIL0                                *
      *  89 - End of file for RERSTDL2                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRInit    - Initialisation                                    *
      * SRProcess - Detail processing                                 *
      * SRDetails - Subroutine to retrieve the Items and Details      *
      * SRSetHdr  - Subroutine to Set the Report Fields for the header*
      * SRSetRDtls- Subroutine to Set the report fields for the detail*
      * SRPrint   - Write the Report                                  *
      * SRRCFP1   - Detail Spool File recorded by RCF                 *
      * SRRCFAU   - Detail Spool File recorded by RCF                 *
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
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** RE Reverse Sweeping/Target Balancing - Details
     FRERSTDL2  IF   E           K DISK    INFSR(*PSSR)
 
      ** RE Reverse Sweeping/Target Balancing - Items
     FRERSTIL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** RE Cash Management hierarchy Details
     FRECMHDL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** GL Postings in Transit
     FGLPSTTL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Accounts master file
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
 
      ** RE Reverse Sweeping/Target Balancing List - Audit
     FRE100503AUO    E             PRINTER
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
      ** RE Reverse Sweeping/Target Balancing List
     FRE100503P1O    E             PRINTER
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
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
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Externally described DS for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** File Information Data Structure for RE100503P1
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
     D  OflLn1               188    189B 0
     D  PrtLn1               367    368B 0
 
      ** File Information Data Structure for RE100503AU
     D SPOOLU          DS
     D  PSFileU               83     92
     D  PSFNumU              123    124B 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PLevel          S              1
     D PEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1
 
      ** Parameters of ZDATE2
     D PDateIn         S              5  0
     D PDatFmt         S              1
     D PDateOut6       S              6  0
     D PDateOut7       S              7
 
      ** Parameters for ZSEDIT
     D PZFld15         S             15  0
     D PZDECS          S              1  0
     D PZECode         S              1
     D PZOut21         S             21
 
      ** Parameters for access object programs
     D PRTCD           S              7
     D POPTN           S              7
     D PCcy            S              3
 
     D WkCNUM          S              6
     D***WkACOD*         S              4                                                     CGL029
     D WkACOD          S             10                                                       CGL029
     D WkACSQ          S              2
 
      ** Key fields
     D KHierID         S              9  0
     D KLinkID         S              9  0
     D KPrDate         S              5  0
     D KSeqNum         S              2  0
     D KXRFI           S              3
     D*KCust****       S              6  0                                                    CSD027
     D KCust           S              6                                                       CSD027
     D KCurr           S              3
     D***KACode*         S              4  0                                                  CGL029
     D KACode          S             10  0                                                    CGL029
     D KASeqN          S              2  0
     D KBranch         S              3
 
     D RqdLn1          S              3P 0
     D DifLn1          S              4P 0
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C                   EXSR      SRInit
 
     C                   EXSR      SRProcess
 
     C                   EVAL      *INLR = *On
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInit - Initialisation                                       *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls:     SRRCFP1, SRRCFAU                                   *
      *                                                               *
      *****************************************************************
 
     C     SRINIT        BEGSR
 
      ** RCF Processing for Printer File.
 
     C                   EXSR      SRRCFP1
 
      ** RCF Processing for Printer File.
 
     C                   EXSR      SRRCFAU
 
     C                   EVAL      RqdLn1 = *Zeros
     C                   EVAL      DifLn1 = *Zeros
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProcess - Detail Processing                                 *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls:     SRAudit; SRSetHdr; SRDetails                       *
      *                                                               *
      *****************************************************************
 
     C     SRProcess     BEGSR
 
     C     *HIVAL        SETLL     RERSTDL2
     C                   READ      RERSTDL2                               89
 
      ** If File is empty, write the audit report
 
     C                   IF        *IN89 = *On
     C                   EXSR      SRAudit
     C                   ELSE
     C                   WRITE     HeadP1
     C                   ENDIF
 
      ** Read through the file
 
     C                   DOW       *IN89 = *Off
 
      ** Set up the report fields for the header
 
     C                   EXSR      SRSetHdr
 
      ** Set up Key Fields
 
     C                   EVAL      KHierID = RDHIER
     C                   EVAL      KLinkID = RDLINK
     C                   EVAL      KPrDate = RDPRCD
     C                   EVAL      KSeqNum = RDSNUM
 
      ** Retrieve the items and details
 
     C                   EXSR      SRDetails
 
      ** Read next Stop Number
 
     C                   READ      RERSTDL2                               89
 
      ** Write the End of the report
 
     C                   IF        *IN89 = *On
     C                   EVAL      RqdLn1 = 3
     C                   EVAL      DifLn1 = OflLn1 - PrtLn1
     C                   IF        DifLn1 < RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
     C                   WRITE     TRAILP1
     C                   ELSE
     C                   EVAL      RqdLn1 = 2
     C                   EVAL      DifLn1 = OflLn1 - PrtLn1
     C                   IF        DifLn1 > RqdLn1
     C                   WRITE     SEPLINE
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDetails - Subroutine to retrieve the Items and Details      *
      *                                                               *
      * Called by: SRProcess                                          *
      *                                                               *
      * Calls:     SRSetRDtls; SRPrint                                *
      *                                                               *
      *****************************************************************
 
     C     SRDetails     BEGSR
 
     C     KRvSwDtls     SETLL     RERSTIL0
     C     KRvSwDtls     READE     RERSTIL0                               88
 
     C                   DOW       *IN88 = *Off
 
     C     KZPstTrns     CHAIN     GLPSTTL0                           87
 
      ** If Record is found, print the report
 
     C                   IF        *IN87 = *Off
     C                   EXSR      SRSetRDtls
     C                   EXSR      SRPrint
     C                   ENDIF
 
      ** Read the next Item
 
     C     KRvSwDtls     READE     RERSTIL0                               88
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSetHdr - Subroutine to Set the Report Fields for the Header *
      *                                                               *
      * Called by: SRProcess                                          *
      *                                                               *
      * Calls:     AOCURRR0; ZDATE2                                   *
      *                                                               *
      *****************************************************************
 
     C     SRSetHdr      BEGSR
 
      ** Set the number of decimal places
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      RDCCCY        PCCY
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *Blanks
     C                   EVAL      X_ERMS = 'BAD CURRENCY:' + PCCY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      PZDECS = A6NBDP
 
      ** Link ID
 
     C                   MOVE      RDLINK        RLINK
 
      ** Hierarchy Shortname and Description
 
     C                   EVAL      RHISN = RDHISN
 
     C     RDHIER        CHAIN     RECMHDL0                           86
 
     C                   IF        *IN86 = *On
     C                   MOVEL     RDHIER        DBKEY
     C                   EVAL      X_ERMS = 'BAD HIERARCHY DETAIL:' + DBKEY
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      RDESC = CDDESC
     C                   ENDIF
 
      ** Sequence Number
 
     C                   MOVE      RDSNUM        RSEQNM
 
      ** Processing Date
 
     C                   EVAL      PDateIn = RDPRCD
 
     C                   CALL      'ZDATE2'
     C                   PARM                    PDateIn
     C                   PARM                    PDatFmt
     C                   PARM                    PDateOut6
     C                   PARM                    PDateOut7
 
     C                   EVAL      RPDATE = PDateOut7
 
      ** Child Account
 
     C                   MOVE      RDCCUS        WkCNUM
     C                   MOVE      RDCACD        WkACOD
     C                   MOVE      RDCASN        WkACSQ
     C                   EVAL      RCACNT = RDCBRC + '-' + WkCNUM + '-' +
     C                             RDCCCY + '-' + WkACOD + '-' + WkACSQ
 
     C                   EVAL      KCust   = RDCCUS
     C                   EVAL      KCurr   = RDCCCY
     C                   EVAL      KACode  = RDCACD
     C                   EVAL      KASeqN  = RDCASN
     C                   EVAL      KBranch = RDCBRC
     C     KAccnt        CHAIN     ACCNTABF                           84
     C                   IF        *IN84 = *On
     C                   EVAL      X_ERMS = 'BAD CHILD ACCOUNT:' + RCACNT
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      ACNO          RCRANO
     C                   ENDIF
 
      ** Parent Account
 
     C                   MOVE      RDPCUS        WkCNUM
     C                   MOVE      RDPACD        WkACOD
     C                   MOVE      RDPASN        WkACSQ
     C                   EVAL      RPACNT = RDPBRC + '-' + WkCNUM + '-' +
     C                             RDPCCY + '-' + WkACOD + '-' + WkACSQ
 
     C                   EVAL      KCust   = RDPCUS
     C                   EVAL      KCurr   = RDPCCY
     C                   EVAL      KACode  = RDPACD
     C                   EVAL      KASeqN  = RDPASN
     C                   EVAL      KBranch = RDPBRC
     C     KAccnt        CHAIN     ACCNTABF                           84
     C                   IF        *IN84 = *On
     C                   EVAL      X_ERMS = 'BAD PARENT ACCOUNT:' + RPACNT
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      ACNO          RPRANO
     C                   ENDIF
 
      ** Print Header
 
     C                   EVAL      RqdLn1 = 10
     C                   EVAL      DifLn1 = OflLn1 - PrtLn1
     C                   IF        DifLn1 < RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
     C                   WRITE     HEADP2
     C                   WRITE     SUBHDR
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSetRDtls - Subroutine to Set the report fields for the      *
      *              Details                                          *
      *                                                               *
      * Called by: SRDetails                                          *
      *                                                               *
      * Calls:     ZDATE2; ZSEDIT                                     *
      *                                                               *
      *****************************************************************
 
     C     SRSetRDtls    BEGSR
 
      ** Value Date
 
     C                   EVAL      PDateIn = VALD
 
     C                   CALL      'ZDATE2'
     C                   PARM                    PDateIn
     C                   PARM                    PDatFmt
     C                   PARM                    PDateOut6
     C                   PARM                    PDateOut7
 
     C                   EVAL      RVALD = PDateOut7
 
      ** Narrative
 
     C                   EVAL      RNARR = PNAR
 
      ** Posting Amount
 
     C                   EVAL      PZFld15 = PSTA
 
     C                   CALL      'ZSEDIT'
     C                   PARM                    PZFld15
     C                   PARM                    PZDECS
     C                   PARM      'J'           PZECode
     C                   PARM      *Blanks       PZOut21
 
     C                   EVAL      RAMNT = PZOut21
 
      ** Debit/Credit
 
     C                   IF        DRCR = 0
     C                   EVAL      RDRCR = 'DR'
     C                   ELSE
     C                   EVAL      RDRCR = 'CR'
     C                   ENDIF
 
      ** Account No.
 
     C                   MOVE      CNUM          WkCNUM
     C                   MOVE      ACOD          WkACOD
     C                   MOVE      ACSQ          WkACSQ
     C                   EVAL      RACCNT = BRCA + '-' + WkCNUM + '-'           212367
     C                             + CCY + '-' + WkACOD + '-' + WkACSQ          212367
     C                   MOVE      ACNO          RRACNO                         212367
     C*******************EVAL      RACCNT = WkCNUM + '-' + CCY + '-' +          212367
     C*******************          WkACOD + '-' + WkACSQ                        212367
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPrint - Write the Report                                    *
      *                                                               *
      * Called by: SRDetails                                          *
      *                                                               *
      * Calls:     None                                               *
      *                                                               *
      *****************************************************************
 
     C     SRPrint       BEGSR
 
      ** Write the header
 
     C                   EVAL      RqdLn1 = 2
     C                   EVAL      DifLn1 = OflLn1 - PrtLn1
     C                   IF        DifLn1 < RqdLn1
     C                   WRITE     HEADP1
     C                   WRITE     SUBHDR
     C                   ENDIF
 
      ** Write out the Detail
 
     C                   WRITE     DETAIL1
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRCFP1 - Detail Spool File recorded by RCF                   *
      *                                                               *
      * Called by: SRInit                                             *
      *                                                               *
      * Calls: ZSFILE                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRRCFP1       BEGSR
 
     C                   EVAL      ZSnum = PSFNum1
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFile1
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSErr
 
      ** If Error occurs during ZSFILE processing, then end abnormally
 
     C                   IF        ZSErr = 'Y'
     C                   EVAL      X_ERMS = 'Call to ZSFILE in error'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRCFAU - Detail Spool File recorded by RCF                   *
      *                                                               *
      * Called by: SRInit                                             *
      *                                                               *
      * Calls: ZSFILE                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRRCFAU       BEGSR
 
     C                   EVAL      ZSnum = PSFNumU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFileU
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSerr
 
      ** If Error occurs during ZSFILE processing, then end abnormally
 
     C                   IF        ZSErr = 'Y'
     C                   EVAL      X_ERMS = 'Call to ZSFILE in error'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAudit- Subroutine to Output Audit Report                    *
      *                                                               *
      * Called by: SRProcess                                          *
      *                                                               *
      * Calls:     None                                               *
      *                                                               *
      *****************************************************************
 
     C     SRAudit       BEGSR
 
      ** Output Report Header and File Controls.
 
     C                   Write     HEADAU
 
      ** Output "No Details" message.
 
     C                   Write     NODTLS
 
      **  End program
 
     C                   EVAL      *INLR = *On
     C                   Return
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PSeq
     C                   PARM                    PLevel
     C                   PARM                    PEnty
 
     C/COPY ZACPYSRC,DBFIELDS
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      X_ERMS = 'Call to AOBANKR0 in error'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Key Lists
 
     C     KRvSwDtls     KLIST
     C                   KFLD                    KHierID
     C                   KFLD                    KLinkID
     C                   KFLD                    KPrDate
     C                   KFLD                    KSeqNum
 
     C     KZPstTrns     KLIST
     C                   KFLD                    KXRFI
     C                   KFLD                    RIXRFN
 
     C     KAccnt        KLIST
     C                   KFLD                    KCust
     C                   KFLD                    KCurr
     C                   KFLD                    KACode
     C                   KFLD                    KASeqN
     C                   KFLD                    KBranch
 
     C                   EVAL      KXRFI = 'ZS'
 
     C                   ENDSR
 
      *****************************************************************
      /COPY ZACPYSRC,RECMPSSR
