     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Tax basket codes Full list')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD0375P - Midas SD Tax Basket Codes Detail Report            *
      *                                                               *
      *  Function:  This module reports the Tax basket codes detail   *
      *             two modes:                                        *
      *             1.Full List  - All the records from the file will *
      *                            be printed.                        *
      *             2.Audit List - Only the records w/ LCD = Rundate  *
      *                            will be printed.                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. AR792632           Date 24Jun11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGL031             Date 05Jul04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023  *CREATE    Date 12Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR792632 - Dump in SDC0602 00001                             *
      *  CGL031 - Taxation on Savings Income                          *
      *  CSE023 - Treaty Withholding Tax                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Error in reading file SDTXBSL1                  *
      *    02         End of file for SDTXBSL1                        *
      *    03         Record not found in SDFCTLL1                    *
      *    20         Audit mode, use for header                      *
      *    21         Out of balance, difference in number of records *
      *    22         Taxation of Savings Income                      *                       CGL031
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRPrint - Print details                                       *
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
      ** SD Tax Basket code details - Retrieve
     FSDTXBSL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Control file retrieval index
     FSDFCTLL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Tax Basket code Printer file - Details
     FSD0375P1  O    E             PRINTER INFDS(SPOOL1)
     F                                     USROPN
     F                                     INFSR(*PSSR)
      *
      ** Tax Basket printer file - Audit
     FSD0375PM  O    E             PRINTER INFDS(SPOOLU)
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
      ** DS for access objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** File Information Data Structure for SD0375P1.
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
      *
      ** File Information Data Structure for SD0375PM.
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0
      *
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  ErrorOnFl             01     01
     D  EndOfFile             02     02
     D  RecNotFnd             03     03
                                                                                              CGL031
      ** Externally described DS for SAR details                                              CGL031
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CGL031
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
      ** Parameters for ZDATE2
     D ZDayNo          S              5P 0
     D ZDate           S              6P 0
     D ZADate          S              7A
      *
      ** Parameters for ZEDIT
     D PZField         S             16A
     D PZADec          S              1  0
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
     D PSARd           S              6                                                       CGL031
      *
      ** Parameter list fields
     D PMode           S              1
     D PLevl           S              1
     D PEnty           S              3
      *
      ** Other fields used
     D WRun            S              1
     D WOpen           S              1    INZ('N')
     D WFirst          S              1    INZ('Y')
     D WFName          S             10
     D WPrtRec         S              1
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
      ** Parameter and work variable declarations                                             CGL031
     D CGL031          S              1A                                                      CGL031
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
     C     *LOVAL        SETLL     SDTXBSL1
     C                   READ      SDTXBSL1                             0102
      *
      ** Database error
      *
     C                   IF        ErrorOnFl = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBFile = 'SDTXBSL1'
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
      ** Count no. of records processed.
      *
     C                   EVAL      WNoRec = WNoRec + 1
      *
      ** Check if Audit list or full list.
      *
     C                   EVAL      WPrtRec = 'Y'
      *
     C                   IF        PMode = 'A' AND
     C                             TBLCD <> BJRDNB
     C                   EVAL      WPrtRec = 'N'
     C                   ENDIF
      *
      ** Process Report Lines.
      *
     C                   IF        WPrtRec = 'Y'
     C                   EXSR      SRPrint
     C                   ENDIF
      *
      ** Read next record.
      *
     C                   READ      SDTXBSL1                             0102
      *
     C                   IF        ErrorOnFl = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*NEXT '
     C                   EVAL      DBFile = 'SDTXBSL1'
     C                   EVAL      DBase = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDDO
      *
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
     C                   EVAL      WOpen = 'Y'
     C                   OPEN      SD0375P1
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
     C                   EVAL      RqdLn1 = 1
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
                                                                                              CGL031
      ** If Taxation feature is on, print additional header column.                           CGL031
                                                                                              CGL031
     C                   IF        CGL031 = 'Y'                                               CGL031
     C                   EVAL      *IN22 = '1'                                                CGL031
     C                   ELSE                                                                 CGL031
     C                   EVAL      *IN22 = '0'                                                CGL031
     C                   ENDIF                                                                CGL031
      *                                                                                       CGL031
     C                   IF        DifLn1 <= RqdLn1 OR
     C                             WFirst = 'Y'
     C                   WRITE     HEADP1
     C                   EVAL      WFIRST = 'N'
     C                   ENDIF
      *
      ** Write details to printer fields.
      *
     C                   EVAL      RCRTT = TBCRTT
     C                   EVAL      RTXBS = TBTXBS
      *
     C                   EVAL      ZDayNo = TBEFDT
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *Zero         ZDate
     C                   PARM      *BLanks       ZADate
      *
     C                   MOVE      ZADate        REFDT
      *
     C                   EVAL      RNARR = TBNARR
      *
     C                   MOVE      *BLANKS       PZField
     C                   MOVE      TBTRAB        PZField
     C                   Z-ADD     4             PZADec
     C                   CALLB     'ZEDIT'
     C                   PARM                    PZField
     C                   PARM                    PZADec
     C                   MOVE      PZField       RTRAB
 
     C                   EVAL      RTYLC = *BLANKS
 
     C                   IF        TBTYLC = 'I'
     C                   EVAL      RTYLC = 'INSERT'
     C                   ELSE
     C                   EVAL      RTYLC = 'AMEND'
     C                   ENDIF
      *
     C                   EVAL      ZDayNo = TBLCD
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *Zero         ZDate
     C                   PARM      *BLanks       ZADate
      *
     C                   MOVE      ZADate        RLCD
                                                                                              CGL031
     C                   IF        CGL031 = 'Y'                                               CGL031
     C                   EVAL      RTRTY = TBTRTY                                             CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
      *
      ** Write Detail
      *
     C                   WRITE     DETAIL
 
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
     C                   IF        WOpen = 'Y'                                              AR792632
     C                   EVAL      RqdLn1 = 4
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
      *
      ** Write out report trailer.
      *
     C                   WRITE     TRAILP1
     C                   ENDIF                                                              AR792632
      *
      ** Retrieve control details.
      *
     C                   EVAL      WFName = 'SDTXBSPD'
     C     WFName        CHAIN     SDFCTLL1                           03
      *
      ** Database error.
      *
     C                   IF        RecNotFnd = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = WFName
     C                   EVAL      DBFile = 'SDFCTLPA'
     C                   EVAL      DBase = 003
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
     C                   OPEN      SD0375PM
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
     C                   PARM                    PRtcd
     C                   PARM                    PMode
     C                   PARM                    PSeq
     C                   PARM                    PLevl
     C                   PARM                    PEnty
      *
     C     *DTAARA       DEFINE                  LDA
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
                                                                                              CGL031
      ** Access SAR details file to determine if Taxation on Sav-                             CGL031
      ** ings Income is on.                                                                   CGL031
                                                                                              CGL031
     C                   CALL      'AOSARDR0'                                                 CGL031
     C                   PARM      *BLANKS       PRtcd                                        CGL031
     C                   PARM      '*VERIFY'     POptn                                        CGL031
     C                   PARM      'CGL031'      PSARd                                        CGL031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL031
      *                                                                                       CGL031
      ** An NRF (No Record Found) return code is valid.                                       CGL031
      ** Issue database error only for error return codes.                                    CGL031
      *                                                                                       CGL031
     C                   IF        PRtcd <> *BLANKS AND                                       CGL031
     C                             PRtcd <> '*NRF   '                                         CGL031
     C                   EVAL      DBKey = 'CGL031'                                           CGL031
     C                   EVAL      DBFile = 'SCSARDPD'                                        CGL031
     C                   Z-ADD     01            DBase                                        CGL031
     C                   EXSR      *PSSR                                                      CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   IF        PRtcd = *BLANKS                                            CGL031
     C                   MOVEL     'Y'           CGL031                                       CGL031
     C                   ELSE                                                                 CGL031
     C                   MOVEL     'N'           CGL031                                       CGL031
     C                   END                                                                  CGL031
                                                                                              CGL031
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
     C                   EVAL      DBase = 004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Report Work fields.
      *
     C                   EVAL      RqdLn1 = 0
     C                   EVAL      DifLn1 = 0
     C                   EVAL      PRTLN1 = 0
      *
      ** Setup indicator which header to use.
      *
     C                   IF        PMode = 'A'
     C                   EVAL      *IN20 = *On
     C                   ELSE
     C                   EVAL      *IN20 = *Off
     C                   ENDIF
 
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
