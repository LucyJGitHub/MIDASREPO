     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Repayments Schedule - Convert for Display')   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LERPSCCVT - Repayments Schedule - Convert for Display        *
      *                                                               *
      *  Function:  This module converts the fields of a repayment    *
      *             schedule from their format as on file to a        *
      *             screen format                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CLE154             Date 02Aug12               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 240408             Date 14Jun06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CAP086             Date 08Jun05               *
      *                 CAP079  *CREATE    Date 03Jul02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE154 - Loan Repayment Schedule Enhancement                 *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - CCR016: Settlement Allocation                      *
      *  240408 - Apply 207629 to Lending APIs                        *
      *           Check System Value LoanCustOriginPurch to decide if *
      *           original borrower should be input as the customer of*
      *           a Part Purchased, instead of 'Purchased From' num.  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager. (Recompiled)                  *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  CAP079 - Lending API enhancements - Repayments schedule      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)                                       240408
     F                                     PREFIX(LO_)                                        240408
     F                                     IGNORE(CLOANHHF)                                   240408
     F                                     IGNORE(CLOANZ1F)                                   240408
      *
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
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
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
     D RpScFilFmt    E DS                  EXTNAME(LOAMSDK)
      ***  Repayments schedule in file format
      *
     D RpScScnFmt    E DS                  EXTNAME(LERPSCPD)
      ***  Repayments schedule in screen format
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ***  External DS for currency details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ***  Second DS for access programs, long data structure
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D WPARM           S             20A   INZ('LoanCustOriginPurch')                         240408
     D ##STAL          S              1A                                                     CSF011A
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ***  Initialization
      *
     C                   EXSR      INIT
      *
      ***  Set output screen fields
      *
     C                   EXSR      SETFLD
      *
      ***  Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SETFLD - Set output screen fields                            *
      *****************************************************************
     C     SETFLD        BEGSR
      *
      ***  Loan number
      *
     C                   MOVE      LNRF          DDLNRF
      *
      ***  Sequnce
      *
     C                   MOVE      LASN          DDSEQN
      *
      ***  Customer number
      *
     C     PTYP          IFEQ      64                                                         240408
     C     PTYP          OREQ      65                                                         240408
     C     PTYP          OREQ      68                                                         240408
     C     PTYP          OREQ      71                                                         240408
      *If the loan is a Participation Purchased, & System Value                               240408
      * LoanCustOriginPurch = 'O', use Original Borrower:                                     240408
     C     PPCUST        IFEQ      'O'                                                        240408
     C     LNRF          CHAIN     CLOAN                              01                      240408
     C                   MOVEL     LO_OLNO       DDCUST                                       240408
      * Else, use 'Purchased from' customer number.                                           240408
     C                   ELSE                                                                 240408
     C                   MOVEL     CNUM          DDCUST                                       240408
     C                   ENDIF                                                                240408
      * Else, loan is not a Part Purchased:                                                   240408
     C                   ELSE                                                                 240408
     C                   MOVEL     CNUM          DDCUST
     C                   ENDIF                                                                240408
      *
      ***  Value date
      *
     C                   MOVE      VDAT          ZDateNum
     C                   MOVE      BJDFIN        ZDateFmtInd
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDateNum          5 0
     C                   PARM                    ZDateFmtInd       1
     C                   PARM                    ZDateFmt6         6 0
     C                   PARM                    ZDateFmt7         7
      *
     C                   MOVE      ZDateFmt6     DDVDAT
      *
      ***  Currency
      *
     C                   MOVEL     CCY           DDCURR
      *
      ***  Amount
      *
     C                   MOVEL     CCY           @CURR             3
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @CURR
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     @CURR         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE                         *************
     C                   MOVEL     '001'         DBASE                          * DBERR 001 *
     C                   EXSR      *PSSR                                        *************
     C                   ENDIF
      *
     C     REPT          IFNE      3
     C                   MOVE      PRAM          ZFIELD
     C                   ELSE
     C                   MOVE      TAMT          ZFIELD
     C                   ENDIF
      *
     C                   MOVE      A6NBDP        ZDEC
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZDEC              1 0
     C                   MOVE      ZFIELD        DDSAMT
      *
      ***  Auto settlement indicator
      *
     C                   MOVEL     AUTO          DDAUTO
      *
      ***  Special instructions - 1
      *
     C                   MOVE      SPI1          DDSPI1
      *
      ***  Special instructions - 2
      *
     C                   MOVE      SPI2          DDSPI2
      *
      ***  Special instructions - 3
      *
     C                   MOVEL     SPI3          DDSPI3
      *
      ***  Repayments schedule status
      *
     C                   SELECT
     C     ASTS          WHENEQ    'C'
     C                   MOVEL     'LES0210'     ZAMSID
     C     ASTS          WHENEQ    'A'
     C                   MOVEL     'LES0211'     ZAMSID
     C     ASTS          WHENEQ    'R'
     C                   MOVEL     'LES0212'     ZAMSID
     C     ASTS          WHENEQ    'D'
     C                   MOVEL     'LES0213'     ZAMSID
     C                   ENDSL
     C                   EXSR      SRTEXT
     C                   MOVEL     ZAMSTP        DDSTAT
     C                   MOVE      *BLANKS       ZAMSID
      *                                                                                       CLE154
     C                   IF        CLE154 = 'Y'                                               CLE154
     C                   MOVE      REPT          DDREPT                                       CLE154
     C                   ENDIF                                                                CLE154
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRTEXT  -  Set up text from message file.                     *
      *****************************************************************
     C     SRTEXT        BEGSR
      *
     C                   CALL      'Y2RVMGC'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    ZAMSID            7            Message Id.
     C                   PARM      'LERMSGF '    ZAMSGF           10            Message file.
     C                   PARM                    ZAMSDA          132            Message data.
     C                   PARM                    ZAMSTP          132            Messge text
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - Initialization                                         *
      *****************************************************************
     C     INIT          BEGSR
      *
      ***  Blank outputs (except for action code)
      *
     C                   MOVEL     DDACTN        ##ACTN            1
     C                   MOVEL     DDSTAL        ##STAL                                      CSF011A
     C                   MOVEL     *BLANK        RpScScnFmt
     C                   MOVEL     ##ACTN        DDACTN
     C                   MOVEL     ##STAL        DDSTAL                                      CSF011A
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ***  Program parameters
      *
     C     *ENTRY        PLIST
      *
      ***  INPUTS parameters
      *
      ***  Return Code
     C                   PARM                    RetCodeIn
      *
      ***  File format
     C                   PARM                    RpScFilFmt
      *
      ***  OUTPUT parameters
      *
      ***  Screen format
     C                   PARM                    RpScScnFmt
      *
      ***  Initialize program name
      *
     C                   MOVEL     'LERPSCCVT'   DBPGM
      *
      ***  Access bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ***  Database error
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '002'         DBASE                          * DBERR 002 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *                                                                                       CLE154
      ** Check if CLE154 is on                                                                CLE154
      *                                                                                       CLE154
     C                   MOVE      'N'           CLE154            1                          CLE154
     C                   CALLB     'AOSARDR0'                                                 CLE154
     C                   PARM      *BLANK        @RTCD                                        CLE154
     C                   PARM      '*VERIFY'     @OPTN                                        CLE154
     C                   PARM      'CLE154'      @SARD                                        CLE154
      *                                                                                       CLE154
     C     @RTCD         IFEQ      *BLANKS                                                    CLE154
     C                   MOVE      'Y'           CLE154                                       CLE154
     C                   END                                                                  CLE154
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
(c) Misys International Banking Systems Ltd. 2002
