     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CG Lending rate change advices')                 *
     F*****************************************************************
     F*                                                               *
     F*  Midas - User Defined Correspondence                          *
     F*                                                               *
     F*  CG6045LE - Lending Rate Change Advices (ILE)                 *
     F*                                                               *
     F*  Function:  This program extracts data for Rate Change        *
     F*             Advices.                                          *
     F*                                                               *
     F*  Called By: CG6040 - Lending Rate Change Advices - Driver.    *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. CLE174             Date 23Oct20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR872415           Date 11Feb12               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE036             Date 22Sep03               *
      *                 CSC022             Date 24Feb04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CCG015             Date 09Aug01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 15May01               *
      *                 CLE011             Date 07Nov00               *
      * Midas DBA 3.03 -----------------------------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CCG008  *CREATE    Date 30Oct95               *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  CLE174 - Libor Deregulation - Lending                        *
      *  CER050 - Annualised Percentage Rate                          *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR872415 - Rate Change advice did not capture the new        *
      *             value of Rounding Method and Rounding             *
      *  CRE073 - Portuguese Feature - Interest Rate Rounding         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE036 - LE Enh for Nordea Phase 1 Pty 2- Specific Base Rate *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *           (Recompile)                                         *
      *  CCG015 - Correspondence Manager Phase 1                      *
      *  CSD006 - Use DSSDY for the call to AOBSRTR0.                 *
      *  CLE011 - Rate Fixing Days for Lending Rollover Processing    *
      *           Recompile                                           *
     F*  CCG008 - User Defined Correspondence - Lending               *
     F*                                                               *
     F*****************************************************************
     FCLOAN     IF   E           K DISK
     F                                     INFSR(SRFILE)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
      *                                                                                       CER050
     FLEAPRHI0  IF   E           K DISK
      *                                                                                       CER050
     F/COPY WNCPYSRC,CG6045F001
      /TITLE FUNCTION OF INDICATORS
     F*****************************************************************
     F*                                                               *
     F*  F U N  C T I O N    O F    I N D I C A T O R S               *
     F*                                                               *
     F*  88   -    No record found in CLOAN file.                     *
     F*  90   -    General error indicator.                           *
     F*  98   -    MMDDYY date format.                                *
     F*  99   -    LOKUP indicator.                                   *
     F*                                                               *
     F*****************************************************************
      /TITLE SUBROUTINE INDEX
     F*****************************************************************
     F*                                                               *
     F*  S U B R O U T I N E    I N D E X                             *
     F*                                                               *
     F*  Main routine                                                 *
     F*  SRMAIN  -  Main Processing                                   *
     F*  SRINIT  -  Initial Processing                                *
     F*  SRINZF  -  Initialise Fields on Each Invocation              *
     F*  SRDETL  -  Obtain Detail Information                         *
     F*  L08RC   -  Process Lending Rate Change Advices               *
     F*  LOANRC  -  Process Loan Rate Change Details                  *
     F*  LOANA   -  Process Loan Associated Details                   *
     F*  SRCINT  -  Calculate Current Interest Rate                   *
     F*  SRNINT  -  Calculate Next Interest Rate                      *
     F*  SRNBRA  -  Determine Next Base Rate Code                     *
     F*  SRADTA  -  Accumulate RDEs and Associated Data               *
     F*  SRODTA  -  Output Accumulated Data to PF/CGUDTAPD            *
     F*  SRBIND  -  Generate Binding Numbers                          *
     F*  SRPATH  -  Generate Path String                              *
     F*  SRRFMN  -  Reformat RDE Data                                 *
     F*  SRDCDT  -  Determine Currency Details                        *
     F*  SRGENR  -  Generate Reference Number                         *
     F*  *PSSR   -  Error Subroutine                                  *
     F*                                                               *
     F*****************************************************************
     D/EJECT
     D*****************************************************************
     D*
     D** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*
     D/COPY CGCPYSRC,CGPACKDLE
     D/COPY CGCPYSRC,SRERRDLE
     D*
     D**  Array of Currencies accessed by program
     D*
     D ##CY            S              3    DIM(100)
     D*
     D**  Look-up string for RDE definition Array
     D*
     D ##SDS           DS
     D**********                              15120 ##S                                       CLE036
     D*
     D #@SDS           DS
     D**********                           51205120 #@S                                       CLE036
     D  #@S                 5632   5632
     D**  Packed data string.
     D*
     D                 DS
     D  ##W                    1     20
     D                                     DIM(20)
     D  ##WNUM                 1     20  0
     D**  Number Field
     D*
     D                 DS
     D  ##ITMA                 1      8
     D  ##ITEM                 1      8  0
     D** Used to convert item reference from character to numeric
     D*
     D                 DS
     D  ##NCIT                 1      6
     D  NMCY                   1      3
     D  SITP                   4      6
     D                 DS
     D  ##CCCC                 1      5
     D  ##CCY                  1      3
     D  ##CCD                  4      5
     D*
     D**  UDC Details for call to CG6001
     D*
     D P1PARM          DS           256
     D* Output Sequence
     D  P1OSEQ                 1      9  0
     D* UDC item number
     D  P1ITEM                10     17  0
     D* This bind level
     D  P1TBIN                18     25  0
     D* Previous bind level
     D  P1PBIN                26     33  0
     D*
     D**  Loan details Parameters for call to CG6001
     D*
     D P3PARM          DS           256
     D**  Loan Reference
     D  P3LNRF                 1      6
     D**  Cancel/Amend Field
     D  P3CNAM                 7      7
     D*
     D**  For error reporting
     D*
     D**  Named constants
     D*
     D P4PARM          DS           256
     D**  Facility Customer Number
     D**********                              1   60P4CNUM                                    CSD027
     D  P4CNUM                 1      6
     D**  Facility Type
     D  P4FACT                 7      9  0
     D**  Facility Number
     D  P4FCNO                10     11  0
     D*
     D W#PTYP          C                   CONST('LOAN RATCH')
     D W#PSTY          C                   CONST('BASIC     ')
     D*
     D DSPARM        E DS                  EXTNAME(RATESRT)
     D** External DS for parameter passed from CG6040
     D*
     D ##UDCR        E DS                  EXTNAME(CGUDCRPD)
     D** External DS for incomplete reference
     D*
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D**  External DS for Bank details
     D/COPY WNCPYSRC,CG6045I001
     D*
     D SDCURR        E DS                  OCCURS(101) EXTNAME(SDCURRPD)
     D**  External DS for currency details
     D*
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
     D**  External DS for base rate codes
     D/COPY WNCPYSRC,CG6045I002
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D**  First DS for access programs, short data structure
     D*
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D**  Second DS for access programs, long data structure
     D*
     D W0FMT         E DS                  EXTNAME(CGUDTAPD)
     D**  Record format of PF/CGUDTAPD for use as a parameter
     D*
     D*
     D**  DS to store subroutine specific data.
     D**  - Saved Path
     D ##PATH          DS                  OCCURS(20)
     D  ##GRPS                 1      6
     D*
     D ##BIND          DS                  OCCURS(20)
     D  ##PBIN                 1      6  0 INZ(1)
     D  ##TBIN                 7     12  0 INZ(1)
     D*
     D                 DS
     D  #@BIND                 1      6  0 INZ(1)
     D*
     D #PDS            DS
     D  P1                     1      3  0 INZ(0)
     D  P2                     4      6  0
     D  P3                     7      9  0
     D  P4                    10     12  0
     D  P5                    13     15  0
     I*
     I*****************************************************************
     I/EJECT
     I*****************************************************************
     I*
     ICLOANCLF
     I** Rename fields of CLOANCL
     I              CNUM                        ##CNUM
     I              BRCA                        ##BRCA
     I              VDAT                        ##VDAT
     I              CCY                         ##CCY1
     I              BRTE                        ##BRTE
     I              RTSP                        ##RTSP
     I              SPIN                        ##SPIN
     I              NACD                        ##NACD
     I              NRTS                        ##NRTS
     I              NSIN                        ##NSIN
     I              NBRA                        ##NBRA
     I              BTIN                        ##BTIN
     I              CNSP                        ##CNSP
     I              CNSG                        ##CNSG
     I              RDMT                        ##RDMT
     I              RDFD                        ##RDFD
     I              NNSP                        ##NNSP                                            AR
     I              NNSG                        ##NNSG                                            AR
     I              NDMT                        ##NDMT                                            AR
     I              NDFD                        ##NDFD                                            AR
     I*****************************************************************
     C/EJECT
     C*****************************************************************
     C*  Process     :  MAINLINE                                      *
     C*  Function    :  Mainline processing                           *
     C*                                                               *
     C*  Called by   :  None                                          *
     C*  Calls       :  SRINIT - Initial Processing - On First Call   *
     C*                 SRINZF - Initialise Fields on Each Invocation *
     C*                 SRMAIN - Main Processing                      *
     C*****************************************************************
     C*
     C**  Parameter list for current program invocation.
     C*
     C     *ENTRY        PLIST
     C                   PARM                    W0RTN
     C                   PARM                    W0CMT             3
     C                   PARM                    ##COPD            1
     C                   PARM                    DSPARM
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q
     C                   MOVEL     'MAIN'        @STK(Q)
     C*
     C**  Initial processing - Once Only
     C*
     C     ##INIT        IFEQ      *BLANK
     C                   EXSR      SRINIT
     C                   MOVE      'Y'           ##INIT            1
     C                   ENDIF
     C*
     C** Initialisation processing
     C*
     C                   EXSR      SRINZF
     C*
     C** Main processing
     C*
     C                   EXSR      SRMAIN
     C*
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C**  Terminate program
     C*
     C                   RETURN
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*  Subroutine  :  SRMAIN                                        *
     C*  Function    :  Main processing                               *
     C*                                                               *
     C*  Called by   :  Mainline                                      *
     C*  Calls       :  SRDETL - Obtain Detail Information            *
     C*                 SRGENR - Generate reference number by writing *
     C*                          to PF/CGUDCRPD                       *
     C*                 L08RC  - Process Lending Rate Change Advices  *
     C*****************************************************************
     C     SRMAIN        BEGSR
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRMAIN'      @STK(Q)
     C*
     C                   EXSR      SRDETL
     C*
     C**  Generate reference number by writing to PF/CGUDCRPD
     C**  If no confirmation to be produced, then bypass
     C*
     C                   MOVE      'N'           ##COPD
     C/COPY WNCPYSRC,CG6045C003
     C                   EXSR      SRGENR
     C     ##COPD        CABEQ     'N'           EXMAIN
     C*
     C** Extract
     C*
     C                   EXSR      L08RC
     C*
     C     EXMAIN        TAG
     C*
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*  Subroutine  :  SRDETL                                        *
     C*  Function    :  Process: Obtain detail information            *
     C*                                                               *
     C*  Called by   :  SRMAIN - Main Processing                      *
     C*  Calls       :  SRERR  - Database Error                       *
     C*****************************************************************
     C     SRDETL        BEGSR
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRDETL'      @STK(Q)
     C*
     C     CLOANK        KLIST
     C                   KFLD                    LNRF
     C                   KFLD                    RCDT
     C*
     C                   MOVEL     'A'           RCDT
     C     CLOANK        CHAIN     CLOAN                              88
     C*
     C     *IN88         IFEQ      '1'
     C                   MOVEL     'CLOAN   '    W0FILE                         ***************
     C                   MOVEL     LNRF          W0KEY                          * DB ERROR 14 *
     C                   Z-ADD     14            W0ERNB                         ***************
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C*
     C     EXDETL        TAG
     C*
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*  Subroutine  :  SRGENR                                        *
     C*  Function    :  Generate reference number by writing to       *
     C*                 PF/CGUDCRPD                                   *
     C*                                                               *
     C*  Called by   :  SRMAIN - Main Processing                      *
     C*  Calls       :  CG9010 - Create reference record              *
     C*****************************************************************
     C     SRGENR        BEGSR
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRGENR'      @STK(Q)
     C*
     C**  Generate reference number and check if further processing
     C**  required. Set up all available information in the record
     C**  format before calling.
     C*
     C                   CLEAR                   ##UDCR
     C*
     C** Booking/Main Branch (Mandatory)
     C*
     C                   MOVEL     BRCA          DRBRCA
     C*
     C** Originating Branch (Optional)
     C*
     C                   MOVEL     ORBR          DRORBR
     C*
     C** Module identifier (Mandatory)
     C*
     C                   MOVEL     'LE'          DRMODI
     C*
     C** Midas Transaction Number (Mandatory)
     C*
     C                   MOVEL     LNRF          DRMTRN
     C*
     C                   MOVEL     W#PTYP        DRPTYP                         * print type
     C                   MOVEL     W#PSTY        DRPSTP                         * print s/type
     C*
     C** Auto Transmission indicator
     C*
     C                   MOVEL     'N'           DRATRM
     C*
     C** Customer Number (Mandatory)
     C*
     C                   MOVEL     CNUM          ##CUST
     C*
     C                   CALL      'CG9010'
     C                   PARM                    ##RTCD            7
     C                   PARM      '*GEN'        ##MODE           10
     C                   PARM      W0CMT         ##CMT             3
     C                   PARM                    ##CUST            6
     C                   PARM                    ##UDCR
     C                   PARM                    ##ITMA            8
     C*
     C**  Blank return code implies generate correspondence.
     C**  CGD1270 => no error, but suppress output for this transaction.
     C*
     C     ##RTCD        IFEQ      *BLANK
     C*
     C                   MOVE      'Y'           ##COPD
      *                                                                                       CCG015
      ** Pass reference as printtype:subtype                                                  CCG015
      *                                                                                       CCG015
     C     DRPTYP        CAT(P)    ':':0         COLON            11
     C     COLON         CAT(P)    DRPSTP:0      ##REFR
     C                   EXSR      WRAPRF
     C*
     C                   ELSE
     C*
     C     ##RTCD        IFNE      'CGD1270'
     C                   MOVEL     'CG9010  '    W0FILE
     C                   MOVEL     ##RTCD        W0KEY                          ***************
     C                   Z-ADD     13            W0ERNB                         * DB ERROR 13 *
     C                   MOVEL     'CGD1286'     W0MSGD                         ***************
     C                   MOVEL     'CGUSRMSG'    W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF
     C*
     C     EXGENR        TAG
     C*
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*  Subroutine  :  L08RC                                         *
     C*  Function    :  Process: Lending Rate Change Advices          *
     C*                                                               *
     C*  Called by   :  SRMAIN - Main Processing                      *
     C*  Calls       :  SRPATH - Generate Path String                 *
     C*                 LOANRC - Process Loan Rate Change Details     *
     C*                 LOANA  - Process Loan Associated Details      *
     C*****************************************************************
     C     L08RC         BEGSR
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q
     C                   MOVEL     'L08RC '      @STK(Q)
     C*
     C                   ADD       1             P1
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'l08RC '      ##GRPS
     C*
     C                   EXSR      SRPATH
      *                                                                                       CCG015
     C                   EXSR      PSHGRS
     C*
     C                   EXSR      LOANRC
     C*
     C                   EXSR      LOANA
     C*
     C**  Decrement Path DS index
     C*
     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1
      *                                                                                       CCG015
     C                   EXSR      POPGRS
     C*
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*  Subroutine  :  LOANRC                                        *
     C*  Function    :  Process: Loan Rate Change details             *
     C*                                                               *
     C*  Called by   :  L08RC  - Process Lending Rate Change Advices  *
     C*  Calls       :  SRPATH - Generate Path String                 *
     C*                 SRDCDT - Determine Currency Details           *
     C*                 SRADTA - Accumulate RDEs and Associated Data  *
     C*                 SRODTA - Output Accumulated Data to           *
     C*                           PF/CGUDTAPD                         *
     C*****************************************************************
     C     LOANRC        BEGSR
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q
     C                   MOVEL     'LOANRC'      @STK(Q)
     C*
     C                   ADD       1             P1
     C     P1            OCCUR     ##PATH
     C                   MOVEL(P)  'LOANRC'      ##GRPS
     C*
     C                   EXSR      SRPATH
      *                                                                                       CCG015
     C                   EXSR      PSHGRS
     C*
     C                   Z-ADD     0             R1                3 0
      *
      ** Init New Fields LIBOR
      *
     C                   MOVEL     *BLANKS       BLRT              1
     C                   MOVEL     *BLANKS       LBDY              2 0
     C                   MOVEL     *BLANKS       LODY              2 0
     C                   MOVEL     *BLANKS       PDLY              2 0
     C                   MOVEL     *BLANKS       BADJ             13 8
     C                   MOVEL     *BLANKS       WGHT              1
     C                   MOVEL     *BLANKS       BRAC              1 0
     C                   MOVEL     *BLANKS       LBAC              2 0
     C                   MOVEL     *BLANKS       PRPL             22 0
     C                   MOVEL     *BLANKS       AVOP              1
     C                   MOVEL     *BLANKS       CART             2015
     C*
     C** Loan Reference
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'LOAN REF'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     LNRF          R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C** Value Date
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'TE'          #@RDE
     C                   MOVEL     'VALUE DA'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     VDAT          ##DATA
     C                   MOVEL     'Date  '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C** Calculate current and next interest rate
     C*
     C                   EXSR      SRCINT
     C                   EXSR      SRNINT
     C*
     C** Interest Rate
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'INT RATE'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##CINT        ##DATA
     C                   MOVEL     'Rate  '      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     '7'           ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C** Next Interest Rate
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'AT'          #@RDE
     C                   MOVEL     'NXT INTR'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##NINT        ##DATA
     C                   MOVEL     'Rate  '      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     '7'           ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C** Determine Next Base Rate Code
     C*
     C                   EXSR      SRNBRA
     C*
     C** Next Base Rate Type
     C*
     C     ##BCOD        IFNE      0
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'YP'          #@RDE
     C                   MOVEL     'NXT BSRT'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     ##BCOD        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C*
     C** Next Base Rate Name
     C*
     C** Access Base Rate Name
     C*
     C                   MOVE      ##BCOD        ##KEY2            2                           BHF84
     C                   CALL      'AOBSRTR0'                                                  S0119
     C                   PARM      '*MSG   '     ##RTCD                                        S0119
     C                   PARM      '*KEY   '     ##OPTN                                        S0119
     C                   PARM      CCY           ##KEY1            3                           S0119
     C                   PARM                    ##KEY2                                        BHF84
     C********** SDBSRT    PARM SDBSRT    DSFDY                     S01194CSD006
     C     SDBSRT        PARM      SDBSRT        DSSDY                                         CSD00
     C*
     C     ##RTCD        IFNE      *BLANKS
     C                   MOVEL     'AOBSRTR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     15            W0ERNB                         * DB ERROR 15 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'AM'          #@RDE
     C                   MOVEL     'NXT BSRN'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     BABSRN        R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CLE036
      ** Next Base Rate                                                                       CLE036
      *                                                                                       CLE036
     C                   ELSE
      *                                                                                       CLE036
     C     CLE036        IFEQ      'Y'
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'NXT BSRA'    #@RDE
     C                   MOVE      'TE'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     NBRE          ##DATA
     C                   MOVEL     'Rate  '      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     '7'           ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
     C                   ENDIF
     C*
     C                   END
     C*
     C** Run date; production time
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'RUNDAT  '    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     BJRDNB        ##DATA
     C                   MOVEL     'Date  '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CRE073
      ** Contractual Spread                                                                   CRE073
      *                                                                                       CRE073
     C     CRE073        IFEQ      'Y'
      *                                                                                       CRE073
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CONTSPR'     #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C     ##NNSP        IFEQ      0
     C                   MOVEL     ##CNSP        ##DATA
     C                   ELSE
     C                   MOVEL     ##NNSP        ##DATA
     C                   ENDIF
     C                   MOVEL     'Rate  '      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     '7'           ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CRE073
      ** Contractual Spread Sign                                                              CRE073
      *                                                                                       CRE073
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CONTSSG'     #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C     ##NNSP        IFEQ      0
     C                   MOVEL     ##CNSG        ##DATA
     C                   ELSE
     C                   MOVEL     ##NNSG        ##DATA
     C                   ENDIF
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CRE073
      ** Rounding Method                                                                      CRE073
      *                                                                                       CRE073
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'RNDMTD'      #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C     ##NNSP        IFEQ      0
     C                   MOVEL     ##RDMT        ##DATA
     C                   ELSE
     C                   MOVEL     ##NDMT        ##DATA
     C                   ENDIF
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CRE073
      ** Rounding Fraction/Decimal                                                            CRE073
      *                                                                                       CRE073
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'RNDFRCD'     #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C     ##NNSP        IFEQ      0
     C                   MOVEL     ##RDFD        ##DATA
     C                   ELSE
     C                   MOVEL     ##NDFD        ##DATA
     C                   ENDIF
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CRE073
      ** CRE073 Switchable Feature                                                            CRE073
      *                                                                                       CRE073
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CRE073F'     #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     CRE073        ##DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CRE073
     C                   ENDIF
      *                                                                                       CRE073
      *
      ** LIBOR Deregulation BACKWARD-LOOKING RATE
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'TE'          #@RDE
     C                   MOVEL     'BCKLOKRA'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     BLRT          R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Averaging Option
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'N'           #@RDE
     C                   MOVEL     'AVGOPTIO'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     AVOP          R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Compounded/Average Rate
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'AR'          #@RDE
     C                   MOVEL     'COMPOUND'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     CART          R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Lookback Days
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'AY'          #@RDE
     C                   MOVEL     'LOOKBCKD'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     LBDY          R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Lockout Days
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'AY'          #@RDE
     C                   MOVEL     'LOCKOUTD'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     LODY          R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Delayed Payment Days
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'YS'          #@RDE
     C                   MOVEL     'DLYPAYDA'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     PDLY          R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Benchmark Adjustment Days
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'OD'          #@RDE
     C                   MOVEL     'BMRKADJC'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     BADJ          R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Weight Convention
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'OD'          #@RDE
     C                   MOVEL     'BMRKADJC'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     WGHT          R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Base Rate Code for Accrual
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'TE'          #@RDE
     C                   MOVEL     'BRACCRRA'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     BRAC          R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Lookback Days for Accrual
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'TE'          #@RDE
     C                   MOVEL     'BRACCRRA'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     LBAC          R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      ** Principal
      *
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVE      'L'           #@RDE
     C                   MOVEL     'PRINCIPA'    #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     PRPL          R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
     C/COPY WNCPYSRC,CG6045C001
      *                                                                                       CER050
     C     CER050        IFEQ      'Y'
     C                   EXSR      Z@NAPR
     C                   ENDIF
      *                                                                                       CER050
     C*
     C** Save new fields
     C*
     C**********           Z-ADDLNRF      ##SLNR                                              CLE148
     C                   MOVEL     LNRF          ##SLNR
     C                   Z-ADD     NBRE          ##SBRE
     C                   Z-ADD     NRTS          ##SRTS
     C                   MOVE      NSIN          ##SSIN
     C                   Z-ADD     ##NINT        ##SINT
     C*
     C                   EXSR      SRADTA
     C                   EXSR      SRODTA
     C*
     C**  Decrement Path DS index
     C*
     C     P1            OCCUR     ##PATH
     C                   CLEAR                   ##GRPS
     C                   SUB       1             P1
      *                                                                                       CCG015
     C                   EXSR      POPGRS
     C*
     C**  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*  Subroutine  :  SRCINT                                        *
     C*  Function    :  Calculate Current Interest Rate               *
     C*                                                               *
     C*  Called by   :  LOANRC - Process Loan Rate Change Details     *
     C*  Calls       :  none                                          *
     C*****************************************************************
     C     SRCINT        BEGSR
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRCINT'      @STK(Q)
     C*
     C** If not first record for loan, use saved interest rate
     C*
     C     LNRF          IFEQ      ##SLNR
     C                   Z-ADD     ##SINT        ##CINT
     C*
     C                   ELSE
     C*
     C** Else, if first record for loan, compute current interest rate
     C*
     C                   SELECT
     C*
     C     SPIN          WHENEQ    'S'
     C     BRTE          SUB       RTSP          ##CINT           11 7
     C*
     C     SPIN          WHENEQ    'P'
     C     RTSP          DIV       100           ##WORK           11 9
     C     ##WORK        MULT(H)   BRTE          ##CINT
     C*
     C                   OTHER
     C     BRTE          ADD       RTSP          ##CINT
     C*
     C                   ENDSL
     C*
     C                   END
     C*
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*  Subroutine  :  SRNINT                                        *
     C*  Function    :  Calculate Next Interest Rate                  *
     C*                                                               *
     C*  Called by   :  LOANRC - Process Loan Rate Change Details     *
     C*  Calls       :  none                                          *
     C*****************************************************************
     C     SRNINT        BEGSR
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRNINT'      @STK(Q)
     C*
     C** If not first record for loan:
     C*
     C     LNRF          IFEQ      ##SLNR
     C*
     C** For BC or BR, use saved spread rate and indicator
     C     AMTP          IFEQ      'BC'
     C     AMTP          OREQ      'BR'
     C                   Z-ADD     ##SRTS        NRTS
     C                   MOVE      ##SSIN        NSIN
     C                   END
     C*
     C** For SC, use saved based rate and spread indicator
     C     AMTP          IFEQ      'SC'
     C                   Z-ADD     ##SBRE        NBRE
     C                   MOVE      ##SSIN        NSIN
     C                   END
     C*
     C                   ELSE
     C*
     C** If first record for loan:
     C*
     C** For BC or BR, use new base rate, current spread rate and indicator
     C     AMTP          IFEQ      'BC'
     C     AMTP          OREQ      'BR'
     C                   Z-ADD     RTSP          NRTS
     C                   MOVE      SPIN          NSIN
     C                   END
     C*
     C** For SC, use new spread rate, current base rate and spread indicator
     C     AMTP          IFEQ      'SC'
     C                   Z-ADD     BRTE          NBRE
     C                   MOVE      SPIN          NSIN
     C                   END
     C*
     C                   END
     C*
     C** Calculate Next Interest Rate
     C*
     C                   SELECT
     C*
     C     NSIN          WHENEQ    'S'
     C     NBRE          SUB       NRTS          ##NINT           11 7
     C*
     C     NSIN          WHENEQ    'P'
     C     NRTS          DIV       100           ##WORK
     C     ##WORK        MULT(H)   NBRE          ##NINT
     C*
     C                   OTHER
     C     NBRE          ADD       NRTS          ##NINT
     C*
     C                   ENDSL
     C*
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*  Subroutine  :  SRNBRA                                        *
     C*  Function    :  Determine Next Base Rate Type                 *
     C*                                                               *
     C*  Called by   :  LOANRC - Process Loan Rate Change Details     *
     C*  Calls       :  none                                          *
     C*****************************************************************
     C     SRNBRA        BEGSR
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRNBRA'      @STK(Q)
     C*
     C** If first record for loan:
     C*
     C     LNRF          IFNE      ##SLNR
     C                   Z-ADD     NBRA          ##BCOD            2 0
     C                   END
     C*
     C** If Base Rate Code change or Rollover, save new code
     C*
     C     AMTP          IFEQ      'BC'
     C     AMTP          OREQ      'RO'
     C                   Z-ADD     NBRA          ##BCOD
     C                   END
     C*
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*  Subroutine  :  LOANA                                         *
     C*  Function    :  Process: Loan Associated Details              *
     C*                                                               *
     C*  Called by   :  L08RC  - Process Lending Rate Changes Advice  *
     C*  Calls       :  SRPATH - Generate Path String                 *
     C*                 CG6001 - General Loan Details                 *
     C*****************************************************************
     C     LOANA         BEGSR
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q
     C                   MOVEL     'LOANA '      @STK(Q)
     C*
     C                   EXSR      SRPATH
     C*
     C                   MOVEL     S#PATH        P2PARM
     C                   Z-ADD     ##OSEQ        P1OSEQ
     C                   Z-ADD     ##ITEM        P1ITEM
     C                   Z-ADD     ##TBIN        P1TBIN
     C                   Z-ADD     ##PBIN        P1PBIN
     C*
     C**  Set up data.
     C*
     C                   CLEAR                   P3PARM
     C                   CLEAR                   P4PARM
     C                   MOVE      LNRF          P3LNRF
     C                   CALL      'CG6001'
     C                   PARM      *BLANKS       W0RTN             7
     C                   PARM                    W0CMT             3
     C                   PARM                    P1PARM                         UDC Details
     C                   PARM                    P2PARM          140            Path Details
     C                   PARM                    P3PARM                         Loan Details
     C                   PARM                    P4PARM                         Facility Dtls
     C                   PARM                    ##AUTO            1
     C                   PARM                    ##REFR
     C                   PARM                    P@ICR
     C                   PARM      'N'           ##MAST
     C*
     C**  Reset Sequence number.
     C*
     C                   Z-ADD     P1OSEQ        ##OSEQ
     C*
     C     EXXPAY        TAG
     C*
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
      *                                                                                       CER050
      *****************************************************************                       CER050
      * Subroutine  :  Z@NAPR                                         *                       CER050
      * Function    :  Extract - Annualised Percentage Rate (APR)     *                       CER050
      *                                                               *                       CER050
      * Called by   :                                                 *                       CER050
      * Calls       :                                                 *                       CER050
      *****************************************************************                       CER050
     C     Z@NAPR        BEGSR
      *                                                                                       CER050
      **  Only if processing type is 61, 62 or 63                                             CER050
     C     PTYP          IFEQ      61
     C     PTYP          OREQ      62
     C     PTYP          OREQ      63
      *                                                                                       CER050
      * Run this process only if Do not print APR is set to Blank                             CER050
      *                                                                                       CER050
     C     APRC          IFEQ      'Y'
     C     LNRF          CHAIN     LEAPRHI0                           89
      *                                                                                       CER050
      * LOOK FOR THE FIRST ELEMENT IN BLANK IN SERIE                                          CER050
     C                   Z-ADD     1             R1
     C     ##R(R1)       DOUEQ     *BLANKS
     C     R1            OREQ      20
     C                   ADD       1             R1
     C                   ENDDO
     C*                                                                                       CER050
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'ZI_NAPR '    #@RDE            10
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     IAPRR         R#DATA
     C                   MOVEL     IAPRR         ##DATA
     C                   MOVEL     'Rate  '      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     '2'           ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *                                                                                       CER050
     C                   END
     C                   ENDIF
      *                                                                                       CER050
     C                   ENDSR
      *****************************************************************                       CER050
     C/COPY WNCPYSRC,CG6045C004
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*  Subroutine  :  SRINZF                                        *
     C*  Function    :  Initialise Fields on Program Invocation       *
     C*                                                               *
     C*  Called by   :  Mainline                                      *
     C*  Calls       :  none                                          *
     C*****************************************************************
     C     SRINZF        BEGSR
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRINZF'      @STK(Q)
     C*
     C**  Initialise work fields
     C*
     C                   Z-ADD     *ZEROS        ##W050            5 0
     C                   Z-ADD     *ZEROS        ##W150           15 0
     C                   Z-ADD     *ZEROS        ##W157           15 7
     C                   Z-ADD     *ZEROS        #1                6 0
     C                   Z-ADD     *ZEROS        #2                6 0
     C                   Z-ADD     *ZEROS        #3                6 0
     C                   MOVE      *BLANKS       S#PATH          256
     C     *LIKE         DEFINE    DEOSEQ        ##OSEQ
     C*
     C**  Initialise output sequence (to CGUDTAPD)
     C*
     C                   Z-ADD     *ZEROS        ##OSEQ
     C*
     C** DJU Additions for CG4999 1st version **
     C*
     C                   MOVE      *BLANKS       #@RDE            10
     C     *LIKE         DEFINE    ##TBIN        #@TBIN
     C*
     C     1             OCCUR     ##BIND
     C                   RESET                   ##BIND
     C                   RESET                   #@BIND
     C                   RESET                   #PDS
      *                                                                                       CCG015
      ** Initialise XML increment                                                             CCG015
      *                                                                                       CCG015
     C                   EXSR      INIXML
     C*
     C     EXINZ         TAG
     C*
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*  Subroutine  :  SRINIT                                        *
     C*  Function    :  Initial processing - First Call Only          *
     C*                                                               *
     C*  Called by   :  Mainline                                      *
     C*  Calls       :  SRERR  - Report Error and Close Down Program  *
     C*                 SRDCDT - Determine Currency Details           *
     C*****************************************************************
     C     SRINIT        BEGSR
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRINIT'      @STK(Q)
     C/COPY WNCPYSRC,CG6045C002
     C*
     C** Call access program for Bank details
     C*
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       ##RTCD            7
     C                   PARM      '*FIRST  '    ##OPTN            7
     C     SDBANK        PARM      SDBANK        DSSDY
     C*
     C     ##RTCD        IFNE      *BLANK
     C*
     C** Database error
     C*
     C                   MOVEL     'AOBANKR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     01            W0ERNB                         * DB ERROR 01 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C*
     C     BJDFIN        COMP      'M'                                    98    MMDDYY, 98 ON
     C*
     C**   Determine Number of decimal places - Base currency
     C*
     C                   MOVEL     BJCYCD        ##CCY
     C                   EXSR      SRDCDT
     C                   Z-ADD     A6NBDP        BASCDP            1 0
      *                                                                                       CCG015
      ** Access SAR details file to determine if CCG015 is installed.                         CCG015
      *                                                                                       CCG015
     C                   MOVEL     'N'           CCG015            1
      *                                                                                       CCG015
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     ##RTCD
     C                   PARM      '*VERIFY'     ##OPTN
     C                   PARM      'CCG015'      ##SARD            6
      *                                                                                       CCG015
      ** Database Error                                                                       CCG015
      *                                                                                       CCG015
     C     ##RTCD        IFNE      *BLANK
     C     ##RTCD        ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     16            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                       CCG015
     C     ##RTCD        IFEQ      *BLANK
     C                   MOVEL     'Y'           CCG015
     C                   ENDIF
      *                                                                                       CLE036
      ** Access SAR details file to determine if CLE036 is installed                          CLE036
      *                                                                                       CLE036
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*VERIFY'     ##OPTN
     C                   PARM      'CLE036'      ##SARD
      *                                                                                       CLE036
      ** Database Error                                                                       CLE036
      *                                                                                       CLE036
     C     ##RTCD        IFNE      *BLANK
     C     ##RTCD        ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL     'CLE036'      W0KEY
     C                   Z-ADD     17            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                       CLE036
     C     ##RTCD        IFEQ      *BLANK
     C                   MOVE      'Y'           CLE036            1
     C                   ELSE
     C                   MOVE      'N'           CLE036
     C                   ENDIF
      *                                                                                       CRE073
      ** Check if CRE073 is ON                                                                CRE073
      *                                                                                       CRE073
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*VERIFY '    ##OPTN
     C                   PARM      'CRE073'      ##SARD
      *                                                                                       CRE073
     C     ##RTCD        IFEQ      *BLANKS
     C                   MOVE      'Y'           CRE073            1
     C                   ELSE
     C                   MOVE      'N'           CRE073
     C                   ENDIF
      *                                                                                       CRE073
      ** Access SAR details file to determine if CER050 is installed.                         CER050
      *                                                                                       CER050
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     ##RTCD
     C                   PARM      '*VERIFY'     ##OPTN
     C                   PARM      'CER050'      ##SARD
      *                                                                                       CER050
     C     ##RTCD        IFEQ      *BLANK
     C                   MOVEL     'Y'           CER050            1
     C                   ELSE
     C                   MOVEL     'N'           CER050
     C                   END
     C*
     C** Initialise save fields
     C*
     C**********           Z-ADD0         ##SLNR  60                                          CLE148
     C                   MOVEL     *BLANKS       ##SLNR            6
     C                   Z-ADD     0             ##SBRE           11 7
     C                   Z-ADD     0             ##SRTS           11 7
     C                   MOVE      *BLANKS       ##SSIN            2
     C                   Z-ADD     0             ##SINT           11 7
     C                   Z-ADD     0             ##BCOD            2 0
     C*
     C**  Copyright
     C*
     C                   MOVEA     CPY@          ACT@             80
     C*
     C     EXINIT        TAG
     C*
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*  Subroutine  :  SRADTA                                        *
     C*  Function    :  Accumulate RDEs and associated data for output*
     C*                                                               *
     C*  Called by   :  LOANRC - Process Loan Rate Change Details     *
     C*  Calls       :  CG3999 - Format and Pack Data                 *
     C*                 SRRFMN - Reformat RDE Data                    *
     C*                 SRERR  - Database Error                       *
     C*****************************************************************
     C     SRADTA        BEGSR
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRADTA'      @STK(Q)
     C*
     C**  Reformat RDE data
     C*
     C                   EXSR      SRRFMN
     C*
     C**  Pack RDEs and associated data into data string
     C*
     C                   CLEAR                   ##SDS
      *                                                                                       CCG015
     C     CCG015        IFEQ      'Y'
     C                   MOVE      '*NEWARR '    W0ACT
     C                   MOVEL     S#PATH        W0SPAT
     C                   ELSE
     C                   MOVE      '*PACK   '    W0ACT
     C                   MOVEL     *BLANKS       W0SPAT
     C                   ENDIF
      *                                                                                       CCG015
     C                   CALL      'CG3999'
     C                   PARM      *BLANK        ##RTCD
     C**********           PARM '*PACK   'W0ACT                                               CCG015
     C                   PARM                    W0ACT
     C                   PARM                    ##R
     C                   PARM                    ##D
     C                   PARM                    ##S
     C                   PARM                    W0SPAT           70
     C                   PARM                    ##RN
     C                   PARM                    ##DN
     C                   PARM                    ##FM
     C*
     C**  Database error
     C*
     C     ##RTCD        IFNE      *BLANK
     C*
     C                   MOVEL     'CG3999  '    W0FILE                         ***************
     C                   MOVEL     ##RTCD        W0KEY                          * DB ERROR 10 *
     C                   Z-ADD     10            W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                       CCG015
      ** Write a XML record for RDE                                                           CCG015
      *                                                                                       CCG015
     C                   EXSR      WRTRDE
     C*
     C**  Append Data from pack routine.
     C*
     C     #@SDS         CAT       ##SDS:0       #@SDS
     C*
     C                   MOVEL     *BLANK        ##R
     C                   MOVEL     *BLANK        ##D
     C                   MOVEL     *BLANK        ##S
     C*
     C     EXADTA        TAG
     C*
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*  Subroutine  :  SRODTA                                        *
     C*  Function    :  Output Accumulated data to PF/CGUDTAPD        *
     C*                                                               *
     C*  Called by   :  LOANRC - Process Loan Rate Change Details     *
     C*  Calls       :  CG9020 - Output Data to CGUDTAPD              *
     C*                 SRERR  - Database Error                       *
     C*****************************************************************
     C     SRODTA        BEGSR
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRODTA'      @STK(Q)
     C*
     C**  Initialise Write Format Parameter.
     C*
     C                   CLEAR                   W0FMT
     C*
     C**  Set up Control Information.
     C*
     C                   Z-ADD     ##ITEM        DEITEM
     C                   ADD       1             ##OSEQ
     C                   Z-ADD     ##OSEQ        DEOSEQ
     C                   Z-ADD     ##PBIN        DEPBIN
     C                   Z-ADD     ##TBIN        DETBIN
     C                   MOVE      'FR'          DEFSLI
     C                   MOVE      *BLANKS       W0PATH
     C                   MOVEL     S#PATH        W0PATH
     C*
     C**  Append Data from pack routine.
     C*
     C     W0FMT         CAT       #@SDS:0       W0FMT
     C*
     C**  Output PF/CGUDTAPD Record.
     C*
     C     CCG015        IFEQ      'N'
     C                   CALL      'CG9020'
     C                   PARM      *BLANK        ##RTCD
     C                   PARM      '*WRITE  '    W0ACT
     C                   PARM                    W0PATH          256
     C                   PARM                    W0FMT
     C                   PARM      *BLANK        W0TITL            7
     C                   PARM      *BLANK        W0ULIN            7
     C                   PARM                    W0CMT
     C*
     C**  Database error
     C*
     C     ##RTCD        IFNE      *BLANK
     C*
     C                   MOVEL     'CG9020  '    W0FILE                         ***************
     C                   MOVEL     ##RTCD        W0KEY                          * DB ERROR 11 *
     C                   Z-ADD     11            W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF
     C*
     C                   CLEAR                   #@SDS
     C*
     C     EXODTA        TAG
     C*
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*  Subroutine  :  SRBIND                                        *
     C*  Function    :  Generate Binding numbers                      *
     C*                                                               *
     C*  Called by   :  All Repeating Group Set Subroutines           *
     C*  Calls       :  none                                          *
     C*****************************************************************
     C     SRBIND        BEGSR
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRBIND'      @STK(Q)
     C*
     C     P1            SUB       1             P2
     C     P2            OCCUR     ##BIND
     C*
     C                   Z-ADD     ##TBIN        #@TBIN
     C     P1            OCCUR     ##BIND
     C                   Z-ADD     #@TBIN        ##PBIN
     C*
     C                   ADD       1             #@BIND
     C                   Z-ADD     #@BIND        ##TBIN
     C*
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*  Subroutine  :  SRPATH                                        *
     C*  Function    :  Generate Path String /GS1/GS2...              *
     C*                                                               *
     C*  Called by   :  L02PI  - Process Lending Rate Change Advices  *
     C*                 LOANRC - Process Loan Rate Change Detail      *
     C*                 LOANA  - Process Loan Associated Details      *
     C*                 SRSDET - Set-up settlement details            *
     C*  Calls       :  none                                          *
     C*****************************************************************
     C     SRPATH        BEGSR
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRPATH'      @STK(Q)
     C*
     C                   CLEAR                   S#PATH
     C*
     C                   DO        P1            P2
     C     P2            OCCUR     ##PATH
     C     S#PATH        CAT       '\':0         S#PATH
     C     S#PATH        CAT       ##GRPS:0      S#PATH
     C                   END
     C*
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*  Subroutine  :  SRRFMN                                        *
     C*  Function    :  Reformat RDE data                             *
     C*                                                               *
     C*  Called by   :  SRADTA - Accumulate RDEs and associated       *
     C*                          data for outout                      *
     C*  Calls       :  none                                          *
     C*****************************************************************
     C     SRRFMN        BEGSR
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRRFMN'      @STK(Q)
     C*
     C** Loop through RDE's and data
     C*
     C                   Z-ADD     0             #1
     C     #1            DOUEQ     20
     C                   ADD       1             #1
     C                   MOVEL     ##R(#1)       R#DEFN
     C                   MOVEL     ##D(#1)       R#DATA
     C*
     C** If data present and RDE is edited
     C*
     C     R#DATA        IFNE      *BLANK
     C     ##RDEC        ANDNE     *BLANK
     C*
     C** Reformat Amount
     C*
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
     C*
     C** Sign the amount
     C*
     C     ##SIGN        IFEQ      '-'
     C                   Z-SUB     ##WNUM        ##NUMB
     C                   ELSE
     C                   Z-ADD     ##WNUM        ##NUMB
     C                   END
     C*
     C** Default Edit Type
     C*
     C     ##EDTT        IFEQ      *BLANK
     C                   MOVEL     ##RDET        ##EDTT
     C                   END
     C*
     C** Default Decimal Places
     C*
     C     ##DCPA        IFEQ      *BLANK
     C                   MOVEL     ##RDED        ##DCPA
     C                   END
     C*
     C** New RDE data
     C*
     C                   MOVEL     R#DATA        ##D(#1)
     C                   ENDIF
     C                   ENDDO
     C*
     C     EXRFMN        TAG
     C*
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*  Subroutine  :  SRDCDT                                        *
     C*  Function    :  Determine Currency Details                    *
     C*                                                               *
     C*  Called by   :  LOANRC - Process Loan Rate Change Detail      *
     C*                 SRINIT - Initial Processing - On First Call   *
     C*  Calls       :  SRERR  - Database Error                       *
     C*****************************************************************
     C     SRDCDT        BEGSR
     C*
     C**  Set up subroutine stack name
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRDCDT'      @STK(Q)
     C*
     C**  Access array of Currency Details already loaded
     C*
     C                   Z-ADD     1             C                 3 0
     C     ##CCY         LOOKUP    ##CY(C)                                99
     C*
     C**  If no match is found determine the next free space in the
     C**  loaded currency array.
     C*
     C     *IN99         IFEQ      *OFF
     C                   Z-ADD     1             C
     C     *BLANK        LOOKUP    ##CY(C)                                99
     C*
     C**  If no space is left, set the Currency Data data structure to
     C**  the 101st occurrence so that when the new details are
     C**  retrieved no existing details are overwritten.
     C*
     C     *IN99         IFEQ      *OFF
     C     101           OCCUR     SDCURR
     C*
     C**  If a space is found, set up the new currency into the array
     C**  and position the Currency Data data structure on the
     C**  occurrence matching the array index.
     C*
     C                   ELSE
     C                   MOVE      ##CCY         ##CY(C)
     C     C             OCCUR     SDCURR
     C                   ENDIF
     C*
     C**  Retrieve the currency details.
     C*
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       ##RTCD                         B:Return Cd
     C                   PARM      '*KEY'        ##OPTN                         I:Option
     C                   PARM      ##CCY         ##CCYP            3            I:Currency Code
     C     SDCURR        PARM      *BLANK        DSSDY                          O:Format
     C*
     C**  Database Error
     C*
     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'SDCURRPD'    W0FILE
     C                   MOVEL     ##CCY         W0KEY                          ***************
     C                   Z-ADD     12            W0ERNB                         * DB ERROR 12 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C*
     C**  If the currency has been retrieved earlier, position the
     C**  Currency Data data structure on the relevant occurrence.
     C*
     C                   ELSE
     C     C             OCCUR     SDCURR
     C                   ENDIF
     C*
     C     EXDCDT        TAG
     C*
     C**  Unwind subroutine stack name
     C*
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*****************************************************************
     C/EJECT
     C/COPY CGCPYSRC,SRERRPSSRL
     C/EJECT
     C/COPY CGCPYSRC,SRERRCLE
     C/EJECT                                                                                  CCG015
     C/COPY CGCPYSRC,CGNWEXILE
     C/EJECT
** ##CPY  **      OBJECT COPYRIGHT
(c) Finastra International Limited 2001
