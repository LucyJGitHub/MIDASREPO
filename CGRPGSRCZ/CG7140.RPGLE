     H DEBUG                                                                                MD056543
     H CCSID(*GRAPH:*SRC)                                                                   MD056543
      *****************************************************************
/*S*D ***RPGBASE*******************************************************                     MD056543
/*STD *  RPGBASEBND                                                   *                     MD056543
/*EXI *  TEXT('Midas CG Audit Letter Reminder Extract')               *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG7140 - CG Audit Letter Reminder Extract                    *
      *                                                               *
      *  Function: This program creates the extract for each reminder *
      *            required.                                          *
      *                                                               *
      *  Called By: CG7130 - CG Audit Letter Reminder Driver          *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD056543           Date 15Sep20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 CER070             Date 19Aug14               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 BUG24140           Date 29May09               *
      *                 BUG23512A          Date 24Apr09               *
      *                 BUG23291           Date 14Apr09               *
      *                 BUG23572           Date 27Mar09               *
      *                 BUG23253           Date 13Mar09               *
      *                 BUG22741           Date 18Feb09               *
      *                 CER041  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056543 - EDWH SSRS Reports cannot be run.                  *
      *           - Translate graphic fields of CGCORRPD and CGCDSHPD *
      *             to readable unicode equivalent.                   *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24140 - Customer details for Audit Letter Reminder is     *
      *             taken from the Branch Internal Customer           *
      *  BUG23512A - Audit Letter does not follow the BRD Header Rules*
      *  BUG23291 - Retreive account officer detail only when BBACOC  *
      *             is nonblank                                       *
      *  BUG23572 - CHIPSABA Not Accept '0' on screen, so that populat*
      *             with blanks when '0' values in database           *
      *  BUG23253 - Add 'Acknowledgement Reception' and 'Date of      *
      *             Reception' (Recompile)                            *
      *  BUG22741 - Populate Telex Number, when STTX Address is blank *
      *             in SDCUSTPD                                       *
      *  CER041 - Audit Letters Correspondence                        *
      *           (Upgrade of FGE132 and FGE171)                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Indicator usage                                              *
      *  ßßßßßßßßßßßßßßß                                              *
      *                                                               *
      *  80   -    chain CGCORRL4 failed                              *
      *  89   -    account officer code in SDACOFPD not found         *
      *  90   -    Poffered for READE LOOPS                           *
      *  99   -    General error indicator                            *
      *                                                               *
      *****************************************************************
      *
      ** Midas CG Correspondent details by customer
      *
     FCGCORRL4  IF   E           K DISK
     F*================================================================
     D*COPY*CGCPYSRC,CGPACKE                                                                MD056543
     D*COPY*CGCPYSRC,SRERRE                                                                 MD056543
     D/COPY CGCPYSRC,CGPACKEILE                                                             MD056543
     D/COPY CGCPYSRC,SRERRDLE                                                               MD056543
      *
      ** Number Arrays
      *
     D*##NUMA***       S              1    DIM(29)                                          MD056543
      *
      ** Array of Currencies accessed by program
      *
     D ##CY            S              3    DIM(100)
      *
      ** Copyright array.
      *
      *                                                                                     BUG22741
      **  External DS for Additinal Customer details                                        BUG22741
      *                                                                                     BUG22741
     D SDACUS        E DS                  EXTNAME(SDACUSPD)                                BUG22741
      *
      ** Look-up string for RDE definition Array
      *
     D ##SDS           DS
     D  ##S                    1   5632
     D                                     DIM(22)                                          MD056543
      *
     D #@SDS           DS
     D  #@S                 5120   5120
      *
      ** Packed data string.
      *
     D                 DS
     D  ##W                    1     20
     D                                     DIM(20)
     D  ##WNUM                 1     20  0
      *
      ** Number Field
      *
     D                 DS
     D  ##ITMA                 1      8
     D  ##ITEM                 1      8  0
      *
      ** Used to convert item reference from character to numeric
      *
     D                 DS
     D  ##NCIT                 1      6
     D  NMCY                   1      3
     D  SITP                   4      6
     D                 DS
     D  ##CCCC                 1      5
     D  ##CCY                  1      3
     D  ##CCD                  4      5
      *
      ** For error reporting
      ** Named constants
      *
     D W#PTYP          C                   CONST('AUDITLET')
     D W#PSTY          C                   CONST('REMIND')
      *
     D ##UDCR        E DS                  EXTNAME(CGUDCRPD)
      *
      ** External DS for incomplete reference
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External DS for Bank details
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      *
      ** External DS for General Ledger details
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
      ** External DS for Module details
      *
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      *
      ** External DS for Securities Trading Module details
      *
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D  QQACC1       E                     EXTFLD(QQACCD)
      *
      ** External DS for Trading Module details
      *
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
     D  QQACC2       E                     EXTFLD(QQACCD)
      *
      ** External DS for Dealing Module details
      *
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  QQACC3       E                     EXTFLD(QQACCD)
      *
      ** External DS for Retail details
      *
     D SDMGME        E DS                  EXTNAME(SDMGMEPD)
      *
      ** External DS for Message Management details
      *
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
      *
      ** External DS for Funds Transfer details
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      *
      ** External DS for branch details
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  QQDFA1       E                     EXTFLD(QQDFAC)
      *
      ** External DS for customer details
      *
     D SDCURR        E DS                  OCCURS(101) EXTNAME(SDCURRPD)
      *
      ** External DS for currency details
      *
     D SDACOF        E DS                  EXTNAME(SDACOFPD)
      *
      ** External DS for account officer details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** MIDAS Switchable Features Accessed Via Access Program
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** First DS for access programs, short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Second DS for access programs, long data structure
      *
     D W0FMT         E DS                  EXTNAME(CGUDTAPD)
      *
      ** Record format of PF/CGUDTAPD for use as a parameter
      *
     D*COPY*CGCPYSRC,CGPACKI                                                                MD056543
     D/COPY CGCPYSRC,CGPACKIILE                                                             MD056543
      *
     D CPYR            DS
      *
      ** Data Structure for Compilation - Copyright Insertion
      *
     D  ##CPY                  1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D*COPY*CGCPYSRC,SRERRI                                                                 MD056543
      *
      ** DS to store subroutine specific data.
      ** - Saved Path
      *
     D ##PATH          DS                  OCCURS(20)
     D  ##GRPS                 1      6
      *
     D ##BIND          DS                  OCCURS(20)
     D  ##PBIN                 1      6  0 INZ(1)
     D  ##TBIN                 7     12  0 INZ(1)
      *
     D                 DS
     D  #@BIND                 1      6  0 INZ(1)
      *
     D #PDS            DS
     D  P1                     1      3  0 INZ(0)
     D  P2                     4      6  0
     D  P3                     7      9  0
     D  P4                    10     12  0
     D  P5                    13     15  0
     D DSPARM        E DS                  EXTNAME(CGAUHSL1)
      *
      ** External DS for parameter passed to CG7140
      *
     C/SPACE 5
      *****************************************************************
      *  Process     -  MAINLINE                                      *
      *  Function    -  Mainline processing                           *
      *                                                               *
      *  Called by   -  None                                          *
      *  Calls       -  SRINIT - Initial Processing - On First Call   *
      *                 SRINZ  - Initialise Fields on Each Invocation *
      *                 SRMAIN - Main Processing                      *
      *****************************************************************
      *
      ** Parameter list for current program invocation.
      *
     C     *ENTRY        PLIST
     C                   PARM                    W0RTN
     C                   PARM                    W0CMT             3
     C                   PARM                    ##COPD            1
     C                   PARM                    DSPARM
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'MAIN'        @STK(Q)
      *
      ** Initial processing - Once Only
      *
     C     ##INIT        IFEQ      *BLANK
     C                   EXSR      SRINIT
     C                   MOVE      'Y'           ##INIT            1
     C                   ENDIF
      *
      ** Initialisation processing
      *
     C                   EXSR      SRINZ
      *
      ** Main processing
      *
     C                   EXSR      SRMAIN
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      ** Terminate program
      *
     C                   RETURN
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      *  Subroutine  -  SRMAIN                                        *
      *  Function    -  Main processing                               *
      *                                                               *
      *  Called by   -  Mainline                                      *
      *  Calls       -                                                *
      *****************************************************************
     C     SRMAIN        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRMAIN'      @STK(Q)
      *
      ** Generate reference number by writing to PF/CGUDCRPD
      ** If no confirmation to be produced, then bypass
      *
     C                   MOVE      'N'           ##COPD
     C                   EXSR      SRGENR
     C     ##COPD        CABEQ     'N'           EXMAIN
      *
     C                   EXSR      AUDTRM                                       Extract
      *
     C     EXMAIN        TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      *  Subroutine  -  AUDTRM                                        *
      *  Function    -  Process: CER041 - Audit Letter Reminder       *
      *                                                               *
      *  Called by   -                                                *
      *  Calls       -                                                *
      *****************************************************************
     C     AUDTRM        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'AUDTRM'      @STK(Q)
      *
     C                   ADD       1             P1
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'AUDTRM'      ##GRPS
      *
     C                   EXSR      SRPATH
      *
     C                   EXSR      PSHGRS
      *
     C     FBRCA         IFEQ      'ALL'
      *
      ** Get Customer Details for Branch Internal Customer
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY   '     ##OPTN
     C                   PARM      FCNUM         ##KEY1            6            From AOBRCHR0
     C                   PARM      *BLANKS       ##KYST            7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      ** Database error
      *
     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'SDCUSTPD'    W0FILE
     C                   MOVEL     FCNUM         W0KEY                          ***************
     C                   Z-ADD     2             W0ERNB                         * DB ERROR 02 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ELSE
     C                   MOVEL     BBBRCD        BRCHCD            3
     C                   END
     C                   ELSE
     C                   MOVEL     FBRCA         BRCHCD            3
     C                   END
      *
      ** Get Branch Details for branch internal customer no.
      *
     C                   CALL      'AOBRCHR0'
     C                   PARM      '*MSG    '    ##RTCD
     C                   PARM      '*KEY    '    ##OPTN
     C                   PARM      BRCHCD        ##BRCD            3
     C     SDBRCH        PARM      SDBRCH        DSFDY
      *
      ** Database error
      *
     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'SDBRCHPD'    W0FILE
     C                   MOVEL     FBRCA         W0KEY                          ***************
     C                   Z-ADD     1             W0ERNB                         * DB ERROR 01 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ELSE
      *
      ** Get Customer Details with Branch Internal Customer no.
      *
     C                   MOVEL     A8BICN        BICUST            6
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY   '     ##OPTN
     C                   PARM      BICUST        ##KEY1                         From AOBRCHR0
     C                   PARM      *BLANKS       ##KYST            7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     A8BICN        CHAIN     CGCORRL4                           80
     C     ##RTCD        IFEQ      *BLANKS
     C     *IN80         ANDEQ     *OFF
      *
     C                   EXSR      CGBRCH
      *
     C                   EXSR      Z132RD
      *
     C**********           EXSR CUST                                                       BUG23512A
     C                   EXSR      CUSTE                                                   BUG23512A
      *
     C                   EXSR      BRANCH
      *
      ** Access acount officer file by account officer code
      *
     C     BBACOC        IFNE      *BLANKS                                                  BUG23291
      *                                                                                     BUG23291
     C                   CALL      'AOACOFR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY   '     ##OPTN
     C                   PARM      BBACOC        ##KEY1                         From AOCUSTR0
     C     SDACOF        PARM      SDACOF        DSSDY
      *
      ** Database error
      *
     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'SDACOFPD'    W0FILE
     C                   MOVEL     BBACOC        W0KEY                          ***************
     C                   Z-ADD     1             W0ERNB                         * DB ERROR 01 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ELSE
      *
     C                   EXSR      ACOF
      *
     C                   END
     C                   ENDIF                                                              BUG23291
     C                   END
     C                   END
      *
      ** Decrement Path DS index
      *
     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1
      *
     C                   EXSR      POPGRS
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
     C/SPACE 5
      *****************************************************************
      *  Subroutine  -  Z132RD                                        *
      *  Function    -  Process: FGE132 - Saldenb.Reminder Data       *
      *                                                               *
      *  Called by   -                                                *
      *  Calls       -                                                *
      *****************************************************************
     C     Z132RD        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'Z132RD'      @STK(Q)
      *
     C                   ADD       1             P1
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'Z132RD'      ##GRPS
      *
     C                   EXSR      SRPATH
      *
     C                   EXSR      PSHGRS
      *
     C                   Z-ADD     0             R1                3 0
      *
      ** 1. Item identifier
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ITEM_ID '    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     FPINR         R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** 2. Production date
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ZZPDAT  '    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     FPDAT         R#DATA
     C                   MOVEL     'Date  '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'POST_MOD'    #@RDE
     C                   MOVE      'UL'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     FMODU         R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
     C                   EXSR      SRADTA
     C                   EXSR      SRODTA
      *
      ** Decrement Path DS index
      *
     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1
      *
     C                   EXSR      POPGRS
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
     C/SPACE 5
      *****************************************************************
      *  Subroutine  -  CGBRCH                                        *
      *  Function    -  Process: FGE091 - Addtnl Address Info         *
      *                                                               *
      *  Called by   -                                                *
      *  Calls       -                                                *
      *****************************************************************
     C     CGBRCH        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'CGBRCH'      @STK(Q)
      *
     C                   ADD       1             P1
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'CGBRCH'      ##GRPS
      *
     C                   EXSR      SRPATH
      *
     C                   EXSR      PSHGRS
      *
     C                   Z-ADD     0             R1                3 0
      *                                                                                     BUG22741
      ** Get Additional Customer Details for Branch Internal Customer                       BUG22741
      *                                                                                     BUG22741
     C                   CALL      'AOACUSR0'                                               BUG22741
     C                   PARM      *BLANKS       ##RTCD                                     BUG22741
     C                   PARM      '*KEY   '     ##OPTN                                     BUG22741
     C                   PARM      A8BICN        ##KEY             6                        BUG22741
     C     SDACUS        PARM      SDACUS        DSSDY                                      BUG22741
      *                                                                                     BUG22741
      ** Database error                                                                     BUG22741
      *                                                                                     BUG22741
     C     ##RTCD        IFNE      *BLANKS                                                  BUG22741
     C                   MOVEL     'SDACUSPD'    W0FILE                                     BUG22741
     C                   MOVEL     A8BICN        W0KEY                                      BUG22741
     C                   Z-ADD     31            W0ERNB                                     BUG22741
     C                   MOVEL     'MEM5004'     W0MSGD                                     BUG22741
     C                   MOVEL     'MIDAS  '     W0MSGF                                     BUG22741
     C                   EXSR      SRERR                                                    BUG22741
     C                   END                                                                BUG22741
      *
      ** FGE091 - Bankleitzahl
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ZZBLCD  '    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     BBBLCD        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** FGE091 - SWIFT code
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ZZCSID  '    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     BBCSID        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** FGE091 - Telephone number
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ZZCTNB  '    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     BBCTNB        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** FGE091 - Fax number
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ZZFAX   '    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     CDFAX         R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** FGE091 - Telex number
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ZZSTAD  '    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C     BBSTAD        IFNE      *BLANKS                                                  BUG22741
     C**********           MOVELBBTXA1    R#DATA                                            BUG22741
     C                   MOVEL     BBSTAD        R#DATA                                     BUG22741
     C                   ELSE                                                               BUG22741
     C                   MOVEL     E5TXNB        R#DATA                                     BUG22741
     C                   ENDIF                                                              BUG22741
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                     BUG23572
      ** Branch Internal Customer Number                                                    BUG23572
      *                                                                                     BUG23572
     C                   ADD       1             R1                                         BUG23572
     C                   CLEAR                   R#DATA                                     BUG23572
     C                   CLEAR                   R#DEFN                                     BUG23572
     C                   CLEAR                   #@RDE                                      BUG23572
     C                   MOVEL     'BICNBR  '    #@RDE                                      BUG23572
     C     ##RDE         CAT       #@RDE:1       ##RDE                                      BUG23572
     C                   MOVEL     A8BICN        R#DATA                                     BUG23572
     C                   MOVEL     R#DATA        ##D(R1)                                    BUG23572
     C                   MOVEL     R#DEFN        ##R(R1)                                    BUG23572
      *                                                                                     BUG23572
      ** Chips Id (Branch-Internal Customer)                                                BUG23572
      *                                                                                     BUG23572
     C                   ADD       1             R1                                         BUG23572
     C                   CLEAR                   R#DATA                                     BUG23572
     C                   CLEAR                   R#DEFN                                     BUG23572
     C                   CLEAR                   #@RDE                                      BUG23572
     C                   MOVE      'D '          #@RDE                                      BUG23572
     C                   MOVEL     'BCHIPS_I'    #@RDE                                      BUG23572
     C     ##RDE         CAT       #@RDE:1       ##RDE                                      BUG23572
     C                   MOVEL     BBCHID        R#DATA                                     BUG23572
     C                   MOVEL     R#DATA        ##D(R1)                                    BUG23572
     C                   MOVEL     R#DEFN        ##R(R1)                                    BUG23572
      *                                                                                     BUG23572
      ** Chips ABA (Branch-Internal Customer)                                               BUG23572
      *                                                                                     BUG23572
     C                   ADD       1             R1                                         BUG23572
     C                   CLEAR                   R#DATA                                     BUG23572
     C                   CLEAR                   R#DEFN                                     BUG23572
     C                   CLEAR                   #@RDE                                      BUG23572
     C                   MOVE      'BA'          #@RDE                                      BUG23572
     C                   MOVEL     'BCHIPS_A'    #@RDE                                      BUG23572
     C     ##RDE         CAT       #@RDE:1       ##RDE                                      BUG23572
     C     BBCABA        IFNE      0                                                        BUG23572
     C                   MOVEL     BBCABA        R#DATA                                     BUG23572
     C                   ELSE                                                               BUG23572
     C                   MOVEL     *BLANKS       R#DATA                                     BUG23572
     C                   ENDIF                                                              BUG23572
     C                   MOVEL     R#DATA        ##D(R1)                                    BUG23572
     C                   MOVEL     R#DEFN        ##R(R1)                                    BUG23572
      *                                                                                     BUG23572
      ** Chaps sort code (Branch-Internal Customer)                                         BUG23572
      *                                                                                     BUG23572
     C                   ADD       1             R1                                         BUG23572
     C                   CLEAR                   R#DATA                                     BUG23572
     C                   CLEAR                   R#DEFN                                     BUG23572
     C                   CLEAR                   #@RDE                                      BUG23572
     C                   MOVE      'RT'          #@RDE                                      BUG23572
     C                   MOVEL     'BCHAPS_S'    #@RDE                                      BUG23572
     C     ##RDE         CAT       #@RDE:1       ##RDE                                      BUG23572
     C                   MOVEL     BBCHSC        R#DATA                                     BUG23572
     C                   MOVEL     R#DATA        ##D(R1)                                    BUG23572
     C                   MOVEL     R#DEFN        ##R(R1)                                    BUG23572
      *                                                                                     BUG23572
      ** BOJ (Branch-Internal Customer)                                                     BUG23572
      *                                                                                     BUG23572
     C                   ADD       1             R1                                         BUG23572
     C                   CLEAR                   R#DATA                                     BUG23572
     C                   CLEAR                   R#DEFN                                     BUG23572
     C                   CLEAR                   #@RDE                                      BUG23572
     C                   MOVEL     'BBOJ    '    #@RDE                                      BUG23572
     C     ##RDE         CAT       #@RDE:1       ##RDE                                      BUG23572
     C                   MOVEL     BBBFIC        R#DATA                                     BUG23572
     C                   MOVEL     R#DATA        ##D(R1)                                    BUG23572
     C                   MOVEL     R#DEFN        ##R(R1)                                    BUG23572
      *                                                                                     BUG23572
      ** Fedwire (Branch-Internal Customer)                                                 BUG23572
      *                                                                                     BUG23572
     C                   ADD       1             R1                                         BUG23572
     C                   CLEAR                   R#DATA                                     BUG23572
     C                   CLEAR                   R#DEFN                                     BUG23572
     C                   CLEAR                   #@RDE                                      BUG23572
     C                   MOVEL     'BFEDWIRE'    #@RDE                                      BUG23572
     C     ##RDE         CAT       #@RDE:1       ##RDE                                      BUG23572
     C                   MOVEL     BBFWCD        R#DATA                                     BUG23572
     C                   MOVEL     R#DATA        ##D(R1)                                    BUG23572
     C                   MOVEL     R#DEFN        ##R(R1)                                    BUG23572
      *
     C                   EXSR      SRADTA
     C                   EXSR      SRODTA
      *
     C                   EXSR      POPGRS
      *
      ** Decrement Path DS index
      *
     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      ***Subroutine**-**CUST                                          *                    BUG23512A
      *  Subroutine  -  CUSTE                                         *                    BUG23512A
      *  Function    -  Process: Customer Details                     *
      *                                                               *
      *  Called by   -                                                *
      *  Calls       -                                                *
      *****************************************************************
     C********** CUST      BEGSR                                                           BUG23512A
     C     CUSTE         BEGSR                                                             BUG23512A
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C**********           MOVEL'CUST  '  @STK,Q                                           BUG23512A
     C                   MOVEL     'CUSTE '      @STK(Q)                                   BUG23512A
      *
     C                   ADD       1             P1
     C     P1            OCCUR     ##PATH
     C**********           MOVEL'CUST  '  ##GRPS    P                                      BUG23512A
     C                   MOVEL(P)  'CUSTE '      ##GRPS                                    BUG23512A
      *
     C                   EXSR      SRPATH
      *
     C                   Z-ADD     0             R1                3 0
     C                   EXSR      PSHGRS
      *
      ** Access Customer Details                                                            BUG24140
      *                                                                                     BUG24140
     C                   CALL      'AOCUSTR0'                                               BUG24140
     C                   PARM      *BLANKS       ##RTCD                                     BUG24140
     C                   PARM      '*KEY   '     ##OPTN                                     BUG24140
     C                   PARM      FCNUM         ##KEY1            6            From AOBRCH BUG24140
     C                   PARM      *BLANKS       ##KYST            7                        BUG24140
     C     SDCUST        PARM      SDCUST        DSSDY                                      BUG24140
      *                                                                                     BUG24140
      ** If no record found, Database error.                                                BUG24140
      *                                                                                     BUG24140
     C     ##RTCD        IFNE      *BLANK                                                   BUG24140
     C                   MOVEL     'SDCUSTPD'    W0FILE                                     BUG24140
     C                   MOVEL     FCNUM         W0KEY                          ************BUG24140
     C                   Z-ADD     3             W0ERNB                         * DBERROR03 BUG24140
     C                   MOVEL     'MEM5004'     W0MSGD                         ************BUG24140
     C                   MOVEL     'MIDAS  '     W0MSGF                                     BUG24140
     C                   EXSR      SRERR                                                    BUG24140
     C                   ENDIF                                                              BUG24140
      *                                                                                     BUG24140
      ** Get Correspondent Details for Customer                                             BUG24140
      *                                                                                     BUG24140
     C     FCNUM         CHAIN     CGCORRL4                           99                    BUG24140
      *                                                                                     BUG24140
     C     *IN99         IFEQ      '1'                                                      BUG24140
      *                                                                                     BUG24140
      ** Database error                                                                     BUG24140
      *                                                                                     BUG24140
     C                   MOVEL     'CGCORRPD'    W0FILE                                     BUG24140
     C                   MOVEL     FCNUM         W0KEY                                      BUG24140
     C                   Z-ADD     4             W0ERNB                                     BUG24140
     C                   MOVEL     'MEM5004'     W0MSGD                                     BUG24140
     C                   MOVEL     'MIDAS  '     W0MSGF                                     BUG24140
     C                   EXSR      SRERR                                                    BUG24140
     C                   ENDIF                                                              BUG24140
      *
      ** Customer address line 1
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      '1 '          #@RDE
     C                   MOVEL     'CUST_ADR'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     BBCNA1        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Customer address line 2
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      '2 '          #@RDE
     C                   MOVEL     'CUST_ADR'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     BBCNA2        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Customer address line 3
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      '3 '          #@RDE
     C                   MOVEL     'CUST_ADR'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     BBCNA3        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Customer address line 4
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      '4 '          #@RDE
     C                   MOVEL     'CUST_ADR'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     BBCNA4        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Customer Name
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'E '          #@RDE
     C                   MOVEL     'CUST_NAM'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     BBCRNM        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                    BUG23512A
      ** Customer Town                                                                     BUG23512A
      *                                                                                    BUG23512A
     C                   ADD       1             R1                                        BUG23512A
     C                   CLEAR                   R#DATA                                    BUG23512A
     C                   CLEAR                   R#DEFN                                    BUG23512A
     C                   CLEAR                   #@RDE                                     BUG23512A
     C                   MOVE      'N '          #@RDE                                     BUG23512A
     C                   MOVEL     'CUST_TOW'    #@RDE                                     BUG23512A
     C     ##RDE         CAT       #@RDE:1       ##RDE                                     BUG23512A
     C                   MOVEL     BBCRTN        R#DATA                                    BUG23512A
     C                   MOVEL     R#DATA        ##D(R1)                                   BUG23512A
     C                   MOVEL     R#DEFN        ##R(R1)                                   BUG23512A
      *
      ** Customer Number
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CUSTOMER'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     BBCUST        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                    BUG23512A
      ** BOJ (Customer)                                                                    BUG23512A
      *                                                                                    BUG23512A
     C                   ADD       1             R1                                        BUG23512A
     C                   CLEAR                   R#DATA                                    BUG23512A
     C                   CLEAR                   R#DEFN                                    BUG23512A
     C                   CLEAR                   #@RDE                                     BUG23512A
     C                   MOVEL     'CBOJ    '    #@RDE                                     BUG23512A
     C     ##RDE         CAT       #@RDE:1       ##RDE                                     BUG23512A
     C                   MOVEL     BBBFIC        R#DATA                                    BUG23512A
     C                   MOVEL     R#DATA        ##D(R1)                                   BUG23512A
     C                   MOVEL     R#DEFN        ##R(R1)                                   BUG23512A
      *                                                                                    BUG23512A
      ** Chaps sort code (Branch-Internal Customer)                                        BUG23512A
      *                                                                                    BUG23512A
     C                   ADD       1             R1                                        BUG23512A
     C                   CLEAR                   R#DATA                                    BUG23512A
     C                   CLEAR                   R#DEFN                                    BUG23512A
     C                   CLEAR                   #@RDE                                     BUG23512A
     C                   MOVE      'RT'          #@RDE                                     BUG23512A
     C                   MOVEL     'CCHAPS_S'    #@RDE                                     BUG23512A
     C     ##RDE         CAT       #@RDE:1       ##RDE                                     BUG23512A
     C                   MOVEL     BBCHSC        R#DATA                                    BUG23512A
     C                   MOVEL     R#DATA        ##D(R1)                                   BUG23512A
     C                   MOVEL     R#DEFN        ##R(R1)                                   BUG23512A
      *                                                                                    BUG23512A
      ** Chips ABA (Customer)                                                              BUG23512A
      *                                                                                    BUG23512A
     C                   ADD       1             R1                                        BUG23512A
     C                   CLEAR                   R#DATA                                    BUG23512A
     C                   CLEAR                   R#DEFN                                    BUG23512A
     C                   CLEAR                   #@RDE                                     BUG23512A
     C                   MOVE      'BA'          #@RDE                                     BUG23512A
     C                   MOVEL     'CCHIPS_A'    #@RDE                                     BUG23512A
     C     ##RDE         CAT       #@RDE:1       ##RDE                                     BUG23512A
     C     BBCABA        IFNE      0                                                       BUG23512A
     C                   MOVEL     BBCABA        R#DATA                                    BUG23512A
     C                   ELSE                                                              BUG23512A
     C                   MOVEL     *BLANKS       R#DATA                                    BUG23512A
     C                   ENDIF                                                             BUG23512A
     C                   MOVEL     R#DATA        ##D(R1)                                   BUG23512A
     C                   MOVEL     R#DEFN        ##R(R1)                                   BUG23512A
      *                                                                                    BUG23512A
      ** Chips-Id (Customer)                                                               BUG23512A
      *                                                                                    BUG23512A
     C                   ADD       1             R1                                        BUG23512A
     C                   CLEAR                   R#DATA                                    BUG23512A
     C                   CLEAR                   R#DEFN                                    BUG23512A
     C                   CLEAR                   #@RDE                                     BUG23512A
     C                   MOVE      'D '          #@RDE                                     BUG23512A
     C                   MOVEL     'CCHIPS_I'    #@RDE                                     BUG23512A
     C     ##RDE         CAT       #@RDE:1       ##RDE                                     BUG23512A
     C                   MOVEL     BBCHID        R#DATA                                    BUG23512A
     C                   MOVEL     R#DATA        ##D(R1)                                   BUG23512A
     C                   MOVEL     R#DEFN        ##R(R1)                                   BUG23512A
      *                                                                                    BUG23512A
      ** Fedwire (Customer)                                                                BUG23512A
      *                                                                                    BUG23512A
     C                   ADD       1             R1                                        BUG23512A
     C                   CLEAR                   R#DATA                                    BUG23512A
     C                   CLEAR                   R#DEFN                                    BUG23512A
     C                   CLEAR                   #@RDE                                     BUG23512A
     C                   MOVEL     'CFEDWIRE'    #@RDE                                     BUG23512A
     C     ##RDE         CAT       #@RDE:1       ##RDE                                     BUG23512A
     C                   MOVEL     BBFWCD        R#DATA                                    BUG23512A
     C                   MOVEL     R#DATA        ##D(R1)                                   BUG23512A
     C                   MOVEL     R#DEFN        ##R(R1)                                   BUG23512A
      *                                                                                    BUG23512A
      ** German Bankleitzahl                                                               BUG23512A
      *                                                                                    BUG23512A
     C                   ADD       1             R1                                        BUG23512A
     C                   CLEAR                   R#DATA                                    BUG23512A
     C                   CLEAR                   R#DEFN                                    BUG23512A
     C                   CLEAR                   #@RDE                                     BUG23512A
     C                   MOVEL     'CUST_BLZ'    #@RDE                                     BUG23512A
     C     ##RDE         CAT       #@RDE:1       ##RDE                                     BUG23512A
     C                   MOVEL     BBBLCD        R#DATA                                    BUG23512A
     C                   MOVEL     R#DATA        ##D(R1)                                   BUG23512A
     C                   MOVEL     R#DEFN        ##R(R1)                                   BUG23512A
      *                                                                                    BUG23512A
      ** Customer Fax Number                                                               BUG23512A
      *                                                                                    BUG23512A
     C                   ADD       1             R1                                        BUG23512A
     C                   CLEAR                   R#DATA                                    BUG23512A
     C                   CLEAR                   R#DEFN                                    BUG23512A
     C                   CLEAR                   #@RDE                                     BUG23512A
     C                   MOVEL     'CUST_FAX'    #@RDE                                     BUG23512A
     C     ##RDE         CAT       #@RDE:1       ##RDE                                     BUG23512A
     C                   MOVEL     CDFAX         R#DATA                                    BUG23512A
     C                   MOVEL     R#DATA        ##D(R1)                                   BUG23512A
     C                   MOVEL     R#DEFN        ##R(R1)                                   BUG23512A
      *                                                                                    BUG23512A
      ** Customer SWIFT code                                                               BUG23512A
      *                                                                                    BUG23512A
     C                   ADD       1             R1                                        BUG23512A
     C                   CLEAR                   R#DATA                                    BUG23512A
     C                   CLEAR                   R#DEFN                                    BUG23512A
     C                   CLEAR                   #@RDE                                     BUG23512A
     C                   MOVE      'FT'          #@RDE                                     BUG23512A
     C                   MOVEL     'CUST_SWI'    #@RDE                                     BUG23512A
     C     ##RDE         CAT       #@RDE:1       ##RDE                                     BUG23512A
     C                   MOVEL     BBCSID        R#DATA                                    BUG23512A
     C                   MOVEL     R#DATA        ##D(R1)                                   BUG23512A
     C                   MOVEL     R#DEFN        ##R(R1)                                   BUG23512A
      *                                                                                    BUG23512A
      ** Customer Telephone Number                                                         BUG23512A
      *                                                                                    BUG23512A
     C                   ADD       1             R1                                        BUG23512A
     C                   CLEAR                   R#DATA                                    BUG23512A
     C                   CLEAR                   R#DEFN                                    BUG23512A
     C                   CLEAR                   #@RDE                                     BUG23512A
     C                   MOVEL     'CUST_TEL'    #@RDE                                     BUG23512A
     C     ##RDE         CAT       #@RDE:1       ##RDE                                     BUG23512A
     C                   MOVEL     BBCTNB        R#DATA                                    BUG23512A
     C                   MOVEL     R#DATA        ##D(R1)                                   BUG23512A
     C                   MOVEL     R#DEFN        ##R(R1)                                   BUG23512A
      *
     C                   EXSR      SRADTA
     C                   EXSR      SRODTA
      *
     C                   EXSR      POPGRS
      *
      ** Decrement Path DS index
      *
     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      *  Subroutine  -  BRANCH                                        *
      *  Function    -  Process: Branch Details                       *
      *                                                               *
      *  Called by   -                                                *
      *  Calls       -                                                *
      *****************************************************************
     C     BRANCH        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'BRANCH'      @STK(Q)
      *
     C                   ADD       1             P1
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'BRANCH'      ##GRPS
      *
     C                   EXSR      SRPATH
      *
     C                   Z-ADD     0             R1                3 0
      *
     C                   EXSR      PSHGRS
      *
      ** Branch (Code)
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'BRANCH  '    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     A8BRCD        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Branch Name
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'AM'          #@RDE
     C                   MOVEL     'BRANCH N'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     A8BRNM        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
     C                   EXSR      SRADTA
     C                   EXSR      SRODTA
      *
     C                   EXSR      POPGRS
      *
      ** Decrement Path DS index
      *
     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      *  Subroutine  -  ACOF                                          *
      *  Function    -  Process: Account Officer Details              *
      *                                                               *
      *  Called by   -                                                *
      *  Calls       -                                                *
      *****************************************************************
     C     ACOF          BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'ACOF  '      @STK(Q)
      *
     C                   ADD       1             P1
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'ACOF  '      ##GRPS
      *
     C                   EXSR      SRPATH
      *
      ** Retrieve account officer details.
      *
     C                   MOVEL     BBACOC        P@ACOC            2
      *
     C                   CALL      'AOACOFR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    P@ACOC
     C     SDACOF        PARM      SDACOF        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   SETON                                        89
     C                   END
      *
     C                   Z-ADD     0             R1                3 0
      *
     C                   EXSR      PSHGRS
      *
      ** Account Officer Code
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'E '          #@RDE
     C                   MOVEL     'ACOF_COD'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     AZACOC        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Acc. Officer Dept. Code
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'T '          #@RDE
     C                   MOVEL     'ACOF_DEP'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     AZDPCD        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Account Officer Name
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'E '          #@RDE
     C                   MOVEL     'ACOF_NAM'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     AZACON        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Account Officer Telephone Number
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'P '          #@RDE
     C                   MOVEL     'ACOF_TEL'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     AZAPHN        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Acc. Off. Telephone Ext.
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'X '          #@RDE
     C                   MOVEL     'ACOF_TEL'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     AZAEXT        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
     C                   EXSR      SRADTA
     C                   EXSR      SRODTA
      *
     C                   EXSR      POPGRS
      *
      ** Decrement Path DS index
      *
     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
     C/SPACE 5
      *****************************************************************
      *  Subroutine  -  SRINZ                                         *
      *  Function    -  Initialise Fields on Program Invocation       *
      *                                                               *
      *  Called by   -  Mainline                                      *
      *  Calls       -                                                *
      *****************************************************************
     C     SRINZ         BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRINZ '      @STK(Q)
      *
      ** Initialise work fields
      *
     C                   Z-ADD     *ZEROS        ##W050            5 0
     C                   Z-ADD     *ZEROS        ##W150           15 0
     C                   Z-ADD     *ZEROS        ##W157           15 7
     C                   Z-ADD     *ZEROS        #1                6 0
     C                   Z-ADD     *ZEROS        #2                6 0
     C                   Z-ADD     *ZEROS        #3                6 0
     C                   MOVE      *BLANKS       S#PATH          256
      *
     C     *LIKE         DEFINE    DEOSEQ        ##OSEQ
     C     *LIKE         DEFINE    @SARD         ##SARD
      ** Initialise output sequence (to CGUDTAPD)
      *
     C                   Z-ADD     *ZEROS        ##OSEQ
      *
      ** DJU Additions for CG4999 1st version **
      *
     C                   MOVE      *BLANKS       #@RDE            10
     C     *LIKE         DEFINE    ##TBIN        #@TBIN
      *
     C     1             OCCUR     ##BIND
     C                   RESET                   ##BIND
     C                   RESET                   #@BIND
     C                   RESET                   #PDS
      *
      ** Initialise XML increment
      *
     C                   EXSR      INIXML
      *
     C     EXINZ         TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      *  Subroutine  -  SRINIT                                        *
      *  Function    -  Initial processing - First Call Only          *
      *                                                               *
      *  Called by   -  Mainline                                      *
      *  Calls       -  None                                          *
      *****************************************************************
     C     SRINIT        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRINIT'      @STK(Q)
      *
      ** Call access program for Bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       ##RTCD            7
     C                   PARM      '*FIRST  '    ##OPTN            7
     C     SDBANK        PARM      SDBANK        DSSDY
      *
     C     ##RTCD        IFNE      *BLANK
      *
      ** Database error
      *
     C                   MOVEL     'AOBANKR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     01            W0ERNB                         * DB ERROR 01 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C     BJDFIN        COMP      'M'                                    98    MMDDYY, 98 ON
      *
      ** Determine Number of decimal places - Base currency
      *
     C                   MOVEL     BJCYCD        ##CCY
     C                   EXSR      SRDCDT
     C                   Z-ADD     A6NBDP        BASCDP            1 0
      *
      ** Call access program for General Ledger Details
      *
     C                   CALL      'AOGELRR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*FIRST  '    ##OPTN
     C     SDGELR        PARM      SDGELR        DSSDY
      *
     C     ##RTCD        IFNE      *BLANK
      *
      ** Database error
      *
     C                   MOVEL     'AOGELRR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     02            W0ERNB                         * DB ERROR 02 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      ** Call access program for Midas Modules Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*FIRST  '    ##OPTN
     C     SDMMOD        PARM      SDMMOD        DSSDY
      *
     C     ##RTCD        IFNE      *BLANK
      *
      ** Database error
      *
     C                   MOVEL     'AOMMODR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     03            W0ERNB                         * DB ERROR 03 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      ** Call acces program for Securities Trading Data Details
      *
     C     BGSECS        IFEQ      'Y'
     C                   CALL      'AOSTRDR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*FIRST  '    ##OPTN
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
     C     ##RTCD        IFNE      *BLANK
      *
      ** Database error
      *
     C                   MOVEL     'AOSTRDR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     04            W0ERNB                         * DB ERROR 04 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C                   ENDIF
      *
      ** Call access program for trading data details
      *
     C                   CALL      'AOTRADR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*FIRST  '    ##OPTN
     C     SDTRAD        PARM      SDTRAD        DSSDY
      *
     C     ##RTCD        IFNE      *BLANK
      *
      ** Database error
      *
     C                   MOVEL     'AOTRADR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     05            W0ERNB                         * DB ERROR 05 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      ** Call access program for Dealing data details
      *
     C     BGDLMM        IFEQ      'Y'
     C     BGDLFX        OREQ      'Y'
     C                   CALL      'AODEALR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*FIRST  '    ##OPTN
     C     SDDEAL        PARM      SDDEAL        DSSDY
      *
     C     ##RTCD        IFNE      *BLANK
      *
      ** Database error
      *
     C                   MOVEL     'AODEALR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     06            W0ERNB                         * DB ERROR 06 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C                   END
      *
      ** Call access program for Retail details
      *
     C     BGRTBN        IFEQ      'Y'
     C     BGIOAC        OREQ      'Y'
     C                   CALL      'AORETLR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*FIRST  '    ##OPTN
     C     SDRETL        PARM      SDRETL        DSSDY
      *
     C     ##RTCD        IFNE      *BLANK
      *
      ** Database error
      *
     C                   MOVEL     'AORETLR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     07            W0ERNB                         * DB ERROR 07 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C                   END
      *
      ** Call access program for Message Management Details
      *
     C     BGNWMI        IFEQ      'Y'
     C                   CALL      'AOMGMER0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*FIRST  '    ##OPTN
     C     SDMGME        PARM      SDMGME        DSSDY
      *
     C     ##RTCD        IFNE      *BLANK
      *
      ** Database error
      *
     C                   MOVEL     'AOMGMER0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     08            W0ERNB                         * DB ERROR 08 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C                   END
      *
      ** Call access program for Funds Transfer Details
      *
     C     BGFDTR        IFEQ      'Y'
     C                   CALL      'AOFTFRR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*FIRST  '    ##OPTN
     C     SDFTFR        PARM      SDFTFR        DSSDY
      *
     C     ##RTCD        IFNE      *BLANK
      *
      ** Database error
      *
     C                   MOVEL     'AOFTFRR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     09            W0ERNB                         * DB ERROR 09 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C                   END
      *
      ** Access Switchable Features file and check if CCG015 is
      ** installed (Correspondence Manager)
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*VERIFY'     ##OPTN
     C                   PARM      'CCG015'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     ##RTCD        IFEQ      *BLANK
     C                   MOVE      'Y'           CCG015            1
     C                   ELSE
     C                   MOVE      'N'           CCG015
      *
     C     ##RTCD        IFNE      '*NRF    '                                   ***************
     C                   MOVEL     'SCSARDPD'    W0FILE                         * DB ERROR 19 *
     C                   MOVEL     '*CALL   '    W0KEY                          ***************
     C                   Z-ADD     19            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF
      *
     C     EXINIT        TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
      /SPACE 5
      *****************************************************************
      *  Subroutine  -  SRADTA                                        *
      *  Function    -  Accumulate RDEs and associated data for output*
      *                                                               *
      *  Called by   -  Simple group set subroutines                  *
      *  Calls       -  CG3999 - Format and Pack Data                 *
      *                 SRERR  - Database Error                       *
      *****************************************************************
     C     SRADTA        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRADTA'      @STK(Q)
      *
      ** Reformat RDE data
      *
     C                   EXSR      SRRFMN
      *
      ** Pack RDEs and associated data into data string
      *
     C                   CLEAR                   ##SDS
      *
      ** If CCG015 is installed, value of W0ACT is '*NEWARR'
      *
     C     CCG015        IFEQ      'Y'
     C                   MOVEL     '*NEWARR '    W0ACT
     C                   MOVEL     S#PATH        W0SPAT
     C                   ELSE
     C                   MOVEL     '*PACK   '    W0ACT
     C                   MOVEL     *BLANK        W0SPAT
     C                   ENDIF
      *
     C                   CALL      'CG3999'
     C                   PARM      *BLANK        ##RTCD
     C                   PARM                    W0ACT
     C                   PARM                    ##R
     C                   PARM                    ##D
     C                   PARM                    ##S
     C                   PARM                    W0SPAT           70
     C                   PARM                    ##RN
     C                   PARM                    ##DN
     C                   PARM                    ##FM
      *
      ** Database error
      *
     C     ##RTCD        IFNE      *BLANK
      *
     C                   MOVEL     'CG3999  '    W0FILE                         ***************
     C                   MOVEL     ##RTCD        W0KEY                          * DB ERROR 10 *
     C                   Z-ADD     10            W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   EXSR      WRTRDE
      *
      ** Append Data from pack routine.
      *
     C     #@SDS         CAT       ##SDS:0       #@SDS
      *
     C                   MOVEL     *BLANK        ##R
     C                   MOVEL     *BLANK        ##D
     C                   MOVEL     *BLANK        ##S
      *
     C     EXADTA        TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *  Subroutine  -  SRODTA                                        *
      *  Function    -  Output Accumulated data to PF/CGUDTAPD        *
      *                                                               *
      *  Called by   -  Simple group set subroutines                  *
      *  Calls       -  CG9020 - Output Data to CGUDTAPD              *
      *                 SRERR  - Database Error                       *
      *****************************************************************
     C     SRODTA        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRODTA'      @STK(Q)
      *
      ** Initialise Write Format Parameter.
      *
     C                   CLEAR                   W0FMT
      *
      ** Set up Control Information.
      *
     C                   Z-ADD     ##ITEM        DEITEM
     C                   ADD       1             ##OSEQ
     C                   Z-ADD     ##OSEQ        DEOSEQ
     C                   Z-ADD     ##PBIN        DEPBIN
     C                   Z-ADD     ##TBIN        DETBIN
     C                   MOVE      'FR'          DEFSLI
     C                   MOVE      *BLANKS       W0PATH
     C                   MOVEL     S#PATH        W0PATH
      *
      ** Append Data from pack routine.
      *
     C     W0FMT         CAT       #@SDS:0       W0FMT
      *
      ** Output PF/CGUDTAPD Record.
      *
     C     CCG015        IFEQ      'N'
     C                   CALL      'CG9020'
     C                   PARM      *BLANK        ##RTCD
     C                   PARM      '*WRITE  '    W0ACT
     C                   PARM                    W0PATH          256
     C                   PARM                    W0FMT
     C                   PARM      *BLANK        W0TITL            7
     C                   PARM      *BLANK        W0ULIN            7
     C                   PARM                    W0CMT
      *
      ** Database error
      *
     C     ##RTCD        IFNE      *BLANK
      *
     C                   MOVEL     'CG9020  '    W0FILE                         ***************
     C                   MOVEL     ##RTCD        W0KEY                          * DB ERROR 11 *
     C                   Z-ADD     11            W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF
      *
     C                   CLEAR                   #@SDS
      *
     C     EXODTA        TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      *  Subroutine  -  SRBIND                                        *
      *  Function    -  Generate Binding numbers                      *
      *                                                               *
      *  Called by   -  All Repeating Group Set Subroutines           *
      *  Calls       -                                                *
      *****************************************************************
     C     SRBIND        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRBIND'      @STK(Q)
      *
     C     P1            SUB       1             P2
     C     P2            OCCUR     ##BIND
      *
     C                   Z-ADD     ##TBIN        #@TBIN
     C     P1            OCCUR     ##BIND
     C                   Z-ADD     #@TBIN        ##PBIN
      *
     C                   ADD       1             #@BIND
     C                   Z-ADD     #@BIND        ##TBIN
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      *  Subroutine  -  SRPATH                                        *
      *  Function    -  Generate Path String /GS1/GS2...              *
      *                                                               *
      *  Called by   -  All Group Set subroutines                     *
      *  Calls       -                                                *
      *****************************************************************
     C     SRPATH        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRPATH'      @STK(Q)
      *
     C                   CLEAR                   S#PATH
      *
     C                   DO        P1            P2
     C     P2            OCCUR     ##PATH
     C     S#PATH        CAT       '\':0         S#PATH
     C     S#PATH        CAT       ##GRPS:0      S#PATH
     C                   END
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *  Subroutine  -  SRRFMN                                        *
      *  Function    -  Reformat RDE data                             *
      *                                                               *
      *  Called by   -  SRADTA                                        *
      *  Calls       -                                                *
      *****************************************************************
     C     SRRFMN        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRRFMN'      @STK(Q)
      *
      ** Loop through RDE's and data
      *
     C                   Z-ADD     0             #1
     C     #1            DOUEQ     20
     C                   ADD       1             #1
     C                   MOVEL     ##R(#1)       R#DEFN
     C                   MOVEL     ##D(#1)       R#DATA
      *
      ** If data present and RDE is edited
      *
     C     R#DATA        IFNE      *BLANK
     C     ##RDEC        ANDNE     *BLANK
      *
      ** Reformat Amount
      *
     C                   Z-ADD     1             #2
     C     *BLANK        LOOKUP    ##NUMA(#2)                             99    *
     C                   Z-ADD     20            #3
     C                   Z-ADD     0             ##WNUM
     C     #2            DOWGT     1
     C     #2            ANDLE     20
     C     #3            ANDGT     1
     C                   SUB       1             #2
     C                   MOVEL     ##NUMA(#2)    ##W(#3)
     C                   SUB       1             #3
     C                   ENDDO
      *
      ** Sign the amount
      *
     C     ##SIGN        IFEQ      '-'
     C                   Z-SUB     ##WNUM        ##NUMB
     C                   ELSE
     C                   Z-ADD     ##WNUM        ##NUMB
     C                   END
      *
      ** Default Edit Type
      *
     C     ##EDTT        IFEQ      *BLANK
     C                   MOVEL     ##RDET        ##EDTT
     C                   END
      *
      * Default Decimal Places
     C     ##DCPA        IFEQ      *BLANK
     C                   MOVEL     ##RDED        ##DCPA
     C                   END
      * New RDE data
     C                   MOVEL     R#DATA        ##D(#1)
     C                   ENDIF
     C                   ENDDO
      *
     C     EXRFMN        TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      *  Subroutine  -  SRDCDT                                        *
      *  Function    -  Determine Currency Details                    *
      *                                                               *
      *  Called by   -                                                *
      *  Calls       -                                                *
      *****************************************************************
     C     SRDCDT        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRDCDT'      @STK(Q)
      *
      ** Access array of Currency Details already loaded
      *
     C                   Z-ADD     1             C                 3 0
     C     ##CCY         LOOKUP    ##CY(C)                                99
      *
      ** If no match is found determine the next free space in the
      ** loaded currency array.
      *
     C     *IN99         IFEQ      *OFF
     C                   Z-ADD     1             C
     C     *BLANK        LOOKUP    ##CY(C)                                99
      *
      ** If no space is left, set the Currency Data data structure to
      ** the 101st occurrence so that when the new details are
      ** retrieved no existing details are overwritten.
      *
     C     *IN99         IFEQ      *OFF
     C     101           OCCUR     SDCURR
      *
      ** If a space is found, set up the new currency into the array
      ** and position the Currency Data data structure on the
      ** occurrence matching the array index.
      *
     C                   ELSE
     C                   MOVE      ##CCY         ##CY(C)
     C     C             OCCUR     SDCURR
     C                   ENDIF
      *
      ** Retrieve the currency details.
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       ##RTCD                         B:Return Cd
     C                   PARM      '*KEY'        ##OPTN                         I:Option
     C                   PARM      ##CCY         ##CCYP            3            I:Currency Code
     C     SDCURR        PARM      *BLANK        DSSDY                          O:Format
      *
      ** Database Error
      *
     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'SDCURRPD'    W0FILE
     C                   MOVEL     ##CCY         W0KEY                          ***************
     C                   Z-ADD     12            W0ERNB                         * DB ERROR 12 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** If the currency has been retrieved earlier, position the
      ** Currency Data data structure on the relevant occurrence.
      *
     C                   ELSE
     C     C             OCCUR     SDCURR
     C                   ENDIF
      *
     C     EXDCDT        TAG
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      *  Subroutine  -  SRGENR                                        *
      *  Function    -  Generate reference number                     *
      *                 by writing to PF/CGUDCRPD                     *
      *                                                               *
      *  Called by   -  SRMAIN - Main Processing                      *
      *  Calls       -  CG9010 - Create reference record              *
      *****************************************************************
     C     SRGENR        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRGENR'      @STK(Q)
      *
      ** Generate reference number and check if further processing
      ** required. Set up all available information in the record
      ** format before calling.
      *
     C                   CLEAR                   ##UDCR
      *
      ** Booking/Main Branch (Mandatory)
      *
     C                   MOVEL     FBRCA         DRBRCA
      *
      ** Originating Branch (Optional)
      *
     C                   MOVEL     FBRCA         DRORBR
      *
      ** Module identifier (Mandatory)
      *
     C                   MOVEL     'FX'          DRMODI
      *
      ** Midas Transaction Number (Mandatory)
      *
     C                   MOVEL     FPINR         DRMTRN
      *
      ** Midas GL Account Reference CNUMCCYACODACSQBRCA  (Optional)
      *
     C                   MOVEL     ' '           DRMACT
      *
     C                   MOVEL     W#PTYP        DRPTYP                         * print type
     C                   MOVEL     W#PSTY        DRPSTP                         * print s/type
      *
      ** Auto Transmission indicator
      *
     C                   MOVEL     ' '           DRATRM
      *
      ** Cheque Reference (Optional)
      *
     C                   MOVEL     ' '           DRCHQR
      *
      ** Further Reference (Optional)
      *
     C                   MOVEL     ' '           DRFREF
      *
      ** Customer Number (Mandatory)
      *
     C                   MOVEL     FCNUM         ##CUST
      *
     C                   CALL      'CG9010'
     C                   PARM                    ##RTCD            7
     C                   PARM      '*GEN'        ##MODE           10
     C                   PARM      W0CMT         ##CMT             3
     C                   PARM                    ##CUST            6
     C                   PARM                    ##UDCR
     C                   PARM                    ##ITMA            8
      *
      ** Blank return code implies generate correspondence.
      ** CGD1270 => no error, but suppress output for this transaction.
      *
     C     ##RTCD        IFEQ      *BLANK
     C     DRPTYP        CAT(P)    ':':0         COLON            11
     C     COLON         CAT(P)    DRPSTP:0      ##REFR
     C                   EXSR      WRAPRF
     C                   END
      *
     C     ##RTCD        IFEQ      *BLANK
      *
     C                   MOVE      'Y'           ##COPD
      *
     C                   ELSE
      *
     C     ##RTCD        IFNE      'CGD1270'
     C                   MOVEL     'CG9010  '    W0FILE
     C                   MOVEL     ##RTCD        W0KEY                          ***************
     C                   Z-ADD     09            W0ERNB                         * DB ERROR 09 *
     C                   MOVEL     'CGD1286'     W0MSGD                         ***************
     C                   MOVEL     'CGUSRMSG'    W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF
      *
     C     EXGENR        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
     C*COPY*CGCPYSRC,SRERRPSSR                                                              MD056543
     C/COPY CGCPYSRC,SRERRPSSRL                                                             MD056543
     C/SPACE 5
     C*COPY*CGCPYSRC,SRERRC                                                                 MD056543
     C/COPY CGCPYSRC,SRERRCLE                                                               MD056543
     C/SPACE 5
     C*COPY*CGCPYSRC,CGNWEX                                                                 MD056543
     C/COPY CGCPYSRC,CGNWEXCILE                                                             MD056543
**CTDATA ##CPY
(c) Finastra International Limited 2008
