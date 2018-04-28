     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas FT Initialisation utility for CFT009')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FT0009 - FT Initialisation Utility for CFT009 (SAR is on)    *
      *                                                               *
      *  Function:  This program initialises fields for CFT009        *
      *             enhancement.                                      *
      *                                                               *
      *  Called By: FTC0009 - Initialisation Utility for CFT009       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. BUG25230           Date 29Jul09               *
      *  Prev Amend No. CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 06Jul06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009  *CREATE    Date 28Mar01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG25230 - FTC0510 00001 failed. Apply fix 219564.           *
      *  219564 - Initialise field INCHGC and OPCHGC.                 *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    80         End of file indicator                           *
      *    90         Chain fail                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  Audit   - Output Audit report                                *
      *  InzInX  - Initialise new fields on the Incoming Payment      *
      *            Details Extension File                             *
      *  InzOtX  - Initialise new fields on the Outgoing Payment      *
      *            Details Extension File                             *
      *  SrInPay - Incoming Payment details processing                *
      *  SrOtPay - Outgoing Payment details processing                *
      *  WrtDetl - Subroutine to write a Detail record to the Report  *
      *  WrtEnd  - Subroutine to write End of Report                  *
      * *PSSR    - Program exception error routine                    *
      * *INZSR   - Program initialisation routine                     *
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
 
      ** Incoming Payment details file
     FINPAY     IF   E           K DISK    INFSR(*PSSR)
 
      ** Incoming Payment details extension file
     FINPAYXL0  UF A E           K DISK    INFSR(*PSSR)
 
      ** Outgoing Payment details file
     FOTPAY     IF   E           K DISK    INFSR(*PSSR)
 
      ** Outgoing Payment details extension file
     FOTPAYXL0  UF A E           K DISK    INFSR(*PSSR)
 
     FFT0009AU  O    E             PRINTER INFDS(SPOOLU)
     FFT0009P1  O    E             PRINTER INFDS(SPOOL1) USROPN
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------------
 
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** File Information Data Structure for FT0009AU
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
 
      ** File Information Data Structure for FT0009P1
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
      ** External data structure for Bank details
     D Sdbank        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for SAR details
     D Scsard        E DS                  EXTNAME(SCSARDPD)
 
      ** DS for Access Objects - short data structure
     D Dsfdy         E DS                  EXTNAME(Dsfdy)
 
      ** Externally described DS for Funds Transfer ICD details                               219564
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)                                  219564
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D RqdLn1          S              3S 0
     D DifLn1          S              3S 0
     D WOpenP1         S              1A
     D CFT014          S              1A
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C                   EXSR      SrInPay
 
     C                   EXSR      SrOtPay
 
     C                   EXSR      Audit
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInPay - Incoming Payment details processing                *
      *                                                               *
      *  Called By : Main Processing                                  *
      *  Calls     : InzInX, WrtEnd                                   *
      *                                                               *
      *****************************************************************
 
     C     SrInPay       BEGSR
 
      ** Reset report work fields, read first record from
      ** Incoming Payments file
 
     C                   EVAL      PRTLN1 = *ZERO
     C                   EVAL      RFile = 'INPAYDD  '
     C                   EVAL      WOpenP1 = 'N'
 
     C     *LOVAL        SETLL     INPAY
     C                   READ      INPAYDDF                               80
 
     C                   IF        *IN80 = *OFF
     C                   OPEN      FT0009P1
     C                   WRITE     HEADP1
     C                   EVAL      WOpenP1 = 'Y'
     C                   ENDIF
 
      ** Do until file end: count number of records read, and
      ** initialise new fields on the extension file
 
     C                   DOW       *IN80 = *OFF
 
     C                   ADD       1             RCntI
     C                   EXSR      InzInX
     C                   READ      INPAYDDF                               80
 
     C                   ENDDO
 
      ** Write final record and End of report
 
     C                   IF        WOpenP1 = 'Y'
     C                   EXSR      WrtEnd
     C                   CLOSE     FT0009P1
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  InzInX - Initialise new fields on the Incoming Payment       *
      *           Details Extension File                              *
      *                                                               *
      *  Called By : SrInPay                                          *
      *  Calls     : WrtDetl                                          *
      *                                                               *
      *****************************************************************
 
     C     InzInX        BEGSR
 
     C     PREF          CHAIN     INPAYXDF                           90
 
      ** Initialise the new fields introduced by CFT009
 
     C                   If        PMode   = '1' OR
     C                             PMode   = '2' AND INCHGC = *Blanks
     C                   EVAL      INRECI  = RECI
     C                   EVAL      FXSPSC  = *BLANKS
     C                   EVAL      INPDOF  = *BLANKS
     C                   EVAL      TLCODE  = *BLANKS
     C                   EVAL      CHCHCD  = *BLANKS
     C                   EVAL      ADCHCD  = *BLANKS
     C                   EVAL      TLCHCD  = *BLANKS
     C                   EVAL      MISCH   = *BLANKS
     C                   EVAL      MSCH1   = *BLANKS
     C                   EVAL      MSCH2   = *BLANKS
     C                   EVAL      MSCH3   = *BLANKS
     C                   EVAL      MSCH4   = *BLANKS
     C                   EVAL      MSCH5   = *BLANKS
     C                   EVAL      TFCCCO  = *BLANKS
     C                   EVAL      FXCHEC  = *BLANKS
     C                   EVAL      VTMIC1  = *BLANK
     C                   EVAL      VTMIC2  = *BLANK
     C                   EVAL      VTMIC3  = *BLANK
     C                   EVAL      VTMIC4  = *BLANK
     C                   EVAL      VTMIC5  = *BLANK
     C                   EVAL      MSC01   = *ZERO
     C                   EVAL      MSC02   = *ZERO
     C                   EVAL      MSC03   = *ZERO
     C                   EVAL      MSC04   = *ZERO
     C                   EVAL      MSC05   = *ZERO
     C                   EVAL      DATNOE  = *ZERO
     C                   EVAL      DATNAH  = *ZERO
     C                   EVAL      CUNFLG  = *BLANK
     C                   EVAL      INCHRT  = *ZERO
     C                   EVAL      INCHGC  = *BLANKS
      *                                                                                       219564
      **Charge currency                                                                       219564
      *                                                                                       219564
     C                   SELECT                                                               219564
      *                                                                                       219564
     C                   WHEN      BTCHCY = 'C'                                               219564
     C                   IF        ADDC = 'A'                                                 219564
     C                   EVAL      INCHGC = SMCY                                              219564
     C                   ELSE                                                                 219564
     C                   EVAL      INCHGC = PCCY                                              219564
     C                   ENDIF                                                                219564
      *                                                                                       219564
     C                   WHEN      BTCHCY = 'L'                                               219564
     C                   EVAL      INCHGC = BJLCCY                                            219564
      *                                                                                       219564
     C                   OTHER                                                                219564
     C                   EVAL      INCHGC = BJCYCD                                            219564
     C                   ENDSL                                                                219564
      *                                                                                       219564
     C                   EVAL      CMSC01  = *ZERO
     C                   EVAL      CMSC02  = *ZERO
     C                   EVAL      CMSC03  = *ZERO
     C                   EVAL      CMSC04  = *ZERO
     C                   EVAL      CMSC05  = *ZERO
 
      ** If CFT014 is not installed, initialise the fields
      ** introduced by CFT014
 
     C                   IF        CFT014 = 'N'
     C                   EVAL      INBOCD = *BLANKS
     C                   EVAL      INICD1 = *BLANKS
     C                   EVAL      INICD2 = *BLANKS
     C                   EVAL      INICD3 = *BLANKS
     C                   EVAL      INICD4 = *BLANKS
     C                   EVAL      INICD5 = *BLANKS
     C                   EVAL      INTTCD = *BLANKS
     C                   EVAL      INOEXR = *ZERO
     C                   EVAL      INTRIT = *BLANK
     C                   EVAL      INTRIB = *BLANKS
     C                   EVAL      INTRN  = *BLANK
     C                   EVAL      INTRI1 = *BLANKS
     C                   EVAL      INTRI2 = *BLANKS
     C                   EVAL      INTRI3 = *BLANKS
     C                   EVAL      INTRI4 = *BLANKS
     C                   EVAL      INTRI5 = *BLANKS
     C                   EVAL      INSCH1 = *ZERO
     C                   EVAL      INSCH2 = *ZERO
     C                   EVAL      INSCH3 = *ZERO
     C                   EVAL      INSCH4 = *ZERO
     C                   EVAL      INSCH5 = *ZERO
     C                   EVAL      INSCY1 = *BLANKS
     C                   EVAL      INSCY2 = *BLANKS
     C                   EVAL      INSCY3 = *BLANKS
     C                   EVAL      INSCY4 = *BLANKS
     C                   EVAL      INSCY5 = *BLANKS
     C                   EVAL      INRCRM = *ZERO
     C                   EVAL      INRCNW = *ZERO
     C                   EVAL      INRCCN = *BLANKS
     C                   EVAL      INRCUS = *BLANK
     C                   EVAL      INRRP1 = *BLANKS
     C                   EVAL      INRRP2 = *BLANKS
     C                   EVAL      INRRP3 = *BLANKS
     C                   EVAL      INFRNT = FRNT
     C                   EVAL      INREPA = REPA
     C                   EVAL      INTMST = TMST
     C                   ENDIF
 
      ** Update record if it exists in the extension file
 
     C                   IF        *IN90 = *OFF
     C                   UPDATE    INPAYXDF
     C                   EVAL      RActn = 'A'
 
      ** Write new record if none exists yet
 
     C                   ELSE
     C                   EVAL      INPREF = PREF
     C                   EVAL      INSETM = *BLANK
     C                   EVAL      INSTPI = *BLANK
     C                   EVAL      INAUTO = 'N'
     C                   EVAL      INBANO = *BLANK
     C                   EVAL      INRUSR = *BLANK
     C                   EVAL      INWSID = *BLANK
     C                   EVAL      INRDAT = *BLANK
     C                   WRITE     INPAYXDF
     C                   EVAL      RActn = 'I'
     C                   ENDIF
 
      ** Print the record on the report
 
     C                   EXSR      WrtDetl
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrOtPay - Outgoing Payment details processing                *
      *                                                               *
      *  Called By : Main Processing                                  *
      *  Calls     : InzOtX, WrtEnd                                   *
      *                                                               *
      *****************************************************************
 
     C     SrOtPay       BEGSR
 
      ** Reset report work fields, read first record from
      ** Outgoing Payments file
 
     C                   EVAL      PRTLN1 = *ZERO
     C                   EVAL      RFile = 'OTPAYDD  '
     C                   EVAL      WOpenP1 = 'N'
 
     c     *LOVAL        SETLL     OTPAY
     C                   READ      OTPAYDDF                               80
 
     C                   IF        *IN80 = *OFF
     C                   OPEN      FT0009P1
     C                   WRITE     HEADP1
     C                   EVAL      WOpenP1 = 'Y'
     C                   ENDIF
 
      ** Do until file end: count number of records read, and
      ** initialise new fields on the extension file
 
     C                   DOW       *IN80 = *OFF
 
     C                   ADD       1             RCntO
     C                   EXSR      InzOtX
     C                   READ      OTPAYDDF                               80
 
     C                   ENDDO
 
      ** Write final record and End of report
 
     C                   IF        WOpenP1 = 'Y'
     C                   EXSR      WrtEnd
     C                   CLOSE     FT0009P1
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  InzOtX - Initialise new fields on the Outgoing Payment       *
      *           Details Extension File                              *
      *                                                               *
      *  Called By : SrOtPay                                          *
      *  Calls     : WrtDetl                                          *
      *                                                               *
      *****************************************************************
 
     C     InzOtX        BEGSR
 
     C     PREF          CHAIN     OTPAYXDF                           90
 
      ** Initialise the new fields introduced by CFT009
 
     C                   If        PMode  = '1'  OR
     C                             PMode  = '2' AND OPCHGC = *Blanks
     C                   EVAL      OPRECI = RECI
     C                   EVAL      FXSRSC = *BLANKS
     C                   EVAL      OTPDOF = *BLANKS
     C                   EVAL      TLXCDE = *BLANKS
     C                   EVAL      CHQCHC = *BLANKS
     C                   EVAL      CACHCD = *BLANKS
     C                   EVAL      SSTCCD = *BLANKS
     C                   EVAL      SPRCCD = *BLANKS
     C                   EVAL      MSCHC  = *BLANKS
     C                   EVAL      MSCHC1 = *BLANKS
     C                   EVAL      MSCHC2 = *BLANKS
     C                   EVAL      MSCHC3 = *BLANKS
     C                   EVAL      MSCHC4 = *BLANKS
     C                   EVAL      MSCHC5 = *BLANKS
     C                   EVAL      TFCCCD = *BLANKS
     C                   EVAL      FXCACC = *BLANKS
     C                   EVAL      VTSWSC = *BLANK
     C                   EVAL      VMIC1  = *BLANK
     C                   EVAL      VMIC2  = *BLANK
     C                   EVAL      VMIC3  = *BLANK
     C                   EVAL      VMIC4  = *BLANK
     C                   EVAL      VMIC5  = *BLANK
     C                   EVAL      MISC01 = *ZERO
     C                   EVAL      MISC02 = *ZERO
     C                   EVAL      MISC03 = *ZERO
     C                   EVAL      MISC04 = *ZERO
     C                   EVAL      MISC05 = *ZERO
     C                   EVAL      SWSCHG = *ZERO
     C                   EVAL      DATNED = *ZERO
     C                   EVAL      DATNAO = *ZERO
     C                   EVAL      CUNFLA = *BLANK
     C                   EVAL      OPCHRT = *ZERO
     C                   EVAL      OPCHGC = *BLANKS
      *                                                                                       219564
      **Charge currency                                                                       219564
      *                                                                                       219564
     C                   SELECT                                                               219564
      *                                                                                       219564
     C                   WHEN      BTCHCY = 'C'                                               219564
     C                   IF        ADDC = 'A'                                                 219564
     C                   EVAL      OPCHGC = SMCY                                              219564
     C                   ELSE                                                                 219564
     C                   EVAL      OPCHGC = PCCY                                              219564
     C                   ENDIF                                                                219564
      *                                                                                       219564
     C                   WHEN      BTCHCY = 'L'                                               219564
     C                   EVAL      OPCHGC = BJLCCY                                            219564
      *                                                                                       219564
     C                   OTHER                                                                219564
     C                   EVAL      OPCHGC = BJCYCD                                            219564
     C                   ENDSL                                                                219564
      *                                                                                       219564
     C                   EVAL      MISCC1 = *ZERO
     C                   EVAL      MISCC2 = *ZERO
     C                   EVAL      MISCC3 = *ZERO
     C                   EVAL      MISC04 = *ZERO
     C                   EVAL      MISC05 = *ZERO
     C                   EVAL      SWSCCC = *ZERO
 
      ** If CFT014 is not installed, initialise the fields
      ** introduced by CFT014
 
     C                   IF        CFT014 = 'N'
     C                   EVAL      OPBOCD = *BLANKS
     C                   EVAL      OPICD1 = *BLANKS
     C                   EVAL      OPICD2 = *BLANKS
     C                   EVAL      OPICD3 = *BLANKS
     C                   EVAL      OPICD4 = *BLANKS
     C                   EVAL      OPICD5 = *BLANKS
     C                   EVAL      OPTTCD = *BLANKS
     C                   EVAL      OPOEXR = *ZERO
     C                   EVAL      OPTRIT = *BLANK
     C                   EVAL      OPTRI1 = *BLANKS
     C                   EVAL      OPTRI2 = *BLANKS
     C                   EVAL      OPTRI3 = *BLANKS
     C                   EVAL      OPTRI4 = *BLANKS
     C                   EVAL      OPTRI5 = *BLANKS
     C                   EVAL      OPSCH1 = *ZERO
     C                   EVAL      OPSCH2 = *ZERO
     C                   EVAL      OPSCH3 = *ZERO
     C                   EVAL      OPSCH4 = *ZERO
     C                   EVAL      OPSCH5 = *ZERO
     C                   EVAL      OPSCC1 = *BLANKS
     C                   EVAL      OPSCC2 = *BLANKS
     C                   EVAL      OPSCC3 = *BLANKS
     C                   EVAL      OPSCC4 = *BLANKS
     C                   EVAL      OPSCC5 = *BLANKS
     C                   EVAL      OPSCLE = *ZERO
     C                   EVAL      OPRCRM = *ZERO
     C                   EVAL      OPRBCQ = *ZERO
     C                   EVAL      OPRCSC = *ZERO
     C                   EVAL      OPRCSQ = *ZERO
     C                   EVAL      OPRCNW = *ZERO
     C                   EVAL      OPRCCN = *BLANK
     C                   EVAL      OPRCUS = *BLANK
     C                   EVAL      OPRRP1 = *BLANK
     C                   EVAL      OPRRP2 = *BLANK
     C                   EVAL      OPRRP3 = *BLANK
     C                   EVAL      OPFRNT = FRNT
     C                   EVAL      OPREPA = REPA
     C                   EVAL      OPTMST = TMST
     C                   ENDIF
 
      ** Update record if it exists in the extension file
 
     C                   IF        *IN90 = *OFF
     C                   UPDATE    OTPAYXDF
     C                   EVAL      RActn = 'A'
 
      ** Write new record if none exists yet
 
     C                   ELSE
     C                   EVAL      OPPREF = PREF
     C                   EVAL      OPBJPR = *BLANKS
     C                   EVAL      OPAUTO = 'N'
     C                   EVAL      OPSTPI = *BLANK
     C                   EVAL      OPBANO = *BLANKS
     C                   EVAL      OPRUSR = *BLANKS
     C                   EVAL      OPWSID = *BLANKS
     C                   EVAL      OPRDAT = *BLANKS
     C                   MOVE      STMT          OPSETM
     C                   WRITE     OTPAYXDF
     C                   EVAL      RActn = 'I'
     C                   ENDIF
 
      ** Print the record on the report
 
     C                   EXSR      WrtDetl
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  WrtDetl - Subroutine to write a Detail record to the Report  *
      *                                                               *
      *  Called By : InzInX, InzOtX                                   *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
 
     C     WrtDetl       BEGSR
 
     C                   EVAL      RPref = PREF
     C                   EVAL      RStat = *BLANKS
 
     C                   SELECT
 
     C                   WHEN      RECI = 'D'
     C                   EVAL      RStat = 'LIVE'
 
     C                   WHEN      RECI = 'M'
     C                   EVAL      RStat = 'MATURED'
 
     C                   WHEN      RECI = 'C'
     C                   EVAL      RStat = 'DELETED'
 
     C                   ENDSL
 
      ** Check that sufficient lines remain for the Format.  If not,
      ** write out the Main Headings on a new page
 
     C                   Z-ADD     1             RqdLn1
     C     OFLLN1        SUB       PRTLN1        DifLn1
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
      ** Write out Detail Record
 
     C                   WRITE     DETAIL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  WrtEnd - Subroutine to write End of Report                   *
      *                                                               *
      *  Called By : SrInPay, SrOtPay                                 *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
 
     C     WrtEnd        BEGSR
 
      ** Check that sufficient lines remain for the Format.  If not,
      ** write out the Main Headings on a new page
 
     C                   Z-ADD     4             RqdLn1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
      ** Write out Total Format
 
     C                   WRITE     TRAILP1
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Audit - Output Audit report                                  *
      *                                                               *
      *  Called By : Main Processing, *PSSR                           *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
 
     C     Audit         BEGSR
 
      ** Output Report Header
 
     C                   WRITE     HEADAU
 
      ** If there is a DB Error, Output the DB Error Information
 
     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE
 
      ** Or, if no records read, output "No Details" message
 
     C                   IF        RCntI = 0 AND RCntO = 0
     C                   WRITE     NODTLS
     C                   ELSE
 
      ** Output Report Header and File Controls
 
     C                   WRITE     CONTROL
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program initialisation routine                       *
      *                                                               *
      *  Called by : Implicitly on program activation                 *
      *  Calls     : AOBANKR0, AOSARDR0, *PSSR                        *
      *                                                               *
      *****************************************************************
 
     C     *Inzsr        BEGSR
 
     C     *ENTRY        PLIST
     C                   Parm                    PMode             1
 
     C     *LOCK         IN        LDA
     C                   EVAL      Dbpgm = 'FT0009    '
     C                   OUT       LDA
 
      ** Retrieve Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     Sdbank        PARM      Sdbank        Dsfdy
 
     C                   IF        @RtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      Dbfile = 'SDBANKPD'
     C                   EVAL      Dbkey = '*FIRST'
     C                   EVAL      Dbase = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access SAR details for STP Phase 2 MT103 for Funds Transfer
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*VERIFY'     @Optn
     C                   PARM      'CFT014'      @Sard
     C     Scsard        PARM      Scsard        Dsfdy
 
     C                   IF        @RtCd <> *BLANKS AND
     C                             @RtCd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      Dbfile = 'SCSARDPD'
     C                   EVAL      Dbkey = 'CFT014'
     C                   EVAL      Dbase = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        @RtCd = *BLANKS
     C                   EVAL      CFT014 = 'Y'
     C                   ELSE
     C                   EVAL      CFT014 = 'N'
     C                   ENDIF
      *                                                                                       219564
      ** Access Funds Transfer ICD details.                                                   219564
      *                                                                                       219564
     C                   CALL      'AOFTFRR0'                                                 219564
     C                   PARM      *BLANKS       @RtCd                                        219564
     C                   PARM      '*FIRST '     @Optn                                        219564
     C     SDFTFR        PARM      SDFTFR        Dsfdy                                        219564
      *                                                                                       219564
      ** Database error.                                                                      219564
      *                                                                                       219564
     C                   IF        @RtCd <> *BLANKS                                           219564
     C     *LOCK         IN        LDA                                                        219564
     C                   EVAL      Dbfile = 'SDFTFRPD'                                        219564
     C                   EVAL      Dbkey = '*FIRST'                                           219564
     C                   EVAL      Dbase = 3                                                  219564
     C                   OUT       LDA                                                        219564
     C                   EXSR      *PSSR                                                      219564
     C                   ENDIF                                                                219564
 
      ** Report work fields
 
     C                   Z-ADD     0             RCntI
     C                   Z-ADD     0             RCntO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *                                                               *
      *  Called By : None                                             *
      *  Calls     : Audit                                            *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
 
      ** Check to see that *PSSR has not already been called
 
     C                   IF        RunBefore = *BLANK
     C                   EVAL      RunBefore = 'Y'
     C                   EXSR      Audit
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
