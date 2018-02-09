      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Payment charge defaults list')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer module                                *
      *                                                               *
      *  FT000575 - Midas FT Payment Charge Defaults : List           *
      *                                                               *
      *  Function:  This module displays the details of each payment  *
      *             default                                           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009  *CREATE    Date 05Jun00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CFT009 - FT Fees and Charges                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Printer Overflow                                *
      *    02         Read on FTPYCGL0                                *
      *    03         Read on SDCUSTLF                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * FILE2PRINT  - Moving file fields to print fields              *
      * *PSSR       - Error processing                                *
      * *INZSR      - Initialise                                      *
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
 
     FFTPYCGL0  IF   E           K DISK
     FSDCUSTLF  IF   E           K DISK
     FFT000575P1O    E             PRINTER OFLIND(*IN01) INFDS(SPOOL1)
     FFT000575AUO    E             PRINTER OFLIND(*IN02) INFDS(SPOOL2)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for bank details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External DS for access programs, short DS
      *
     D SPOOL1          DS
     D  Sfile1                83     92
     D  Sfnum1               123    124B 0
 
     D SPOOL2          DS
     D  Sfile2                83     92
     D  Sfnum2               123    124B 0
 
     ** Data for ZSFILE
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D SvCust          S                   Like(BBCUST)
 
     D @RUN            S              1
 
     D ReturnCode      S              7
     D Option          S              7
 
     ** Parameters for AOBANKR0
 
     D RSeq            S              5
     D Rent            S              3
     D Sfilp           S             10
     D Splno           S              6  0
     D Zerr            S              1    INZ(*Blank)
 
     ** Parameters for ZSFILE
 
     D  RptDtl         S              1
 
     D #Pgm            S             10
 
      *****************************************************************
 
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
 
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
     C     *Loval        Setll     FTPYCGL0
     C                   Read      FTPYCGL0                               02
 
     C                   If        *In02 = *Off
     C                   Eval      RptDtl = 'Y'
     C                   Endif
 
     C                   Dow       *In02 = *Off
 
      ** Move file fields into print fields
 
     C                   Exsr      File2Print
 
      ** Write header
     C   01              Exsr      Write_Hdr
 
      ** Write details
 
     C                   If        WCSGRCD <> *Blanks
     C                   Exsr      Write_Cus
     C                   Endif
 
     C   01              Exsr      Write_Hdr
     C                   Write     CHGH1
     C   01              Exsr      Write_Hdr
     C                   Write     CHGD1
     C   01              Exsr      Write_Hdr
     C                   Write     CHGH2
     C   01              Exsr      Write_Hdr
     C                   Write     CHGD2
     C   01              Exsr      Write_Hdr
     C                   Write     CHGH3
     C   01              Exsr      Write_Hdr
     C                   Write     CHGD3
     C   01              Exsr      Write_Hdr
     C                   Write     CHGH4
     C   01              Exsr      Write_Hdr
     C                   Write     CHGD4
     C   01              Exsr      Write_Hdr
     C                   Write     CHGH5
     C   01              Exsr      Write_Hdr
     C                   Write     CHGD5
     C   01              Exsr      Write_Hdr
     C                   Write     CHGH6
     C   01              Exsr      Write_Hdr
     C                   Write     CHGD6
     C   01              Exsr      Write_Hdr
     C                   Write     CHGH7
     C   01              Exsr      Write_Hdr
     C                   Write     CHGD7
 
 
     C                   Eval      *In01 = *On
 
     C                   Read      FTPYCGL0                               02
     C                   Enddo
 
      ** Write trailer - 'End of report'
 
     C                   If        RptDtl = 'Y'
     C                   Write     TRAILPY
     C                   Else
     C                   Add       1             PagNum
     C                   Write     HDR575
     C                   Write     NoDetl
     C                   Endif
 
     C                   Seton                                        LR
      /EJECT
      *****************************************************************
      *                                                               *
      * Write_Cus - Write customer details for customer group         *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Write_Cus     Begsr
 
     C     WCSGRCD       Setll     SDCUSTLF                               04
 
     C                   If        *In04
     C                   Write     CUSH1
     C                   Write     CUSH2
     C                   Endif
 
     C     WCSGRCD       ReadE     SDCUSTLF                               03
     C                   Dow       *In03 = *Off
 
     C                   If        *In01
     C                   Exsr      Write_Hdr
     C                   Write     CUSH1
     C                   Write     CUSH2
     C                   Endif
 
     C                   If        BBCUST <> SvCust
     C                   Write     CUSDET
     C                   Endif
 
     C                   Eval      SvCust = BBCUST
 
     C     WCSGRCD       ReadE     SDCUSTLF                               03
     C                   Enddo
 
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * FILE2PRINT - Moving file fields to print fields               *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     File2Print    Begsr
 
     C                   Eval      WBRANCH = BRANCH
     C                   Eval      WCUSTOM = CUSTOM
     C                   Eval      WTRNTYP = TRNTYP
     C                   Eval      WTRSBTY = TRSBTY
     C                   Eval      WCSGRCD = CSGRCD
     C                   Eval      WCURRCY = CURRCY
     C                   Eval      WPDESCR = PDESCR
     C                   Eval      WFXSPST = FXSPST
     C                   Eval      WPDOFCD = PDOFCD
     C                   Eval      WTXCHCD = TXCHCD
     C                   Eval      WCHCHRG = CHCHRG
     C                   Eval      WCABCHC = CABCHC
     C                   Eval      WSWSTCH = SWSTCH
     C                   Eval      WSWPRCH = SWPRCH
     C                   Eval      WMISCHG = MISCHG
     C                   Eval      WMISCH1 = MISCH1
     C                   Eval      WMISCH2 = MISCH2
     C                   Eval      WMISCH3 = MISCH3
     C                   Eval      WMISCH4 = MISCH4
     C                   Eval      WMISCH5 = MISCH5
     C                   Eval      WTRCMCH = TRCMCH
     C                   Eval      WFXCHCC = FXCHCC
     C                   Eval      WADVCHG = ADVCHG
     C                   Eval      WTELCHG = TELCHG
     C                   Eval      WCOLCHG = COLCHG
     C                   Eval      WCORCHG = CORCHG
     C                   Eval      WDEDCHG = DEDCHG
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Write_Hdr : Writes new header record on overflow              *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Write_Hdr     Begsr
 
     C                   Add       1             PagNum
     C                   Write     HDR575
     C                   Eval      *In01 = *Off
 
     C                   Endsr
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
 
     C     *INZSR        Begsr
 
     C     *Entry        Plist
     C                   Parm                    PARM1             1
     C                   Parm                    RSEQ              5
     C                   Parm                    RLEV              1
     C                   Parm                    RENT              3
 
      ** RCF : List
 
     C                   Eval      Splno = Sfnum1
     C                   Eval      Sfilp = Sfile1
 
     C                   Call      'ZSFILE'
     C                   Parm                    Rseq
     C                   Parm                    Rent
     C                   Parm                    Sfilp
     C                   Parm                    Splno
     C                   Parm                    Zerr
 
      ** Database error
 
     C                   If        ZERR = 'Y'
     C     *LOCK         IN        LDA
     C                   Eval      *INU7= *ON
     C                   Eval      *INU8= *ON
     C                   Eval      DBFILE =  'ZSFILE'
     C                   Eval      DBKEY  =  SFILE1
     C                   Eval      DBPGM  =  PSProcPgm
     C                   Eval      DBASE  =  001
     C                   Eval      DBMOD  =  PSProcMod
     C                   Eval      DBPROC =  '*INZSR'
     C                   OUT       LDA
     C                   Write     DBERROR
     C                   Exsr      *PSSR
     C                   Endif
 
      ** RCF : Audit
 
     C                   Eval      Splno = Sfnum2
     C                   Eval      Sfilp = Sfile2
 
     C                   Call      'ZSFILE'
     C                   Parm                    Rseq
     C                   Parm                    Rent
     C                   Parm                    Sfilp
     C                   Parm                    Splno
     C                   Parm                    Zerr
 
      ** Database error
 
     C                   If        ZERR = 'Y'
     C     *LOCK         IN        LDA
     C                   Eval      *INU7= *ON
     C                   Eval      *INU8= *ON
     C                   Eval      DBFILE =  'ZSFILE'
     C                   Eval      DBKEY  =  SFILE1
     C                   Eval      DBPGM  =  PSProcPgm
     C                   Eval      DBASE  =  002
     C                   Eval      DBMOD  =  PSProcMod
     C                   Eval      DBPROC =  '*INZSR'
     C                   OUT       LDA
     C                   Write     DBERROR
     C                   Exsr      *PSSR
     C                   Endif
      ** Retrieve bank details
 
     C                   CallB     'AOBANKR0'
     C                   Parm      *Blanks       ReturnCode
     C                   Parm      '*FIRST   '   Option
     C     SDBANK        Parm      SDBANK        DSFDY
 
      ** Database error
 
     C                   If        ReturnCode <> *Blanks
     C     *LOCK         IN        LDA
     C                   Eval      *INU7 = *ON
     C                   Eval      *INU8 = *ON
     C                   Eval      DBFILE =  'SDBANKPD'
     C                   Eval      DBKEY  =  '*FIRST'
     C                   Eval      DBPGM  =  PSProcPgm
     C                   Eval      DBASE  =  003
     C                   Eval      DBMOD  =  PSProcMod
     C                   Eval      DBPROC =  '*INZSR'
     C                   OUT       LDA
     C                   Write     DBERROR
     C                   Exsr      *PSSR
     C                   Endif
      *
 
     C                   Eval      #Pgm = 'FTC000575'
 
     C                   Eval      *In01 = *On
 
 
     C                   Endsr
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         Begsr
 
     C                   Dump
 
     C                   If        @RUN = *Blank
     C                   Eval      @RUN = 'Y'
 
     C                   CallB     'DBERRCTL'
 
     C                   Endif
 
     C                   Eval      *InU7 = *On
     C                   Eval      *InU8 = *On
     C                   Eval      *InLR = *On
     C                   Return
 
     C                   Endsr
 
      ********************************************************************
