     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD US Treaty WTax Info and Cust Ext C Init')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000555 - US Treaty Witholding Tax Info / Cust Details      *
      *                Extension C Initialisation                     *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD054605           Date 17Oct19               *
      *                 MD050212           Date 02Apr18               *
      *                 CGL157             Date 17Aug15               *
      *                 MD046248           Date 27Oct17               *
      *                 CER071             Date 01Aug16               *
      *                 MD026905A          Date 24Jun14               *
      *                 MD026905           Date 15Jun14               *
      *                 CGL132   *CREATE   Date 01May13               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *           Applied for MD-55510.                               *
      *  MD054605 - Deliverable Data Split for SDSVALPD               *
      *  MD050212 - Replication processing for PF/SDCUSTXC            *
      *  CGL157 - CRS Reporting (Recompile)                           *
      *  MD046248 - Finastra Rebranding                               *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  MD026905A - Make the program re-runnable (Reopen)            *
      *  MD026905 - Make the program re-runnable                      *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
      **
     FSDCUSTL0  IF   E           K DISK

      **
     FSDACUSL0  UF A E           K DISK

      ** Withholding Tax Customer Details
     FSDWTCSPD  IF   E             DISK

      ** Customer Details Extension C
     F***SDCUSTXC  IF A E             DISK                                                  MD026905
     FSDCUSXL0  UF A E           K DISK                                                     MD026905
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE

      ** External DS for Bank Details ICD retrieval
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D SDACUS        E DS                  EXTNAME(SDACUSPD)
     D*SDSVAL***     E DS                  EXTNAME(SDSVALPD)                                MD054605

     D CMDXC           S             75    DIM(1) CTDATA PERRCD(1)

      ** Data structure for AOSVALR0 string
     D P@VL01          DS           200
     D WCtryOfTax              1      2
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D PRetCode        S              7    INZ(*Blanks)
     D POption         S              7    INZ(*Blanks)
     D Recursive       S              1    INZ('N')

     D CtryOfTaxSVal   S              2    INZ(*Blanks)
     D WCustNo         S              6    INZ(*Blanks)
     D WCustTIN        S             25    INZ(*Blanks)
     D WCrtUpdFlg      S              1    INZ(*Blanks)
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** System value Default Classification for Take-on
     DWSysVal1         C                   'FATCACountryofTax'
      *****************************************************************
      *                                                               *
      * M A I N   P R O C E D U R E                                   *
      *                                                               *
      *****************************************************************
      *
      ** US Treaty Withholding Tax Information Take-on
      *
     C                   READ      SDWTCSPD
     C                   DOW       %EOF = '0'

     C                   IF        WHCRTT = CtryOfTaxSVal
     C                             and WHRECI = 'D'
     C                   EVAL      WCustNo = WHCSNO
     C                   EVAL      WCustTin = WHTIN
     C                   EXSR      UpdCustDet
     C                   EVAL      WCustNo = *BLANKS
     C                   EVAL      WCustTin = *BLANKS
     C                   ENDIF

     C                   READ      SDWTCSPD
     C                   ENDDO
      *
      ** Customer Details Extension C - Initialisation
      *
     C                   EXSR      InitExtFil
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      /EJECT
      *
      *****************************************************************
      *                                                               *
      * S U B R O U T I N E S                                         *
      *                                                               *
      *****************************************************************
      *
      *******************************************************************
      *                                                                 *
      * InitExtFil - Initialise Customer Details Extension File C       *
      *                                                                 *
      *******************************************************************
     C     InitExtFil    BEGSR
     C
     C     *LOVAL        SETLL     SDCUSTL0
     C                   READ      @BBREBG
     C                   DOW       %EOF = '0'
     C                   EVAL      WCustNo = BBCUST                                         MD026905
      *                                                                                     MD026905
      ** Check if already exists                                                            MD026905
      *                                                                                     MD026905
     C     WCustNo       CHAIN     SDCUSXL0                                                 MD026905
     C                   IF        %FOUND = '0'                                             MD026905
     C                   EVAL      XCCUST = BBCUST
     C                   EVAL      XCBRCH = BBBRCD                                          MD050212
     C                   EVAL      XCACCZ = ''
     C                   EVAL      XCCRDT = 0
     C                   EVAL      XCLCUS = ''
     C                   EVAL      XCDRMT = ''
     C                   WRITE     SDCUSTX0
     C                   ENDIF                                                              MD026905
      *                                                                                     MD026905
     C                   READ      @BBREBG
     C                   ENDDO

     C     InitExtFilE   ENDSR
      *
      *******************************************************************
      *                                                                 *
      * UpdCustDet - Update Customer Details with TIN retrieved         *
      *                                                                 *
      *******************************************************************
     C     UpdCustDet    BEGSR
     C     WCustNo       CHAIN     @BBREBG
     C                   IF        %FOUND = '0'
     C                   GOTO      UpdCustDetE
     C                   ENDIF

     C     WCustNo       CHAIN     @ACUSL0
     C                   IF        %FOUND = '0'
     C                   EVAL      WCrtUpdFlg = '0'
     C                   EVAL      SDACUS = *BLANKS
     C                   EVAL      E5CUST = WCustNo
     C                   EVAL      E5TYLC = 'I'
     C                   ELSE
     C                   IF        BBCOLC = CtryOfTaxSVal                                   MD026905
     C                             or E5TNC2 = CtryOfTaxSVal                                MD026905
     C                             or E5TNC3 = CtryOfTaxSVal                                MD026905
     C                             or E5TNC4 = CtryOfTaxSVal                                MD026905
     C                             or E5TNC5 = CtryOfTaxSVal                                MD026905
                                                                                           MD026905A
     C                   IF        BBCOLC = CtryOfTaxSVal                                  MD026905A
     C                             and E5TINO = *BLANKS                                    MD026905A
     C                   ELSE                                                              MD026905A
     C                   GOTO      Cleanup                                                  MD026905
     C                   ENDIF                                                             MD026905A
                                                                                           MD026905A
     C                   ENDIF                                                              MD026905
                                                                                            MD026905
     C                   EVAL      WCrtUpdFlg = '1'
     C                   EVAL      E5TYLC = 'A'
     C                   ENDIF

     C                   IF        BBCOLC = CtryOfTaxSVal
     C                             and E5TINO = *BLANKS
     C                   EVAL      E5TINO = WCustTin
     C                   ELSE

     C                   SELECT
     C                   WHEN      %trim(E5TIN2) = *BLANKS
     C                   EVAL      E5TIN2 = WCustTin
     C                   EVAL      E5TNC2 = CtryOfTaxSVal
     C                   WHEN      %trim(E5TIN3) = *BLANKS
     C                   EVAL      E5TIN3 = WCustTin
     C                   EVAL      E5TNC3 = CtryOfTaxSVal
     C                   WHEN      %trim(E5TIN4) = *BLANKS
     C                   EVAL      E5TIN4 = WCustTin
     C                   EVAL      E5TNC4 = CtryOfTaxSVal
     C                   WHEN      %trim(E5TIN5) = *BLANKS
     C                   EVAL      E5TIN5 = WCustTin
     C                   EVAL      E5TNC5 = CtryOfTaxSVal
     C                   ENDSL
     C                   ENDIF

     C                   EVAL      E5LCD  = BJRDNB
     C                   EVAL      E5TMST = %timestamp()
     C                   EVAL      E5DOLV = 0
     C                   EVAL      E5BRTH = 0

     C                   IF        WCrtUpdFlg = '1'
     C                   UPDATE    @ACUSL0
     C                   ELSE
     C                   WRITE     @ACUSL0
     C                   ENDIF

     C     Cleanup       TAG                                                                MD026905
     C                   EVAL      SDACUS = *BLANKS

     C     UpdCustDetE   ENDSR
      *******************************************************************
      *                                                                 *
      * *INZSR - Initialisation                                         *
      *                                                                 *
      *******************************************************************
     C     *INZSR        BEGSR

      ** Access installation control data
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST'      POption
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = '*FIRST'
     C                   EVAL      DBASE  = 1
     C                   EVAL      DBPGM = 'SD000555'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRetCode          7
     C                   PARM      WSysVal1      P@OP01           20
     C                   PARM      *BLANKS       P@VL01
     C                   PARM      *BLANKS       P@OP02           20
     C                   PARM      *BLANKS       P@VL02          200
     C                   PARM      *BLANKS       P@OP03           20
     C                   PARM      *BLANKS       P@VL03          200
     C                   PARM      *BLANKS       P@OP04           20
     C                   PARM      *BLANKS       P@VL04          200
     C                   PARM      *BLANKS       P@OP05           20
     C                   PARM      *BLANKS       P@VL05          200
     C                   PARM      *BLANKS       P@OP06           20
     C                   PARM      *BLANKS       P@VL06          200
     C                   PARM      *BLANKS       P@OP07           20
     C                   PARM      *BLANKS       P@VL07          200
     C                   PARM      *BLANKS       P@OP08           20
     C                   PARM      *BLANKS       P@VL08          200
     C                   PARM      *BLANKS       P@OP09           20
     C                   PARM      *BLANKS       P@VL09          200
     C                   PARM      *BLANKS       P@OP10           20
     C                   PARM      *BLANKS       P@VL10          200

     C                   IF        PRetCode  <> *BLANKS
     C                   EVAL      DBFile = 'SDSVALPD'
     C                   EVAL      DBKEy = '*KEY   '
     C                   EVAL      DBase = 2
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      CtryOfTaxSVal = WCtryOfTax

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  -   Program exception error routine                    *
      *            Called automatically if a program error occurs,    *
      *            or directly by the program code using EXSR.        *
      *            This subroutine DUMPs the program just once.       *
      *                                                               *
      * Called by: *INZSR                                             *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = *BLANK
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
