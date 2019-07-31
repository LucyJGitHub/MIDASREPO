     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Federal State Codes Report')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD200201 - Midas SD Federal State Codes Report               *
      *                                                               *
      *  Function:  This will list all the Federal States maintained  *
      *             on the system.  It will display the State Codes   *
      *             in ascending order.                               *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER054  *CREATE    Date 07Apr09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    21         Display DIFFERENCE in SD200201AU                *
      *    60         Display AUDIT header in SD200201P1              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR        -  Program Initialisation Routine              *
      *  *PSSR         -  Error handling subroutine                   *
      *  SRPrint       -  Print Detail Report                         *
      *  SREnd         -  Write Trailer in Report                     *
      *  SRAudit       -  Write audit report                          *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Midas SD Federal State Codes by State Code
     FSDGESTL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD Standing Data Controls
     FSDFCTLL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD Federal State Codes Report
     FSD200201P1O    E             PRINTER INFDS(SPOOL1)
     F                                     USROPN
     F                                     INFSR(*PSSR)
 
      ** Midas SD Federal State Codes Report-Audit
     FSD200201AUO    E             PRINTER INFDS(SPOOLU)
     F                                     USROPN
     F                                     INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for Switchable Features
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Parameters for ZDATE2
     D ZDayNo          S              5P 0
     D ZDate           S              6P 0
     D ZADate          S              7A
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D SEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1
 
      ** Access Object Parameters
     D PRTCD           S              7A
     D POptn           S              7A
     D PSARD           S              6A
 
      ** File Information Data Structure for SD200201P1
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
 
      ** File Information Data Structure for SD200201AU
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0
 
     D RqdLn1          S              3  0
     D DifLn1          S              4  0
     D WFirst          S              1    INZ('Y')
     D WNoRec          S              5S 0 INZ(0)
     D WNoRecA         S              5S 0 INZ(0)
     D WPrtRec         S              1
     D WRun            S              1
     D PMODE           S              1
     D PLEVEL          S              1
     D PENTITY         S              3
 
     D WFileName       C                   CONST('SDGESTPD  ')
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Set file pointer to first record and do initial read.
 
     C     *LOVAL        SETLL     SDGESTL0
     C                   READ      SDGESTL0
 
     C                   IF        %EOF(SDGESTL0)
     C                   EXSR      SRAudit
     C                   ENDIF
 
     C                   DOU       %EOF(SDGESTL0)
 
     C                   EVAL      WNoRec = WNoRec + 1
 
     C                   EVAL      WPrtRec = 'Y'
 
     C                   IF        PMODE = 'A' and GELCD <> BJRDNB
     C                   EVAL      WPrtRec = 'N'
     C                   ENDIF
 
     C                   IF        WPrtRec = 'Y'
     C                   EVAL      WNoRecA = WNoRecA + 1
     C                   EXSR      SRPrint
     C                   ENDIF
 
     C                   READ      SDGESTL0
     C                   ENDDO
 
     C                   EXSR      SREnd
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRPrint  - Print Detail Report                                *
      *****************************************************************
 
     C     SRPrint       BEGSR
 
     C                   IF        NOT %OPEN(SD200201P1)
     C                   OPEN      SD200201P1
 
     C                   EVAL      ZSnum = SFNUM1
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILE1
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSerr
 
     C     ZSerr         IFEQ      'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      RqdLn1 = 1
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
      ** If initial print of details or overflow has occured, print the Header
      ** of the report.
 
     C                   IF        DifLn1 <= RqdLn1 OR
     C                             WFirst = 'Y'
     C                   WRITE     HEADP1
     C                   EVAL      WFirst = 'N'
     C                   ENDIF
 
      ** Write details to printer fields.
 
     C                   MOVE      GESTCD        RSTCD
     C                   MOVE      GESTNM        RSTNM
     C                   MOVE      GETXBS        RTXBS
 
     C                   SELECT
     C                   WHEN      GETYLC = 'I'
     C                   MOVE      'INSERT'      RTYLC
     C                   WHEN      GETYLC = 'A'
     C                   MOVE      'AMEND '      RTYLC
     C                   WHEN      GETYLC = 'D'
     C                   MOVE      'DELETE'      RTYLC
     C                   ENDSL
 
     C                   EVAL      ZDayNo = GELCD
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *Zero         ZDate
     C                   PARM      *BLanks       ZADate
 
     C                   MOVE      ZADate        RLCD
 
     C                   WRITE     DETAIL
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRAudit - Write audit report                                  *
      *****************************************************************
 
     C     SRAudit       BEGSR
 
     C                   IF        NOT %OPEN(SD200201AU)
     C                   OPEN      SD200201AU
     C                   ENDIF
 
     C                   EVAL      ZSnumU = SFNUMU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILEU
     C                   PARM                    ZSnumU
     C                   PARM      *Blank        ZSerr
 
     C     ZSerr         IFEQ      'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   WRITE     HEADAU
 
      ** If there is a DB Error, Output the DB Error Information.
 
     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ENDIF
 
     C                   IF        WNoRecA <> 0 and *INU7 <> *ON
     C                   WRITE     CONTROL
     C                   ELSE
     C                   WRITE     NODTLS
     C                   ENDIF
 
      ** Close printer files.
 
     C                   IF        %OPEN(SD200201AU)
     C                   CLOSE     SD200201AU
     C                   ENDIF
 
     C                   IF        %OPEN(SD200201P1)
     C                   CLOSE     SD200201P1
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SREnd - Write Trailer in Report                              *
      *****************************************************************
 
     C     SREnd         BEGSR
 
     C                   IF        %OPEN(SD200201P1)
     C                   EVAL      RqdLn1 = 4
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
      ** Write out report trailer.
 
     C                   WRITE     TRAILP1
     C                   ENDIF
 
     C     WFileName     CHAIN     SDFCTLL1
     C                   IF        NOT %FOUND(SDFCTLL1)
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'SDGESTPD'
     C                   EVAL      DBFILE = 'SDFCTLL1'
     C                   EVAL      DBASE = 2
     C                   EVAL      DBPGM = PSProcPgm
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      RINSER = AHNOIN
     C                   EVAL      RAMEND = AHNOAM
     C                   EVAL      RDELET = AHNODL
     C                   EVAL      RAUDIT = AHNORC
     C                   EVAL      RCOUNT = WNoRec
 
      ** Print the word "Difference" if no. of records processed <> recorded on SDFCTLPA
 
     C                   IF        RCOUNT <> RAUDIT
     C                   EVAL      *IN21 = *ON
     C                   ENDIF
 
     C                   EXSR      SRAudit
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation Routine                       *
      *****************************************************************
      *
     C     *INZSR        BEGSR
 
      ** Accept entry parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    PRTCD
     C                   PARM                    PMODE
     C                   PARM                    PSEQ
     C                   PARM                    PLEVEL
     C                   PARM                    PENTITY
 
      ** Define LDA
 
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'SD200201'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY =  *BLANKS
     C                   EVAL      DBASE = 0
     C                   OUT       LDA
 
      ** Call Access Program for Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST  '    POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRTCD <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POPTN
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Report Work Fields
 
     C                   EVAL      RqdLn1 = 0
     C                   EVAL      DifLn1 = 0
     C                   EVAL      PRTLN1 = 0
 
     C                   IF        PMODE = 'A'
     C                   EVAL      *IN60 = *ON
     C                   ENDIF
 
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
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2009
