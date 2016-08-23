     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Business Classification Type List')           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000835 - Midas SD Business Classification Type List        *
      *                                                               *
      *  Function:  This will list all the Business Classification    *
      *             Type maintained on the system. It will display    *
      *             the Business Classification Type in ascending     *
      *             order.                                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. BUG26779 *CREATE   Date 27Nov09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26779 - Change request on GSART table                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    21         Display DIFFERENCE in SD000835AU                *
      *    60         Display AUDIT header in SD000835P1              *
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
 
      ** Midas SD Business Classification Type by Code
     FSDBUTYL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD Standing Data Controls
     FSDFCTLL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD Business Classification Type Report
     FSD000835P1O    E             PRINTER INFDS(SPOOL1)
     F                                     USROPN
     F                                     INFSR(*PSSR)
 
      ** Midas SD Business Classification Type Audit
     FSD000835AUO    E             PRINTER INFDS(SPOOLU)
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
 
      ** File Information Data Structure for SD000835P1
     D SPOOL1          DS
     D   SFile1               83     92
     D   SFNum1              123    124B 0
     D   OfLlN1              188    189B 0
     D   PrtLn1              367    368B 0
 
      ** File Information Data Structure for SD000835AU
     D SPOOLU          DS
     D   SFileU               83     92
     D   SFNumU              123    124B 0
 
     D RqdLn1          S              3  0
     D DifLn1          S              4  0
     D WFirst          S              1    INZ('Y')
     D WNoRec          S              5S 0 INZ(0)
     D WNoRecP         S              5S 0 INZ(0)
     D WPrtRec         S              1
     D WRun            S              1
      *
      ** Entry Parameters
     D PMode           S              1
     D PLevel          S              1
     D PEntity         S              3
 
     D WFileName       C                   CONST('SDBUTYPD  ')
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Set file pointer to first record and do initial read.
 
     C     *LOVAL        SETLL     SDBUTYL0
     C                   READ      SDBUTYL0
 
     C                   IF        %EOF(SDBUTYL0)
     C                   EXSR      SRAudit
     C                   ENDIF
 
     C                   DOU       %EOF(SDBUTYL0)
 
     C                   EVAL      WNoRec = WNoRec + 1
 
     C                   EVAL      WPrtRec = 'Y'
 
     C                   IF        PMode = 'A' and N0LCD <> BJRDNB
     C                   EVAL      WPrtRec = 'N'
     C                   ENDIF
 
     C                   IF        WPrtRec = 'Y'
     C                   EVAL      WNoRecP = WNoRecP + 1
     C                   EXSR      SRPrint
     C                   ENDIF
 
     C                   READ      SDBUTYL0
     C                   ENDDO
 
     C                   EXSR      SREnd
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRPrint  - Print Detail Report                                *
      *****************************************************************
 
     C     SRPrint       BEGSR
 
     C                   IF        NOT %OPEN(SD000835P1)
     C                   OPEN      SD000835P1
 
     C                   EVAL      ZSnum = SFNUM1
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFile1
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
     C                   EVAL      DifLn1 = OfLlN1 - PrtLn1
 
      ** If initial print of details or overflow has occured, print the Header
      ** of the report.
 
     C                   IF        DifLn1 <= RqdLn1 OR
     C                             WFirst = 'Y'
     C                   WRITE     HEADP1
     C                   EVAL      WFirst = 'N'
     C                   ENDIF
 
      ** Write details to printer fields.
 
     C                   MOVE      N0BUTY        RCODE
     C                   MOVE      N0DESC        RDESC
 
     C                   SELECT
     C                   WHEN      N0TYLC = 'I'
     C                   MOVE      'INSERT'      RTYLC
     C                   WHEN      N0TYLC = 'A'
     C                   MOVE      'AMEND '      RTYLC
     C                   ENDSL
 
     C                   EVAL      ZDayNo = N0LCD
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
 
     C                   IF        NOT %OPEN(SD000835AU)
     C                   OPEN      SD000835AU
     C                   ENDIF
 
     C                   EVAL      ZSnumU = SFNumU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFileU
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
 
     C                   IF        WNoRecP <> 0 and *INU7 <> *ON
     C                   WRITE     CONTROL
     C                   ENDIF
 
     C                   IF        WNoRecP = 0
     C                   WRITE     NODTLS
     C                   ENDIF
 
      ** Close printer files.
 
     C                   IF        %OPEN(SD000835AU)
     C                   CLOSE     SD000835AU
     C                   ENDIF
 
     C                   IF        %OPEN(SD000835P1)
     C                   CLOSE     SD000835P1
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
 
     C                   IF        %OPEN(SD000835P1)
     C                   EVAL      RqdLn1 = 4
     C                   EVAL      DifLn1 = OfLlN1 - PrtLn1
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
      ** Write out report trailer.
 
     C                   WRITE     TRAILP1
     C                   ENDIF
 
     C     WFileName     CHAIN     SDFCTLL1
     C                   IF        NOT %FOUND(SDFCTLL1)
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'SDBUTYPD'
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
 
     C                   IF        RCOUNT <> RAUDIT AND WNoRec <> 0
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
     C                   PARM                    PrtCd
     C                   PARM                    PMode
     C                   PARM                    PSeq
     C                   PARM                    PLevel
     C                   PARM                    PEntity
 
      ** Define LDA
 
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'SD000835'
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
     C                   EVAL      PrtLn1 = 0
 
     C                   IF        PMode = 'A'
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
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2009
