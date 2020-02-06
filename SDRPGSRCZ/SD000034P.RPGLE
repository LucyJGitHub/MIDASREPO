     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Margin Schedule Type Details Report')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000034P - Margin Schedule Type Details Report Module       *
      *                                                               *
      *  Function:  This module will report all the Margin Schedule   *
      *             Type details from file SDMASTPD.                  *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CLE040  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE040 - Collateralised Lending Phase 2                      *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDMASTL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Margin Schedule Type Retrieval Index
 
     FSDFCTLL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Standing Data Controls File Retrieval Index
 
     FSD000034P1O    E             PRINTER INFDS(SPOOL1) USROPN INFSR(*PSSR)
      ** Midas SD Margin Schedule Type Details Printer File - Details
 
     FSD000034AUO    E             PRINTER INFDS(SPOOLU) USROPN INFSR(*PSSR)
      ** Midas SD Margin Schedule Type Details Printer File - Audit
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
 
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** DS for access objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** File Information Data Structure for SD0000034P1
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
 
      ** File Information Data Structure for SD0000034AU
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0
 
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  ErrorOnFl             35     35
     D  EndOfFile             45     45
     D  RecNotFnd             55     55
 
      ** +--------------------------------------+
      ** ¦ D-specs: Named constants             ¦
      ** ¦ =======  ===============             ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
 
      ** Parameter list fields
     D PMode           S              1
     D PLevl           S              1
     D PEnty           S              3
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D SEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1
 
      ** Parameters for ZDATE2
     D ZDayNo          S              5P 0
     D ZDate           S              6P 0
     D ZADate          S              7A
 
      ** Parameters for access object programs
     D PRTCD           S              7
     D POPTN           S              7
 
      ** Other fields used
     D WRun            S              1
     D WOpen           S              1    INZ('N')
     D WFirst          S              1    INZ('Y')
     D WFName          S             10
     D WNoRec          S              5  0 INZ(0)
     D RqdLn1          S              3  0
     D DifLn1          S              3  0
 
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C     *LOVAL        SETLL     SDMASTL0
     C                   READ      SDMASTL0                             3545
 
      ** Database error
 
     C                   IF        ErrorOnFl = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBFile = 'SDMASTL0'
     C                   EVAL      DBase = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        EndOfFile = True
     C                   EXSR      SRAudit
     C                   ENDIF
 
     C                   DOU       EndOfFile = True
 
      ** Count no. of records processed
 
     C                   EVAL      WNoRec = WNoRec + 1
 
      ** Process Report Lines
 
     C                   EXSR      SRPrint
 
      ** Read next record
 
     C                   READ      SDMASTL0                             3545
 
     C                   IF        ErrorOnFl = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*NEXT'
     C                   EVAL      DBFile = 'SDMASTL0'
     C                   EVAL      DBase = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EXSR      SREnd
 
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPrint - Print details report                                *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: ZSFILE, ZDATE2                                         *
      *                                                               *
      *****************************************************************
 
     C     SRPrint       BEGSR
 
     C                   IF        WOpen <> 'Y'
     C                   EVAL      WOpen = 'Y'
     C                   OPEN      SD000034P1
 
      ** Ensure Detail Spool File recorded by RCF
 
     C                   EVAL      ZSnum = SFNUM1
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *BLANK        SEnty
     C                   PARM                    SFILE1
     C                   PARM                    ZSnum
     C                   PARM      *BLANK        ZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program
 
     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      RqdLn1 = 1
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        DifLn1 <= RqdLn1 OR
     C                             WFirst = 'Y'
     C                   WRITE     HEADER
     C                   EVAL      WFirst = 'N'
     C                   ENDIF
 
      ** Write details to printer fields
 
     C                   EVAL      RTYPE = MSTYPE
     C                   EVAL      RCURR = MSCURR
     C                   EVAL      RDESC = MSDESC
     C                   MOVE      MSPERC        RPERC
 
     C                   IF        MSTYLC = 'I'
     C                   EVAL      RCHTP = 'INSERT'
     C                   ELSE
     C                   EVAL      RCHTP = 'AMEND'
     C                   ENDIF
 
     C                   EVAL      ZDayNo = MSLCD
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *Zero         ZDate
     C                   PARM      *BLanks       ZADate
 
     C                   IF        ZADate <> *Blanks
     C                   EVAL      RLCDT = ZADate
     C                   ELSE
     C                   EVAL      RLCDT = *Blanks
     C                   ENDIF
 
      ** Write Detail Format
 
     C                   WRITE     DETAIL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREnd - Print trailer report                                  *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRAudit                                                *
      *                                                               *
      *****************************************************************
 
     C     SREnd         BEGSR
 
     C                   EVAL      RqdLn1 = 4
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADER
     C                   ENDIF
 
      ** Write out report trailer
 
     C                   WRITE     TRAILER
 
      ** Check control details
 
     C                   EVAL      WFName = 'SDMASTPD'
     C     WFName        CHAIN     SDFCTLL1                           55
 
      ** Database error
 
     C                   IF        RecNotFnd = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = WFName
     C                   EVAL      DBFile = 'SDFCTLPA'
     C                   EVAL      DBase = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      RINSER = AHNOIN
     C                   EVAL      RAMEND = AHNOAM
     C                   EVAL      RDELET = AHNODL
     C                   EVAL      RAUDIT = AHNORC
     C                   EVAL      RCOUNT = WNoRec
 
     C                   IF        RCOUNT <> RAUDIT
     C                   EVAL      *IN21 = *ON
     C                   ELSE
     C                   EVAL      *IN21 = *OFF
     C                   ENDIF
 
      ** Write audit report
 
     C                   EXSR      SRAudit
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAudit - Print audit report                                  *
      *                                                               *
      * Called by: Main Processing, SREnd, *PSSR                      *
      *                                                               *
      * Calls: ZSFILE                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRAudit       BEGSR
 
     C                   OPEN      SD000034AU
 
      ** Ensure Audit Spool File recorded by RCF
 
     C                   EVAL      ZSnumU = SFNUMU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILEU
     C                   PARM                    ZSnumU
     C                   PARM      *Blank        ZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program
 
     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   WRITE     HEADAU
 
      ** If there is a DB Error, Output the DB Error Information
 
     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE
 
      ** If there is a record read, write audit control report
 
     C                   IF        WNoRec <> 0
     C                   WRITE     CONTROL
     C                   ELSE
 
      ** Or, if no records read, Output "No Details" message
 
     C                   WRITE     NODTLS
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: AOBANKR0                                               *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PRtcd
     C                   PARM                    PMode
     C                   PARM                    PSeq
     C                   PARM                    PLevl
     C                   PARM                    PEnty
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Report Work fields
 
     C                   EVAL      RqdLn1 = 0
     C                   EVAL      DifLn1 = 0
     C                   EVAL      PRTLN1 = 0
 
     C                   ENDSR
 
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
      * Calls: SRAudit                                                *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *Blank
     C                   EVAL      WRun = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
     C                   EXSR      SRAudit
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2004
