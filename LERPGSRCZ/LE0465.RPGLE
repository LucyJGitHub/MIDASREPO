     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Lending Trans. Ref. File Housekeeping')       *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Module                                  *
      *                                                               *
      *  LE0465 -  Drop Lending Transaction Reference Records         *
      *                                                               *
      *  Function:  This program will drop Lending Transaction        *
      *             Reference records from the file LETREFPD, if      *
      *             corresponding transaction no longer exists in     *
      *             the database                                      *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. AR674226           Date 04Dec19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG13339           Date 13Feb07               *
      *                 BUG13153           Date 25Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 03May06               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106  *CREATE    Date 01Aug04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR674226 - Manual transaction reached 999. Increase the size *
      *             of utilisation sequence no. and transaction       *
      *             sequence. (Child: AR674227)                       *
      *           - Applied for MD054782.                             *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  BUG13339 - Missing Title Heading                             *
      *  BUG13153 - Component LEC0465 failed                          *
      *  CSD027A - Conversion of customer number to alpha (post       *
      *            build 103). Recompiled.                            *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR      - Program exception error routine                 *
      *  SrProcessPrint - Process printing of dropped participant     *
      *  SrPrntBrch - Print per branch                                *
      *  SrPrtUnknwn- Print unknown transaction                       *
      *  SrWriteP1  - Print detail 1                                  *
      *  SrWriteP2  - Print detail 2                                  *
      *  SrWrtHeader- Print header                                    *
      *  SrDelDrop  - Drop participant distribution history           *
      *  SrWP1End   - Print Footer 1                                  *
      *  SrWP2End   - Print Footer 2                                  *
      *  *INZSR     - Initial routine                                 *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas LE Transaction References by Branch
     FLETREFL1  UF   E           K DISK    INFSR(*PSSR)
 
      ** Midas LE Facility file A record by PC ref
     FFCLTYL4   IF   E           K DISK    INFSR(*PSSR) PREFIX(Y)
 
      ** Midas LE Facility amendments by PC Reference
     FLEFCAMLC  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas LE Loans by PCRF
     FCLOANL5   IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas LE Loan Amendments by PC Reference
     FLOAMSL2   IF   E           K DISK    INFSR(*PSSR)
 
      **Midas LE Agg. Facility amendment to Authorised
     FLEAGAML6  IF   E           K DISK    INFSR(*PSSR) RENAME(LEFCAMPF:LEFCA2)
 
      ** Midas LE Adjustments to Accrued Interest by PCRF
     FLEADINL2  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas LE Accrued Margin Adjustments by PCRF
     FMTRA2     IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas LE Lending fees master detail inputs
     FLEFEEDL4  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas LE Fee adj. for fee accruals by PC Reference
     FLEFEADL3  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas LE Manual Transactions by PCRF
     FLEMNFUL8  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas LE Drop Lending Transaction Reference Record
     FLE0465P1  O    E             PRINTER INFDS(SPOOL1) INFSR(*PSSR)
     F                                     USROPN
 
      ** Unknown Transaction Reference Types on LETREFPD
     FLE0465P2  O    E             PRINTER INFDS(SPOOL2) INFSR(*PSSR)
     F                                     USROPN
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      ** Short Data Structure for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External data structure for Midas SD Bank details ICD file
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Long Data Structure for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External DS for Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** File Information Data Structure for LE0465P1
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
      ** File Information Data Structure for LE0465P2
     D SPOOL2          DS
     D  SFILE2                83     92
     D  SFNUM2               123    124B 0
     D  OFLLN2               188    189B 0
     D  PRTLN2               367    368B 0
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WDIFLN1         S              3  0 INZ(0)
     D WkPrintFlag     S              1A   INZ('N')
     D WkPrintFlag2    S              1A   INZ('N')
     D WkDtlFlag       S              1A   INZ('N')
     D WkPrevBRCA      S                   LIKE(BRCA)
     D WkPrevBRCA2     S                   LIKE(BRCA)
     D WkPrevTRTP      S                   LIKE(TRTP)
     D WkPrevTRTP2     S                   LIKE(TRTP)
     D WkToPrint       S              2A
 
      ** parameters for AOBANKRO
 
     D PRTCD           S              7A
     D POPTN           S              7A
     D PBranch         S              3A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
     ILEFCAMPF                                                                              AR674226
     I              SQNO                        FCSQNO                                      AR674226
     ILEFCA2                                                                                AR674226
     I              SQNO                        FGSQNO                                      AR674226
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Read all records from LETREFL1
 
     C     *LOVAL        SETLL     LETREFL1
 
     C                   READ      LETREFL1
                                                                                            BUG13339
     C                   EVAL      WkToPrint = 'P1'                                         BUG13339
     C                   DOW       NOT %EOF(LETREFL1)
 
     C                   IF        BRCA <> *BLANKS
 
      ** Process printing
 
     C                   EXSR      SrProcessPrint
 
     C                   ENDIF
 
     C                   READ      LETREFL1
     C                   ENDDO
 
      ** Print Footer
 
     C                   IF        WkDtlFlag = 'N'
     C                   OPEN      LE0465P1
     C                   EVAL      BRCA = *BLANKS
     C                   EXSR      SrWrtHeader
     C                   EVAL      *IN80 = *ON
     C                   EVAL      WkPrintFlag = 'Y'
     C                   ENDIF
 
      ** Footer 1
 
     C                   EXSR      SrWp1End
 
      ** Footer 1
 
     C                   EXSR      SrWp2End
 
      ** Program wrap up
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrProcessPrint - Process printing of dropped lending reference*
      *                  records                                      *
      *                                                               *
      *****************************************************************
     C     SrProcessPrintBEGSR
 
     C                   EVAL      WkToPrint = 'P1'
 
      ** Check transaction type
 
     C                   SELECT
     C                   WHEN      TRTP = 'FCIP'
     C     PCRF          CHAIN     FCLTYL4
 
     C                   WHEN      TRTP = 'FAMD FI' OR TRTP = 'FAMD FD' OR
     C                             TRTP = 'FAMD FR' OR TRTP = 'FAMD RC'
     C     PCRF          CHAIN     LEFCAMLC
     C                   IF        NOT %FOUND(LEFCAMLC)
     C     PCRF          CHAIN     LEAGAML6
     C                   ENDIF
 
     C                   WHEN      TRTP = 'CLIP'
     C     PCRF          CHAIN     CLOANL5
 
     C                   WHEN      TRTP = 'LOAM BC' OR TRTP = 'LOAM SC' OR
     C                             TRTP = 'LOAM LS' OR TRTP = 'LOAM SA' OR
     C                             TRTP = 'LOAM PI' OR TRTP = 'MAPY' OR
     C                             TRTP = 'RPSC' OR TRTP = 'PTPF'
     C     PCRF          CHAIN     LOAMSL2
 
     C                   WHEN      TRTP = 'AIAJ'
     C     PCRF          CHAIN     LEADINL2
 
     C                   WHEN      TRTP = 'AMAJ'
     C     PCRF          CHAIN     MTRA2
 
     C                   WHEN      TRTP = 'FEEM'
     C     PCRF          CHAIN     LEFEEDL4
 
     C                   WHEN      TRTP = 'FEAD' OR TRTP = 'FEST'
     C     PCRF          CHAIN     LEFEADL3
 
     C                   WHEN      TRTP = 'MLMTRAN'
     C     PCRF          CHAIN     LEMNFUL8
 
     C                   OTHER
 
      ** Print Unknown Transaction
 
     C                   EVAL      WkToPrint = 'P2'
 
     C                   EXSR      SrPrtUnknwn
 
     C                   ENDSL
 
      ** Print per branch
 
     C                   IF        NOT %FOUND AND WkToPrint = 'P1'
 
     C                   EXSR      SrPrntBrch
 
     C                   ENDIF
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrPrntBrch - Print per branch                                *
      *                                                               *
      *****************************************************************
     C     SrPrntBrch    BEGSR
 
     C                   IF        BRCA <> WkPrevBRCA
 
      ** Print Footer
 
     C                   EXSR      SrWp1End
 
      ** Open printer file
 
     C                   OPEN      LE0465P1
     C                   ENDIF
 
      ** Print report
 
     C                   EXSR      SrWriteP1
 
      ** Drop lending transaction reference records
 
     C                   EXSR      SrDelDrop
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrPrtUnknwn - Print unknown transaction                      *
      *                                                               *
      *****************************************************************
     C     SrPrtUnknwn   BEGSR
 
     C                   IF        BRCA <> WkPrevBRCA2
 
      ** Print Footer
 
     C                   EXSR      SrWp2End
 
      ** Open printer file
 
     C                   OPEN      LE0465P2
     C                   ENDIF
 
      ** Print report
 
     C                   EXSR      SrWriteP2
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrWriteP1 - Write the participants contribution history      *
      *              records that must be removed                     *
      *                                                               *
      *****************************************************************
     C     SrWriteP1     BEGSR
 
     C     OFLLN1        SUB       PRTLN1        WDIFLN1
     C                   IF        WDIFLN1  <= 2 OR WkPrintFlag = 'N'
     C                   EXSR      SrWrtHeader
     C                   ENDIF
 
      ** Move values
 
     C                   IF        TRTP <> WkPrevTRTP
     C                   EVAL      RTRTP = TRTP
     C                   EVAL      WkPrevTRTP = TRTP
     C                   ELSE
     C                   EVAL      RTRTP = *BLANKS
     C                   ENDIF
     C                   EVAL      RAREF = AREF
     C                   EVAL      RPCRF = PCRF
     C                   EVAL      RTDSC = TDSC
 
      ** Write P1 Header if required
 
     C     OFLLN1        SUB       PRTLN1        WDIFLN1
     C                   IF        WDIFLN1 <= 2
     C                   EXSR      SrWrtHeader
     C                   ENDIF
 
     C                   EVAL      WkPrintFlag = 'Y'
     C                   EVAL      WkDtlFlag = 'Y'
 
      ** Write detail
 
     C                   WRITE     DETLE1
 
      ** Save facility branch and set as previous branch
 
     C                   EVAL      WkPrevBRCA = BRCA
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrWriteP2 - Write unknown transactions                       *
      *                                                               *
      *****************************************************************
     C     SrWriteP2     BEGSR
 
     C     OFLLN2        SUB       PRTLN2        WDIFLN1
     C                   IF        WDIFLN1  <= 2 OR WkPrintFlag2 = 'N'
     C                   EXSR      SrWrtHeader
     C                   ENDIF
 
      ** Move values
 
     C                   IF        TRTP <> WkPrevTRTP2
     C                   EVAL      RTRTP2 = TRTP
     C                   EVAL      WkPrevTRTP2 = TRTP
     C                   ELSE
     C                   EVAL      RTRTP2 = *BLANKS
     C                   ENDIF
     C                   EVAL      RAREF2 = AREF
     C                   EVAL      RPCRF2 = PCRF
     C                   EVAL      RTDSC2 = TDSC
 
      ** Write P1 Header if required
 
     C     OFLLN2        SUB       PRTLN2        WDIFLN1
     C                   IF        WDIFLN1 <= 2
     C                   EXSR      SrWrtHeader
     C                   ENDIF
 
     C                   EVAL      WkPrintFlag2 = 'Y'
 
      ** Write detail
 
     C                   WRITE     DETLE2
 
      ** Save facility branch and set as previous branch
 
     C                   EVAL      WkPrevBRCA2 = BRCA
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrWrtHeader - Print Header                                   *
      *                                                               *
      *****************************************************************
     C     SrWrtHeader   BEGSR
 
     C                   IF        BRCA <> *BLANKS                                          BUG13153
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      BRCA          PBRANCH
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
 
      ** Data base error in file SDBRCHPD
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBKEY  = BRCA
     C                   EVAL      DBASE  = 3
      /COPY ZACPYSRC,DBFIELDS
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      BRCA = BRCA
     C                   EVAL      BRNM = A8BRNM
     C                   ENDIF
     C                   ENDIF                                                              BUG13153
 
     C                   SELECT
     C                   WHEN      WkToPrint = 'P1'
     C                   WRITE     HEADER
     C                   WHEN      WkToPrint = 'P2'
     C                   WRITE     HEADER2
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrWP1End - Print Footer                                      *
      *                                                               *
      *****************************************************************
     C     SrWP1End      BEGSR
 
     C                   IF        WkPrintFlag = 'Y'
 
     C     OFLLN1        SUB       PRTLN1        WDIFLN1
     C                   IF        WDIFLN1 <= 4
     C                   EXSR      SrWrtHeader
     C                   ENDIF
 
     C                   WRITE     TRAILPY
 
      ** Close printer file
 
     C                   CLOSE     LE0465P1
 
     C                   EVAL      WkPrintFlag = 'N'
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrWP2End - Print Footer                                      *
      *                                                               *
      *****************************************************************
     C     SrWP2End      BEGSR
 
     C                   IF        WkPrintFlag2 = 'Y'
 
     C     OFLLN2        SUB       PRTLN2        WDIFLN1
     C                   IF        WDIFLN1 <= 4
     C                   EXSR      SrWrtHeader
     C                   ENDIF
 
     C                   WRITE     TRAILPY2
 
      ** Close printer file
 
     C                   CLOSE     LE0465P2
 
     C                   EVAL      WkPrintFlag2 = 'N'
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDelDrop - Drop participant distribution history            *
      *                                                               *
      *****************************************************************
     C     SrDelDrop     BEGSR
 
     C** TEDDY           DELETE    LETREFD0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Set up Local Data Area
 
     C     *LOCK         IN        LDA
     C                   EVAL      DbFile = *BLANKS
     C                   EVAL      DbKey  = *BLANKS
     C                   EVAL      DbPGM  = *BLANKS
     C                   EVAL      DbPGM  = 'LE0465'
     C                   EVAL      Dbase  = *ZERO
     C                   OUT       LDA
 
      ** Get Bank ICD
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DbFile = 'SDBANKPD'
     C                   EVAL      Dbase = 1
     C                   EVAL      DbKey = '*FIRST'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
      /COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2005
