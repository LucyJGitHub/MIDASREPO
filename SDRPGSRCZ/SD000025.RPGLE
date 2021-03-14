     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Populate AML Account details import table')            *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000025 - Populate AML Account Details Import Table         *
      *                                                               *
      *  Function:  This program will populate the AML Account        *
      *             details import table                              *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE073             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG3031            Date 03Jun02               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CSD017  *CREATE    Date 08Nov02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG3031 - Compliance Watch AML export data corrections       *
      *            (Recompile)                                        *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSD017 - Midas Compliance Watch - Anti-Money Laundering      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         If bits '0123467' of RETB are on                *
      *    02         If bit '0' of RETB is on                        *
      *    03         If bit '1' of RETB is on                        *
      *    04         If bit '2' of RETB is on                        *
      *    05         If bit '3' of RETB is on                        *
      *    06         If bit '4' of RETB is on                        *
      *    07         If bit '6' of RETB is on                        *
      *    08         If bit '7' of RETB is on                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      * SRCVTDATE - Convert Midas Run Day Date format                 *
      * SRCVTAMT  - Convert amounts to the "TO" currency              *
      * SRRTVCURR - Get currency details                              *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FSDACCTPD  UF A E             DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
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
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      **  Account Details
     D SDACCNT       E DS                  EXTNAME(ACCNTAB)
 
      **  Account Code Details
     D SDACOD        E DS                  EXTNAME(SDACODPD)
 
      **  CW Configuration Data
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)
 
      **  Currency Deatils File
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      **  Short Data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WCNUM           S              6
     D*WACOD****       S              4                                                       CGL029
     D WACOD           S             10                                                       CGL029
     D WACSQ           S              2
     D WACNO           S             10
     D WANAM           S             24
     D WDACO           S              5  0
     D WDACC           S              5  0
 
      ** Entry Parameter
     D PMODE           S              1
 
      ** Standard Parameters
     D PRTCD           S              7
     D POPTN           S              7
 
      ** Parameters for ZACVTDATE
     D PINDATE         S              5
     D POUTDATE        S               D
     D PCVTDDATE       S             10
 
      ** Parameters for ZACVTAMT
     D PINAMT          S             15
     D PINCCY          S              3
     D PCCY            S              3
     D POUTAMT         S             18  3
     D PCVTDAMT        S             16
 
      ** Parameters for ZCCYCN
     D PFRAMT          S             15  0
     D PFRCCY          S              3
     D PTOCCY          S              3
     D PFRSPRT         S             13  8
     D PTOSPRT         S             13  8
     D PFRMDIND        S              1
     D PTOMDIND        S              1
     D PFRNBDP         S              1  0
     D PTONBDP         S              1  0
     D PTOAMT          S             15  0
     D PCXRT           S             13  8
     D PCMDI           S              1
     D WFRAMT          S             15  0
     D WINAMT          S             18  0
 
     D @RUN            S              1
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Move all numeric fields to a character work variable
 
     C                   MOVEL     CNUM          WCNUM
     C                   MOVEL     ACOD          WACOD
     C                   MOVEL     ACSQ          WACSQ
     C                   MOVEL     ACNO          WACNO
 
      ** Retrieve ACC_NUM
 
     C                   EVAL      X5ACNO = BRCA + WCNUM + CCY +
     C                                      WACOD +WACSQ
 
      ** Retrieve BRCH_ID
 
     C                   EVAL      X5BRCA = BRCA
 
      ** Retrieve PROD_CODE
 
     C                   EVAL      X5PROD = WACOD
 
      ** Retrieve MIDAS_ACCOUNT_SUBTYPE
 
     C                   EVAL      X5MAST = STYP
 
      ** Retrieve MIDAS_ACCOUNT_TYPE
 
     C                   EVAL      X5MATP = ATYP
 
      ** Retrieve MIDAS_ACCOUNT_SECTION
 
     C                   EVAL      X5MASC = A5ACSC
 
      ** Retrieve ACC_OPENED
 
     C                   CLEAR                   X5OPEN
     C                   IF        DACO <> 0
     C                   EVAL      WDACO = DACO
     C                   MOVE      WDACO         PINDATE
     C                   EXSR      SRCVTDATE
     C                   EVAL      X5OPEN = PCVTDDATE
     C                   ENDIF
 
      ** Retrieve ACC_CLOSED
 
     C                   CLEAR                   X5CLOS
     C                   IF        DACC <> 0
     C                   EVAL      WDACC = DACC
     C                   MOVE      WDACC         PINDATE
     C                   EXSR      SRCVTDATE
     C                   EVAL      X5CLOS = PCVTDDATE
     C                   ENDIF
 
      ** Retrieve BALANCE (Converted to the "TO" currency)
 
     C                   EVAL      PFRAMT = CLBL
     C                   EXSR      SRCVTAMT
     C                   EVAL      X5BALN = POUTAMT
 
      ** Retrieve MIDAS_BALANCE_CCY
 
     C                   EVAL      X5MBCY = W1ACCY
 
      ** Retrieve MIDAS_ACCOUNT_BALANCE
 
     C                   EVAL      PINAMT = *BLANKS
     C                   EVAL      PINCCY = CCY
     C                   MOVE      CLBL          PINAMT
     C                   EXSR      SRFMTAMT
     C                   EVAL      X5MABL = POUTAMT
 
      ** Retrieve MIDAS_ACCOUNT_CCY
 
     C                   EVAL      X5MACY = CCY
 
      ** Retrieve NOTES (Account Name and Account Number starting
      ** at positions 1 and 25 respectively)
 
     C                   EVAL      WANAM = ANAM
     C                   EVAL      X5NOTE = WANAM + WACNO
 
      ** Set 'Y' to ACC_BLOCKED if bits 0,4,6 or 7 of RETB is '1'
 
     C                   TESTB     '0123467'     RETB                   01
     C                   IF        *IN01 = *ON
     C                   EVAL      X5BLCK = 'Y'
     C                   ELSE
     C                   EVAL      X5BLCK = 'N'
     C                   ENDIF
 
      ** Test each bit of Retail Indicator (RETB)
 
     C                   TESTB     '0'           RETB                     02
     C                   TESTB     '1'           RETB                     03
     C                   TESTB     '2'           RETB                     04
     C                   TESTB     '3'           RETB                     05
     C                   TESTB     '4'           RETB                     06
     C                   TESTB     '6'           RETB                     07
     C                   TESTB     '7'           RETB                     08
 
      ** Set 'Y' to MIDAS_REFER_DR if bit 0 of RETB is '1'
 
     C                   IF        *IN02 = *ON
     C                   EVAL      X5MRDR = 'Y'
     C                   ELSE
     C                   EVAL      X5MRDR = 'N'
     C                   ENDIF
 
      ** Set 'Y' to MIDAS_REFER_CR if bit 1 of RETB is '1'
 
     C                   IF        *IN03 = *ON
     C                   EVAL      X5MRCR = 'Y'
     C                   ELSE
     C                   EVAL      X5MRCR = 'N'
     C                   ENDIF
 
      ** Set 'Y' to MIDAS_BLOCK_DR if bit 2 of RETB is '1'
 
     C                   IF        *IN04 = *ON
     C                   EVAL      X5MBDR = 'Y'
     C                   ELSE
     C                   EVAL      X5MBDR = 'N'
     C                   ENDIF
 
      ** Set 'Y' to MIDAS_BLOCK_CR if bit 3 of RETB is '1'
 
     C                   IF        *IN05 = *ON
     C                   EVAL      X5MBCR = 'Y'
     C                   ELSE
     C                   EVAL      X5MBCR = 'N'
     C                   ENDIF
 
      ** Set 'Y' to MIDAS_INACTIVE_ACCOUNT if bit 4 of RETB is '1'
 
     C                   IF        *IN06 = *ON
     C                   EVAL      X5MIAC = 'Y'
     C                   ELSE
     C                   EVAL      X5MIAC = 'N'
     C                   ENDIF
 
      ** Set 'Y' to MIDAS_BANKRUPT_ACCOUNT if bit 6 of RETB is '1'
 
     C                   IF        *IN07 = *ON
     C                   EVAL      X5MBRP = 'Y'
     C                   ELSE
     C                   EVAL      X5MBRP = 'N'
     C                   ENDIF
 
      ** Set 'Y' to MIDAS_BAD_DEBT_ACCOUNT if bit 7 of RETB is '1'
 
     C                   IF        *IN08 = *ON
     C                   EVAL      X5MBAD = 'Y'
     C                   ELSE
     C                   EVAL      X5MBAD = 'N'
     C                   ENDIF
 
      ** Retrieve MIN_BALANCE (Converted to the "TO" currency)
 
     C                   EVAL      PFRAMT = MINB
     C                   EXSR      SRCVTAMT
     C                   EVAL      X5MINB = POUTAMT
 
      ** Retrieve MIDAS_MIN_ACCOUNT_BALANCE
 
     C                   EVAL      PINAMT = *BLANKS
     C                   EVAL      PINCCY = CCY
     C                   MOVE      MINB          PINAMT
     C                   EXSR      SRRTVCurr
     C                   EVAL(H R) WINAMT = MINB * (10 ** A6NBDP)
     C                   MOVE      WINAMT        PINAMT
     C                   EXSR      SRFMTAMT
     C                   EVAL      X5MMBL = POUTAMT
 
      ** Retrieve ACTION
 
     C                   IF        PMODE = 'A'
     C                   EVAL      X5ACTN = 'I'
     C                   ELSE
     C                   EVAL      X5ACTN = CHTP
     C                   ENDIF
 
      ** Write record to AML Account Details Import Table (SDACCTPD)
 
     C                   WRITE     SDACCTD0
 
     C                   EVAL      *INLR = *ON
 
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
 
     C     *ENTRY        PLIST
     C                   PARM                    PMODE
     C                   PARM                    SDACCNT
     C                   PARM                    SDACOD
     C                   PARM                    SDCWCD
 
      ** Get the details of the "TO" currency code
 
     C                   EVAL      PCCY = W1ACCY
     C                   EVAL      PTOCCY = W1ACCY
     C                   EXSR      SRRTVCURR
     C                   EVAL      PTOSPRT = A6SPRT
     C                   EVAL      PTOMDIND = A6MDIN
     C                   EVAL      PTONBDP = A6NBDP
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************
      *                                                               *
      * SrRtvCurr - Retrieve currency details                         *
      *                                                               *
      *****************************************************************
     C     SRRTVCURR     BEGSR
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PCCY
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = W1ACCY
     C                   EVAL      DBFILE = 'SCCURRPD'
     C                   EVAL      DBASE = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************
      *                                                               *
      * SrCvtDate - Convert Midas Run Date to date format             *
      *                                                               *
      *****************************************************************
     C     SRCVTDATE     BEGSR
 
     C                   CALLB     'ZACVTDATE'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    PINDATE
     C                   PARM                    POUTDATE
     C                   PARM                    PCVTDDATE
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************
      *                                                               *
      * SRCVTAMT - Convert amounts at the current spot rate           *
      *                                                               *
      *****************************************************************
     C     SRCVTAMT      BEGSR
 
      ** Get the details of the "FROM" currency code
 
     C                   EVAL      PCCY = CCY
     C                   EVAL      PFRCCY = CCY
     C                   EXSR      SRRTVCURR
     C                   EVAL      PFRSPRT = A6SPRT
     C                   EVAL      PFRMDIND = A6MDIN
     C                   EVAL      PFRNBDP = A6NBDP
     C                   EVAL      WFRAMT = PFRAMT
 
      ** Get the Input Amount equivalent in 'To' Currency.
 
     C                   CALLB     'ZCCYCN'
     C                   PARM                    PFRAMT
     C                   PARM                    PFRCCY
     C                   PARM                    PTOCCY
     C                   PARM                    PFRSPRT
     C                   PARM                    PTOSPRT
     C                   PARM                    PFRMDIND
     C                   PARM                    PTOMDIND
     C                   PARM                    PFRNBDP
     C                   PARM                    PTONBDP
     C                   PARM                    PTOAMT
     C                   PARM                    PCXRT
     C                   PARM                    PCMDI
 
      ** Convert amount depending on the number of decimal places
 
     C                   IF        WFRAMT = MINB
     C                   EVAL(H R) WINAMT = PTOAMT * (10 ** PTONBDP)
     C                   MOVE      WINAMT        PTOAMT
     C                   ENDIF
 
     C                   EVAL      PINAMT = *BLANKS
     C                   EVAL      PINCCY = PTOCCY
     C                   MOVE      PTOAMT        PINAMT
     C                   EXSR      SRFMTAMT
 
     C                   ENDSR
 
      /EJECT                                                          *
      *****************************************************************
      *                                                               *
      * SRFMTAMT - Formats amounts from 0 dec to 18,3                 *
      *                                                               *
      *****************************************************************
 
     C     SRFMTAMT      BEGSR
 
     C                   CALLB     'ZACVTAMT'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    PINCCY
     C                   PARM                    PINAMT
     C                   PARM                    POUTAMT
     C                   PARM                    PCVTDAMT
 
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
      * Called by: *INZSR                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2002
