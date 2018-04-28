     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('MIDAS SD Intermediary Customers Audit Report')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD0379P - Midas SD Intermediary Customers Audit Report       *
      *                                                               *
      *  Function:  This module will report all the exemption codes   *
      *             details from file SDINTCLPD.                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE024   *CREATE   Date 12Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSE024 - Withholding Tax - Sub account processing            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    21         Difference in number of records                 *
      *    30         Unallocated Holding indicator                   *
      *    35         Error in reading file SDINTCLL1                 *
      *    45         End of file for SDINTCLL1                       *
      *    55         Record not found in SD Controls file            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRPrint - Print details                                       *
      * SRFilHdr2 - Fill up Header 2 screen fields                    *
      * SRChkUnHldg - Check Unallocated Holding                       *
      * SRFmtAmt - Format printer file fields amount                  *
      * SREnd   - Write trailer in report                             *
      * SRAudit - Write audit report                                  *
      * *INZSR  - Initialise                                          *
      * *PSSR   - Error processing                                    *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** SD Intermediary Client details retrieval index
     FSDINTCLL1 IF   E           K DISK    INFSR(*PSSR)
      *
      ** Control file retrieval index
     FSDFCTLL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Intermediary Customers printer file - Detail
     FSD0379P1  O    E             PRINTER INFDS(SPOOL1)
     F                                     USROPN
     F                                     INFSR(*PSSR)
      *
      ** Intermediary Customers printer file - Audit
     FSD0379PM  O    E             PRINTER INFDS(SPOOLU)
     F                                     USROPN
     F                                     INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
      *
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** DS for access objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for access objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** File Information Data Structure for SD0379P1.
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
      *
      ** File Information Data Structure for SD0379PM.
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0
      *
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  ErrorOnFl             35     35
     D  EndOfFile             45     45
     D  RecNotFnd             55     55
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Named constants             ¦
      ** ¦ =======  ===============             ¦
      ** +--------------------------------------+
      *
      ** True and False can be used for indicators being on or off.
     D True            C                   *On
     D False           C                   *Off
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
      *
      ** Parameters for ZSFILE
     D PSeq            S              5
     D SEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1
      *
      ** Parameters for access object programs
     D PRtcd           S              7
     D POptn           S              7
     D PCust           S             10
     D PKySt           S              7
      *
      ** Parameters for ZSEDITF
     D ZFld15          S             15P 0
     D ZDecs           S              1P 0
     D ZECode          S              1A
     D ZEChar          S              1A
     D ZOut21          S             21A
      *
      ** Other fields used
     D WRun            S              1
     D WFirstRec       S              1    INZ('Y')
     D WNewCust        S              1    INZ('Y')
     D WNewSecs        S              1    INZ('Y')
     D WNewDept        S              1    INZ('Y')
     D WOpen           S              1    INZ('N')
     D WCnum           S              6
     D WCrnm           S             10
     D WSecs           S             10
     D WDept           S              6
     D WToth           S             15
     D WStat           S              7
     D WPrevCnum       S              6
     D WPrevSecs       S             10
     D WPrevDept       S              6
     D WTotHldg        S             15  0 INZ(0)
     D WUnHldg         S             15  0
     D WFName          S             10
     D WNoRec          S              5  0 INZ(0)
     D RqdLn1          S              3  0
     D DifLn1          S              3  0
      *
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
      *
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
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
     C     *LOVAL        SETLL     SDINTCLL1
     C                   READ      SDINTCLL1                            3545
      *
      ** Database error.
      *
     C                   IF        ErrorOnFl = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBFile = 'SDINTCLL1'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        EndOfFile = True
     C                   EXSR      SRAudit
     C                   ENDIF
      *
     C                   DOU       EndOfFile = True
      *
      ** Process Report Lines.
      *
     C                   EXSR      SRPrint
      *
      ** Read next record.
      *
     C                   READ      SDINTCLL1                            3545
      *
      ** Database error.
      *
     C                   IF        ErrorOnFl = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*NEXT'
     C                   EVAL      DBFile = 'SDINTCLL1'
     C                   EVAL      DBase = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Check if next customer.
      *
     C                   IF        INCNUM <> WPrevCnum
     C                   EVAL      WNewCust = 'Y'
     C                   ELSE
     C                   EVAL      WNewCust = 'N'
     C                   ENDIF
      *
      ** Check if new security.
      *
     C                   IF        INSECS <> WPrevSecs
     C                   EVAL      WNewSecs = 'Y'
     C                   ELSE
     C                   EVAL      WNewSecs = 'N'
     C                   ENDIF
      *
      ** Check if new depot number.
      *
     C                   IF        INDEPT <> WPrevDept
     C                   EVAL      WNewDept = 'Y'
     C                   ELSE
     C                   EVAL      WNewDept = 'N'
     C                   ENDIF
      *
     C                   EVAL      WPrevCnum = INCNUM
     C                   EVAL      WPrevSecs = INSECS
     C                   EVAL      WPrevDept = INDEPT
      *
      ** End of DO until.
      *
     C                   ENDDO
      *
      ** Check unallocated holding of the final record
      *
     C                   EXSR      SRChkUnHldg
 
     C                   EXSR      SREnd
      *
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrnt - Print details                                       *
      *                                                               *
      *****************************************************************
 
     C     SRPrint       BEGSR
 
     C                   IF        WOpen <> 'Y'
      *
     C                   EVAL      WOpen = 'Y'
     C                   OPEN      SD0379P1
      *
     C                   EVAL      WPrevCnum = INCNUM
     C                   EVAL      WPrevSecs = INSECS
     C                   EVAL      WPrevDept = INDEPT
      *
      ** Ensure Detail Spool File recorded by RCF.
      *
     C                   EVAL      ZSnum = SFNUM1
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILE1
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSerr
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If new customer number or new security or new depot number.
      *
     C                   IF        WNewCust = 'Y' OR
     C                             WNewSecs = 'Y' OR
     C                             WNewDept = 'Y'
      *
      ** Check unallocated holding.
      *
     C                   IF        WFirstRec <> 'Y'
     C                   EXSR      SRChkUnHldg
     C                   ENDIF
      *
     C                   EVAL      WFirstRec = 'N'
      *
     C                   WRITE     HEADP1
      *
      ** Reset total holding work field.
      *
     C                   Z-ADD     INHLDN        WTotHldg
      *
      ** Fill up Header2 screen fields.
      *
     C                   EXSR      SRFilHdr2
     C                   WRITE     HEADP2
      *
     C                   ELSE
      *
     C                   EVAL      RqdLn1 = 8
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
      *
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   EXSR      SRFilHdr2
     C                   WRITE     HEADP2
     C                   ENDIF
      *
      ** Add the record's holding to the customer's total holding.
      *
     C                   ADD       INHLDN        WTotHldg
      *
     C                   ENDIF
      *
      ** Write Detail.
      *
     C                   MOVE      INBONO        RBONO
     C                   EVAL      RBONM = INBONM
     C                   EVAL      RBOA1 = INBOA1
     C                   EVAL      RBOA2 = INBOA2
     C                   EVAL      RBOA3 = INBOA3
     C                   EVAL      RCTRS = INCTRS
     C                   EVAL      RCSTN = INCSTN
     C                   EVAL      RTXBS = INTXBS
      *
     C                   EVAL      ZFld15 = *Zeros
     C                   EVAL      ZFld15 = INHLDN
     C                   EVAL      ZDecs = *Zero
     C                   EVAL      ZECode = 'J'
     C                   EXSR      SRFmtAmt
     C                   EVAL      RHLDN = ZOut21
      *
     C                   WRITE     DETAIL1
      *
      ** Count no. of records processed.
      *
     C                   EVAL      WNoRec = WNoRec + 1
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFIlHdr2 - Fill up HEADER 2 screen fields                   *
      *                                                               *
      *****************************************************************
 
     C     SRFilHdr2     BEGSR
      *
      ** Retrieve new data if new record.
      *
     C                   IF        WNewCust = 'Y' OR
     C                             WNewSecs = 'Y' OR
     C                             WNewDept = 'Y'
      *
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      INCNUM        PCust
     C                   PARM                    PKySt
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      ** Database error.
      *
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = PCust
     C                   EVAL      DBFile = 'SDCUSTPD'
     C                   EVAL      DBase = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      RCNUM = INCNUM
     C                   EVAL      RCRNM = BBCRNM
     C                   EVAL      RSECS = INSECS
     C                   EVAL      RDEPT = INDEPT
      *
     C                   EVAL      ZFld15 = *Zeros
     C                   EVAL      ZFld15 = INTOTH
     C                   EVAL      ZDecs = *Zero
     C                   EVAL      ZECode = 'J'
     C                   EXSR      SRFmtAmt
     C                   EVAL      RTOTH = ZOut21
      *
     C                   IF        INRECI <> 'D'
     C                   EVAL      RSTAT = 'DELETED'
     C                   ELSE
     C                   EVAL      RSTAT = 'LIVE'
     C                   ENDIF
      *
     C                   EVAL      WCnum = RCNUM
     C                   EVAL      WCrnm = RCRNM
     C                   EVAL      WSecs = RSECS
     C                   EVAL      WDept = RDEPT
     C                   EVAL      WToth = RTOTH
     C                   EVAL      WStat = RSTAT
      *
     C                   ELSE
      *
      ** Use the previous data.
      *
     C                   EVAL      RCNUM = WCnum
     C                   EVAL      RCRNM = WCrnm
     C                   EVAL      RSECS = WSecs
     C                   EVAL      RDEPT = WDept
     C                   EVAL      RTOTH = WToth
     C                   EVAL      RSTAT = WStat
      *
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkUnHldg - Check Unallocated Holding                      *
      *                                                               *
      *****************************************************************
 
     C     SRChkUnHldg   BEGSR
      *
      ** If Total holding in file does not equal to calculated
      ** total holding,
      *
     C                   IF        INTOTH <> WTotHldg
      *
      ** Print unallocated holding field.
      *
     C                   EVAL      *IN30 = *On
      *
     C     INTOTH        SUB       WTotHldg      WUnHldg
     C                   EVAL      ZFld15 = *Zeros
     C                   EVAL      ZFld15 = WUnHldg
     C                   EVAL      ZDecs = *Zero
     C                   EVAL      ZECode = 'J'
     C                   EXSR      SRFmtAmt
      *
     C                   EVAL      RUNHO = ZOut21
      *
     C                   ELSE
      *
      ** Do not print unallocated holding field.
      *
     C                   EVAL      *IN30 = *Off
      *
     C                   ENDIF
      *
     C                   WRITE     DETAIL2
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtAmt - Format printer file fields amount                 *
      *                                                               *
      *****************************************************************
 
     C     SRFMtAmt      BEGSR
      *
     C                   CALLB     'ZSEDITF'
     C                   PARM                    ZFld15
     C                   PARM                    ZDecs
     C                   PARM                    ZECode
     C                   PARM      *Blanks       ZEChar
     C                   PARM      *Blanks       ZOut21
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREnd - Write trailer in report                              *
      *                                                               *
      *****************************************************************
 
     C     SREnd         BEGSR
      *
     C                   EVAL      RqdLn1 = 4
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
      *
      ** Write out report trailer.
      *
     C                   WRITE     TRAILP1
      *
      ** Check control details.
      *
     C                   EVAL      WFName = 'SDINTCLPD'
     C     WFName        CHAIN     SDFCTLL1                           55
      *
      ** Database error.
      *
     C                   IF        RecNotFnd = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = WFName
     C                   EVAL      DBFile = 'SDFCTLPA'
     C                   EVAL      DBase = 004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      RINSER = AHNOIN
     C                   EVAL      RAMEND = AHNOAM
     C                   EVAL      RDELET = AHNODL
     C                   EVAL      RAUDIT = AHNORC
     C                   EVAL      RCOUNT = WNoRec
      *
     C                   IF        RCOUNT <> RAUDIT
     C                   EVAL      *IN21 = *On
     C                   ELSE
     C                   EVAL      *IN21 = *Off
     C                   ENDIF
      *
      ** Write audit report.
      *
     C                   EXSR      SRAudit
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Write audit report                                 *
      *                                                               *
      *****************************************************************
 
     C     SRAudit       BEGSR
      *
     C                   OPEN      SD0379PM
      *
      ** Ensure Audit Spool File recorded by RCF.
      *
     C                   EVAL      ZSnumU = SFNUMU
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILEU
     C                   PARM                    ZSnumU
     C                   PARM      *Blank        ZSerr
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
     C                   WRITE     HEADAU
      *
      ** If there is a DB Error, Output the DB Error Information.
      *
     C                   IF        *INU7 = *ON
      *
     C                   IF        DBase = 001 OR
     C                             DBase = 002
     C                   EVAL      DBFILEX = 'SDINTCLL1'
     C                   ELSE
     C                   EVAL      DBFILEX = DBFILE
     C                   ENDIF
      *
     C                   WRITE     DBERROR
     C                   ELSE
      *
      ** If there is a record read, write audit control report.
      *
     C                   IF        WNoRec <> 0
     C                   WRITE     CONTROL
     C                   ELSE
      *
      ** Or, if no records read, Output "No Details" message.
      *
     C                   WRITE     NODTLS
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   EVAL      *INLR ='1'
     C                   RETURN
 
     C                   ENDSR
      *
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
      *
     C     *ENTRY        PLIST
     C                   PARM                    PSeq
      *
     C     *DTAARA       DEFINE                  LDA
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error.
      *
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 005
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Report Work fields.
      *
     C                   EVAL      RqdLn1 = 0
     C                   EVAL      DifLn1 = 0
     C                   EVAL      PRTLN1 = 0
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *Blank
     C                   EVAL      WRun = 'Y'
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   DUMP
     C                   EXSR      SRAudit
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
