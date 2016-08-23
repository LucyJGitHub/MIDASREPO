     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Payment Charge Definition : List')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer module                                *
      *                                                               *
      *  FT000573 - Midas FT Payment Charges List                     *
      *                                                               *
      *  Function:  This module displays the details of each payment  *
      *             charge code                                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. BUG433             Date 05Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009  *CREATE    Date 05Jun00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG433 - Recompiled due to change in FTPCHGPD                *
      *  CFT009 - FT Fees and Charges                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Printer Overflow                                *
      *    02         Read on FTPCHGL0                                *
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
 
     FFTPCHGL0  IF   E           K DISK
     FFT000573P1O    E             PRINTER INFDS(SPOOL1) OFLIND(*IN01)
     FFT000573AUO    E             PRINTER INFDS(SPOOL2) OFLIND(*IN02)
 
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
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External data structure for currency codes
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for access programs, long data structure
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
 
     D @RUN            S              1
     D ReturnCode      S              7
     D Option          S              7
 
     D RSeq            S              5
     D Rent            S              3
     D Sfilp           S             10
     D Splno           S              6  0
     D Zerr            S              1
 
     ** Parameters for ZSFILE
 
     D  RptDtl         S              1
 
     D  BaseDec        S              1P 0
     D  OtherDec       S                   Like(BaseDec)
     D  CcyDec         S                   Like(BaseDec)
     D  @Rtcd          S              7
     D  @Optn          S                   Like(@Rtcd)
     D  CccyA          S                   Like(BJCYCD)
 
     D ZField          S             16
 
     D ZADec           S              1  0
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
 
     C     *Loval        SETLL     FTPCHGL0
     C                   READ      FTPCHGL0                               02
     C                   DOW       *In02 = *Off
 
     C                   EVAL      RptDtl = 'Y'
 
     C                   EVAL      CccyA    = BJCYCD
     C                   EXSR      Decimals
     C                   EVAL      BaseDec  = A6NBDP
 
     C                   EVAL      CccyA    = OTHCCY
     C                   EXSR      Decimals
     C                   EVAL      OtherDec = A6NBDP
 
      ** Move file fields into print fields
 
     C                   EXSR      File2Print
 
     C                   WRITE     Hdr573
 
     C                   READ      FTPCHGL0                               02
     C                   ENDDO
 
      ** Write trailer - 'End of report'
 
     C                   IF        RptDtl = 'Y'
     C                   WRITE     TRL574
     C                   ELSE
     C                   WRITE     NODTLS
     C                   ENDIF
 
     C                   SETON                                        LR
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
 
     C     File2Print    BEGSR
 
     C                   ADD       1             PagNbr
 
      * ================     Range 1 details     =====================
 
      * Base currency decimals
     C                   EVAL      CcyDec = BaseDec
 
      * Range Number
     C                   EVAL      Wrng1    = 1
 
      * Base Ccy
     C                   EVAL      WBccy1   = BJCYCD
 
      * Start Range Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SABC01        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WSMB1
 
      * End Range Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      EABC01        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WEMB1
 
      * Range Rate Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      RATE01        ZFIELD
     C                   EXSR      ZeditDec8
     C                   EVAL      WRMB1    = ZField
 
      * Pro-Mile Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      PMBC01        ZFIELD
     C                   EXSR      ZeditDec8
     C                   MOVE      ZFIELD        WPMB1
 
      * Minimum Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      MIBC01        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINBM1
 
      * Maximun Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      MXBC01        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXBM1
 
      * Range Start STP Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SSBC01        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WSSB1
 
      * Range End STP Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SSEC01        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WESB1
 
      * Range Rate STP Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SRAT01        ZFIELD
     C                   EXSR      ZeditDec8
     C                   EVAL      WRSB1    = ZField
 
      * STP Pro-Mile Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SPMB01        ZFIELD
     C                   EXSR      ZeditDec8
     C                   MOVE      ZFIELD        WPSB1
 
      * STP Minimum Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SMIB01        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINBS1
 
      * STP Maximum Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SMAB01        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXBS1
 
      * Other Currency
      * Other currency decimals
     C                   EVAL      CcyDec = OtherDec
 
     C                   EVAL      WOCCY1   = OTHCCY
 
      * Other Currency Start Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      STOC01        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WSMO1
 
      * Other Ccy End Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      ENOC01        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WEMO1
 
      * Other Ccy Minimum Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      MIOC01        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINOM1
 
      * Other Ccy Maximum Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      MAOC01        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXOM1
 
      * STP Other Ccy Range Start
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SSOC01        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WSSO1
 
      * STP Other Ccy Range End
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SEOC01        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WESO1
 
      * Other Ccy Minimum STP
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SMIO01        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINOS1
 
      * Other Ccy Maximum STP
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SMAC01        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXOS1
 
      * ================     Range 2 details     =====================
 
      * Base currency decimals
     C                   EVAL      CcyDec = BaseDec
 
      * Range Number
     C                   EVAL      Wrng2    = 2
 
      * Base Ccy
     C                   EVAL      WBccy2   = BJCYCD
 
      * Start Range Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SABC02        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WSMB2
 
      * End Range Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      EABC02        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WEMB2
 
      * Range Rate Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      RATE02        ZFIELD
     C                   EXSR      ZeditDec8
     C                   EVAL      WRMB2    = ZField
 
      * Pro-Mile Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      PMBC02        ZFIELD
     C                   EXSR      ZeditDec8
     C                   MOVE      ZFIELD        WPMB2
 
      * Minimum Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      MIBC02        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINBM2
 
      * Maximun Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      MXBC02        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXBM2
 
      * Range Start STP Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SSBC02        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WSSB2
 
      * Range End STP Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SSEC02        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WESB2
 
      * Range Rate STP Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SRAT02        ZFIELD
     C                   EXSR      ZeditDec8
     C                   EVAL      WRSB2    = ZField
 
      * STP Pro-Mile Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SPMB02        ZFIELD
     C                   EXSR      ZeditDec8
     C                   MOVE      ZFIELD        WPSB2
 
      * STP Minimum Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SMIB02        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINBS2
 
      * STP Maximum Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SMAB02        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXBS2
 
      * Other Currency
      * Other currency decimals
     C                   EVAL      CcyDec = OtherDec
 
     C                   EVAL      WOCCY2   = OTHCCY
 
      * Other Currency Start Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      STOC02        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WSMO2
 
      * Other Ccy End Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      ENOC02        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WEMO2
 
      * Other Ccy Minimum Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      MIOC02        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINOM2
 
      * Other Ccy Maximum Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      MAOC02        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXOM2
 
      * STP Other Ccy Range Start
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SSOC02        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WSSO2
 
      * STP Other Ccy Range End
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SEOC02        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WESO2
 
      * Other Ccy Minimum STP
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SMIO02        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINOS2
 
      * Other Ccy Maximum STP
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SMAC02        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXOS2
 
 
      * ================     Range 3 details     =====================
      * Base currency decimals
     C                   EVAL      CcyDec = BaseDec
 
      * Range Number
     C                   EVAL      Wrng3    = 3
 
      * Base Ccy
     C                   EVAL      WBccy3   = BJCYCD
 
      * Start Range Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SABC03        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WSMB3
 
      * End Range Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      EABC03        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WEMB3
 
      * Range Rate Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      RATE03        ZFIELD
     C                   EXSR      ZeditDec8
     C                   EVAL      WRMB3    = ZField
 
      * Pro-Mile Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      PMBC03        ZFIELD
     C                   EXSR      ZeditDec8
     C                   MOVE      ZFIELD        WPMB3
 
      * Minimum Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      MIBC03        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINBM3
 
      * Maximun Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      MXBC03        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXBM3
 
      * Range Start STP Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SSBC03        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WSSB3
 
      * Range End STP Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SSEC03        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WESB3
 
      * Range Rate STP Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SRAT03        ZFIELD
     C                   EXSR      ZeditDec8
     C                   EVAL      WRSB3    = ZField
 
      * STP Pro-Mile Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SPMB03        ZFIELD
     C                   EXSR      ZeditDec8
     C                   MOVE      ZFIELD        WPSB3
 
      * STP Minimum Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SMIB03        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINBS3
 
      * STP Maximum Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SMAB03        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXBS3
 
      * Other Currency
      * Other currency decimals
     C                   EVAL      CcyDec = OtherDec
 
     C                   EVAL      WOCCY3   = OTHCCY
 
      * Other Currency Start Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      STOC03        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WSMO3
 
      * Other Ccy End Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      ENOC03        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WEMO3
 
      * Other Ccy Minimum Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      MIOC03        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINOM3
 
      * Other Ccy Maximum Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      MAOC03        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXOM3
 
      * STP Other Ccy Range Start
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SSOC03        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WSSO3
 
      * STP Other Ccy Range End
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SEOC03        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WESO3
 
      * Other Ccy Minimum STP
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SMIO03        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINOS3
 
      * Other Ccy Maximum STP
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SMAC03        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXOS3
 
      * ================     Range 4 details     =====================
      * Base currency decimals
     C                   EVAL      CcyDec = BaseDec
 
      * Range Number
     C                   EVAL      Wrng4    = 4
 
      * Base Ccy
     C                   EVAL      WBccy4   = BJCYCD
 
      * Start Range Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SABC04        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WSMB4
 
      * End Range Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      EABC04        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WEMB4
 
      * Range Rate Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      RATE04        ZFIELD
     C                   EXSR      ZeditDec8
     C                   EVAL      WRMB4    = ZField
 
      * Pro-Mile Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      PMBC04        ZFIELD
     C                   EXSR      ZeditDec8
     C                   MOVE      ZFIELD        WPMB4
 
      * Minimum Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      MIBC04        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINBM4
 
      * Maximun Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      MXBC04        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXBM4
 
      * Range Start STP Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SSBC04        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WSSB4
 
      * Range End STP Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SSEC04        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WESB4
 
      * Range Rate STP Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SRAT04        ZFIELD
     C                   EXSR      ZeditDec8
     C                   EVAL      WRSB4    = ZField
 
      * STP Pro-Mile Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SPMB04        ZFIELD
     C                   EXSR      ZeditDec8
     C                   MOVE      ZFIELD        WPSB4
 
      * STP Minimum Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SMIB04        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINBS4
 
      * STP Maximum Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SMAB04        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXBS4
 
      * Other Currency
      * Other currency decimals
     C                   EVAL      CcyDec = OtherDec
 
     C                   EVAL      WOCCY4   = OTHCCY
 
      * Other Currency Start Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      STOC04        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WSMO4
 
      * Other Ccy End Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      ENOC04        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WEMO4
 
      * Other Ccy Minimum Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      MIOC04        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINOM4
 
      * Other Ccy Maximum Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      MAOC04        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXOM4
 
      * STP Other Ccy Range Start
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SSOC04        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WSSO4
 
      * STP Other Ccy Range End
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SEOC04        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WESO4
 
      * Other Ccy Minimum STP
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SMIO04        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINOS4
 
      * Other Ccy Maximum STP
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SMAC04        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXOS4
 
      * ================     Range 5 details     =====================
      * Base currency decimals
     C                   EVAL      CcyDec = BaseDec
 
      * Range Number
     C                   EVAL      Wrng5    = 5
 
      * Base Ccy
     C                   EVAL      WBccy5   = BJCYCD
 
      * Start Range Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SABC05        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WSMB5
 
      * End Range Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      EABC05        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WEMB5
 
      * Range Rate Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      RATE05        ZFIELD
     C                   EXSR      ZeditDec8
     C                   EVAL      WRMB5    = ZField
 
      * Pro-Mile Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      PMBC05        ZFIELD
     C                   EXSR      ZeditDec8
     C                   MOVE      ZFIELD        WPMB5
 
      * Minimum Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      MIBC05        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINBM5
 
      * Maximun Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      MXBC05        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXBM5
 
      * Range Start STP Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SSBC05        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WSSB5
 
      * Range End STP Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SSEC05        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WESB5
 
      * Range Rate STP Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SRAT05        ZFIELD
     C                   EXSR      ZeditDec8
     C                   EVAL      WRSB5    = ZField
 
      * STP Pro-Mile Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SPMB05        ZFIELD
     C                   EXSR      ZeditDec8
     C                   MOVE      ZFIELD        WPSB5
 
      * STP Minimum Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SMIB05        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINBS5
 
      * STP Maximum Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SMAB05        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXBS5
 
      * Other Currency
      * Other currency decimals
     C                   EVAL      CcyDec = OtherDec
 
     C                   EVAL      WOCCY5   = OTHCCY
 
      * Other Currency Start Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      STOC05        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WSMO5
 
      * Other Ccy End Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      ENOC05        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WEMO5
 
      * Other Ccy Minimum Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      MIOC05        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINOM5
 
      * Other Ccy Maximum Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      MAOC05        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXOM5
 
      * STP Other Ccy Range Start
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SSOC05        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WSSO5
 
      * STP Other Ccy Range End
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SEOC05        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WESO5
 
      * Other Ccy Minimum STP
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SMIO05        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINOS5
 
      * Other Ccy Maximum STP
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SMAC05        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXOS5
      * ================     Range 6 details     =====================
      * Base currency decimals
     C                   EVAL      CcyDec = BaseDec
 
      * Range Number
     C                   EVAL      Wrng6    = 6
 
      * Base Ccy
     C                   EVAL      WBccy6   = BJCYCD
 
      * Start Range Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SABC06        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WSMB6
 
      * End Range Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      EABC06        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WEMB6
 
      * Range Rate Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      RATE06        ZFIELD
     C                   EXSR      ZeditDec8
     C                   EVAL      WRMB6    = ZField
 
      * Pro-Mile Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      PMBC06        ZFIELD
     C                   EXSR      ZeditDec8
     C                   MOVE      ZFIELD        WPMB6
 
      * Minimum Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      MIBC06        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINBM6
 
      * Maximun Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      MXBC06        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXBM6
 
      * Range Start STP Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SSBC06        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WSSB6
 
      * Range End STP Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SSEC06        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WESB6
 
      * Range Rate STP Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SRAT06        ZFIELD
     C                   EXSR      ZeditDec8
     C                   EVAL      WRSB6    = ZField
 
      * STP Pro-Mile Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SPMB06        ZFIELD
     C                   EXSR      ZeditDec8
     C                   MOVE      ZFIELD        WPSB6
 
      * STP Minimum Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SMIB06        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINBS6
 
      * STP Maximum Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SMAB06        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXBS6
 
      * Other Currency
      * Other currency decimals
     C                   EVAL      CcyDec = OtherDec
 
     C                   EVAL      WOCCY6   = OTHCCY
 
      * Other Currency Start Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      STOC06        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WSMO6
 
      * Other Ccy End Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      ENOC06        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WEMO6
 
      * Other Ccy Minimum Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      MIOC06        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINOM6
 
      * Other Ccy Maximum Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      MAOC06        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXOM6
 
      * STP Other Ccy Range Start
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SSOC06        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WSSO6
 
      * STP Other Ccy Range End
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SEOC06        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WESO6
 
      * Other Ccy Minimum STP
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SMIO06        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINOS6
 
      * Other Ccy Maximum STP
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SMAC06        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXOS6
      * ================     Range 7 details     =====================
      * Base currency decimals
     C                   EVAL      CcyDec = BaseDec
 
      * Range Number
     C                   EVAL      Wrng7    = 7
 
      * Base Ccy
     C                   EVAL      WBccy7   = BJCYCD
 
      * Start Range Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SABC07        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WSMB7
 
      * End Range Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      EABC07        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WEMB7
 
      * Range Rate Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      RATE07        ZFIELD
     C                   EXSR      ZeditDec8
     C                   EVAL      WRMB7    = ZField
 
      * Pro-Mile Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      PMBC07        ZFIELD
     C                   EXSR      ZeditDec8
     C                   MOVE      ZFIELD        WPMB7
 
      * Minimum Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      MIBC07        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINBM7
 
      * Maximun Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      MXBC07        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXBM7
 
      * Range Start STP Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SSBC07        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WSSB7
 
      * Range End STP Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SSEC07        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WESB7
 
      * Range Rate STP Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SRAT07        ZFIELD
     C                   EXSR      ZeditDec8
     C                   EVAL      WRSB7    = ZField
 
      * STP Pro-Mile Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SPMB07        ZFIELD
     C                   EXSR      ZeditDec8
     C                   MOVE      ZFIELD        WPSB7
 
      * STP Minimum Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SMIB07        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINBS7
 
      * STP Maximum Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SMAB07        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXBS7
 
      * Other Currency
      * Other currency decimals
     C                   EVAL      CcyDec = OtherDec
 
     C                   EVAL      WOCCY7   = OTHCCY
 
      * Other Currency Start Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      STOC07        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WSMO7
 
      * Other Ccy End Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      ENOC07        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WEMO7
 
      * Other Ccy Minimum Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      MIOC07        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINOM7
 
      * Other Ccy Maximum Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      MAOC07        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXOM7
 
      * STP Other Ccy Range Start
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SSOC07        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WSSO7
 
      * STP Other Ccy Range End
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SEOC07        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WESO7
 
      * Other Ccy Minimum STP
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SMIO07        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINOS7
 
      * Other Ccy Maximum STP
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SMAC07        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXOS7
      * ================     Range 8 details     =====================
      * Base currency decimals
     C                   EVAL      CcyDec = BaseDec
 
      * Range Number
     C                   EVAL      Wrng8    = 8
 
      * Base Ccy
     C                   EVAL      WBccy8   = BJCYCD
 
      * Start Range Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SABC08        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WSMB8
 
      * End Range Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      EABC08        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WEMB8
 
      * Range Rate Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      RATE08        ZFIELD
     C                   EXSR      ZeditDec8
     C                   EVAL      WRMB8    = ZField
 
      * Pro-Mile Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      PMBC08        ZFIELD
     C                   EXSR      ZeditDec8
     C                   MOVE      ZFIELD        WPMB8
 
      * Minimum Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      MIBC08        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINBM8
 
      * Maximun Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      MXBC08        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXBM8
 
      * Range Start STP Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SSBC08        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WSSB8
 
      * Range End STP Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SSEC08        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WESB8
 
      * Range Rate STP Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SRAT08        ZFIELD
     C                   EXSR      ZeditDec8
     C                   EVAL      WRSB8    = ZField
 
      * STP Pro-Mile Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SPMB08        ZFIELD
     C                   EXSR      ZeditDec8
     C                   MOVE      ZFIELD        WPSB8
 
      * STP Minimum Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SMIB08        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINBS8
 
      * STP Maximum Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SMAB08        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXBS8
 
      * Other Currency
      * Other currency decimals
     C                   EVAL      CcyDec = OtherDec
 
     C                   EVAL      WOCCY8   = OTHCCY
 
      * Other Currency Start Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      STOC08        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WSMO8
 
      * Other Ccy End Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      ENOC08        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WEMO8
 
      * Other Ccy Minimum Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      MIOC08        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINOM8
 
      * Other Ccy Maximum Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      MAOC08        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXOM8
 
      * STP Other Ccy Range Start
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SSOC08        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WSSO8
 
      * STP Other Ccy Range End
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SEOC08        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WESO8
 
      * Other Ccy Minimum STP
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SMIO08        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINOS8
 
      * Other Ccy Maximum STP
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SMAC08        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXOS8
      * ================     Range 9 details     =====================
      * Base currency decimals
     C                   EVAL      CcyDec = BaseDec
 
      * Range Number
     C                   EVAL      Wrng9    = 9
 
      * Base Ccy
     C                   EVAL      WBccy9   = BJCYCD
 
      * Start Range Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SABC09        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WSMB9
 
      * End Range Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      EABC09        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WEMB9
 
      * Range Rate Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      RATE09        ZFIELD
     C                   EXSR      ZeditDec8
     C                   EVAL      WRMB9    = ZField
 
      * Pro-Mile Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      PMBC09        ZFIELD
     C                   EXSR      ZeditDec8
     C                   MOVE      ZFIELD        WPMB9
 
      * Minimum Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      MIBC09        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINBM9
 
      * Maximun Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      MXBC09        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXBM9
 
      * Range Start STP Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SSBC09        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WSSB9
 
      * Range End STP Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SSEC09        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WESB9
 
      * Range Rate STP Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SRAT09        ZFIELD
     C                   EXSR      ZeditDec8
     C                   EVAL      WRSB9    = ZField
 
      * STP Pro-Mile Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SPMB09        ZFIELD
     C                   EXSR      ZeditDec8
     C                   MOVE      ZFIELD        WPSB9
 
      * STP Minimum Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SMIB09        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINBS9
 
      * STP Maximum Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SMAB09        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXBS9
 
      * Other Currency
      * Other currency decimals
     C                   EVAL      CcyDec = OtherDec
 
     C                   EVAL      WOCCY9   = OTHCCY
 
      * Other Currency Start Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      STOC09        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WSMO9
 
      * Other Ccy End Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      ENOC09        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WEMO9
 
      * Other Ccy Minimum Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      MIOC09        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINOM9
 
      * Other Ccy Maximum Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      MAOC09        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXOM9
 
      * STP Other Ccy Range Start
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SSOC09        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WSSO9
 
      * STP Other Ccy Range End
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SEOC09        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WESO9
 
      * Other Ccy Minimum STP
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SMIO09        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINOS9
 
      * Other Ccy Maximum STP
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SMAC09        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXOS9
      * ================     Range 10 details    =====================
      * Base currency decimals
     C                   EVAL      CcyDec = BaseDec
 
      * Range Number
     C                   EVAL      Wrng0    = 10
 
      * Base Ccy
     C                   EVAL      WBccy0   = BJCYCD
 
      * Start Range Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SABC10        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WSMB0
 
      * End Range Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      EABC10        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WEMB0
 
      * Range Rate Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      RATE10        ZFIELD
     C                   EXSR      ZeditDec8
     C                   EVAL      WRMB0    = ZField
 
      * Pro-Mile Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      PMBC10        ZFIELD
     C                   EXSR      ZeditDec8
     C                   MOVE      ZFIELD        WPMB0
 
      * Minimum Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      MIBC10        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINBM0
 
      * Maximun Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      MXBC10        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXBM0
 
      * Range Start STP Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SSBC10        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WSSB0
 
      * Range End STP Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SSEC10        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WESB0
 
      * Range Rate STP Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SRAT10        ZFIELD
     C                   EXSR      ZeditDec8
     C                   EVAL      WRSB0    = ZField
 
      * STP Pro-Mile Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SPMB10        ZFIELD
     C                   EXSR      ZeditDec8
     C                   MOVE      ZFIELD        WPSB0
 
      * STP Minimum Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SMIB10        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINBS0
 
      * STP Maximum Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SMAB10        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXBS0
 
      * Other Currency
      * Other currency decimals
     C                   EVAL      CcyDec = OtherDec
 
     C                   EVAL      WOCCY0   = OTHCCY
 
      * Other Currency Start Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      STOC10        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WSMO0
 
      * Other Ccy End Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      ENOC10        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WEMO0
 
      * Other Ccy Minimum Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      MIOC10        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINOM0
 
      * Other Ccy Maximum Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      MAOC10        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXOM0
 
      * STP Other Ccy Range Start
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SSOC10        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WSSO0
 
      * STP Other Ccy Range End
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SEOC10        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WESO0
 
      * Other Ccy Minimum STP
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SMIO10        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINOS0
 
      * Other Ccy Maximum STP
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SMAC10        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXOS0
      * ================     Range OB details    =====================
      * Base currency decimals
     C                   EVAL      CcyDec = BaseDec
      * Range Number
     C                   EVAL      WrngZ    = 'OB'
 
 
      * Base Ccy
     C                   EVAL      WBccyZ   = BJCYCD
 
      * Range Rate Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      ORBC          ZFIELD
     C                   EXSR      ZeditDec8
     C                   EVAL      WRMBZ    = ZField
 
      * Pro-Mile Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      OPMAB         ZFIELD
     C                   EXSR      ZeditDec8
     C                   MOVE      ZFIELD        WPMBZ
 
      * Minimum Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      OMIBC         ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINBMZ
 
      * Maximun Manual Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      OMABC         ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXBMZ
 
      * Range Rate STP Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SORBC         ZFIELD
     C                   EXSR      ZeditDec8
     C                   EVAL      WRSBZ    = ZField
 
      * STP Pro-Mile Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SOPMAB        ZFIELD
     C                   EXSR      ZeditDec8
     C                   MOVE      ZFIELD        WPSBZ
 
      * STP Minimum Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SOMIBC        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINBSZ
 
      * STP Maximum Base Ccy
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SOMABC        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXBSZ
 
      * Other Currency
      * Other currency decimals
     C                   EVAL      CcyDec = OtherDec
 
     C                   EVAL      WOCCYZ   = OTHCCY
 
      * Other Ccy Minimum Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      OMIOC         ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINOMZ
 
      * Other Ccy Maximum Manual
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      OMAOC         ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXOMZ
 
      * Other Ccy Minimum STP
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SOMIOC        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMINOSZ
 
      * Other Ccy Maximum STP
     C                   Move      *Blanks       ZFIELD
     C                   MOVE      SOMAOC        ZFIELD
     C                   EXSR      Zedit
     C                   MOVE      ZFIELD        WMAXOSZ
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * Zedit   - use Zedit routine                                   *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Zedit         BEGSR
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    CcyDec
 
     C                   IF        ZField = '            0.00'
     C                   Eval      ZField = *Blanks
     C                   Endif
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * ZeditDec8    use Zedit routine                                *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     ZeditDec8     BEGSR
 
     C                   Eval      ZADec = 8
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
 
     C                   IF        ZField = '      0.00000000'
     C                   Eval      ZField = *Blanks
     C                   Endif
 
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * Clear_D - Clears Printer File Output Fields                   *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Clear_D       BEGSR
      *
     C                   EVAL      BJURPT   = *Blanks
     C                   EVAL      PYCHCD   = *Blanks
     C                   EVAL      CHDESC   = *Blanks
     C                   EVAL      VATLIN   = *Blanks
     C                   EVAL      CALCMD   = *Blanks
     C                   EVAL      STPCMD   = *Blanks
      *
     C                   EVAL      WRSO1    = *Zeros
      *
     C                   EVAL      WRNG1   = *Zeros
     C                   EVAL      WBCCY1  = *Blanks
     C                   EVAL      WSMB1   = *Blanks
     C                   EVAL      WEMB1   = *Blanks
     C                   EVAL      WRMB1   = *Zeros
     C                   EVAL      WPMB1   = *Blanks
     C                   EVAL      WMINBM1 = *Blanks
     C                   EVAL      WMAXBM1 = *Blanks
     C                   EVAL      WSSB1   = *Blanks
     C                   EVAL      WESB1   = *Blanks
     C                   EVAL      WRSB1   = *Zeros
     C                   EVAL      WPSB1   = *Blanks
     C                   EVAL      WMINBS1 = *Blanks
     C                   EVAL      WMAXBS1 = *Blanks
     C                   EVAL      WOCCY1  = *Blanks
     C                   EVAL      WSMO1   = *Blanks
     C                   EVAL      WEMO1   = *Blanks
     C                   EVAL      WRMO1   = *Zeros
     C                   EVAL      WMINOM1 = *Blanks
     C                   EVAL      WMAXOM1 = *Blanks
     C                   EVAL      WSSO1   = *Blanks
     C                   EVAL      WESO1   = *Blanks
     C                   EVAL      WRSO1   = *Zeros
     C                   EVAL      WPSO1   = *Blanks
     C                   EVAL      WMINOS1 = *Blanks
     C                   EVAL      WMAXOS1 = *Blanks
     C                   EVAL      WRNG2   = *Zeros
     C                   EVAL      WBCCY2  = *Blanks
     C                   EVAL      WSMB2   = *Blanks
     C                   EVAL      WEMB2   = *Blanks
     C                   EVAL      WRMB2   = *Zeros
     C                   EVAL      WPMB2   = *Blanks
     C                   EVAL      WMINBM2 = *Blanks
     C                   EVAL      WMAXBM2 = *Blanks
     C                   EVAL      WSSB2   = *Blanks
     C                   EVAL      WESB2   = *Blanks
     C                   EVAL      WRSB2   = *Zeros
     C                   EVAL      WPSB2   = *Blanks
     C                   EVAL      WMINBS2 = *Blanks
     C                   EVAL      WMAXBS2 = *Blanks
     C                   EVAL      WOCCY2  = *Blanks
     C                   EVAL      WSMO2   = *Blanks
     C                   EVAL      WEMO2   = *Blanks
     C                   EVAL      WRMO2   = *Zeros
     C                   EVAL      WMINOM2 = *Blanks
     C                   EVAL      WMAXOM2 = *Blanks
     C                   EVAL      WSSO2   = *Blanks
     C                   EVAL      WESO2   = *Blanks
     C                   EVAL      WRSO2   = *Zeros
     C                   EVAL      WPSO2   = *Blanks
     C                   EVAL      WMINOS2 = *Blanks
     C                   EVAL      WMAXOS2 = *Blanks
     C                   EVAL      WRNG3   = *Zeros
     C                   EVAL      WBCCY3  = *Blanks
     C                   EVAL      WSMB3   = *Blanks
     C                   EVAL      WEMB3   = *Blanks
     C                   EVAL      WRMB3   = *Zeros
     C                   EVAL      WPMB3   = *Blanks
     C                   EVAL      WMINBM3 = *Blanks
     C                   EVAL      WMAXBM3 = *Blanks
     C                   EVAL      WSSB3   = *Blanks
     C                   EVAL      WESB3   = *Blanks
     C                   EVAL      WRSB3   = *Zeros
     C                   EVAL      WPSB3   = *Blanks
     C                   EVAL      WMINBS3 = *Blanks
     C                   EVAL      WMAXBS3 = *Blanks
     C                   EVAL      WOCCY3  = *Blanks
     C                   EVAL      WSMO3   = *Blanks
     C                   EVAL      WEMO3   = *Blanks
     C                   EVAL      WRMO3   = *Zeros
     C                   EVAL      WMINOM3 = *Blanks
     C                   EVAL      WMAXOM3 = *Blanks
     C                   EVAL      WSSO3   = *Blanks
     C                   EVAL      WESO3   = *Blanks
     C                   EVAL      WRSO3   = *Zeros
     C                   EVAL      WPSO3   = *Blanks
     C                   EVAL      WMINOS3 = *Blanks
     C                   EVAL      WMAXOS3 = *Blanks
     C                   EVAL      WRNG4   = *Zeros
     C                   EVAL      WBCCY4  = *Blanks
     C                   EVAL      WSMB4   = *Blanks
     C                   EVAL      WEMB4   = *Blanks
     C                   EVAL      WRMB4   = *Zeros
     C                   EVAL      WPMB4   = *Blanks
     C                   EVAL      WMINBM4 = *Blanks
     C                   EVAL      WMAXBM4 = *Blanks
     C                   EVAL      WSSB4   = *Blanks
     C                   EVAL      WESB4   = *Blanks
     C                   EVAL      WRSB4   = *Zeros
     C                   EVAL      WPSB4   = *Blanks
     C                   EVAL      WMINBS4 = *Blanks
     C                   EVAL      WMAXBS4 = *Blanks
     C                   EVAL      WOCCY4  = *Blanks
     C                   EVAL      WSMO4   = *Blanks
     C                   EVAL      WEMO4   = *Blanks
     C                   EVAL      WRMO4   = *Zeros
     C                   EVAL      WMINOM4 = *Blanks
     C                   EVAL      WMAXOM4 = *Blanks
     C                   EVAL      WSSO4   = *Blanks
     C                   EVAL      WESO4   = *Blanks
     C                   EVAL      WRSO4   = *Zeros
     C                   EVAL      WPSO4   = *Blanks
     C                   EVAL      WMINOS4 = *Blanks
     C                   EVAL      WMAXOS4 = *Blanks
     C                   EVAL      WRNG5   = *Zeros
     C                   EVAL      WBCCY5  = *Blanks
     C                   EVAL      WSMB5   = *Blanks
     C                   EVAL      WEMB5   = *Blanks
     C                   EVAL      WRMB5   = *Zeros
     C                   EVAL      WPMB5   = *Blanks
     C                   EVAL      WMINBM5 = *Blanks
     C                   EVAL      WMAXBM5 = *Blanks
     C                   EVAL      WSSB5   = *Blanks
     C                   EVAL      WESB5   = *Blanks
     C                   EVAL      WRSB5   = *Zeros
     C                   EVAL      WPSB5   = *Blanks
     C                   EVAL      WMINBS5 = *Blanks
     C                   EVAL      WMAXBS5 = *Blanks
     C                   EVAL      WOCCY5  = *Blanks
     C                   EVAL      WSMO5   = *Blanks
     C                   EVAL      WEMO5   = *Blanks
     C                   EVAL      WRMO5   = *Zeros
     C                   EVAL      WMINOM5 = *Blanks
     C                   EVAL      WMAXOM5 = *Blanks
     C                   EVAL      WSSO5   = *Blanks
     C                   EVAL      WESO5   = *Blanks
     C                   EVAL      WRSO5   = *Zeros
     C                   EVAL      WPSO5   = *Blanks
     C                   EVAL      WMINOS5 = *Blanks
     C                   EVAL      WMAXOS5 = *Blanks
     C                   EVAL      WRNG6   = *Zeros
     C                   EVAL      WBCCY6  = *Blanks
     C                   EVAL      WSMB6   = *Blanks
     C                   EVAL      WEMB6   = *Blanks
     C                   EVAL      WRMB6   = *Zeros
     C                   EVAL      WPMB6   = *Blanks
     C                   EVAL      WMINBM6 = *Blanks
     C                   EVAL      WMAXBM6 = *Blanks
     C                   EVAL      WSSB6   = *Blanks
     C                   EVAL      WESB6   = *Blanks
     C                   EVAL      WRSB6   = *Zeros
     C                   EVAL      WPSB6   = *Blanks
     C                   EVAL      WMINBS6 = *Blanks
     C                   EVAL      WMAXBS6 = *Blanks
     C                   EVAL      WOCCY6  = *Blanks
     C                   EVAL      WSMO6   = *Blanks
     C                   EVAL      WEMO6   = *Blanks
     C                   EVAL      WRMO6   = *Zeros
     C                   EVAL      WMINOM6 = *Blanks
     C                   EVAL      WMAXOM6 = *Blanks
     C                   EVAL      WSSO6   = *Blanks
     C                   EVAL      WESO6   = *Blanks
     C                   EVAL      WRSO6   = *Zeros
     C                   EVAL      WPSO6   = *Blanks
     C                   EVAL      WMINOS6 = *Blanks
     C                   EVAL      WMAXOS6 = *Blanks
     C                   EVAL      WRNG7   = *Zeros
     C                   EVAL      WBCCY7  = *Blanks
     C                   EVAL      WSMB7   = *Blanks
     C                   EVAL      WEMB7   = *Blanks
     C                   EVAL      WRMB7   = *Zeros
     C                   EVAL      WPMB7   = *Blanks
     C                   EVAL      WMINBM7 = *Blanks
     C                   EVAL      WMAXBM7 = *Blanks
     C                   EVAL      WSSB7   = *Blanks
     C                   EVAL      WESB7   = *Blanks
     C                   EVAL      WRSB7   = *Zeros
     C                   EVAL      WPSB7   = *Blanks
     C                   EVAL      WMINBS7 = *Blanks
     C                   EVAL      WMAXBS7 = *Blanks
     C                   EVAL      WOCCY7  = *Blanks
     C                   EVAL      WSMO7   = *Blanks
     C                   EVAL      WEMO7   = *Blanks
     C                   EVAL      WRMO7   = *Zeros
     C                   EVAL      WMINOM7 = *Blanks
     C                   EVAL      WMAXOM7 = *Blanks
     C                   EVAL      WSSO7   = *Blanks
     C                   EVAL      WESO7   = *Blanks
     C                   EVAL      WRSO7   = *Zeros
     C                   EVAL      WPSO7   = *Blanks
     C                   EVAL      WMINOS7 = *Blanks
     C                   EVAL      WMAXOS7 = *Blanks
     C                   EVAL      WRNG8   = *Zeros
     C                   EVAL      WBCCY8  = *Blanks
     C                   EVAL      WSMB8   = *Blanks
     C                   EVAL      WEMB8   = *Blanks
     C                   EVAL      WRMB8   = *Zeros
     C                   EVAL      WPMB8   = *Blanks
     C                   EVAL      WMINBM8 = *Blanks
     C                   EVAL      WMAXBM8 = *Blanks
     C                   EVAL      WSSB8   = *Blanks
     C                   EVAL      WESB8   = *Blanks
     C                   EVAL      WRSB8   = *Zeros
     C                   EVAL      WPSB8   = *Blanks
     C                   EVAL      WMINBS8 = *Blanks
     C                   EVAL      WMAXBS8 = *Blanks
     C                   EVAL      WOCCY8  = *Blanks
     C                   EVAL      WSMO8   = *Blanks
     C                   EVAL      WEMO8   = *Blanks
     C                   EVAL      WRMO8   = *Zeros
     C                   EVAL      WMINOM8 = *Blanks
     C                   EVAL      WMAXOM8 = *Blanks
     C                   EVAL      WSSO8   = *Blanks
     C                   EVAL      WESO8   = *Blanks
     C                   EVAL      WRSO8   = *Zeros
     C                   EVAL      WPSO8   = *Blanks
     C                   EVAL      WMINOS8 = *Blanks
     C                   EVAL      WMAXOS8 = *Blanks
     C                   EVAL      WRNG9   = *Zeros
     C                   EVAL      WBCCY9  = *Blanks
     C                   EVAL      WSMB9   = *Blanks
     C                   EVAL      WEMB9   = *Blanks
     C                   EVAL      WRMB9   = *Zeros
     C                   EVAL      WPMB9   = *Blanks
     C                   EVAL      WMINBM9 = *Blanks
     C                   EVAL      WMAXBM9 = *Blanks
     C                   EVAL      WSSB9   = *Blanks
     C                   EVAL      WESB9   = *Blanks
     C                   EVAL      WRSB9   = *Zeros
     C                   EVAL      WPSB9   = *Blanks
     C                   EVAL      WMINBS9 = *Blanks
     C                   EVAL      WMAXBS9 = *Blanks
     C                   EVAL      WOCCY9  = *Blanks
     C                   EVAL      WSMO9   = *Blanks
     C                   EVAL      WEMO9   = *Blanks
     C                   EVAL      WRMO9   = *Zeros
     C                   EVAL      WMINOM9 = *Blanks
     C                   EVAL      WMAXOM9 = *Blanks
     C                   EVAL      WSSO9   = *Blanks
     C                   EVAL      WESO9   = *Blanks
     C                   EVAL      WRSO9   = *Zeros
     C                   EVAL      WPSO9   = *Blanks
     C                   EVAL      WMINOS9 = *Blanks
     C                   EVAL      WMAXOS9 = *Blanks
     C                   EVAL      WRNG0   = *Zeros
     C                   EVAL      WBCCY0  = *Blanks
     C                   EVAL      WSMB0   = *Blanks
     C                   EVAL      WEMB0   = *Blanks
     C                   EVAL      WRMB0   = *Zeros
     C                   EVAL      WPMB0   = *Blanks
     C                   EVAL      WMINBM0 = *Blanks
     C                   EVAL      WMAXBM0 = *Blanks
     C                   EVAL      WSSB0   = *Blanks
     C                   EVAL      WESB0   = *Blanks
     C                   EVAL      WRSB0   = *Zeros
     C                   EVAL      WPSB0   = *Blanks
     C                   EVAL      WMINBS0 = *Blanks
     C                   EVAL      WMAXBS0 = *Blanks
     C                   EVAL      WOCCY0  = *Blanks
     C                   EVAL      WSMO0   = *Blanks
     C                   EVAL      WEMO0   = *Blanks
     C                   EVAL      WRMO0   = *Zeros
     C                   EVAL      WMINOM0 = *Blanks
     C                   EVAL      WMAXOM0 = *Blanks
     C                   EVAL      WSSO0   = *Blanks
     C                   EVAL      WESO0   = *Blanks
     C                   EVAL      WRSO0   = *Zeros
     C                   EVAL      WPSO0   = *Blanks
     C                   EVAL      WMINOS0 = *Blanks
     C                   EVAL      WMAXOS0 = *Blanks
     C                   EVAL      WRNGZ   = *Zeros
     C                   EVAL      WBCCYZ  = *Blanks
     C                   EVAL      WSMBZ   = *Blanks
     C                   EVAL      WEMBZ   = *Blanks
     C                   EVAL      WRMBZ   = *Zeros
     C                   EVAL      WPMBZ   = *Blanks
     C                   EVAL      WMINBMZ = *Blanks
     C                   EVAL      WMAXBMZ = *Blanks
     C                   EVAL      WSSBZ   = *Blanks
     C                   EVAL      WESBZ   = *Blanks
     C                   EVAL      WRSBZ   = *Zeros
     C                   EVAL      WPSBZ   = *Blanks
     C                   EVAL      WMINBSZ = *Blanks
     C                   EVAL      WMAXBSZ = *Blanks
     C                   EVAL      WOCCYZ  = *Blanks
     C                   EVAL      WSMOZ   = *Blanks
     C                   EVAL      WEMOZ   = *Blanks
     C                   EVAL      WRMOZ   = *Zeros
     C                   EVAL      WMINOMZ = *Blanks
     C                   EVAL      WMAXOMZ = *Blanks
     C                   EVAL      WSSOZ   = *Blanks
     C                   EVAL      WESOZ   = *Blanks
     C                   EVAL      WRSOZ   = *Zeros
     C                   EVAL      WPSOZ   = *Blanks
     C                   EVAL      WMINOSZ = *Blanks
     C                   EVAL      WMAXOSZ = *Blanks
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * Decimals - get number of decimal places for currency          *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Decimals      BEGSR
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    CccyA
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   ENDSR
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
 
     C     *Entry        PLIST
     C                   PARM                    PARM1             1
     C                   PARM                    RSEQ              5
     C                   PARM                    RLEV              1
     C                   PARM                    RENT              3
 
      ** RCF Printer File
 
     C                   EVAL      Splno = Sfnum1
     C                   EVAL      Sfilp = Sfile1
 
     C                   CALL      'ZSFILE'
     C                   PARM                    Rseq
     C                   PARM                    Rent
     C                   PARM                    Sfilp
     C                   PARM                    Splno
     C                   PARM      *Blank        Zerr
 
      ** Database error
 
     C                   IF        ZERR = 'Y'
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7= *ON
     C                   EVAL      *INU8= *ON
     C                   EVAL      DBFILE =  'ZSFILE'
     C                   EVAL      DBKEY  =  SFILE1
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  '*INZSR'
     C                   OUT       LDA
     C                   WRITE     DBERROR
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** RCF Printer File : Audit Report
 
     C                   EVAL      Splno = Sfnum2
     C                   EVAL      Sfilp = Sfile2
 
     C                   CALL      'ZSFILE'
     C                   PARM                    Rseq
     C                   PARM                    Rent
     C                   PARM                    Sfilp
     C                   PARM                    Splno
     C                   PARM      *Blank        Zerr
 
      ** Database error
 
     C                   IF        ZERR = 'Y'
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7= *ON
     C                   EVAL      *INU8= *ON
     C                   EVAL      DBFILE =  'ZSFILE'
     C                   EVAL      DBKEY  =  SFILE1
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  002
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  '*INZSR'
     C                   OUT       LDA
     C                   WRITE     DBERROR
     C                   EXSR      *PSSR
     C                   ENDIF
      ** Retrieve bank details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *Blanks       ReturnCode
     C                   PARM      '*FIRST   '   Option
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        ReturnCode <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBKEY  =  '*FIRST'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  003
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  '*INZSR'
     C                   OUT       LDA
     C                   WRITE     DBERROR
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      #Pgm = 'FTC000573'
 
     C                   ENDSR
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
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        @RUN = *Blank
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *InU7 = *On
     C                   EVAL      *InU8 = *On
     C                   EVAL      *InLR = *On
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
