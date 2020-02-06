     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Manual Repayment - Convert for Display')      *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LEMAPYCVT - Manual Repayment - convert to Display            *
      *                                                               *
      *  Function:  This module converts the fields of a Manual       *
      *             Repayment from Loan Amendment format to a         *
      *             screen format                                     *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR830785           Date 07May13               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 AR702741           Date 02Feb11               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 243399             Date 14Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 245082             Date 30Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
/*    *                 240408             Date 14Jun06               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE035             Date 22Sep03               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG3114            Date 27Jul04               *
      *                 CAP077  *CREATE    Date 17Jul02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR830785 - Looping on insert of accrued interest adjustment  *
      *             Extended core fix 263533. (Child: AR830786)       *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  AR702741 - Include location as parameter in ZFREQB to        *
      *             determine the next settlement date                *
      *             (Child: AR702742)                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  243399 - Modify formula in calculating Outstanding Interest  *
      *  245082 - Corrected processing for ADDI = 'B' to treat it as  *
      *           First day from start date and to add 1 day on       *
      *           maturity date.                                      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  240408 - Apply 207629 to Lending APIs                        *
      *           Check System Value LoanCustOriginPurch to decide if *
      *           original borrower should be input as the customer of*
      *           a Part Purchased, instead of 'Purchased From' num.  *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE035 - Nordea LE Enh. Phase 1 Pty 2 - Income Splits.       *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  BUG3114- Missing Rule of 78s (CLE028) change in the Lending  *
      *           APIs as description in the amendment history.       *
      *  CAP077 - Lending API enhancements - Manual Repayments        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
      *
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
      ***  Midas LE Loans details file
     F                                     Include(CLOANCLF)
     F                                     PREFIX(CL_)
      *
     FFCLTY     IF   E           K DISK    INFSR(*PSSR)
      ***  Midas LE Facility Details file
     F                                     Include(FCLTYFMF)
     F                                     Prefix(FC_)
     FLEFCLTLH  IF   E           K DISK    INFSR(*PSSR)                                       CLE035
      ***  Midas LE Facility Extension file                                                   CLE035
     F                                     Prefix(LT)                                         CLE035
     FLELOAML3  IF   E           K DISK    INFSR(*PSSR)
     F                                     Rename(LOAMSDKF:LOAMRPY)
      ***  Midas Loan Amendment File (Live Record)
     F                                     PREFIX(RPY_)
      *
      *****************************************************************
      ** +--------------------------------------+
      **   Automatically included D-specs        
      **   ==============================        
      ** +--------------------------------------+
      *
      ***  Compile time Array
     D POWER           S              7S 3 DIM(7) CTDATA PERRCD(1)
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
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      **   Manually included D-specs             
      **   =========================             
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      **   Named constants                       
      **   ===============                       
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      **   Arrays and Data Structures            
      **   ==========================            
      ** +--------------------------------------+
      *
      *
     D MaPyFilFmt    E DS                  EXTNAME(LOAMSDK)
      ***  Manual Repayments in file format
      *
     D PDLoAmFilFmt  E DS                  EXTNAME(LOAMSDK)
      ***  PD/RE in file format
     D                                     PREFIX(PD_)
      *
     D MaPyScnFmt    E DS                  EXTNAME(LEMAPYPD)
      ***  Manual Repayments in screen format
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ***  External DS for currency details
      *
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
      ***  External DS for Base Rate details
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)                                 BUG3114
      ** External DS for General Ledger Details                                              BUG3114
                                                                                             BUG3114
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ***  Second DS for access programs, long data structure
      *
      ** +--------------------------------------+
      **   Declared variables                    
      **   ==================                    
      ** +--------------------------------------+
      *
     D  ZOUT22         DS            22
     D  ZOUT21                 1     21
     D  ZOUT20                 1     20
     D  ZNEG                  21     21
      *                                                                                      BUG3114
      ** Data structure to define variables used in holiday sub-routines                     BUG3114
      *                                                                                      BUG3114
     D  ZIND           S              1                                                      BUG3114
     D  ZDAYNO         S              5  0                                                   BUG3114
     D  ZCCY           S              3                                                      BUG3114
     D  ZLOC           S              3                                                      BUG3114
      *
     D                 DS
     D  TmpLPAM                1     13 00
     D  TmpRATE1               1     13 07
      *
     D WPRAM           S                   LIKE(PRAM)
     D WINTA           S                   LIKE(INTA)
     D WPNAM           S                   LIKE(PNAM)
     D WTAMT           S                   LIKE(TAMT)
     D WKCNUM          S              6A                                                      CLE035
     D WKFACT          S              3A                                                      CLE035
     D WKFCNO          S              2A                                                      CLE035
     D WPARM           S             20A   INZ('LoanCustOriginPurch')                         240408
      *
      ** +--------------------------------------+
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ***  Initialization
 
     C                   EXSR      INIT
 
      ***  Set output screen fields
 
     C                   EXSR      SETFLD
 
      ***  Return
 
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
     C                   MOVEL     LNRF          DDLNRF
      *
      ***  Manual Repayments status
      *
     C                   SELECT
     C     ASTS          WHENEQ    'C'                                          Complete
     C                   MOVEL     'LEM0060'     ZAMSID
     C     ASTS          WHENEQ    'A'                                          Authorized
     C                   MOVEL     'LEM0062'     ZAMSID
     C     ASTS          WHENEQ    'R'                                          Reauthorized
     C                   MOVEL     'LEM0061'     ZAMSID
     C     ASTS          WHENEQ    'D'                                          deleted
     C                   MOVEL     'LEM0063'     ZAMSID
     C                   ENDSL
     C                   EXSR      SRTEXT
     C                   MOVEL     ZAMSTP        DDRSTS
     C                   MOVE      *BLANKS       ZAMSID
      *
      ***  Customer Number
      *
     C     PTYP          IFEQ      64                                                         240408
     C     PTYP          OREQ      65                                                         240408
     C     PTYP          OREQ      68                                                         240408
     C     PTYP          OREQ      71                                                         240408
      *If the loan is a Participation Purchased, & System Value                               240408
      * LoanCustOriginPurch = 'O', use Original Borrower:                                     240408
     C     PPCUST        IFEQ      'O'                                                        240408
     C                   MOVEL     CL_OLNO       DDCUST                                       240408
      * Else, use 'Purchased from' customer number.                                           240408
     C                   ELSE                                                                 240408
     C                   MOVEL     CNUM          DDCUST                                       240408
     C                   ENDIF                                                                240408
      * Else, loan is not a Part Purchased:                                                   240408
     C                   ELSE                                                                 240408
     C                   MOVEL     CNUM          DDCUST
     C                   ENDIF                                                                240408
      *
      ***  Sequence
      *
     C                   MOVE      LASN          DDSEQN
      *
      ***  Value Date
      *
     C                   MOVE      VDAT          ZDateNum
     C                   MOVE      BJDFIN        ZDateFmtInd
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDateNum          5 0
     C                   PARM                    ZDateFmtInd       1
     C                   PARM                    ZDateFmt6         6 0
     C                   PARM                    ZDateFmt7         7
      *
     C                   MOVE      ZDateFmt6     DDVALD
      *
      ***  Currency
      *
     C                   MOVEL     CCY           DDSCCY
      *
      ***  Amount
      *
     C                   MOVEL     DDSCCY        @CURR             3
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @CURR
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     @CURR         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE                         *************
     C                   MOVEL     '002'         DBASE                          * DBERR 002 *
     C                   EXSR      *PSSR                                        *************
     C                   ENDIF
     C                   MOVE      A6NBDP        CrNBDP            1 0          current Dec. places
      *
     C                   Z-ADD     CL_CPAM       ZFLD15           15 0          Current Principal
     C                   Z-Add     CrNBDP        ZDECS             1 0
     C                   MOVE      'J'           ZECODE
     C                   CALLb     'ZFRPED'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM                    ZECODE
     C                   PARM      *BLANKS       ZOUT22           22
     C                   PARM      *BLANKS       ZOUT25           25
      *
     C                   if        ZNEG = '-'
     C                   MOVE      ZOUT21        DDCURP
     C                   else
     C                   MOVE      Zout20        DDCURP
     C                   endif
      *
      ***  Calculate Outstanding Interest
      *
     C                   EXSR      OutstInt
      *
     C                   Z-ADD     WrkOutIntr    ZFLD15                         O/S interest
     C                   CALLb     'ZFRPED'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM      'J'           ZECODE            1
     C                   PARM      *BLANKS       ZOUT22           22
     C                   PARM      *BLANKS       ZOUT25           25
     C                   if        ZNEG = '-'
     C                   MOVE      ZOUT21        DDINTD
     C                   else
     C                   MOVE      ZOUT20        DDINTD
     C                   endif
      *                                                                                      BUG3114
      ** For flat rate personal loans, calculate interest refunded                           BUG3114
      ** and charges refunded                                                                BUG3114
      *                                                                                      BUG3114
     C                   if        CLE028 = 'Y' and CL_PTYP = 80                             BUG3114
     C                   EXSR      SRRFND                                                    BUG3114
      *                                                                                      BUG3114
      ** Add charges and/or interest to the principal where these                            BUG3114
      ** have been added on, but only if the loan hasn't started                             BUG3114
      *                                                                                      BUG3114
     C                   if        CL_ORED = BJRDNB or                                       BUG3114
     C                             CL_ORED < CL_VDAT                                         BUG3114
      *                                                                                      BUG3114
     C                   IF        CL_ADIF = 'Y'                                             BUG3114
     C                   ADD       CL_FLTI       WrkOutPrinc                                 BUG3114
     C                   ADD       CL_FLTI       CL_CPAM                                     BUG3114
     C                   ENDIF                                                               BUG3114
      *                                                                                      BUG3114
     C                   IF        CL_ADCF = 'Y'                                             BUG3114
     C                   ADD       CL_CHGA       WrkOutPrinc                                 BUG3114
     C                   ADD       CL_CHGA       CL_CPAM                                     BUG3114
     C                   ENDIF                                                               BUG3114
      *                                                                                      BUG3114
     C                   endif                                                               BUG3114
      *                                                                                      BUG3114
     C                   endif                                                               BUG3114
      *
      ***  Calculate Expected Loan Details
      ***  Use details of DS PDLoAmFilFmt passed in PARM (Prefix PD_)
      *
     C                   Z-ADD     0             WrkExpPrin       13 0
     C                   if        PD_VDAT <> 0                                 Expected Details
      *
     C                   MOVE      PD_VDAT       ZDateNum
     C                   MOVE      BJDFIN        ZDateFmtInd
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDateNum          5 0
     C                   PARM                    ZDateFmtInd       1
     C                   PARM                    ZDateFmt6         6 0
     C                   PARM                    ZDateFmt7         7
     C                   MOVE      ZDateFmt6     DDEVAL
      *
     C                   MOVE      PD_LASN       DDESEQ
      *
      ***  Use details of DS PDLoAmFilFmt passed in PARM (Prefix PD_)
      *
      ***  Expected Principal Amount
      *
     C                   if        DDESEQ = 'LN '
     C                   Z-ADD     CL_RAMT       WrkExpPrin                     Rebate Amount
     C                   Else
     C                   Z-ADD     PD_PRAM       WrkExpPrin                     PD/RE Princ. Amnt
     C                   Endif
      *
     C                   Eval      WrkExpPrin = PD_PRAM + PRAM
      *
     C                   Z-ADD     WrkExpPrin    ZFLD15                         Expected Princ.
     C                   CALLb     'ZFRPED'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM      'J'           ZECODE
     C                   PARM      *BLANKS       ZOUT22           22
     C                   PARM      *BLANKS       ZOUT25           25
     C                   if        ZNEG = '-'
     C                   MOVE      ZOUT21        DDEPRI
     C                   else
     C                   MOVE      ZOUT20        DDEPRI
     C                   endif
      *
      ***  Expected Interest/Withholding tax Amounts
      *
     C     PD_INTA       Add       INTA          WrkExpInt        13 0
     C     PD_WTXA       Add       WTXA          WrkExpWtx        13 0
      *
     C                   Z-ADD     WrkExpInt     ZFLD15                         Expected Interest
     C                   CALLb     'ZFRPED'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM      'J'           ZECODE
     C                   PARM      *BLANKS       ZOUT22           22
     C                   PARM      *BLANKS       ZOUT25           25
     C                   if        ZNEG = '-'
     C                   MOVE      ZOUT21        DDEINT
     C                   else
     C                   MOVE      ZOUT20        DDEINT
     C                   endif
      *
     C                   Z-ADD     WrkExpWtx     ZFLD15                         Expected WTax .
     C                   CALLb     'ZFRPED'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM      'J'           ZECODE
     C                   PARM      *BLANKS       ZOUT22           22
     C                   PARM      *BLANKS       ZOUT25           25
     C                   if        ZNEG = '-'
     C                   MOVE      ZOUT21        DDWHTX
     C                   else
     C                   MOVE      ZOUT20        DDWHTX
     C                   endif
      *
      ***  Expected Total
      *
     C                   IF        DDESEQ = 'LN '
     C                   Z-ADD     CL_RAMT       WrkExpTot        13 0          Loan Rebate Amnt
     C                   Else
     C                   Z-add     TAMT          WrkExpTot                      MR Total Amnt
     C                   endif
      *
     C                   Select
     C                   When      PD_AMTP = 'RE'
     C                   Select
     C                   When      CL_REPT = 2
     C     PD_TAMT       Add       PRAM          WrkExpTot        13 0          PD total+ MR princ
     C                   When      CL_REPT = 3
     C     PD_TAMT       Add       TAMT          WrkExpTot        13 0          PD total+ MR Total
     c                   endSl
     C                   When      PD_AMTP = 'PD'
     C     PD_TAMT       Add       TAMT          WrkExpTot        13 0          PD total+ MR Total
     C                   EndSl
      *
      *
     C                   Z-ADD     WrkExpTot     ZFLD15                         Expected Total
     C                   CALLb     'ZFRPED'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM      'J'           ZECODE
     C                   PARM      *BLANKS       ZOUT22           22
     C                   PARM      *BLANKS       ZOUT25           25
     C                   if        ZNEG = '-'
     C                   MOVE      ZOUT21        DDETOT
     C                   else
     C                   MOVE      ZOUT20        DDETOT
     C                   endif
      *
      ***  Calculated Expected Penality
      *
     c                   Z-ADD     0             WrkExpPen        13 0
     C                   IF        VDAT > PD_VDAT and PD_AMTP = 'PD'
     C                   EXSR      SRPNAM
      *
     C                   Z-ADD     WrkExpPen     ZFLD15                         Expected Penality
     C                   CALLb     'ZFRPED'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM      'J'           ZECODE
     C                   PARM      *BLANKS       ZOUT22           22
     C                   PARM      *BLANKS       ZOUT25           25
     C                   if        ZNEG = '-'
     C                   MOVE      ZOUT21        DDEPEN
     C                   else
     C                   MOVE      ZOUT20        DDEPEN
     C                   endif
     C                   Endif
      *
     C                   Endif                                                  PD_VDAT <> 0
      *
      ***  Display MR Details if not Insert
      *
      *
      ***  Setup Sign of Amounts
      *
     C                   EVAL      WPRAM = 0
 
     C                   if        PRAM < 0                                     Principal
     C                   Eval      DDPSIG = '-'
     C                   Z-SUB     PRAM          WPRAM
     C                   ELSE
     C                   Eval      DDPSIG = ' '
     C                   Z-ADD     PRAM          WPRAM
     C                   Endif
      *
     C                   MOVE(P)   WPRAM         ZFIELD
     C                   Z-ADD     CrNBDP        ZADEC
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
      *
     C                   MOVE      ZFIELD        DDRPRI                         Principal Amount
      *
     C                   EVAL      WINTA = 0
 
     C                   if        INTA < 0                                     Interest
     C                   Eval      DDISIG = '-'
     C                   Z-SUB     INTA          WINTA
     C                   ELSE
     C                   Eval      DDISIG = ' '
     C                   Z-ADD     INTA          WINTA
     C                   Endif
      *
     C                   MOVE(P)   WINTA         ZFIELD
     C                   Z-ADD     CrNBDP        ZADEC
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
      *
     C                   MOVE      ZFIELD        DDRINT                         Interest Amount
      *
     C                   EVAL      WPNAM = 0
 
     C                   if        PNAM < 0                                     Penality
     C                   Eval      DDRPIG = '-'
     C                   Z-SUB     PNAM          WPNAM
     C                   ELSE
     C                   Eval      DDRPIG = ' '
     C                   Z-ADD     PNAM          WPNAM
     C                   Endif
      *
     C                   MOVE(P)   WPNAM         ZFIELD
     C                   Z-ADD     CrNBDP        ZADEC
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
      *
     C                   MOVE      ZFIELD        DDRPEN                         Penality Amount
      *
     C                   EVAL      WTAMT = 0
 
     C                   if        TAMT < 0                                     Penality
     C                   Eval      DDRSIG = '-'
     C                   Z-SUB     TAMT          WTAMT
     C                   ELSE
     C                   Eval      DDRSIG = ' '
     C                   Z-ADD     TAMT          WTAMT
     C                   Endif
      *
     C                   MOVE(P)   WTAMT         ZFIELD
     C                   Z-ADD     CrNBDP        ZADEC
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
      *
     C                   MOVE      ZFIELD        DDRTOT                         Total Amount
      *
      *
      ***  Setup field depending on Action Code
      *
     C                   MOVE      WTIN          DDWTTP                         Withholding tax type
     C                   MOVE      PAST          DDPASD                         Past due Flag
     C                   MOVE      LWOI          DDWOFF                         Write off
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
      * OutstInt    - Calculate Outstanding Interest                  *
      *****************************************************************
     C     OutstInt      BEGSR
      *
      ***  Calculate Amounts to be displayed : Outstanding Interest
      ***  Calculate Evaluate Principal (WrkOutPrinc) and Evaluate Interest (WrkRemainInt)
      *
     C                   Z-ADD     CL_CPAM       WrkOutPrinc      13 0          O/s Principal
     C                   Z-ADD     0             WrkMRIntr        13 0          MR Interest
     C                   Z-ADD     0             WrkOutIntr       13 0          O/s Interest
      *
      ***  Read all live Loan Amendments to know Active Repayments
      *
     C     k@LNRF        SetLL     LOAMRPY                                      RPY_RPY = 'D'
     C     k@LNRF        READE     LOAMRPY                                99    RPY_RPY = 'D'
     C                   DoW       *IN99= *OFF
      *
     C                   select
     C                   when      RPY_AMTP = 'MR'
      *
      ***  Manual Repayment
      *
     c                   Eval      WrkOutPrinc = WrkOutPrinc - RPY_PRAM
     c                   Eval      WrkMRIntr = WrkMRIntr + RPY_INTA
      *
     C**********         when      RPY_AMTP = 'RE' and RPY_AUTO = 'Y'                         CLE134
                                                                                              CLE134
     C                   WHEN          RPY_AMTP = 'RE'                                        CLE134
     C                             and RPY_AUTO = 'Y'                                         CLE134
                                                                                              CLE134
     C                             or  RPY_AMTP = 'RE'                                        CLE134
     C                             and RPY_AUTO = 'C'                                         CLE134
     C                             and CLE134   = 'Y'                                         CLE134
      *
      ***  Repayment schedule
      ***  if Currency is not = To current Details, Convert
      *
     C                   if        RPY_CCY <> CL_CCY
     C                   MOVEL     RPY_CCY       @CURR             3
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @CURR
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     @CURR         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE                         *************
     C                   MOVEL     '003'         DBASE                          * DBERR 003 *
     C                   EXSR      *PSSR                                        *************
     C                   ENDIF
      *
     C                   Z-Add     0             WrkAmnt          19 3
     C                   Z-ADD     A6NBDP        WrNBDP            1 0
     C                   Eval(H)   WrkAmnt = (RPY_PRAM)
     C                                      * power((CrNBDP-WrNBDP)+4)
     C                   if        CL_FMDI = 'D'                                PRAM in Loan CCY
     C                   Eval(H)   RPY_PRAM = Wrkamnt*CL_FCXR
     C                   else
     C                   Eval(H)   RPY_PRAM = Wrkamnt/CL_FCXR
     C                   endif
     C                   Endif
      *
     c                   Eval      WrkOutPrinc = WrkOutPrinc - RPY_PRAM
     c                   Eval      WrkMRIntr = WrkMRIntr + RPY_INTA
      *
     C                   when      RPY_AMTP = 'PF'
      *
      ***  Principal F.....
      *
     c                   Eval      WrkOutPrinc = WrkOutPrinc - RPY_PRAM
     c                   Eval      WrkMRIntr = WrkMRIntr + RPY_INTA
      *
     C                   when      RPY_AMTP = 'PI' or RPY_AMTP = 'PT'
      *
      ***  Principal Increase or Principal T....
      *
     C                   if        RPY_VDAT < WrkValDate
     c                   Eval      WrkOutPrinc = WrkOutPrinc + RPY_PRAM
     C                   Endif
     C                   Endsl
      *
     C     k@LNRF        ReadE     LOAMRPY                                99    RPY_RPY = 'D'
      *
     C                   Enddo
      *
      ***  Recalculate Interest on period : Setup Fields for GLINTC
      *
     C                   if        WrkValDate > BJRDNB and CLE005 = 'Y'
     c                   Z-ADD     WrkValDate    ZIEND             5 0
     C                   else
     C                   Z-ADD     BJRDNB        ZIEND
     C                   endif
      *
     C                   if        CL_MDAT <> 0 and CL_MDAT < BJRDNB
     C                   Z-ADD     CL_MDAT       ZIEND
     C                   endif
      *
     C                   if        WrkReactFacil = 'Y' and CLE007 = 'Y'
     C                   Z-ADD     0             ZINTR
     c                   Else
      *
      *** Add 1 day to End Date depending on Loan Add Day indicator
      *
     c                   Z-ADD     CL_IACD       ZIBEG
     C**********         if        CL_ADDI = 'B' and ZIBEG = WrkValDate                       245082
     C                   if        CL_ADDI = 'B' and ZIEND = CL_MDAT                          245082
     C                             and CL_ORED < CL_MDAT                                      245082
     C                   Eval      ZIEND = ZIEND + 1
     C                   Endif
      *
      ***  if Original entry Date is after Maturity Date
      *
     C                   if        CL_ADDI = 'B' and CL_ORED >= CL_MDAT
     C                   Eval      ZIEND = ZIEND + 1
     C                   Endif
      *
     C                   MOVE      CL_ICBS       ZICALC
     C                   MOVE      CL_INTR       ZIRATE
     C                   Z-ADD     CL_CPAM       ZIAMT
      *
     C                   if        CLE028 = 'Y' and CL_PTYP = 80                             BUG3114
     C                   EXSR      SROSIN                                                    BUG3114
     C                   Z-ADD     ZINTR         WrkOutIntr                                  BUG3114
     C                   else                                                                BUG3114
     C                   EXSR      GLINTC
     C                   endif                                                               BUG3114
      *
      ***  Round interest if defined so.
      *
     C**********         IF        CL_RDFC = 'Y'                                             BUG3114
     C                   IF        CL_RDFC = 'Y' and CL_PTYP <> 80                           BUG3114
     C                   Z-ADD     ZINTR         WrkIntRound      13 0
     C                   Z-ADD     WrkIntRound   ZINTR
     C                   Endif
      *
     C                   endif
      *
      ***  Compute interest paid
      *
     C                   Z-ADD     0             WrkPaidInt       13 0          Paid Interest
      *
     C                   if        CL_MDAT < CL_IACD and CL_MDAT <> 0
     C                             and CL_RECI = 'D'
     C                   Eval      WrkPaidInt = CL_AIAP + CL_AIMN + CL_PDIN
      *
     C                   Else
      *
      ***  Check if Stop Accrual is true
      *
     C                   TESTB     '3'           CL_LONI                  99
     C                   If        *IN99 = *ON
     C                   Eval(h)   WrkPaidInt = CL_AITC + CL_AIAP + CL_AIMN
     C                   Else
     C                   if        CLE028 = 'N' or CLE028 = 'Y'                              BUG3114
     C                             and CL_PTYP <> 80                                         BUG3114
     C                   Eval(h)   WrkPaidInt=ZINTR+CL_AITC                                  BUG3114
     C                   endif                                                               BUG3114
     C**********         Eval(h)   WrkPaidInt=ZINTR+CL_AITC+CL_AIAP+CL_AIMN                  BUG3114
     C**********         Eval(h)   WrkPaidInt=CL_AIAP+CL_AIMN                         BUG3114 243399
     C                   Eval(h)   WrkPaidInt=WrkPaidInt+(CL_AIAP+CL_AIMN)                    243399
     C                   Endif
     C                   endif
      *
      ***  Substract Interest already paid
      *
     C                   if        CLE028 = 'N' or (CLE028 ='Y'                              BUG3114
     C                             and CL_PTYP <> 80) or (CLE028 = 'Y'                       BUG3114
     C                             and CL_PTYP = 80 and CL_ADIF <> 'Y')                      BUG3114
     C                   Eval      WrkPaidInt=WrkPaidInt-CL_IPRD                             BUG3114
     C                   endif                                                               BUG3114
     C**********         Eval      WrkPaidInt=WrkPaidInt-CL_IPRD-CL_ICTD-CL_IWOD             BUG3114
     C                   Eval      WrkPaidInt=WrkPaidInt-CL_ICTD-CL_IWOD                     BUG3114
      *
     C                   if        ZIRATE = 0 and WrkPaidInt > 0
     C                             or ZIRATE <> 0 and WrkPaidInt < 0
     C                   Eval      WrkPaidInt = 0
     C                   Endif
      *
      ***  Outstanding = Interest - Paid Interest
      *
     C                   Eval      WrkOutIntr = WrkPaidInt
      *
      ***  Remaining interest = (Interest - Paid interest) - "MR" interest
      *
     C                   Z-ADD     0             WrkRemainInt     13 0
     C                   Eval      WrkRemainInt = WrkOutintr - WrkMRIntr
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRPNAM - Calculate Expected penality                          *
      *****************************************************************
     C     SRPNAM        BEGSR
      *
      ***  Calcul are working with Facilty details
      *
      ***  If Late Payment type is 'A', expected penalty will be
      ***  equal to the late payment amount
      *
     C     FC_LPTP       IFEQ      'A'
     C     FC_FCCY       IFEQ      CL_CCY
     C                   Z-ADD     FC_LPAM       WrkExpPen
     C                   else
     C     CL_FMDI       Ifeq      'M'
     C                   Eval      WrkExpPen = FC_LPAM / CL_FCXR
     C                   Else
     C                   Eval      WrkExpPen = FC_LPAM * CL_FCXR
     C                   Endif                                                  FMDI = 'M'
     C                   Endif                                                  FCCY <> CCY
     C                   Endif                                                  LPTP = 'A'
      *
      ***  If Late Payment Type is 'P' , use base rate
      *
     C     FC_LPTP       IFEQ      'P'
     C                   MOVEL     FC_LPBR       TmpLPBR           2
     C                   Z-ADD     FC_LPAM       TmpLPAM                        ==> TmpRATE1 (13,7)
     C                   IF        LTFCXPFR <> 0                                              CLE035
     C                   EVAL      WrkRATE = LTFCXPFR                                         CLE035
     C                   ELSE                                                                 CLE035
     C                   IF        CLE035 = 'Y'                                               CLE035
      *                                                                                       CLE035
      ***  Determine rate                                                                     CLE035
      *                                                                                       CLE035
     C                   IF        FC_LPBR <> 0                                               CLE035
      *                                                                                       CLE035
      ***  Read Base rate details                                                             CLE035
      *                                                                                       CLE035
     C                   CALLB     'AOBSRTR0'                                                 CLE035
     C                   PARM      *BLANKS       @RTCD                                        CLE035
     C                   PARM      '*KEY   '     @OPTN                                        CLE035
     C                   PARM      FC_FCCY       PCCY                                         CLE035
     C                   PARM      TmpLPBR       PBSRT                                        CLE035
     C     SDBSRT        PARM      SDBSRT        DSSDY                                        CLE035
     C     @RTCD         IFEQ      *BLANKS                                                    CLE035
     C                   EVAL      WrkRATE = BACBSR                                           CLE035
     C                   ENDIF                                                                CLE035
     C                   ELSE                                                                 CLE035
     C                   EVAL      WrkRATE = LTFCXPRT                                         CLE035
     C                   ENDIF                                                                CLE035
      *                                                                                       CLE035
     C     FC_LPPS       IFEQ      '+'                                                        CLE035
     C                   EVAL      WrkRATE = WrkRATE + LTFCXPSR                               CLE035
     C                   ELSE                                                                 CLE035
     C                   EVAL      WrkRATE = WrkRATE - LTFCXPSR                               CLE035
     C                   Endif                                                                CLE035
      *                                                                                       CLE035
     C                   ELSE                                                                 CLE035
      *
      ***  Determine rate
      *
     C                   if        FC_LPBR <> 0                                 Late Penality B Rate
      *
      ***  Read Base rate details
      *
     C                   CallB     'AOBSRTR0'
     C                   parm      *BLANKS       @RTCD
     C                   parm      '*KEY   '     @OPTN
     C                   parm      FC_FCCY       PCCY              3
     C                   parm      TmpLPBR       PBSRT             2
     C     SDBSRT        PARM      SDBSRT        DSSDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C     FC_LPPS       IFEQ      '+'
     C     BACBSR        Add       TmpRATE1      WrkRATE          11 7
     C                   else
     C     BACBSR        Sub       TmpRATE1      WrkRATE
     C                   Endif
     C                   Endif
      *
     C                   Else
      *
      ***  if Late Penality Base rate is not 'P',
      *
     C                   Z-ADD     TmpRATE1      WrkRate
     C                   Endif
     C                   ENDIF                                                                CLE035
     C                   ENDIF                                                                CLE035
      *
      ***  Compute penality
      *
     C                   Z-ADD     PD_VDAT       ZIBEG                          Expect date
     C                   Z-ADD     VDAT          ZIEND                          Value date
     C                   Z-ADD     CL_ICBS       ZICALC                         Int. Calc Basis
     C                   Z-ADD     WrkExpTot     ZIAMT                          Exp. Tot
     C                   Z-ADD     WrkRATE       ZIRATE                         Calc. Rate
     C                   EXSR      GLINTC
     C                   Z-ADD     ZINTR         WrkExpPen                      Exp. Penality
     C                   Endif
      *
     C                   ENDSR
      *****************************************************************                      BUG3114
      /EJECT                                                                                 BUG3114
      *****************************************************************                      BUG3114
      * SRRFND - Calculate Interest Refunded and Charges Refunded     *                      BUG3114
      *****************************************************************                      BUG3114
     C     SRRFND        BEGSR                                                               BUG3114
      *                                                                                      BUG3114
     C                   Z-ADD     CL_VDAT       W78VDT            5 0                       BUG3114
     C                   Z-ADD     CL_MDAT       W78MDT            5 0                       BUG3114
     C                   Z-ADD     CL_FLTI       W78FLT           15 0                       BUG3114
     C                   MOVE      CL_RFRQ       W78RPF            1                         BUG3114
     C                   Z-ADD     CL_FRPD       W78FRD            5 0                       BUG3114
     C                   Z-ADD     CL_RDYN       W78RPM            2 0                       BUG3114
     C                   MOVE      CL_CCY        W78CCY            3                         BUG3114
     C                   MOVE      *BLANKS       W78LCN            3                         BUG3114
     C                   If        ZDateNum = CL_MDAT                                        BUG3114
     C                   Z-ADD     CL_MDAT       W78BEG            5 0                       BUG3114
     C                   ELSE                                                                BUG3114
     C                   eval      W78BEG = ZDateNum + 1                                     BUG3114
     C                   EndIf                                                               BUG3114
     C                   Z-ADD     CL_MDAT       W78END            5 0                       BUG3114
     C                   MOVE      'A'           W78ROA            1                         BUG3114
     C                   EXSR      RULE78                                                    BUG3114
      *                                                                                      BUG3114
      ** Compute for interest refunded if manual payment is for early                        BUG3114
      ** pay-offs and Add on interest is 'Y'                                                 BUG3114
      *                                                                                      BUG3114
     C                   if        DDESEQ = ' ' and CL_ADIF = 'Y'                            BUG3114
     C                   Z-SUB(H)  W78INT        WINRF            13 0                       BUG3114
     C                   MOVE      *BLANKS       ZFLD15                                      BUG3114
     C                   MOVE      WINRF         ZFLD15                                      BUG3114
     C                   Z-Add     CrNBDP        ZDECS             1 0                       BUG3114
     C                   MOVE      'J'           ZECODE                                      BUG3114
     C                   CALLb     'ZFRPED'                                                  BUG3114
     C                   PARM                    ZFLD15                                      BUG3114
     C                   PARM                    ZDECS                                       BUG3114
     C                   PARM                    ZECODE                                      BUG3114
     C                   PARM      *BLANKS       ZOUT22           22                         BUG3114
     C                   PARM      *BLANKS       ZOUT25           25                         BUG3114
      *                                                                                      BUG3114
     C                   if        ZNEG = '-'                                                BUG3114
     C                   MOVE      ZOUT21        DDINRF                                      BUG3114
     C                   else                                                                BUG3114
     C                   MOVE      ZOUT20        DDINRF                                      BUG3114
     C                   endif                                                               BUG3114
      *                                                                                      BUG3114
     C                   ENDIF                                                               BUG3114
      *                                                                                      BUG3114
      ** Compute for charges refunded if manual payment is for early                         BUG3114
      ** pay-offs and Add on charges is 'Y'                                                  BUG3114
      *                                                                                      BUG3114
     C                   if        DDESEQ = ' ' and CL_ADCF = 'Y'                            BUG3114
      *                                                                                      BUG3114
      ** Compute for charge amount per payment                                               BUG3114
      *                                                                                      BUG3114
     C                   if        W78NPY <> 0                                               BUG3114
     C     CL_CHGA       DIV       W78NPY        WCHGPY           30 9                       BUG3114
     C                   ENDIF                                                               BUG3114
      *                                                                                      BUG3114
      ** Compute for number of months for charges to be refunded                             BUG3114
      ** if value date is not equal to rundate.                                              BUG3114
      *                                                                                      BUG3114
     C     ZDateNum      IFLT      CL_MDAT                                                   BUG3114
     C     W78NPY        SUB       W78NTH        WMOSRF            5 0                       BUG3114
     C                   ADD       2             WMOSRF                                      BUG3114
     C     WCHGPY        MULT      WMOSRF        WCHGRF           30 9                       BUG3114
     C                   Z-SUB(H)  WCHGRF        WCGRF            13 0                       BUG3114
     C                   ELSE                                                                BUG3114
     C                   Z-ADD     *ZERO         WCGRF                                       BUG3114
     C                   ENDIF                                                               BUG3114
      *                                                                                      BUG3114
     C                   MOVE      *BLANKS       ZFLD15                                      BUG3114
     C                   MOVE      WCGRF         ZFLD15                                      BUG3114
     C                   Z-Add     CrNBDP        ZDECS             1 0                       BUG3114
     C                   MOVE      'J'           ZECODE                                      BUG3114
     C                   CALLb     'ZFRPED'                                                  BUG3114
     C                   PARM                    ZFLD15                                      BUG3114
     C                   PARM                    ZDECS                                       BUG3114
     C                   PARM                    ZECODE                                      BUG3114
     C                   PARM      *BLANKS       ZOUT22           22                         BUG3114
     C                   PARM      *BLANKS       ZOUT25           25                         BUG3114
      *                                                                                      BUG3114
     C                   if        ZNEG = '-'                                                BUG3114
     C                   MOVE      ZOUT21        DDCGRF                                      BUG3114
     C                   else                                                                BUG3114
     C                   MOVE      Zout20        DDCGRF                                      BUG3114
     C                   endif                                                               BUG3114
      *                                                                                      BUG3114
     C                   ENDIF                                                               BUG3114
      *                                                                                      BUG3114
     C                   ENDSR                                                               BUG3114
      *****************************************************************                      BUG3114
      /EJECT                                                                                 BUG3114
      *****************************************************************                      BUG3114
      * SROSIN - Calculate Outstanding Interest via Rule of 78        *                      BUG3114
      *****************************************************************                      BUG3114
     C     SROSIN        BEGSR                                                               BUG3114
      *                                                                                      BUG3114
     C                   Z-ADD     CL_VDAT       W78VDT            5 0                       BUG3114
     C                   Z-ADD     CL_MDAT       W78MDT            5 0                       BUG3114
     C                   Z-ADD     CL_FLTI       W78FLT           15 0                       BUG3114
     C                   MOVE      CL_RFRQ       W78RPF            1                         BUG3114
     C                   Z-ADD     CL_FRPD       W78FRD            5 0                       BUG3114
     C                   Z-ADD     CL_RDYN       W78RPM            2 0                       BUG3114
     C                   MOVE      CL_CCY        W78CCY            3                         BUG3114
     C                   MOVE      *BLANKS       W78LCN            3                         BUG3114
     C                   Z-ADD     CL_VDAT       W78BEG            5 0                       BUG3114
     C                   Z-ADD     ZIEND         W78END            5 0                       BUG3114
     C                   MOVE      'A'           W78ROA            1                         BUG3114
      *                                                                                      BUG3114
     C                   EXSR      RULE78                                                    BUG3114
      *                                                                                      BUG3114
     C                   Z-ADD     W78INT        ZINTR                                       BUG3114
      *                                                                                      BUG3114
     C                   ENDSR                                                               BUG3114
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - Initialization                                         *
      *****************************************************************
     C     INIT          BEGSR
      *
      ***  Blank outputs (except for action code)
      *
      *
      ***  Clean Screen Fields
      *
      *
     C                   Z-ADD     VDAT          WrkValDate        5 0
      *
      *
      ***  Retrieve Loan Details
      *
     C                   MOVE      LNRF          k@LNRF
     C     k@lnrf        chain     CLOAN
      *
     C                   if        %found
     c                   Eval      k@CNUM = CL_FCUS
     c                   Eval      K@FACT = CL_FTYP
     c                   Eval      K@FCNO = CL_FSEQ
      *
      ***  Retrieve Facility details
      *
     c     KEYLoanFac    CHAIN     FCLTY
      *                                                                                       CLE035
      ** Retrieve corresponding Facilities extension file                                     CLE035
      *                                                                                       CLE035
     C                   MOVEL     K@CNUM        WKCNUM                                       CLE035
     C                   MOVEL     K@FACT        WKFACT                                       CLE035
     C                   MOVEL     K@FCNO        WKFCNO                                       CLE035
     C     KEYFaciExt    CHAIN     LEFCLTLH                                                   CLE035
     c                   endif
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * GLINTC - Calculate Interest on period                         *
      *****************************************************************
     C     GLINTC        BEGSR
      *
     C                   CALLB     'GLINTC'
     C                   PARM                    ZIBEG             5 0       STARTING DATE
     C                   PARM                    ZIEND             5 0       FINISHING DATE
     C                   PARM                    ZICALC            1 0       CALC. BASIS
     C                   PARM                    ZIAMT            15 0       PRINCIPAL
     C                   PARM                    ZIRATE           11 7       RATE OF INTRST
     C                   PARM                    ZINTR            30 9       INTEREST
      *
     C                   ENDSR
      *****************************************************************                      BUG3114
      /EJECT                                                                                 BUG3114
      *****************************************************************                      BUG3114
      * RULE78 - Calculate Outstanding interest for a given period    *                      BUG3114
      *          based on Rule of 78                                  *                      BUG3114
      *****************************************************************                      BUG3114
     C     RULE78        BEGSR                                                               BUG3114
      *                                                                                      BUG3114
      ** Define input and output fields                                                      BUG3114
      *                                                                                      BUG3114
     C                   Z-ADD     W78VDT        W78VDT            5 0                       BUG3114
     C                   Z-ADD     W78MDT        W78MDT            5 0                       BUG3114
     C                   Z-ADD     W78FLT        W78FLT           15 0                       BUG3114
     C                   MOVE      W78RPF        W78RPF            1                         BUG3114
     C                   Z-ADD     W78FRD        W78FRD            5 0                       BUG3114
     C                   Z-ADD     W78RPM        W78RPM            2 0                       BUG3114
     C                   MOVE      W78CCY        W78CCY            3                         BUG3114
     C                   MOVE      W78LCN        W78LCN            3                         BUG3114
     C                   Z-ADD     W78BEG        W78BEG            5 0                       BUG3114
     C                   Z-ADD     W78END        W78END            5 0                       BUG3114
     C                   MOVE      W78ROA        W78ROA            1                         BUG3114
     C                   Z-ADD     *ZERO         W78INT           30 9                       BUG3114
     C                   Z-ADD     *ZERO         W78SUM            6 0                       BUG3114
     C                   Z-ADD     *ZERO         W78NPY            5 0                       BUG3114
     C                   Z-ADD     *ZERO         W78NTH            3 0                       BUG3114
     C                   Z-ADD     *ZERO         W78PRD            3 0                       BUG3114
      *                                                                                      BUG3114
      ** Save fields, may be used in other programs                                          BUG3114
      *                                                                                      BUG3114
     C                   Z-ADD     ZDAYNO        WZDAYN            5 0                       BUG3114
     C                   MOVE      ZFREQ         WZFREQ            1                         BUG3114
     C                   Z-ADD     ZMDAY         WZMDAY            2 0                       BUG3114
     C                   MOVE      ZCCY          WZCCY             3                         BUG3114
     C                   MOVE      ZLOC          WZLOC             3                         BUG3114
      *                                                                                      BUG3114
      ** Compute for the total number of payments during the life of                         BUG3114
      ** the loan, depending on the repayment frequency                                      BUG3114
      *                                                                                      BUG3114
     C     W78RPF        IFEQ      *BLANKS                                                   BUG3114
     C                   GOTO      ERUL78                                                    BUG3114
     C                   ENDIF                                                               BUG3114
      *                                                                                      BUG3114
     C                   Z-ADD     1             W78NPY                                      BUG3114
     C                   Z-ADD     W78FRD        ZDAYNO                                      BUG3114
     C                   MOVE      W78RPF        ZFREQ                                       BUG3114
     C                   Z-ADD     W78RPM        ZMDAY                                       BUG3114
     C                   MOVE      W78CCY        ZCCY                                        BUG3114
     C                   MOVE      W78LCN        ZLOC                                        BUG3114
     C                   EXSR      ZFREQB                                                    BUG3114
     C     ZDAYNO        DOWLT     W78MDT                                                    BUG3114
     C     ZDAYNO        ANDGE     W78FRD                                                   AR830785
     C                   ADD       1             W78NPY                                      BUG3114
     C                   EXSR      ZFREQB                                                    BUG3114
     C                   ENDDO                                                               BUG3114
      *                                                                                      BUG3114
      ** Add 1 to total number of payments to include repayment on                           BUG3114
      ** maturity date                                                                       BUG3114
      *                                                                                      BUG3114
     C                   ADD       1             W78NPY                                      BUG3114
      *                                                                                      BUG3114
      ** Compute for the sum of digits                                                       BUG3114
      *                                                                                      BUG3114
     C     W78NPY        ADD       1             WKSUM             8 2                       BUG3114
     C                   DIV       2             WKSUM                                       BUG3114
     C     WKSUM         MULT      W78NPY        W78SUM                                      BUG3114
      *                                                                                      BUG3114
      ** If first repayment date is a holiday, move to next working day                      BUG3114
      *                                                                                      BUG3114
     C                   Z-ADD     W78FRD        ZDAYNO                                      BUG3114
     C                   MOVE      W78CCY        ZCCY                                        BUG3114
     C                   MOVE      W78LCN        ZLOC                                        BUG3114
     C                   MOVE      *BLANKS       ZIND                                        BUG3114
     C     ZIND          DOUNE     'H'                                                       BUG3114
     C                   CALLB     'ZCHKH'                                                   BUG3114
     C                   PARM                    ZDAYNO                                      BUG3114
     C                   PARM                    ZCCY                                        BUG3114
     C                   PARM                    BJSLCD                                      BUG3114
     C                   PARM                    ZIND                                        BUG3114
     C     ZIND          IFEQ      'H'                                                       BUG3114
     C                   ADD       1             ZDAYNO                                      BUG3114
     C                   ENDIF                                                               BUG3114
     C                   ENDDO                                                               BUG3114
      *                                                                                      BUG3114
      ** Compute for the Nth payment for interest for a given period                         BUG3114
      *                                                                                      BUG3114
     C     W78ROA        IFEQ      'A'                                                       BUG3114
     C     W78VDT        IFEQ      W78BEG                                                    BUG3114
     C                   Z-ADD     1             W78NTH                                      BUG3114
     C                   ELSE                                                                BUG3114
     C                   Z-ADD     2             W78NTH                                      BUG3114
     C                   ENDIF                                                               BUG3114
     C                   ELSE                                                                BUG3114
     C     W78BEG        IFLT      ZDAYNO                                                    BUG3114
     C     W78BEG        IFEQ      W78END                                                    BUG3114
     C                   Z-ADD     ZDAYNO        W78END                                      BUG3114
     C                   ENDIF                                                               BUG3114
     C                   Z-ADD     ZDAYNO        W78BEG                                      BUG3114
     C                   ENDIF                                                               BUG3114
     C                   Z-ADD     1             W78NTH                                      BUG3114
     C                   ENDIF                                                               BUG3114
      *                                                                                      BUG3114
     C                   MOVE      W78RPF        ZFREQ                                       BUG3114
     C                   Z-ADD     W78RPM        ZMDAY                                       BUG3114
     C                   MOVE      W78CCY        ZCCY                                        BUG3114
     C                   MOVE      W78LCN        ZLOC                                        BUG3114
     C                   MOVE      ZDAYNO        TDAYNO            5 0                      AR830785
     C     ZDAYNO        DOWLT     W78BEG                                                    BUG3114
     C     ZDAYNO        ANDGE     TDAYNO                                                   AR830785
     C                   EXSR      ZFREQB                                                    BUG3114
     C                   ADD       1             W78NTH                                      BUG3114
      *                                                                                      BUG3114
      ** If next  repayment date is a holiday, move to next working day                      BUG3114
      *                                                                                      BUG3114
     C     ZIND          DOUNE     'H'                                                       BUG3114
     C                   CALLB     'ZCHKH'                                                   BUG3114
     C                   PARM                    ZDAYNO                                      BUG3114
     C                   PARM                    ZCCY                                        BUG3114
     C                   PARM                    BJSLCD                                      BUG3114
     C                   PARM                    ZIND                                        BUG3114
     C     ZIND          IFEQ      'H'                                                       BUG3114
     C                   ADD       1             ZDAYNO                                      BUG3114
     C                   ENDIF                                                               BUG3114
     C                   ENDDO                                                               BUG3114
     C                   ENDDO                                                               BUG3114
      *                                                                                      BUG3114
      ** If end date < start date, OR amortisation date same or after                        BUG3114
      ** maturity date, OR repayment date is after maturity date,                            BUG3114
      ** OR repayment date earlier than the first repayment date                             BUG3114
      ** - zeroise the interest amount                                                       BUG3114
      *                                                                                      BUG3114
     C     W78END        IFLT      W78BEG                                                    BUG3114
     C     W78BEG        ORGE      W78MDT                                                    BUG3114
     C     W78ROA        ANDEQ     'A'                                                       BUG3114
     C     W78BEG        ORLT      W78VDT                                                    BUG3114
     C     W78ROA        ANDEQ     'A'                                                       BUG3114
     C     W78BEG        ORGT      W78MDT                                                    BUG3114
     C     W78ROA        ANDEQ     'R'                                                       BUG3114
     C     W78BEG        ORLT      W78FRD                                                    BUG3114
     C     W78END        ANDLT     W78FRD                                                    BUG3114
     C     W78ROA        ANDEQ     'R'                                                       BUG3114
     C                   Z-ADD     *ZERO         W78INT                                      BUG3114
     C                   GOTO      ERUL78                                                    BUG3114
     C                   ENDIF                                                               BUG3114
      *                                                                                      BUG3114
     C                   Z-ADD     W78NTH        WKSAV             3 0                       BUG3114
      *                                                                                      BUG3114
      ** Compute for outstanding interest for the period                                     BUG3114
      ** until given end date or until                                                       BUG3114
      *                                                                                      BUG3114
     C     ZDAYNO        DOUGT     W78END                                                    BUG3114
     C     W78NTH        ORGT      W78NPY                                                    BUG3114
     C     W78NPY        SUB       W78NTH        WINTPD           30 9                       BUG3114
     C                   ADD       1             WINTPD                                      BUG3114
     C                   MULT      W78FLT        WINTPD                                      BUG3114
     C                   DIV       W78SUM        WINTPD                                      BUG3114
     C                   ADD       WINTPD        W78INT                                      BUG3114
      *                                                                                      BUG3114
      ** Do not process frequency date calculation on first payment                          BUG3114
      ** date, i.e., beginning date is less than FRPD                                        BUG3114
      *                                                                                      BUG3114
     C     W78NTH        IFNE      1                                                         BUG3114
     C     W78ROA        ANDEQ     'A'                                                       BUG3114
     C     W78ROA        OREQ      'R'                                                       BUG3114
     C                   EXSR      ZFREQB                                                    BUG3114
      *                                                                                      BUG3114
      ** If next  repayment date is a holiday, move to next working day                      BUG3114
      *                                                                                      BUG3114
     C     ZIND          DOUNE     'H'                                                       BUG3114
     C                   CALLB     'ZCHKH'                                                   BUG3114
     C                   PARM                    ZDAYNO                                      BUG3114
     C                   PARM                    ZCCY                                        BUG3114
     C                   PARM                    BJSLCD                                      BUG3114
     C                   PARM                    ZIND                                        BUG3114
     C     ZIND          IFEQ      'H'                                                       BUG3114
     C                   ADD       1             ZDAYNO                                      BUG3114
     C                   ENDIF                                                               BUG3114
     C                   ENDDO                                                               BUG3114
      *                                                                                      BUG3114
     C                   ENDIF                                                               BUG3114
      *                                                                                      BUG3114
     C                   ADD       1             W78NTH                                      BUG3114
     C                   ADD       1             W78PRD                                      BUG3114
     C                   ENDDO                                                               BUG3114
     C                   SUB       1             W78PRD                                      BUG3114
     C                   Z-ADD     WKSAV         W78NTH            3 0                       BUG3114
      *                                                                                      BUG3114
      ** Restore fields, may be used in other programs                                       BUG3114
      *                                                                                      BUG3114
     C     ERUL78        TAG                                                                 BUG3114
     C                   Z-ADD     WZDAYN        ZDAYNO                                      BUG3114
     C                   MOVE      WZFREQ        ZFREQ                                       BUG3114
     C                   Z-ADD     WZMDAY        ZMDAY                                       BUG3114
     C                   MOVE      WZCCY         ZCCY                                        BUG3114
     C                   MOVE      WZLOC         ZLOC                                        BUG3114
      *                                                                                      BUG3114
     C                   ENDSR                                                               BUG3114
      *****************************************************************                      BUG3114
      /EJECT                                                                                 BUG3114
      *****************************************************************                      BUG3114
      *                                                               *                      BUG3114
      * ZFREQB - Calc day num of next pymnt frq from curr dayno       *                      BUG3114
      *                                                               *                      BUG3114
      *****************************************************************                      BUG3114
     C     ZFREQB        BEGSR                                                               BUG3114
                                                                                             BUG3114
     C                   CallB     'ZFREQB'                                                  BUG3114
     C                   Parm      *blanks       RetCodeIn                                   BUG3114
     C                   Parm                    ZFREQ             1                         BUG3114
     C                   Parm                    ZDAYNO            5 0                       BUG3114
     C                   Parm                    ZCCY              3                         BUG3114
     C                   PARM                    ZLOC                                       AR702741
     C                   Parm                    ZMDAY             2 0                       BUG3114
     C                   Parm                    BJDFIN                                      BUG3114
     C                   Parm      SDGELR        SDGELR                                      BUG3114
                                                                                             BUG3114
     C                   ENDSR                                                               BUG3114
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
     C                   PARM                    MaPyFilFmt
     C                   PARM                    PDLoAmFilFmt
     C                   PARM                    CLE005            1            Feature
     C                   PARM                    CLE007            1            Feature
     C                   PARM                    CLE023            1            Feature
     C                   parm                    WrkReactFacil     1            (from RTV)
      *
      ***  OUTPUT parameters
      *
      ***  Screen format
     C                   PARM                    MaPyScnFmt
     C                   PARM                    CL_PTYP
     C                   PARM                    WrkOutPrinc      13 0
     C                   PARM                    WrkRemainInt     13 0
      *
      ***  Initialize program name
      *
     C                   MOVEL     'LEMAPYCVT'   DBPGM
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
     C                   MOVEL     '001'         DBASE                          * DBERR 001 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      ***  Key to retrieve Loan Details
      *
     C     KeyLoan       KLIST
     C**********         KFLD                    K@LNRF            6 0                        CLE148
     C                   KFLD                    K@LNRF            6                          CLE148
      *
      ***  Key to retrieve Feacilty loan Details
      *
     C     KEYLoanFac    KLIST
     C**********         KFLD                    K@CNUM            6 0                        CSD027
     C                   KFLD                    K@CNUM            6                          CSD027
     C                   KFLD                    K@FACT            3 0
     C                   KFLD                    K@FCNO            2 0
      *                                                                                       CLE035
      ***  Key to retrieve Facility Extension file                                            CLE035
      *                                                                                       CLE035
     C     KEYFaciExt    KLIST                                                                CLE035
     C                   KFLD                    WKCNUM                                       CLE035
     C                   KFLD                    WKFACT                                       CLE035
     C                   KFLD                    WKFCNO                                       CLE035
                                                                                              CLE134
      ** Access Switchable SAR details for the existance of CLE134                            CLE134
                                                                                              CLE134
     C                   CALLB     'AOSARDR0'                                                 CLE134
     C                   PARM      *BLANK        @RTCD                                        CLE134
     C                   PARM      '*VERIFY'     @OPTN                                        CLE134
     C                   PARM      'CLE134'      @SARD                                        CLE134
                                                                                              CLE134
     C     @RTCD         IFEQ      *BLANKS                                                    CLE134
     C                   MOVE      'Y'           CLE134            1                          CLE134
     C                   ELSE                                                                 CLE134
     C                   MOVE      'N'           CLE134                                       CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      *                                                                                      BUG3114
      ** Access Switchable SAR details for the existence of CLE028                           BUG3114
      *                                                                                      BUG3114
     C                   CALLB     'AOSARDR0'                                                BUG3114
     C                   PARM      *BLANK        @RTCD                                       BUG3114
     C                   PARM      '*VERIFY'     @OPTN                                       BUG3114
     C                   PARM      'CLE028'      @SARD                                       BUG3114
      *                                                                                      BUG3114
     C     @RTCD         IFEQ      *BLANKS                                                   BUG3114
     C                   MOVE      'Y'           CLE028            1                         BUG3114
     C                   ELSE                                                                BUG3114
     C                   MOVE      'N'           CLE028                                      BUG3114
     C                   ENDIF                                                               BUG3114
      *                                                                                       CLE035
      ** Access Switchable SAR details for the existence of CLE035                            CLE035
      *                                                                                       CLE035
     C                   CALLB     'AOSARDR0'                                                 CLE035
     C                   PARM      *BLANK        @RTCD                                        CLE035
     C                   PARM      '*VERIFY'     @OPTN                                        CLE035
     C                   PARM      'CLE035'      @SARD                                        CLE035
      *                                                                                       CLE035
     C     @RTCD         IFEQ      *BLANKS                                                    CLE035
     C                   MOVE      'Y'           CLE035            1                          CLE035
     C                   ELSE                                                                 CLE035
     C                   MOVE      'N'           CLE035                                       CLE035
     C                   ENDIF                                                                CLE035
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
**  POWER
0000001
0000010
0000100
0001000
0010000
0100000
1000000
**  CPY@
(c) Finastra International Limited 2002
