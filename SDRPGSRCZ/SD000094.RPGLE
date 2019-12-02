     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Initialise CSD079 Files')                              *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000094 - Initialise CSD079 files                           *
      *                                                               *
      *  Function:  This program populates the files introduced by    *
      *  CSD079                                                       *
      *                                                               *
      *  Called By: SDC000094 - Initialise CSD079 files               *
      *                                                               *
      *  (c) Finastra International Limited 2007                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER071             Date 01Aug16               *
      *                 CER070             Date 19Aug14               *
      *                 CLE134             Date 01Aug12               *
      *                 CSD090             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG15874           Date 07Feb08               *
      *                 BUG14530*CREATE    Date 03Aug07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSD090 - Customer Segmentation (Recompile)                   *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG15874 - Initialize Customer extension files               *
      *  BUG14530 - Missing Details from customers existing prior to  *
      *             ECM Delivery/installation                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    nn         Function of Indicator                           *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
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
     FSDCUSTL0  IF   E           K DISK
 
     FSDCHEQL0  UF A E           K DISK
 
     FSDSAFEL0  UF A E           K DISK
 
     FSDCMRKL0  UF A E           K DISK
 
     FSDACUSL0  UF A E           K DISK
 
     FSDCFCDL0  UF A E           K DISK
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
 
     D CSD079          S              1A
     D S01425          S              1A
     D CSD008          S              1A
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
      *                                                                                     BUG15874
      *** Initialize Customer extension files                                               BUG15874
      *                                                                                     BUG15874
     C                   CALL      'SD91000A'                                               BUG15874
                                                                                            BUG15874
     C     *LOVAL        SETLL     SDCUSTL0
     C                   READ      SDCUSTL0
 
     C                   DOU       %EOF(SDCUSTL0)
 
     C                   IF        BGNXST = 'Y'
     C                   EXSR      SRCHEQ
     C                   ENDIF
 
     C                   EXSR      SRSAFE
     C                   EXSR      SRCMRK
 
     C                   IF        S01425 = 'Y'
     C                   EXSR      SRACUS
     C                   ENDIF
 
     C                   IF        CSD008 = 'Y'
     C                   EXSR      SRCFCD
     C                   ENDIF
 
     C                   READ      SDCUSTL0
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
     C                   Return
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRCHEQ - Initialise Customer Cheque Handling                 *
      *****************************************************************
     C     SRCHEQ        BEGSR
 
     C     BBCUST        CHAIN     SDCHEQL0
 
     C                   IF        NOT(%FOUND)
     C                   CLEAR                   SDCHEQPF
     C                   EVAL      SCCUST = BBCUST
     C                   EVAL      SCCSSN = BBCSSN
     C                   EVAL      SCCRNM = BBCRNM
     C                   EVAL      SCCRTN = BBCRTN
     C                   EVAL      SCCHTP = BBTYLC
     C                   EVAL      SCRECI = 'D'
 
     C                   WRITE     SDCHEQPF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRSAFE - Initialise Customer Safe Handling                   *
      *****************************************************************
     C     SRSAFE        BEGSR
 
     C     BBCUST        CHAIN     SDSAFEL0
 
     C                   IF        NOT(%FOUND)
     C                   CLEAR                   SDSAFEPF
     C                   EVAL      SACUST = BBCUST
     C                   EVAL      SACSSN = BBCSSN
     C                   EVAL      SACRNM = BBCRNM
     C                   EVAL      SACRTN = BBCRTN
     C                   EVAL      SACHTP = BBTYLC
 
     C                   WRITE     SDSAFEPF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRCMRK - Initialise Customer Marketing Groups                *
      *****************************************************************
     C     SRCMRK        BEGSR
 
     C     BBCUST        CHAIN     SDCMRKL0
 
     C                   IF        NOT(%FOUND)
     C                   CLEAR                   @D7REJA
     C                   EVAL      D7CUST = BBCUST
     C                   EVAL      D7LCD  = BJRDNB
     C                   EVAL      D7TYLC = BBTYLC
 
     C                   WRITE     @D7REJA
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRACUS - Initialise Additional Customer Details              *
      *****************************************************************
     C     SRACUS        BEGSR
 
     C     BBCUST        CHAIN     SDACUSL0
 
     C                   IF        NOT(%FOUND)
     C                   CLEAR                   @ACUSL0
     C                   EVAL      E5CUST = BBCUST
     C                   EVAL      E5LCD  = BJRDNB
     C                   EVAL      E5TYLC = BBTYLC
     C                   EVAL      E5CNA1 = BBCNA1
     C                   EVAL      E5CNA2 = BBCNA2
     C                   EVAL      E5CNA3 = BBCNA3
     C                   EVAL      E5CNA4 = BBCNA4
     C                   EVAL      E5CSSN = BBCSSN
     C                   EVAL      E5JATP = 'N'
 
     C                   WRITE     @ACUSL0
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRCFCD - Initialise Customer Fees Details                    *
      *****************************************************************
     C     SRCFCD        BEGSR
 
     C     BBCUST        CHAIN     SDCFCDL0
 
     C                   IF        NOT(%FOUND)
     C                   CLEAR                   @CFCDL0
     C                   EVAL      E6CUST = BBCUST
     C                   EVAL      E6LCD  = BJRDNB
     C                   EVAL      E6TYLC = BBTYLC
 
     C                   WRITE     @CFCDL0
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR  - Initialisation                                      *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Access Midas Module Details
 
     C                   CALL      'AOMMODR0'
     C                   PARM      '*MSG    '    PRTCD
     C                   PARM      '*FIRST  '    POPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
     C                   IF        PRTCD <> *BLANK
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   EXSR      SRERR
     C                   ENDIF
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG    '    PRTCD
     C                   PARM      '*FIRST  '    POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRTCD <> *BLANK
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   EXSR      SRERR
     C                   ENDIF
 
      ** Check if enhancement S01425 is on
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'S01425'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY  = 'S01425'
     C                   EVAL      DBASE  = 920
     C                   EXSR      SRERR
     C                   ENDIF
     C
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      S01425 = 'Y'
     C                   ELSE
     C                   EVAL      S01425 = 'N'
     C                   ENDIF
 
      ** Check if enhancement CSD008 is on
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSD008'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY  = 'CSD008'
     C                   EVAL      DBASE  = 921
     C                   EXSR      SRERR
     C                   ENDIF
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSD008 = 'Y'
     C                   ELSE
     C                   EVAL      CSD008 = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRERR - EXCEPTION ERRORS                                     *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
 
     C                   MOVEL     'SDCUSDUPD'   DBPGM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
 
      ** Terminate the Program
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
