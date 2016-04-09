     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Zero-Balancing Stops List')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100502  - Zero-Balancing Stops List                        *
      *                                                               *
      *  Function: This module lists the Zero Balancing Stops.        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. BUG28077           Date 26Aug10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 212349             Date 07Jan03               *
      *                 212367             Date 10Dec02               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG28077 - Parent account code field was not updated to 10S. *
      *             (Recompile)                                       *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  212349 - Problems with stopped sweeps                        *
      *  212367 - Various reporting errors                            *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *  87 - No find for Chain to GLPSTTL0                           *
      *  88 - End of file for REZSTIL0                                *
      *  89 - End of file for REZSTDL3                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRInit    - Initialisation                                    *
      * SRProcess - Detail processing                                 *
      * SrRtvItms - Retrieve the Items                                *
      * SrRtvOPts - Retrieve the Originating Postings                 *
      * SRSetRDtl - Set the Report Fields for the Detail Record       *
      * SRSetRPst - Set the Report Fields for a Posting               *
      * SRPrntItm - Print an Item                                     *
      * SRPrntOpt - Print an Originating Posting                      *
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
 
      ** RE Zero-Balancing Stops - Details
     FREZSTDL3  IF   E           K DISK    INFSR(*PSSR)
 
      ** RE Zero-Balancing Stops - Items
     FREZSTIL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** RE Cash Management hierarchy Details
     FRECMHDL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** GL Postings in Transit
     FGLPSTTL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Accounts master file
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas GL Postings by BRCA CNUM CCY ACOD ACSQ PSTD DRCR
     F*APOST****IF   E           K DISK    INFSR(*PSSR)                         212349
     FAPOSTL4   IF   E           K DISK    INFSR(*PSSR)                         212349
     F                                     RENAME(APOSTPDF:APOSTD0)
     F*************************************IGNORE(APOSTRAF)                     212349
 
      ** RE Zero-Balancing Stops List - Audit
     FRE100502AUO    E             PRINTER
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
      ** RE Zero-Balancing Stops List
     FRE100502P1O    E             PRINTER
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
 
      ** File Information Data Structure for RE100502P1
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
     D  OflLn1               188    189B 0
     D  PrtLn1               367    368B 0
 
      ** File Information Data Structure for RE100502AU
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
     D KProcDat        S              5  0
     D KStopNum        S              2  0
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
      * SRInit - Initialisation                                       *
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
      * SRProcess - Detail Processing                                 *
      *****************************************************************
     C     SRProcess     BEGSR
 
     C     *HIVAL        SETLL     REZSTDL3
     C                   READ      REZSTDL3                               89
 
      ** If File is empty, write the audit report
 
     C                   IF        *IN89 = *On
     C                   EXSR      SRAudit
     C                   ELSE
     C                   WRITE     PAGEHEAD
     C                   ENDIF
 
      ** Read through the file
 
     C                   DOW       *IN89 = *Off
 
      ** Set up the report fields for the detail record
 
     C                   EXSR      SRSetRDtl
 
      ** Print Detail Record
 
     C                   EVAL      RqdLn1 = 7
     C                   EVAL      DifLn1 = OflLn1 - PrtLn1
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     PAGEHEAD
     C                   ENDIF
     C                   WRITE     DETAIL
 
      ** Retrieve the items
 
     C                   EXSR      SrRtvItms
 
      ** Retrieve the originating Postings
 
     C                   EXSR      SrRtvOPts
 
      ** Read next Stop Number
 
     C                   READ      REZSTDL3                               89
 
      ** Write the End of the report
 
     C                   IF        *IN89 = *On
     C                   EVAL      RqdLn1 = 3
     C                   EVAL      DifLn1 = OflLn1 - PrtLn1
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     PAGEHEAD
     C                   ENDIF
     C                   WRITE     TRAILP1
     C                   ELSE
     C                   EVAL      RqdLn1 = 2
     C                   EVAL      DifLn1 = OflLn1 - PrtLn1
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     PAGEHEAD
     C                   ENDIF
     C                   WRITE     SEPLINE
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrRtvItms - Retrieve the Items                                *
      *****************************************************************
     C     SrRtvItms     BEGSR
 
      ** Print Item Header
 
     C                   EVAL      RqdLn1 = 4
     C                   EVAL      DifLn1 = OflLn1 - PrtLn1
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     PAGEHEAD
     C                   ENDIF
     C                   WRITE     ITEMHDR
 
      ** Set up Key Fields
 
     C                   EVAL      KHierID  = ZDHIER
     C                   EVAL      KLinkID  = ZDLINK
     C                   EVAL      KProcDat = ZDPRCD
     C                   EVAL      KStopNum = ZDSTPN
 
     C     KZBalDtls     SETLL     REZSTIL0
     C     KZBalDtls     READE     REZSTIL0                               88
 
     C                   DOW       *IN88 = *Off
 
     C     KZPstTrns     CHAIN     GLPSTTL0                           87
 
      ** If the Posting is found, print it
 
     C                   IF        *IN87 = *Off
     C                   EXSR      SRSetRPst
     C                   EXSR      SRPrntItm
     C                   ENDIF
 
      ** Read the next Item
 
     C     KZBalDtls     READE     REZSTIL0                               88
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrRtvOPts - Retrieve the Originating Postings                 *
      *****************************************************************
     C     SrRtvOPts     BEGSR
 
      ** Print Originating Posting Header
 
     C                   EVAL      RqdLn1 = 4
     C                   EVAL      DifLn1 = OflLn1 - PrtLn1
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     PAGEHEAD
     C                   ENDIF
     C                   WRITE     OPSTHDR
 
      ** Set up Key Fields
 
     C                   EVAL      BRCA = ZDCBRC
     C                   EVAL      CNUM = ZDCCUS
     C                   EVAL      CCY  = ZDCCCY
     C                   EVAL      ACOD = ZDCACD
     C                   EVAL      ACSQ = ZDCASN
     C                   EVAL      PSTD = ZDPRCD
 
     C     KAPOST        SETLL     APOSTL4                                      212349
     C     KAPOST        READE     APOSTL4                                88    212349
     C*****KAPOST********SETLL     APOST                                        212349
     C*****KAPOST********READE     APOST                                  88    212349
 
     C                   DOW       *IN88 = *Off
 
     C                   EXSR      SRSetRPst
     C                   EXSR      SRPrntOpt
 
      ** Read the next Posting
 
     C     KAPOST        READE     APOSTL4                                88    212349
     C*****KAPOST********READE     APOST                                  88    212349
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSetRDtl- Set the Report Fields for the Detail Record        *
      *****************************************************************
     C     SRSetRDtl     BEGSR
 
      ** Set the number of decimal places
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      ZDCCCY        PCCY
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *Blanks
     C                   EVAL      X_ERMS = 'BAD CURRENCY:' + PCCY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      PZDECS = A6NBDP
 
      ** Hierarchy Shortname and Description
 
     C                   EVAL      RHISN = ZDHISN
 
     C     ZDHIER        CHAIN     RECMHDL0                           86
 
     C                   IF        *IN86 = *On
     C                   MOVEL     ZDHIER        DBKEY
     C                   EVAL      X_ERMS = 'BAD HIERARCHY DETAIL:' + DBKEY
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      RDESC = CDDESC
     C                   ENDIF
 
      ** Child Account
 
     C                   MOVE      ZDCCUS        WkCNUM
     C                   MOVE      ZDCACD        WkACOD
     C                   MOVE      ZDCASN        WkACSQ
     C                   EVAL      RCACNT = ZDCBRC + '-' + WkCNUM + '-' +
     C                             ZDCCCY + '-' + WkACOD + '-' + WkACSQ
 
     C                   EVAL      KCust   = ZDCCUS
     C                   EVAL      KCurr   = ZDCCCY
     C                   EVAL      KACode  = ZDCACD
     C                   EVAL      KASeqN  = ZDCASN
     C                   EVAL      KBranch = ZDCBRC
     C     KAccnt        CHAIN     ACCNTABF                           84
     C                   IF        *IN84 = *On
     C                   EVAL      X_ERMS = 'BAD CHILD ACCOUNT:' + RCACNT
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      ACNO          RCRANO
     C                   ENDIF
 
      ** Link ID
 
     C                   MOVE      ZDLINK        RLINK
 
      ** Parent Account
 
     C                   MOVE      ZDPCUS        WkCNUM
     C**********         MOVE      ZDPACD        WkACOD                                     BUG28077
     C                   MOVE      ZDPA10        WkACOD                                     BUG28077
     C                   MOVE      ZDPASN        WkACSQ
     C                   EVAL      RPACNT = ZDPBRC + '-' + WkCNUM + '-' +
     C                             ZDPCCY + '-' + WkACOD + '-' + WkACSQ
 
     C                   EVAL      KCust   = ZDPCUS
     C                   EVAL      KCurr   = ZDPCCY
     C**********         EVAL      KACode  = ZDPACD                                         BUG28077
     C                   EVAL      KACode  = ZDPA10                                         BUG28077
     C                   EVAL      KASeqN  = ZDPASN
     C                   EVAL      KBranch = ZDPBRC
     C     KAccnt        CHAIN     ACCNTABF                           84
     C                   IF        *IN84 = *On
     C                   EVAL      X_ERMS = 'BAD PARENT ACCOUNT:' + RPACNT
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      ACNO          RPRANO
     C                   ENDIF
 
      ** Stop Number
 
     C                   MOVE      ZDSTPN        RSTPN
 
      ** Release
 
     C                   IF        ZDRELD = 'Y'
     C                   EVAL      RRELD = 'YES'
     C                   ELSE
     C                   EVAL      RRELD = 'NO '
     C                   ENDIF
 
      ** Deleted
 
     C                   IF        ZDDELD = 'Y'
     C                   EVAL      RDELD = 'YES'
     C                   ELSE
     C                   EVAL      RDELD = 'NO '
     C                   ENDIF
 
      ** Maximum Debit Value in a day
 
     C                   EVAL      PZFld15 = ZDMDVD
 
     C                   CALL      'ZSEDIT'
     C                   PARM                    PZFld15
     C                   PARM                    PZDECS
     C                   PARM      'J'           PZECode
     C                   PARM      *Blanks       PZOut21
 
     C                   EVAL      RMDVD = PZOut21
 
      ** Processing Date
 
     C                   EVAL      PDateIn = ZDPRCD
 
     C                   CALL      'ZDATE2'
     C                   PARM                    PDateIn
     C                   PARM                    PDatFmt
     C                   PARM                    PDateOut6
     C                   PARM                    PDateOut7
 
     C                   EVAL      RPRCD  = PDateOut7
     C                   EVAL      RPRCD1 = PDateOut7
     C                   EVAL      RPRCD2 = PDateOut7
 
      ** Total Debit Value
 
     C                   EVAL      PZFld15 = ZDTVDR
 
     C                   CALL      'ZSEDIT'
     C                   PARM                    PZFld15
     C                   PARM                    PZDECS
     C                   PARM      'J'           PZECODE
     C                   PARM      *Blanks       PZOut21
 
     C                   EVAL      RTVDR = PZOut21
 
      ** Maximum Debit Count
 
     C                   EVAL      RMDCD = ZDMDCD
 
      ** Total Debit Count
 
     C                   EVAL      RTCDR = ZDTCDR
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSetRPst - Set the Report Fields for a Posting               *
      *****************************************************************
     C     SRSetRPst     BEGSR
 
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
     C                   EVAL      RACCNT = BRCA + '-'  + WkCNUM + '-' + CCY
     C                             + '-' + WkACOD + '-' + WkACSQ
     C                   MOVE      ACNO          RRACNO                         212367
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRPrntItm - Print an Item                                     *
      *****************************************************************
     C     SRPrntItm     BEGSR
 
     C                   EVAL      RqdLn1 = 1
     C                   EVAL      DifLn1 = OflLn1 - PrtLn1
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     PAGEHEAD
     C                   WRITE     ITEMHDR
     C                   ENDIF
 
     C                   WRITE     ITEM
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRPrntOpt - Print an Originating Posting                      *
      *****************************************************************
     C     SRPrntOPt     BEGSR
 
     C                   EVAL      RqdLn1 = 1
     C                   EVAL      DifLn1 = OflLn1 - PrtLn1
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     PAGEHEAD
     C                   WRITE     OPSTHDR
     C                   ENDIF
 
     C                   WRITE     OPST
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRCFP1 - Detail Spool File recorded by RCF                   *
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
      * SRRCFAU - Detail Spool File recorded by RCF                   *
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
      * SRAudit- Output Audit Report                                  *
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
      * *INZSR - Program Initialisation routine                       *
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
 
     C     KZBalDtls     KLIST
     C                   KFLD                    KHierID
     C                   KFLD                    KLinkID
     C                   KFLD                    KProcDat
     C                   KFLD                    KStopNum
 
     C     KZPstTrns     KLIST
     C                   KFLD                    XRFI              3
     C                   KFLD                    ZIXRFN
 
     C     KAPOST        KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C                   KFLD                    PSTD
 
     C     KAccnt        KLIST
     C                   KFLD                    KCust
     C                   KFLD                    KCurr
     C                   KFLD                    KACode
     C                   KFLD                    KASeqN
     C                   KFLD                    KBranch
 
     C                   MOVEL     'ZS '         XRFI
 
     C                   ENDSR
      *****************************************************************
      /COPY ZACPYSRC,RECMPSSR
