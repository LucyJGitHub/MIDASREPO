     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ER Bundesbank Cash Flow Extract Report')         *
      *****************************************************************
      *                                                               *
      *  Midas - European Reporting Module                            *
      *                                                               *
      *  ER000198 - Midas ER Bundesbank Cash Flow Extract Report      *
      *                                                               *
      *  Function: This program generates report of Extracted         *
      *            Cash Flow detail.                                  *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD030247           Date 26Jan15               *
      *                 CER070             Date 19Aug14               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26702           Date 16Nov09               *
      *                 BUG26695           Date 06Nov09               *
      *                 CER045  *CREATE    Date 20Jul09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD030247 - Increase size of GSRE to 21.                      *
      *             Applied for MD032081 (Recompile)                  *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT062: Changed Customer No. to alphanumeric         *
      *           (Recompile)                                         *
      *  BUG26702 - Negative sign should be at the left side.         *
      *  BUG26695 - Decimals are not displayed correctly              *
      *  CER045 - German Features - Reporting Bundesbank              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    02         End of file for ERKGLIL0                        *
      *    03         Record not found in ERKGLIL0                    *
      *    20         Audit mode, use for header                      *
      *    21         Out of balance, difference in number of records *
      *    22         Space between different Country of Security     *
      *               Issues                                          *
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
 
      ** Midas ER GRI Cash Flows
 
     FERKGLIL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas ER GRI Master Account/Transaction File
 
     FERGSTIL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas ER Bundesbank Cash Flow Extract Report - Details
 
     FER000198P1O    E             PRINTER INFDS(SPOOL1)
     F                                     USROPN
     F                                     INFSR(*PSSR)
 
      ** Midas ER Bundesbank Cash Flow Extract Report - Audit
 
     FER000198AUO    E             PRINTER INFDS(SPOOLU)
     F                                     USROPN
     F                                     INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
 
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
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      ** Program Status Data Structure
 
     D/COPY ZACPYSRC,PSDS
 
      ** Externally described DS for bank details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Externally described DS for Currency Codes
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** DS for access objects - short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** File Information Data Structure for SD0760P1.
 
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
 
      ** File Information Data Structure for ER000198AU.
 
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0
 
      ** Indicator Array
 
     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             02     02
     D  RecNotFnd             03     03
 
      ** Decimal Alignment DS
 
     D AlignAmt        DS
     D  TBVal                  1     18S 2
     D  TChr                   1     18
     D  TNum                   1     18S 0
 
      ** +--------------------------------------+
      ** ¦ D-specs: Named constants             ¦
      ** ¦ =======  ===============             ¦
      ** +--------------------------------------+
 
      ** True and False can be used for indicators being on or off.
 
     D True            C                   *On
     D False           C                   *Off
 
      ** Constants for decimal alignment.
 
     D NDec            C                   CONST('00')
     D MaxDec          C                   CONST('000000000')
 
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
 
      ** Parameters for ZSEDITL
 
     D ZFld            S             19  0
     D ZDec            S              2  0
     D ZEdtC           S              1
     D ZOut22          S             22
 
      ** Parameters for ZSFILE
 
     D PSeq            S              5    INZ(*BLANKS)
     D SEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1
 
      ** Parameters for access object programs
 
     D PRtcd           S              7
     D POptn           S              7
     D PSARd           S              6
 
      ** Parameter list fields
 
     D PCurr           S              3
 
      ** Other fields used
 
     D WRun            S              1
     D WOpen           S              1    INZ('N')
     D WFirst          S              1    INZ('Y')
     D WFName          S             10
     D WNoRec          S              5  0 INZ(0)
     D RqdLn1          S              3  0
     D DifLn1          S              4  0
     D WCsis           S              2
     D WPos            S              2  0
     D WDec            S              2  0
     D WSign           S              1                                                     BUG26702
 
      ** Pointer for the indicator Array
 
     D IndicatorP      S               *   INZ(%Addr(*IN))
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
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
 
      ** Set file pointer to first record and do initial read.
 
     C     *LOVAL        SETLL     ERKGLIL0
     C                   READ      ERKGLIL0                               02
 
     C                   IF        EndOfFile = True
     C                   EXSR      SRAudit
     C                   ENDIF
 
     C                   DOU       EndOfFile = True
 
      ** Count no. of records processed.
 
     C                   EVAL      WNoRec = WNoRec + 1
 
      ** Process Report Lines.
 
     C                   EXSR      SRPrint
 
      ** Read next record.
 
     C                   READ      ERKGLIL0                               02
     C                   ENDDO
 
     C                   EXSR      SREnd
 
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
 
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrnt - Print details                                       *
      *                                                               *
      *****************************************************************
 
     C     SRPrint       BEGSR
 
     C                   IF        WOpen <> 'Y'
     C                   EVAL      WOpen = 'Y'
     C                   OPEN      ER000198P1
 
      ** Ensure Detail Spool File recorded by RCF.
 
     C                   EVAL      ZSnum = SFNUM1
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILE1
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      RqdLn1 = 2
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
      ** For initial print of details or overflow has occured, print the Header
      ** of the report.
 
     C                   IF        DifLn1 <= RqdLn1 OR
     C                             WFirst = 'Y'
     C                   WRITE     HEADP1
     C                   EVAL      WFIRST = 'N'
     C                   ENDIF
 
      ** Write details to printer fields.
 
     C                   EVAL      RGSRE = B6GSRE
     C     B6GSRE        CHAIN     ERGSTIL0
     C                   IF        %FOUND()
 
      ** Get number of decimal places for the currency.
 
     C                   EVAL      RWHIS = B3WHIS
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      B3WHIS        PCurr
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRtcd <> *BLANKS AND
     C                             PRtcd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY  = PCurr
     C                   EVAL      DBPGM  = 'ER000198'
     C                   EVAL      DBASE  = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      ZDec   = A6NBDP
 
     C                   ELSE
 
     C                   EVAL      ZDec   = 2
 
     C                   ENDIF
 
     C**********         EVAL      TBVal  = B6LB1G                                          BUG26695
     C                   Z-ADD     B6LB1G        ZFld                                       BUG26695
     C                   EXSR      SRZEdit
     C                   EVALR     RLB1G  = %TRIM(ZOut22)
 
     C**********         EVAL      TBVal  = B6LB2G                                          BUG26695
     C                   Z-ADD     B6LB2G        ZFld                                       BUG26695
     C                   EXSR      SRZEdit
     C                   EVALR     RLB2G  = %TRIM(ZOut22)
 
     C**********         EVAL      TBVal  = B6LB3G                                          BUG26695
     C                   Z-ADD     B6LB3G        ZFld                                       BUG26695
     C                   EXSR      SRZEdit
     C                   EVALR     RLB3G  = %TRIM(ZOut22)
 
     C**********         EVAL      TBVal  = B6LB4G                                          BUG26695
     C                   Z-ADD     B6LB4G        ZFld                                       BUG26695
     C                   EXSR      SRZEdit
     C                   EVALR     RLB4G  = %TRIM(ZOut22)
 
     C**********         EVAL      TBVal  = B6LB5G                                          BUG26695
     C                   Z-ADD     B6LB5G        ZFld                                       BUG26695
     C                   EXSR      SRZEdit
     C                   EVALR     RLB5G  = %TRIM(ZOut22)
 
     C**********         EVAL      TBVal  = B6LB1B                                          BUG26695
     C                   Z-ADD     B6LB1B        ZFld                                       BUG26695
     C                   EXSR      SRZEdit
     C                   EVALR     RLB1B  = %TRIM(ZOut22)
 
     C**********         EVAL      TBVal  = B6LB2B                                          BUG26695
     C                   Z-ADD     B6LB2B        ZFld                                       BUG26695
     C                   EXSR      SRZEdit
     C                   EVALR     RLB2B  = %TRIM(ZOut22)
 
     C**********         EVAL      TBVal  = B6LB3B                                          BUG26695
     C                   Z-ADD     B6LB3B        ZFld                                       BUG26695
     C                   EXSR      SRZEdit
     C                   EVALR     RLB3B  = %TRIM(ZOut22)
 
     C**********         EVAL      TBVal  = B6LB4B                                          BUG26695
     C                   Z-ADD     B6LB4B        ZFld                                       BUG26695
     C                   EXSR      SRZEdit
     C                   EVALR     RLB4B  = %TRIM(ZOut22)
 
      ** Write Detail
 
     C                   WRITE     DETAIL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREnd - Write trailer in report                              *
      *                                                               *
      *****************************************************************
 
     C     SREnd         BEGSR
 
     C                   EVAL      RqdLn1 = 4
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
      ** Write out report trailer.
 
     C                   WRITE     TRAILP1
 
      ** Write audit report.
 
     C                   EXSR      SRAudit
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZedit - Format Amount                                      *
      *                                                               *
      *****************************************************************
 
     C     SRZEdit       BEGSR
 
      ***Align*Decimal*position*(from*2*to*0*DP)*                                           BUG26695
      **********                                                                            BUG26695
     C**********         EVAL      WPos  = ZDec + 1                                         BUG26695
     C**********         EVAL      TChr =  %SUBST(NDec+TChr+MaxDec:WPos:18)                 BUG26695
     C**********         EVAL      ZFld  = TNum                                             BUG26695
 
     C                   EVAL      WSign = ' '                                              BUG26702
                                                                                            BUG26702
     C                   IF        ZFld < 0                                                 BUG26702
     C                   EVAL      WSign = '-'                                              BUG26702
     C                   ENDIF                                                              BUG26702
                                                                                            BUG26702
     C                   EVAL      ZFld = %ABS(ZFld)                                        BUG26702
                                                                                            BUG26702
      ** Format Input Amount field
 
     C                   CALL      'ZSEDITL'
     C                   PARM                    ZFLd
     C                   PARM                    ZDec
     C                   PARM      *BLANK        ZEdtC
     C                   PARM                    ZOut22
 
     C                   IF        WSign <> ' '                                             BUG26702
     C                   EVALR     ZOut22 = WSign + %TRIM(ZOut22)                           BUG26702
     C                   ENDIF                                                              BUG26702
                                                                                            BUG26702
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Write audit report                                 *
      *                                                               *
      *****************************************************************
 
     C     SRAudit       BEGSR
 
     C                   IF        *INU7   = *ON OR
     C                             WNoRec  = 0
 
     C                   OPEN      ER000198AU
 
      ** Ensure Audit Spool File recorded by RCF.
 
     C                   EVAL      ZSnumU = SFNUMU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILEU
     C                   PARM                    ZSnumU
     C                   PARM      *Blank        ZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   WRITE     HEADAU
 
      ** If there is a DB Error, Output the DB Error Information.
 
     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE
 
     C                   IF        WNoRec  = 0
 
      ** Or, if no records read, Output "No Details" message.
 
     C                   WRITE     NODTLS
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      *INLR ='1'
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
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *DTAARA       DEFINE                  LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error.
 
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Report Work fields.
 
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
**  CPY@
(c) Finastra International Limited 2004
