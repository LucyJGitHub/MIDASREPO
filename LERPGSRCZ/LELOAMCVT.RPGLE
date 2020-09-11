     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Loan amendments convert file to screen')      *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LELOAMCVT - Loan Amendment - convert file to screen          *
      *                                                               *
      *  Function:  This module converts the fields of a customer     *
      *             loan amendment from their format as on file to a  *
      *             screen format (Loan Amendment Screen format)      *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD035672           Date 07Sep15               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 245992             Date 30Mar07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
/*    *                 240408             Date 14Jun06               *
/*    *                 CLE042             Date 06Sep05               *
      *                 BUG9655            Date 19Dec05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE036             Date 22Sep03               *
      *                 CLE034             Date 05May03               *
      *                 CLE031             Date 03Feb03               *
      *                 CAP086             Date 08Jun05               *
/*    *                 BG1135             Date 19Mar04               *
      *                 CLE030             Date 01Oct02               *
      *                 CAP075  *CREATE    Date 16Jul02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  MD035672 - Spread rate should be shown in spread rate field  *
      *             not in fixed rate field.                          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding                              *
      *  245992 - Unable to view spread rate insert, authorization    *
      *           and enquiry via action botton.
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  240408 - Apply 207629 to Lending APIs                        *
      *           Check System Value LoanCustOriginPurch to decide if *
      *           original borrower should be input as the customer of*
      *           a Part Purchased, instead of 'Purchased From' num.  *
      *  CLE042 - Extended Loan Sub Type                              *
      *  BUG9655- Base rate field in Loans, Base Rate Code Change in  *
      *           Loan Event and Rollover Maintenance should be       *
      *           dependent on switchable feature CLE036.             *
      *  CLE106 - Syndications Manager                                *
      *  CLE036 - Lending Enhancements for Nordea Phase 1 Priority 2  *
      *           Allow specific base rates  (Recompile)              *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *           (Recompile)                                         *
      *  CLE031 - Lending Enhancements (Recompile)                    *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
/*    *  BG1135 - Recompiled over LELOAMCVT changes                   *
      *  CLE030 - Release Authorisation processing                    *
      *  CAP075 - Lending API enhancements - Loan Amendment           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *                                                                                       CLE106
      **  Midas LE Loans Detail Files                                                         CLE106
      *                                                                                       CLE106
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)                                       CLE106
     F***********                          USROPN                                       CLE106240408
     F                                     PREFIX(LO_)                                        CLE106
     F                                     IGNORE(CLOANHHF)                                   CLE106
     F                                     IGNORE(CLOANZ1F)                                   CLE106
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Include the standard declares
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ***  Loan Amendment in file Format
     D LoamFilFmt    E DS                  EXTNAME(LOAMSDK)

      ** Loan Amendment Extension in file format                                              CRE073
     D LoamFilXFmt   E DS                  EXTNAME(LEVLOAMPD)                                 CRE073
                                                                                              CRE073
      ** Loan Amendment Layout file - Input Fields
     D LoamScnFmt    E DS                  EXTNAME(LELOAMPD)

      ***  External DS for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ***  DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ***  DS for Access programs - short data structure                                      CLE106
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CLE106
      *** EXTERNAL DS FOR SAR DETAILS                                                         CLE106
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CLE106
     D SC_LCD        E                     EXTFLD(LCD)                                        CLE106
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *                                                                                       CLE106
      ** Work variables for switchable feature                                                CLE106
      *                                                                                       CLE106
     D CLEC106         S              1A                                                      CLE106
     D CLE036          S              1A                                                     BUG9655
     D CRE073          S              1A                                                      CRE073
     D WPARM           S             20A   INZ('LoanCustOriginPurch')                         240408
                                                                                              CLE106
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *inzsr  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** ¦ Note that this module uses logic-cycle processing; it will ¦
      ** ¦ repeat the main processing until 'return' is specified.    ¦
      ** ¦ It will also only execute the *INZSR once, on activation,  ¦
      ** ¦ not every time it is called.                               ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      **  Blank outputs
     C                   CLEAR                   LoamScnFmt
     C                   CLEAR                   DDSTAT

      *  Set screen fields

      ** Loan number.
     C                   MOVE      LNRF          DDLOAN
      *
      ** Amendment type
     C                   MOVE      AMTP          DDATYP
      *
      ** Loan amendment status
     C                   MOVE      ASTS          WRSTS             1
     C                   EXSR      SRSTAT
     C                   MOVEL     WSTAT         DDSTAT
      *
      ** Value date
     C                   Z-ADD     VDAT          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATE         DDVDAT
      *
      ** Sequence
     C                   MOVE      LASN          DDSEQN
      *
      ** Customer
     C     PTYP          IFEQ      64                                                         240408
     C     PTYP          OREQ      65                                                         240408
     C     PTYP          OREQ      68                                                         240408
     C     PTYP          OREQ      71                                                         240408
      *If the loan is a Participation Purchased, & System Value                               240408
      * LoanCustOriginPurch = 'O', use Original Borrower:                                     240408
     C     PPCUST        IFEQ      'O'                                                        240408
     C     LNRF          CHAIN     CLOAN                              01                      240408
     C                   MOVEL     LO_OLNO       DDCNUM                                       240408
      * Else, use 'Purchased from' customer number.                                           240408
     C                   ELSE                                                                 240408
     C                   MOVEL     CNUM          DDCNUM                                       240408
     C                   ENDIF                                                                240408
      * Else, loan is not a Part Purchased:                                                   240408
     C                   ELSE                                                                 240408
     C                   MOVEL     CNUM          DDCNUM
     C                   ENDIF                                                                240408
                                                                                              CLE106
      ** Loan Type                                                                            CLE106
                                                                                              CLE106
     C                   MOVE      LTYP          DDLTYP                                       CLE106
      *
      ** Loan subtype
     C                   MOVE      SUTP          DDSTYP
      *                                                                                       CLE042
      ** Loan class                                                                           CLE042
     C                   MOVE      CLAS          DDCLAS                                       CLE042
      *
      ** Maturity date
     C                   IF        LSMD <> 0
     C                   Z-ADD     LSMD          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATE         DDMDAT
     C                   ELSE
     C                   MOVE      *BLANKS       DDMDAT
     C                   ENDIF
      *
      ***Base*rate****************************************************                        CLE106
      ** Base rate code                                                                       CLE106
     C**********         IF        BRTT = 0                                                   CSD103
     C                   IF        BRTT = *BLANKS                                             CSD103
     C                   MOVE      *BLANK        DDBRAT
     C                   ELSE
     C                   IF        DDATYP = 'BC'
     C                   MOVE      BRTT          DDBRAT
     C                   ENDIF
     C                   ENDIF
                                                                                              CLE106
      ** Base rate                                                                            CLE106
                                                                                              CLE106
     C                   MOVE      *BLANKS       DDBASR                                       CLE106
                                                                                              CLE106
     C                   IF        DDATYP = 'BC' and BASR <> 0                                CLE106
     C                   MOVE      *BLANKS       ZFIELD                                       CLE106
     C                   MOVE(P)   BASR          ZFIELD                                       CLE106
     C                   Z-ADD     7             ZADEC                                        CLE106
     C                   EXSR      ZEDIT                                                      CLE106
     C                   MOVE      ZFIELD        DDBASR                                       CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
      ** Check loan details if CLEC106is switched on                                          CLE106
      *                                                                                       CLE106
     C                   If        CLEC106= 'Y' or CLE036= 'Y'                       CLE106 MD035672
     C*********          OPEN      CLOAN                                                CLE106240408
     C     LNRF          CHAIN     CLOAN                              01                      CLE106
     C*********          CLOSE     CLOAN                                                CLE106240408
     C                   Endif                                                                CLE106
      *
      ** Spread / rate
     C                   MOVE      *BLANKS       DDRTSP
      *                                                                                       CLE106
      ** Fixed Rate                                                                           CLE106
      *                                                                                       CLE106
     C                   MOVE      *BLANKS       DDFXRT                                       CLE106
      *
     C                   IF        DDATYP = 'SC'
     C                   IF        RTSP < *ZERO                                               CRE073
     C                   EVAL      ZFIELD = %CHAR(RTSP)                                       CRE073
     C                   ELSE                                                                 CRE073
     C                   MOVE      *BLANKS       ZFIELD                                       CLE106
     C                   MOVE(P)   RTSP          ZFIELD
     C                   Z-ADD     7             ZADEC
     C                   EXSR      ZEDIT
     C                   ENDIF                                                                CRE073
     C**********         If        CLEC106= 'N' or                                     CLE106 245992
     C**********                   CLEC106= 'Y' and LO_BRTT  <> 0 and                  CLE106 245992
     C**********         If        CLE036= 'N' or                                    245992 MD035672
     C**********                   CLE036= 'Y' and LO_BRTT  <> 0 and                 245992 MD035672
     C**********                         LO_BASR  <> 0 and                           CLE106 MD035672
     C**********                         LO_BRTE  <> 0 and *IN01 = '0'               CLE106 MD035672
     C**********         MOVE      ZFIELD        DDRTSP                                       CRE073
     C                   If        CLE036= 'N' or                                           MD035672
     C                             (CLE036= 'Y' and *IN01 = '0'and                          MD035672
     C*                                  (LO_BRTT  <> 0 or LO_BASR  <> 0                    MD035672
     C                                   (LO_BRTT  <> *BLANKS or LO_BASR  <> 0      MD035672 CSD103
     C                                     or LO_BRTE  <> 0))                               MD035672
     C                   MOVEL     ZFIELD        DDRTSP                                       CRE073
     C                   Else                                                                 CLE106
     C**********         MOVE      ZFIELD        DDFXRT                                CLE106 CRE073
     C                   MOVEL     ZFIELD        DDFXRT                                       CRE073
     C                   Endif                                                                CLE106
     C                   ENDIF
      *
      ** Funding spread / rate
     C     FSRP          IFEQ      0
     C                   MOVE      *BLANKS       DDFRAT
     C                   MOVE      *BLANKS       DDFRSP                                       CLE106
     C                   ELSE
     C                   MOVE      *BLANKS       ZFIELD                                       CLE106
     C                   MOVE(P)   FSRP          ZFIELD
     C                   Z-ADD     7             ZADEC
     C                   EXSR      ZEDIT
     C**********         If        CLEC106= 'N' or                                    CLE106 BUG9655
     C**********                   CLEC106= 'Y' and LO_FSGN = *BLANKS                 CLE106 BUG9655
     C**********                          and *IN01 = '0'                             CLE106 BUG9655
     C                   If        CLEC106= 'N' AND CLE036 = 'Y' OR                          BUG9655
     C                             CLEC106= 'Y' AND LO_FSGN = *BLANKS AND                    BUG9655
     C                             *IN01 = '0'  AND CLE036 = 'Y'                             BUG9655
     C                   MOVE      ZFIELD        DDFRAT
     C                   Else                                                                 CLE106
     C                   MOVE      ZFIELD        DDFRSP                                       CLE106
     C                   Endif                                                                CLE106
     C                   ENDIF
      *
      ** Currency
     C                   MOVE      CCY           DDCURR
      *
      ** Amount
     C***********        IF        DDATYP = 'PI'                                              BG1135
     C                   IF        DDATYP = 'PI' OR DDATYP = 'PD'                             BG1135
     C                   IF        TAMT = 0
     C                   MOVE      *BLANK        DDAMNT
     C                   ELSE
     C                   MOVEL     DDCURR        @CURR
     C                   Z-ADD     2             DBASE
     C                   EXSR      SRCurrDet
     C                   Z-ADD     0             DBASE
     C                   MOVE(P)   TAMT          ZFIELD
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDAMNT
     C                   ENDIF
     C                   ENDIF
      *
      ** Default participation loan type / subtype
     C                   MOVE      DFTP          DDDFTP
     C                   MOVE      DFST          DDDFST
     C                   MOVE      DFCL          DDDFCL                                      CLE042
                                                                                             CLE106
      ** Default SUB-participation loan type / subtype                                       CLE106
                                                                                             CLE106
     C                   MOVE      SLTP          DDSLTP                                      CLE106
     C                   MOVE      SLST          DDSLST                                      CLE106
     C                   MOVE      SLCL          DDSLCL                                      CLE042
      *
      ** Start / stop accruals
     C                   IF        DDATYP = 'SA'
     C                   MOVE      STAI          DDSTPA
     C                   ENDIF
      *
      ** Special instructions
     C                   MOVE      SPI1          DDSPI1
     C                   MOVE      SPI2          DDSPI2
     C                   MOVE      SPI3          DDSPI3
                                                                                              CRE073
     C                   IF        CRE073 = 'Y'  AND                                          CRE073
     C                             DDATYP = 'SC'                                              CRE073
                                                                                              CRE073
      ** Contractual Spread                                                                   CRE073
                                                                                              CRE073
     C                   IF        LACNSP <> *ZEROS                                           CRE073
     C                   MOVE      *BLANKS       ZFIELD                                       CRE073
     C                   MOVE(P)   LACNSP        ZFIELD                                       CRE073
     C                   Z-ADD     7             ZADEC                                        CRE073
     C                   EXSR      ZEDIT                                                      CRE073
     C                   MOVE      ZFIELD        DDCNSP                                       CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
      ** Contractual Spread Sign                                                              CRE073
                                                                                              CRE073
     C                   MOVEL     LACNSG        DDCNSG                                       CRE073
                                                                                              CRE073
      ** Rounding Method                                                                      CRE073
                                                                                              CRE073
     C                   MOVEL     LARDMT        DDRDMT                                       CRE073
                                                                                              CRE073
      ** Rounding Fraction/Decimal                                                            CRE073
                                                                                              CRE073
     C                   MOVEL     LARDFD        DDRDFD                                       CRE073
                                                                                              CRE073
     C                   ENDIF                                                                CRE073
      *
      ***  Return
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSTAT  -  Determine loan amendment status narrative          *
      *****************************************************************
     C     SRSTAT        BEGSR

     C                   MOVE      *BLANKS       ZAMSID            7

     C                   SELECT
     C     WRSTS         WHENEQ    'C'
     C                   MOVEL     'LEA0060'     ZAMSID

     C     WRSTS         WHENEQ    'R'
     C                   MOVEL     'LEA0061'     ZAMSID

     C     WRSTS         WHENEQ    'A'
     C                   MOVEL     'LEA0062'     ZAMSID

     C     WRSTS         WHENEQ    'D'
     C                   MOVEL     'LEA0063'     ZAMSID

     C     WRSTS         WHENEQ    'Q'
     C                   MOVEL     'LEA0064'     ZAMSID                                       CLE030
                                                                                              CLE030
     C                   OTHER
     C                   MOVE      *BLANKS       WSTAT
     C                   ENDSL

     C     ZAMSID        IFNE      *BLANKS
     C                   EXSR      SRTEXT
     C                   MOVEL(P)  ZAMSTX        WSTAT            16
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCurrDet - Access currency details                           *
      *****************************************************************
     C     SrCurrDet     BEGSR

     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @CURR             3
     C     SDCURR        PARM                    DSSDY

      * Database error
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @CURR         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   EXSR      *PSSR
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ZDATE2 - Format a date for output                             *
      *****************************************************************
     C     ZDATE2        BEGSR

     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      BJDFIN        DateFmt           1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRTEXT  -  Set up text from message file.                     *
      *****************************************************************
     C     SRTEXT        BEGSR

     C                   CALL      'Y2RVMGC'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    ZAMSID            7
     C                   PARM      'LERMSGF '    ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM                    ZAMSTX          132

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ZEDIT - Edit an unsigned field                                *
      *****************************************************************
     C     ZEDIT         BEGSR
      *
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  Program parameters
     C     *ENTRY        PLIST
      *
      ***  INPUT parameters
      ***  Return Code
     C                   PARM                    RetCodeIn
      *
      ***  Loan amendment in file format
     C                   PARM                    LoamFilFmt
      *
      * Date format indicator
     C                   PARM                    BJDFIN            1
      *
      ***  OUTPUT parameters
      ***  Loan Amendment in screen format
     C                   PARM                    LoamScnFmt
      *
      ***  Output only screen field : Loan status
     C                   PARM                    DDSTAT           16
     C                   PARM                    LoamFilXFmt                                  CRE073
      *
      ***  Initialise program name
     C                   MOVEL     'LELOAMCVT'   DBPGM
                                                                                              CLE106
      *                                                                                       CLE106
      ** Determine if CLEC106is switched on                                                   CLE106
      *                                                                                       CLE106
                                                                                              CLE106
     C                   EVAL      CLEC106= 'N'                                               CLE106
     C                   CALLB     'AOSARDR0'                                                 CLE106
     C                   PARM      *Blanks       @RTCD                                        CLE106
     C                   PARM      '*VERIFY'     @OPTN                                        CLE106
     C                   PARM      'CLE106'      @SARD                                        CLE106
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE106
                                                                                              CLE106
     C                   If        @RTCD = *Blanks                                            CLE106
     C                   EVAL      CLEC106= 'Y'                                               CLE106
     C                   Endif                                                                CLE106
      *                                                                                      BUG9655
      ** Determine if CLE036 is switched on                                                  BUG9655
      *                                                                                      BUG9655
                                                                                             BUG9655
     C                   EVAL      CLE036 = 'N'                                              BUG9655
     C                   CALLB     'AOSARDR0'                                                BUG9655
     C                   PARM      *Blanks       @RTCD                                       BUG9655
     C                   PARM      '*VERIFY'     @OPTN                                       BUG9655
     C                   PARM      'CLE036'      @SARD                                       BUG9655
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG9655
                                                                                             BUG9655
     C                   If        @RTCD = *Blanks                                           BUG9655
     C                   EVAL      CLE036 = 'Y'                                              BUG9655
     C                   Endif                                                               BUG9655
                                                                                              CRE073
      ** Determine if CRE073 Interest Rate Rounding feature is isntalled                      CRE073
                                                                                              CRE073
     C                   EVAL      CRE073 = 'N'                                               CRE073
     C                   CALLB     'AOSARDR0'                                                 CRE073
     C                   PARM      *BLANKS       @RTCD                                        CRE073
     C                   PARM      '*VERIFY'     @OPTN                                        CRE073
     C                   PARM      'CRE073'      @SARD                                        CRE073
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE073
                                                                                              CRE073
     C                   IF        @RTCD = *BLANKS                                            CRE073
     C                   EVAL      CRE073 = 'Y'                                               CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       240408
      ** Check System Value: Use Original Borrower or Purchased From?                         240408
      ** Set up parameter so access object checks LoanCustOriginPurch                         240408
     C                   MOVEL     WPARM         SVALK1                                       240408
      * Call Access object:                                                                   240408
     C                   CALL      'AOSVALR0'                                                 240408
     C                   PARM                    RTNCDE            7                          240408
     C                   PARM                    SVALK1           20                          240408
     C                   PARM                    SVAL1           200                          240408
     C                   PARM                    SVALK2           20                          240408
     C                   PARM                    SVAL2           200                          240408
     C                   PARM                    SVALK3           20                          240408
     C                   PARM                    SVAL3           200                          240408
     C                   PARM                    SVALK4           20                          240408
     C                   PARM                    SVAL4           200                          240408
     C                   PARM                    SVALK5           20                          240408
     C                   PARM                    SVAL5           200                          240408
     C                   PARM                    SVALK6           20                          240408
     C                   PARM                    SVAL6           200                          240408
     C                   PARM                    SVALK7           20                          240408
     C                   PARM                    SVAL7           200                          240408
     C                   PARM                    SVALK8           20                          240408
     C                   PARM                    SVAL8           200                          240408
     C                   PARM                    SVALK9           20                          240408
     C                   PARM                    SVAL9           200                          240408
     C                   PARM                    SVALK0           20                          240408
     C                   PARM                    SVAL10          200                          240408
      * If the system value is not found then default value to 'P'                            240408
     C     RTNCDE        IFNE      '        '                                                 240408
     C                   MOVE      'P'           PPCUST                                       240408
     C                   ELSE                                                                 240408
      * Isolate the first character of SVAL1 which = 'P' or 'O'.                              240408
     C                   MOVEL     SVAL1         WRK01             1                          240408
     C     WRK01         IFEQ      'O'                                                        240408
     C                   MOVE      'O'           PPCUST            1                          240408
     C                   ELSE                                                                 240408
     C                   MOVE      'P'           PPCUST                                       240408
     C                   ENDIF                                                                240408
     C                   ENDIF                                                                240408
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
