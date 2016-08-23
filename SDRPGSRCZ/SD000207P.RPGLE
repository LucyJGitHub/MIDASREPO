     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Withholding Tax Rate Default Mtrx Report')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000207P - Withholding Tax Rate Default Mtrx Report         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2015            *
      *                                                               *
      *  Last Amend No. CGL165  *Create    Date 23Feb15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax                                *
      *                                                               *
      *****************************************************************
     FSDWTDML1  IF   E           K DISK
      * RTV: Withholding Tax Rate Dft Matrix Retrieval index
      *
     FSDFCTLL1  IF   E           K DISK
      * RTV: Standing Data Controls    Retrieval index
      *
     FSDFCTLL0  UF   E           K DISK
      * UPD: Standing Data Controls    Update index
      *
     FSDBANKL1  IF   E           K DISK
      * RTV: Bank Details              Retrieval index
      *
     FSD000207P1O    E             PRINTER OFLIND(*IN97)
     F                                     INFDS(INFDS#)
      * PRT: Midas SD Withholding Tax Rate Dft Mtrx Report
      *
     D HDR1            S             14    DIM(9)
     D HDR2            S             14    DIM(9)
     D** Withholding Tax Rate Default Matrix Arrays to hold ordered Base Field
     D** headings according to their associated field priorities.
     D**
     D HDR3            S             14    DIM(9)  CTDATA PERRCD(1)
     D HDR4            S             14    DIM(9)  CTDATA PERRCD(1)
     D** Withholding Tax Rate Default Matrix Arrays to hold Heading Text for all
     D** base fields.
     D**
     D HD1             S              1    DIM(76)
     D HD2             S              1    DIM(76)
     D** Withholding Tax Rate Default Matrix Output Array
     D**
     D/EJECT
     D**
     D PARR            S             14    DIM(9)
     D** Withholding Tax Rate Default Matrix Array to hold ordered Base Fields
     D** according to their priorities.
     D**
     D AR1             S              1    DIM(79)
     D** Withholding Tax Rate Default Matrix Output Array
     D**
     D/EJECT
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
     D UAR             S              1    DIM(53)
     D ULN             S              1    DIM(53)
     D UARRAY          S             26    DIM(2) CTDATA PERRCD(1)
      *
      ** SAVE INDICATOR *IN 99
      *
     D @CN             S             30    DIM(14) CTDATA PERRCD(1)             Long constants.
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D*Prft Ctre Dft Mtrx ReportInitialise Program I-Spec
     D/COPY WNCPYSRC,SD0490PIPG
      /EJECT
      * Data structures:-
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      * Program data structure.
     D JBDTTM          DS
      * Job date/time.
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
     D DfltPr          DS
      * Default Priorities
     D  DMBR                   1      1  0
     D  DMBO                   2      2  0
     D  DMCU                   3      3  0
     D  DMCD                   4      4  0
     D  DMCT                   5      5  0
     D  DMIN                   6      6  0
     D  DMMO                   7      7  0
     D  DMTY                   8      8  0
     D  DMTS                   9      9  0
     D INFDS#        E DS                  EXTNAME(Y2I$DSP)
      * Printer file information data structure.
      *
     D A@CPY           DS
     D* Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright     array
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
      /EJECT
      * Parameter declarations.
     D P1PARM          DS
      * I:    Audit/Request Status Ind
     D  P1ARSI                 1      1
     D P2PARM          DS
      * I:MAP RCF sequence number
     D  P2RSQN                 1      5
     D P3PARM          DS
      * I:MAP Level
     D  P3LEVL                 1      1
     D P4PARM          DS
      * I:MAP Entity
     D  P4ENTY                 1      3
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Database Error (ICD)'
      * Filename
     D  ZA0001                 1     10
      /EJECT
      *****************************************************************
     C     *ENTRY        PLIST                                                  Entry parameter
     C                   PARM                    P0RTN             7            Return code
     C     P1ARSI        PARM                    WP0001            1            Audit/Request S
     C     P2RSQN        PARM                    WP0002            5            RCF sequence nu
     C     P3LEVL        PARM                    WP0003            1            Level
     C     P4ENTY        PARM                    WP0004            3            Entity
      *****************************************************************
      * Initialise
     C                   EXSR      ZZINIT
      *
      * Clear overflow indicator.
     C                   SETOFF                                       97
      *
      * Establish starting position.
     C     *LOVAL        SETLL     SDWTDMD0                                     *
      *
      * Read first record with user selection.
     C                   EXSR      GARDRC
      * Print null report headings.
     C     W0EOF         IFEQ      '1'
     C                   WRITE     ZZPAGHDR
     C                   WRITE     ZZENDRPT
     C                   ELSE
      * Request all headings.
     C                   MOVEL     'Y'           L0                1            Page headings
      * Initialise final totals.
     C                   MOVEL     *BLANK        ZTCON                          *CON (Screen co
     C                   Z-ADD     *ZERO         ZTNCRC                         No of Calculate
      * Print report body.
     C     W0EOF         DOWEQ     '0'
      * Print headings.
     C                   EXSR      BAPRHD
      * Print report detail line.
     C                   EXSR      CAPRDT
      * Hold current values.
     C     *LIKE         DEFINE    BRCH          WZBRCH                         Branch Code
     C                   MOVEL     BRCH          WZBRCH
     C     *LIKE         DEFINE    BOOK          WZBOOK                         Book Code
     C                   MOVEL     BOOK          WZBOOK
     C     *LIKE         DEFINE    CURY          WZCURY                         Currency
     C                   MOVEL     CURY          WZCURY
     C     *LIKE         DEFINE    CTRY          WZCTRY                         Country of Domicile
     C                   MOVEL     CTRY          WZCTRY
     C     *LIKE         DEFINE    CUTY          WZCUTY                         Customer Type
     C                   MOVEL     CUTY          WZCUTY
     C     *LIKE         DEFINE    INST          WZINST                         Institution Code
     C                   MOVEL     INST          WZINST
     C     *LIKE         DEFINE    MODU          WZMODU                         Module
     C                   MOVEL     MODU          WZMODU
     C     *LIKE         DEFINE    TRTY          WZTRTY                         Transaction Type
     C                   MOVEL     TRTY          WZTRTY
     C     *LIKE         DEFINE    TRST          WZTRST                         Transaction Subtype
     C                   MOVEL     TRST          WZTRST
      * Read next record with user selection.
     C                   EXSR      GARDRC
      * Determine level changes.
     C                   EXSR      DALVCH
      * Print totals.
     C                   EXSR      EAPRTT
      * Process necessary heading requests
     C                   EXSR      FASGHD
     C                   END
     C                   WRITE     ZZENDRPT
     C                   END
      * Exit program.
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
      *****************************************************************
      /EJECT
     CSR   BAPRHD        BEGSR
      *================================================================
      * Print report Headers.
      *================================================================
     C     L0            IFEQ      'Y'
     C                   WRITE     ZZPAGHDR
      *
      * Load format.
     C                   MOVEL     BRCH          Z1BRCH                         Branch Code
     C                   MOVEL     *BLANK        Z1WMH1                         WH Tax Rate Def M
     C                   MOVEL     *BLANK        Z1WMH2                         WH Tax Rate Def M
      *
     C                   MOVEL     'Y'           W0PFM
      * User: Process Branch Code headings.
      * Set up the Base Fields header text.
      * Base Field Set-up Hdr - Withholding Tax Rate Default Matrix *
     C**
     C** Move each DB field heading into the associated section of the
     C** array in order to move the correct Headings into the screen
     C** heading output fields.
     C**
     C** To place the text into the correct portion of the array make
     C** use of the priorities specified for each base field off the
     C** General Ledger File, the fields of which are passed into this
     C** user source.
     C**
     C** Set-up Branch Code Heading
     C**
     C**  IF Multibranching Switched On then Branch Code Will be
     C**  displayed if the priority on WHTDftMtrxPriorities is GT 0
     C     WUMBIN        IFEQ      'Y'
     C**
     C     WUWMBH        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMBH        H                 2 0
     C** Initialise Branch Storage Fields - Line 1
     C**                   ¦
     C                   MOVE      *BLANKS       UUHHD1           14
     C                   MOVE      *BLANKS       UUHHD2           14
     C** UUHHD1- Move ' Brch         ' into Line 1
     C** UUHHD2- Move ' Code         ' into Line 2
     C**                   ¦
     C                   MOVEA     HDR3(1)       UUHHD1
     C                   MOVEA     HDR4(1)       UUHHD2
     C** Find Length if Field Required To be Displayed from Compile
     C** time array data - BRCH Code element is 1
     C**                   ¦
     C** Move length of field required to be printed into last 2 Chars
     C** of Heading Line 1 & 2 giving
     C**
     C** UUHHD1- Move ' Brch      08' into Line 1
     C** UUHHD2- Move ' Code      08' into Line 2
     C**                   ¦
     C                   MOVE      '08'          UUHHD1
     C                   MOVE      '08'          UUHHD2
     C** Move Headings 1 & 2 into array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEL     UUHHD1        HDR1(H)
     C                   MOVEL     UUHHD2        HDR2(H)
     C                   END                                                      IF 1
     C                   END                                                      IF 1
     C** Set-up Book Code Heading
     C**
     C     WUWMBK        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMBK        B                 2 0
     C** Initialise Book Storage Fields - Line 1
     C**                   ¦
     C                   MOVE      *BLANKS       UUBHD1           14
     C                   MOVE      *BLANKS       UUBHD2           14
     C** UUBHD1- Move ' Book         ' into Line 1
     C** UUBHD2- Move ' Code         ' into Line 2
     C**                   ¦
     C                   MOVEA     HDR3(2)       UUBHD1
     C                   MOVEA     HDR4(2)       UUBHD2
     C** Find Length if Field Required To be Displayed from Compile
     C** time array data - Book Code element is 2
     C**                   ¦
     C** Move length of field required to be printed into last 2 Chars
     C** of Heading Line 1 & 2 giving
     C**
     C** UUBHD1- Move ' Book       08' into Line 1
     C** UUBHD2- Move ' Code       08' into Line 2
     C**                   ¦
     C                   MOVE      '08'          UUBHD1
     C                   MOVE      '08'          UUBHD2
     C** Move Headings 1 & 2 into array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEL     UUBHD1        HDR1(B)
     C                   MOVEL     UUBHD2        HDR2(B)
     C                   END                                                      IF 1
     C/EJECT
     C** Set-up Currency Heading
     C**
     C     WUWMCY        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMCY        C                 2 0
     C** Initialise Currency Storage Fields - Line 1
     C**                   ¦
     C                   MOVE      *BLANKS       UUCHD1           14
     C                   MOVE      *BLANKS       UUCHD2           14
     C** UUBHD1- Move ' Ccy          ' into Line 1
     C** UUBHD2- Move ' Code         ' into Line 2
     C**                   ¦
     C                   MOVEA     HDR3(3)       UUCHD1
     C                   MOVEA     HDR4(3)       UUCHD2
     C** Find Length if Field Required To be Displayed from Compile
     C** time array data - Currency Code element is 3
     C**                   ¦
     C** Move length of field required to be printed into last 2 Chars
     C** of Heading Line 1 & 2 giving
     C**
     C** UUBHD1- Move ' Ccy        07' into Line 1
     C** UUBHD2- Move ' Code       07' into Line 2
     C**                   ¦
     C                   MOVE      '07'          UUCHD1
     C                   MOVE      '07'          UUCHD2
     C** Move Headings 1 & 2 into array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEL     UUCHD1        HDR1(C)
     C                   MOVEL     UUCHD2        HDR2(C)
     C                   END                                                      IF 1
     C/EJECT
     C** Set-up Country of Domicile Heading
     C**
     C     WUWMCR        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMCR        D                 2 0
     C** Initialise Country of Domicile Storage Fields - Line 1
     C**                   ¦
     C                   MOVE      *BLANKS       UUDHD1           14
     C                   MOVE      *BLANKS       UUDHD2           14
     C** UUAHD1- Move ' Ctry of      ' into Line 1
     C** UUAHD2- Move ' Domic        ' into Line 2
     C**                   ¦
     C                   MOVEA     HDR3(4)       UUDHD1
     C                   MOVEA     HDR4(4)       UUDHD2
     C** Find Length if Field Required To be Displayed from Compile
     C** time array data - Country of Domicile element is 4
     C**                   ¦
     C** Move length of field required to be printed into last 2 Chars
     C** of Heading Line 1 & 2 giving
     C**
     C** UUAHD1- Move ' Ctry of    11' into Line 1
     C** UUAHD2- Move ' Domic      11' into Line 2
     C**                   ¦
     C                   MOVE      '11'          UUDHD1
     C                   MOVE      '11'          UUDHD2
     C** Move Headings 1 & 2 into array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEL     UUDHD1        HDR1(D)
     C                   MOVEL     UUDHD2        HDR2(D)
     C                   END                                                      IF 1
     C/EJECT
     C** Set-up Customer Type Heading
     C**
     C     WUWMCT        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMCT        U                 2 0
     C** Initialise Customer Type Storage Fields - Line 1
     C**                   ¦
     C                   MOVE      *BLANKS       UUUHD1           14
     C                   MOVE      *BLANKS       UUUHD2           14
     C** UUCHD1- Move '  Cust    ' into Line 1
     C** UUCHD2- Move '  Type    ' into Line 2
     C**                   ¦
     C                   MOVEA     HDR3(5)       UUUHD1
     C                   MOVEA     HDR4(5)       UUUHD2
     C** Find Length if Field Required To be Displayed from Compile
     C** time array data - Customer Type element is 5
     C**                   ¦
     C** Move length of field required to be printed into last 2 Chars
     C** of Heading Line 1 & 2 giving
     C**
     C** UUBHD1- Move '  Cust      08' into Line 1
     C** UUBHD2- Move '  Type      08' into Line 2
     C**                   ¦
     C                   MOVE      '08'          UUUHD1
     C                   MOVE      '08'          UUUHD2
     C** Move Headings 1 & 2 into array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEL     UUUHD1        HDR1(U)
     C                   MOVEL     UUUHD2        HDR2(U)
     C                   END                                                      IF 1
     C/EJECT
     C** Set-up Institution Code Heading
     C**
     C     WUWMIS        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMIS        I                 2 0
     C** Initialise Dept Storage Fields - Line 1
     C**                   ¦
     C                   MOVE      *BLANKS       UUIHD1           14
     C                   MOVE      *BLANKS       UUIHD2           14
     C** UUDHD1- Move ' Inst         ' into Line 1
     C** UUDHD2- Move ' Code         ' into Line 2
     C**                   ¦
     C                   MOVEA     HDR3(6)       UUIHD1
     C                   MOVEA     HDR4(6)       UUIHD2
     C** Find Length if Field Required To be Displayed from Compile
     C** time array data - Institution Code element is 6
     C**                   ¦
     C** Move length of field required to be printed into last 2 Chars
     C** of Heading Line 1 & 2 giving
     C**
     C** UUDHD1- Move ' Inst       08' into Line 1
     C** UUDHD2- Move ' Code       08' into Line 2
     C**                   ¦
     C                   MOVE      '08'          UUIHD1
     C                   MOVE      '08'          UUIHD2
     C** Move Headings 1 & 2 into array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEL     UUIHD1        HDR1(I)
     C                   MOVEL     UUIHD2        HDR2(I)
     C                   END                                                      IF 1
     C/EJECT
     C** Set-up Module Heading
     C**
     C     WUWMMO        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMMO        M                 2 0
     C** Initialise Module Storage Fields - Line 1
     C**                   ¦
     C                   MOVE      *BLANKS       UUMHD1           14
     C                   MOVE      *BLANKS       UUMHD2           14
     C** UUAHD1- Move ' Module       ' into Line 1
     C** UUAHD2- Move '              ' into Line 2
     C**                   ¦
     C                   MOVEA     HDR3(7)       UUMHD1
     C                   MOVEA     HDR4(7)       UUMHD2
     C** Find Length if Field Required To be Displayed from Compile
     C** time array data - Module element is 7
     C**                   ¦
     C** Move length of field required to be printed into last 2 Chars
     C** of Heading Line 1 & 2 giving
     C**
     C** UUAHD1- Move ' Mod        07' into Line 1
     C** UUAHD2- Move '            07' into Line 2
     C**                   ¦
     C                   MOVE      '07'          UUMHD1
     C                   MOVE      '07'          UUMHD2
     C** Move Headings 1 & 2 into array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEL     UUMHD1        HDR1(M)
     C                   MOVEL     UUMHD2        HDR2(M)
     C                   END                                                      IF 1
     C/EJECT
     C** Set-up Transaction Type Heading
     C**
     C     WUWMTT        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMTT        T                 2 0
     C** Initialise Trans Type Storage Fields - Line 1
     C**                   ¦
     C                   MOVE      *BLANKS       UUTHD1           14
     C                   MOVE      *BLANKS       UUTHD2           14
     C** UUTHD1- Move ' Trans        ' into Line 1
     C** UUTHD2- Move ' Type         ' into Line 2
     C**                   ¦
     C                   MOVEA     HDR3(8)       UUTHD1
     C                   MOVEA     HDR4(8)       UUTHD2
     C** Find Length if Field Required To be Displayed from Compile
     C** time array data - Trans Type element is 8
     C**                   ¦
     C** Move length of field required to be printed into last 2 Chars
     C** of Heading Line 1 & 2 giving
     C**
     C** UUTHD1- Move ' Trans      09' into Line 1
     C** UUTHD2- Move ' Type       09' into Line 2
     C**                   ¦
     C*********************MOVE '09'      UUTHD1                                              HUT003
     C*********************MOVE '09'      UUTHD2                                              HUT003
     C                   MOVE      '12'          UUTHD1
     C                   MOVE      '12'          UUTHD2
     C** Move Headings 1 & 2 into array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEL     UUTHD1        HDR1(T)
     C                   MOVEL     UUTHD2        HDR2(T)
     C                   END                                                      IF 1
     C/EJECT
     C** Transaction Subtype Heading
     C**
     C     WUWMTS        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMTS        S                 2 0
     C** Initialise Tran Subtype Storage Fields - Line 1
     C**                   ¦
     C                   MOVE      *BLANKS       UUSHD1           14
     C                   MOVE      *BLANKS       UUSHD2           14
     C** UUSHD1- Move ' Trans           ' into Line 1
     C** UUSHD2- Move ' Subtype         ' into Line 2
     C**                   ¦
     C                   MOVEA     HDR3(9)       UUSHD1
     C                   MOVEA     HDR4(9)       UUSHD2
     C** Find Length if Field Required To be Displayed from Compile
     C** time array data - Trans Subtype  element is 9
     C**                   ¦
     C** Move length of field required to be printed into last 2 Chars
     C** of Heading Line 1 & 2 giving
     C**
     C** UUSHD1- Move ' Trans      10' into Line 1
     C** UUSHD2- Move ' Subtype    10' into Line 2
     C**                   ¦
     C                   MOVE      '10'          UUSHD1
     C                   MOVE      '10'          UUSHD2
     C** Move Headings 1 & 2 into array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEL     UUSHD1        HDR1(S)
     C                   MOVEL     UUSHD2        HDR2(S)
     C                   END                                                      IF 1
     C/EJECT
     C** Load 70 Character 1 Bit Array with all Field Values
     C**
     C                   Z-ADD     1             Y                 2 0
     C                   Z-ADD     1             Z                 2 0
     C** Load HD1 HD2 with all 9 Base Fields according to their priors
     C** and there length.
     C**
     C     Y             DOWNE     10                                            DO
     C**                   ¦
     C                   MOVEA     HDR1(Y)       HD1(Z)
     C                   MOVEA     HDR2(Y)       HD2(Z)
     C                   MOVE      HDR1(Y)       PTR               2 0
     C     Z             ADD       PTR           Z
     C                   ADD       1             Y
     C**                   ¦
     C                   END                                                     WOD
     C**
     C**
     C** Move Final Array Contents to Output Screen Field
     C**
     C                   MOVEA     HD1           Z1WMH1
     C                   MOVEA     HD2           Z1WMH2
     C**
     C**
     C     W0PFM         IFEQ      'Y'
      * Print format.
     C                   WRITE     Z1KEYHDR
     C                   END
     C                   END
      *
      *================================================================
     CSR   BAEXIT        ENDSR
      /EJECT
     CSR   CAPRDT        BEGSR
      *================================================================
      * Print report detail line.
      *================================================================
      * Load detail line.
     C                   MOVEL     BRCH          XRBRCH                         Branch Code
     C                   MOVEL     BOOK          XRBOOK                         Book Code
     C                   MOVEL     CURY          XRCURY                         Currency
     C                   MOVEL     CTRY          XRCTRY                         Country of Domicile
     C                   MOVEL     CUTY          XRCUTY                         Customer Type
     C                   MOVEL     INST          XRINST                         Institution Code
     C                   MOVEL     MODU          XRMODU                         Module
     C                   MOVEL     TRTY          XRTRTY                         Transaction Type
     C                   MOVEL     TRST          XRTRST                         Transaction Subtype
      *
     C                   MOVEL     TXR1          XRTXR1                         Default Tax Rate Cod
     C                   Z-ADD     LCD           XRLCD                          Last Change Dat
     C                   MOVEL     TYPC          XRTYPC                         Type of Last Ch
     C                   MOVEL     *BLANK        XRWDMO                         WH Tax Dft Matrix
     C                   MOVEL     *BLANK        XRACDT                         alpha change da
     C                   MOVEL     *BLANK        XRALCH                         alpha of last c
     C                   MOVEL     *BLANK        XRWNFF                         Window Function
     C                   MOVEL     *BLANK        XRWNF1                         Window Function
     C                   MOVEL     *BLANK        XRWNF2                         Window Function
     C                   MOVEL     'Y'           W0PFM
      * USER: Process detail record
      * Set up the Base Fields.
      * Base Field Set-up - Withholding Tax Rate Default Matrix *
     C**
     C** Move each database field into the associated section of the
     C** array in order to display all the details into the screen
     C** output field.
     C**
     C** To place the field into the correct portion of the array make
     C** use of the priorities specified for each field off the
     C** General Ledger File, the fields of which are passed into this
     C** user source.
     C**
     C** Set-up Branch Code
     C**
     C**  IF Multibranching Switched On then Branch Code Will be
     C**  displayed if the priority on WHTDftMtrxPriorities is GT 0
     C     WUMBIN        IFEQ      'Y'
     C**
     C     WUWMBH        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMBH        H
     C** Initialise Branch Code Storage Fields
     C**                   ¦
     C                   MOVE      *BLANKS       UUBCH             5
     C                   MOVE      *BLANKS       UUBCH2           14
     C** UUBCH - Move Branch Code to Store Branch Code 5 Long to hold
     C** bbXXX where b is blank and X's is the Branch code.
     C**                   ¦
     C     XRBRCH        IFNE      '***'
     C                   MOVE      XRBRCH        UUBCH
     C                   END
     C** UUBCH2- Move Store Bch Code to Store Bch Code 14 Long
     C** bbXXXbbbbbbbbb where b's are blanks and X's is the Bch Code.
     C**                   ¦
     C                   MOVEL     UUBCH         UUBCH2
     C** Find Length if Field Required To be Displayed from Compile
     C** time array data - Branch code element is 1
     C**                   ¦
     C** Move length of field required to be printed into last 2 Chars
     C** of Long Store Bch Code giving - bbXXXbbbbbbb06 in the field.
     C** where b's are blanks and XX is the Trans Type, 07 Len of Fld.
     C**                   ¦
     C                   MOVE      '08'          UUBCH2
     C** Move Long Store Bch Code  to array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEA     UUBCH2        PARR(H)
     C                   END                                                      IF 1
     C**
     C                   END
     C/EJECT
     C** Set-up Book Code
     C**
     C     WUWMBK        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMBK        B
     C** Initialise Book Code Storage Fields
     C**                   ¦
     C                   MOVE      *BLANKS       UUBOK             4
     C                   MOVE      *BLANKS       UUBOK2           14
     C** UUBOK - Move Book Code to Store Book Code 4 Long to hold
     C**         bbXX  where bb are blanks and XX is the Book Code.
     C**                   ¦
     C     XRBOOK        IFNE      '**'
     C                   MOVE      XRBOOK        UUBOK
     C                   END
     C** UUBOK2 - Move Store Book Code to Store Long Book Code 14 Long
     C** bbXXbbbbbbbbbb where b's are blanks and XX is the Book Code.
     C**                   ¦
     C                   MOVEL     UUBOK         UUBOK2
     C** Find Length if Field Required To be Displayed from Compile
     C** time array data - Book Code element is 2
     C**                   ¦
     C** Move length of field required to be printed into last 2 Chars
     C** of Long Store Book Code giving - bbXXbbbbbbbb06 in the field.
     C** where b's are blanks and XX is the Book Code, 06 Len of Fld.
     C**                   ¦
     C                   MOVE      '08'          UUBOK2
     C** Move Long Store Book Code to array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEA     UUBOK2        PARR(B)
     C                   END                                                      IF 1
     C/EJECT
     C** Set-up Currency
     C**
     C     WUWMCY        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMCY        C
     C** Initialise Currency Storage Fields
     C**                   ¦
     C                   MOVE      *BLANKS       UUCCY             5
     C                   MOVE      *BLANKS       UUCCY2           14
     C** UUCCY - Move Currency to Store Currency 5 Long to hold
     C**         bbXXX where bb are blanks and XX is the Currency
     C**                   ¦
     C     XRCURY        IFNE      '***'
     C                   MOVE      XRCURY        UUCCY
     C                   END
     C** UUCCY2 - Move Store Currency to Store Currency Code 14 Long
     C** bbXXXbbbbbbbbb where b's are blanks and XX is the Currency.
     C**                   ¦
     C                   MOVEL     UUCCY         UUCCY2
     C** Find Length if Field Required To be Displayed from Compile
     C** time array data - Currency element is 3
     C**                   ¦
     C** Move length of field required to be printed into last 2 Chars
     C** of Long Store Currency giving - bbXXXbbbbbbb05 in the field.
     C** where b's are blanks and XX is the Currency, 05 Len of Fld.
     C**                   ¦
     C                   MOVE      '07'          UUCCY2
     C** Move Long Store Currency to array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEA     UUCCY2        PARR(C)
     C                   END                                                      IF 1
     C/EJECT
     C** Set-up Country of Domicile
     C**
     C     WUWMCR        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMCR        D
     C** Initialise Country of Domicile Storage Fields
     C**                   ¦
     C                   MOVE      *BLANKS       UUCTR             4
     C                   MOVE      *BLANKS       UUCTR2           14
     C** UUCTR - Move Country of Domicile to Store Country of Domicile
     C** 4 Long to hold bbXX where b is blank and X's is the Country of Domicile .
     C**                   ¦
     C     XRCTRY        IFNE      '**'
     C                   MOVE      XRCTRY        UUCTR
     C                   END
     C** UUCTR2- Move Store Country of Domicile to Store Country of Domicile
     C** Code 14 Long bbXXbbbbbbbbbb where b's are blanks and X's is the
     C** Country of Domicile.
     C**
     C                   MOVEL     UUCTR         UUCTR2
     C** Find Length if Field Required To be Displayed from Compile
     C** time array data - Country of Domicile is 4
     C**                   ¦
     C** Move length of field required to be printed into last 2 Chars
     C** of Long Store Country of Domicile giving - bXXXXXbbbbbb09 in the field.
     C** where b's are blanks and XX is the Country of Domicile 09 Len of Fld.
     C**                   ¦
     C                   MOVE      '11'          UUCTR2
     C** Move Long Store Country of Domicile to array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEA     UUCTR2        PARR(D)
     C                   END                                                      IF 1
     C/EJECT
     C** Set-up Customer Type
     C**
     C     WUWMCT        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMCT        U
     C** Initialise Customer Type Storage Fields
     C**                   ¦
     C                   MOVE      *BLANKS       UUCUS             3
     C                   MOVE      *BLANKS       UUCUS2           14
     C** UUCUS - Move Customer Type to Store Customer Type 3 Long to hold
     C** bbX where b is blank and X's is the Customer Type.
     C**                   ¦
     C     XRCUTY        IFNE      '*'
     C                   MOVE      XRCUTY        UUCUS
     C                   END
     C** UUCUS2- Move Store Customer Type to Store Customer Type 14 Long
     C** bbXbbbbbbbbbbb where b's are blanks and X's is the Customer Type
     C**                   ¦
     C                   MOVEL     UUCUS         UUCUS2
     C** Find Length if Field Required To be Displayed from Compile
     C** time array data - Customer Type element is 5
     C**                   ¦
     C** Move length of field required to be printed into last 2 Chars
     C** of Long Store Customer Type giving - bbXXXbbbbbbb06 in the field.
     C** where b's are blanks and XX is the Customer Type, 06 Len of Fld.
     C**                   ¦
     C                   MOVE      '07'          UUCUS2
     C** Move Long Store Customer Type to array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEA     UUCUS2        PARR(U)
     C                   END                                                      IF 1
     C/EJECT
     C** Set-up Institution Code
     C**
     C     WUWMIS        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMIS        I
     C** Initialise Institution Code Storage Fields
     C**                   ¦
     C                   MOVE      *BLANKS       UUINS             4
     C                   MOVE      *BLANKS       UUINS2           14
     C** UUINS - Move Institution Code to Store Institution Code 4 Long to hold
     C** bbXX where b is blank and X's is the Institution Code.
     C**                   ¦
     C     XRINST        IFNE      '**'
     C                   MOVE      XRINST        UUINS
     C                   END
     C** UUDPT2- Move Store Institution Code to Institution Code Type 14 Long
     C** bbXXbbbbbbbbbb where b's are blanks and X's is the Institution Code
     C**                   ¦
     C                   MOVEL     UUINS         UUINS2
     C** Find Length if Field Required To be Displayed from Compile
     C** time array data - Institution Code element is 5
     C**                   ¦
     C** Move length of field required to be printed into last 2 Chars
     C** of Long Store Institution Code giving - bbXXXbbbbbbb06 in the field.
     C** where b's are blanks and XX is the Institution Code, 06 Len of Fld.
     C**                   ¦
     C                   MOVE      '08'          UUINS2
     C** Move Long Store Institution Code to array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEA     UUINS2        PARR(I)
     C                   END                                                      IF 1
     C/EJECT
     C** Set-up Module
     C**
     C     WUWMMO        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMMO        M
     C** Initialise Module Storage Fields
     C**                   ¦
     C                   MOVE      *BLANKS       UUMOD             4
     C                   MOVE      *BLANKS       UUMOD2           14
     C** UUMOD -Move Module to Store Module to 6 Long to hold
     C** bbXXbbbbbbb where b is blank and X's is the Module
     C**                   ¦
     C     XRMODU        IFNE      '**'
     C                   MOVE      XRMODU        UUMOD
     C                   END
     C** UUMOD2- Move Store Module to Store Module 14 Long
     C** bbXXbbbbbbbbbb where b's are blanks and X's is the Module
     C**                   ¦
     C                   MOVEL     UUMOD         UUMOD2
     C** Find Length if Field Required To be Displayed from Compile
     C** time array data - Module element is 7
     C**                   ¦
     C** Move length of field required to be printed into last 2 Chars
     C** of Long Store Module giving - bbXXbbbbbbbb05 in the field.
     C** where b's are blanks and XX is the Module, 05 Len of Fld.
     C**                   ¦
     C                   MOVE      '07'          UUMOD2
     C** Move Long Store Module to array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEA     UUMOD2        PARR(M)
     C                   END                                                      IF 1
     C/EJECT
     C** Set-up Transaction Type
     C**
     C     WUWMTT        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMTT        T
     C** Initialise Transaction Type Storage Fields
     C**                   ¦
     C                   MOVE      *BLANKS       UUTTY            10
     C                   MOVE      *BLANKS       UUTTY2           14
     C** Change required as Account Code is used as a Product Type
     C** UUTTY-Move Transaction Type to Store Transaction Type to 10 Long to hold
     C** bbXXXX where b is blank and X's is the Transaction Type.
     C**                   ¦
     C                   MOVEL     XRTRTY        WRTRTY            4
     C***********XRTRTY    IFNE '****'                                                        HUT003
     C     WRTRTY        IFNE      '****'
     C                   MOVE      XRTRTY        UUTTY
     C                   END
     C** UUTTY2- Move Store Transaction Type to Store Transaction Type 14 Long
     C** bbXXXXbbbbbbbb where b's are blanks and X's is the Transaction Type
     C**                   ¦
     C                   MOVEL     UUTTY         UUTTY2
     C** Find Length if Field Required To be Displayed from Compile
     C** time array data - Transaction Type element is 8
     C**                   ¦
     C** Move length of field required to be printed into last 2 Chars
     C** of Long Store Transaction Type giving - bbXXXXbbbbbb07 in the field.
     C** where b's are blanks and XX is the Transaction Type, 07 Len of Fld.
     C**                   ¦
     C*********************MOVE '09'      UUTTY2                                              HUT003
     C                   MOVE      '12'          UUTTY2
     C** Move Long Store Transaction Type to array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEA     UUTTY2        PARR(T)
     C                   END                                                      IF 1
     C/EJECT
     C** Set-up Transaction Subtype
     C**
     C     WUWMTS        IFNE      0                                               IF 1
     C                   Z-ADD     WUWMTS        S
     C** Initialise Transaction Subtype Storage Fields
     C**                   ¦
     C                   MOVE      *BLANKS       UUTST             4
     C                   MOVE      *BLANKS       UUTST2           14
     C** UUCUS-Move Transaction Subtype to Store Transaction Subtype 04 Long to hold
     C** bbXX where b is blank and X's is the Transaction Subtype.
     C**                   ¦
     C     XRTRST        IFNE      '**'
     C                   MOVE      XRTRST        UUTST
     C                   END
     C** UUTST2- Move Store Transaction Subtype to Store Transaction Subtype 14 Long
     C** bbXXbbbbbbbbbb where b's are blanks and X's is the Transaction Subtype.
     C**                   ¦
     C                   MOVEL     UUTST         UUTST2
     C** Find Length if Field Required To be Displayed from Compile
     C** time array data - Transaction Subtype element is 9.
     C**                   ¦
     C** Move length of field required to be printed into last 2 Chars
     C** of Long Store Transaction Subtype giving - bbXXbbbbbbbb08 in the field.
     C** where b's are blanks and XX is the Transaction Subtype, 08 Len of Fld.
     C**                   ¦
     C                   MOVE      '10'          UUTST2
     C** Move Long Store Transaction Subtype to according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEA     UUTST2        PARR(S)
     C                   END                                                      IF 1
     C/EJECT
     C** Load 70 Character 1 Bit Array with all Field Values
     C**
     C                   Z-ADD     1             Y                 2 0
     C                   Z-ADD     1             Z                 2 0
     C** Load AR1 with all 9 Base Fields according to their priorities
     C** and there length.
     C**
     C                   CLEAR                   AR1
     C     Y             DOWNE     10                                            DO
     C**                   ¦
     C     PARR(Y)       IFNE      *BLANK                                        IF 1
     C**                   ¦¦
     C                   MOVE      *BLANKS       WW12             12
     C                   MOVE      *BLANKS       WW02              2
     C                   MOVEA     PARR(Y)       WW12
     C                   MOVE      PARR(Y)       WW02
     C                   MOVEA     WW12          AR1(Z)
     C                   MOVE      WW02          PTR               2 0
     C     Z             ADD       PTR           Z
     C**                   ¦¦
     C                   END                                                     FI 1
     C**                   ¦
     C                   ADD       1             Y
     C**                   ¦
     C                   END                                                     WOD
     C**
     C** Move Final Array Contents to Output Screen Field
     C**
     C                   MOVEA     AR1           XRWDMO
     C**
     C**
     C                   MOVEL     P1ARSI        WUARSI                         Audit/Request S
      * Process Detail Rec PRTFIL
     C                   ADD       1             WUWKNB                         work number
      *CASE:     PAR.Audit/Request Status Ind is Audit Mode
     C     WUARSI        IFEQ      @CN(02)                                      *IF
      *CASE:     PAR.Last Change Date NE WRK.run day number
     C     XRLCD         IFNE      WURDNB                                       *IF
     C                   MOVEL     @CN(03)       W0PFM                          *Print format
     C                   END                                                    *FI
     C                   END                                                    *FI
      *CASE:     PGM.*Print format is Print format
     C     W0PFM         IFEQ      @CN(01)                                      *IF
     C                   ADD       1             ZTNCRC                         No of Calculate
      *CASE:     PAR.No of Calculated Recs is Equal 1
     C     ZTNCRC        IFEQ      1                                            *IF
      * Change Print Control to Y - Standing Data Controls  *
     C*
     C* Set Print Control To Y To Enable Column Headers To Be
     C*             Printed On First Record..
     C*
     C                   MOVEL     'Y'           BAPR              1
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Check File Date - Rundate  *
     C                   CALL      'ZDATE2'                             90      Check File Date
     C                   PARM      XRLCD         WQ0001            5 0          Work Midas Date
     C                   PARM      WUDFF         WQ0002            1            Date format fla
     C     WUWCDT        PARM      *ZERO         WQ0003            6 0          Work Converted
     C     XRACDT        PARM      *BLANK        WQ0004            7            Work Alpha Date
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
      * PAR.alpha of last change = Condition name of PAR.Type of Last Change
     C                   CALL      'Y2RVCNR'                            90      *
     C                   PARM                    W0RTN             7            Return code
     C                   PARM      1100584       Y2LSNO            7 0          List number
     C                   PARM      XRTYPC        W0INVL           20            Type of Last Ch
     C                   PARM      ' '           W0VLMP            1            Value mapped?
     C     XRALCH        PARM                    W0CNNM           25            alpha of last c
      *
     C     W0PFM         IFEQ      'Y'
      * Print detail line.
     C                   WRITE     ZZDTLRCD
     C                   END
      *================================================================
     CSR   CAEXIT        ENDSR
      /EJECT
     CSR   DALVCH        BEGSR
      *================================================================
      * Detect level changes.
      *================================================================
      * Clear all level breaks.
     C                   MOVEL     *BLANK        L0                             Page headings
      * Clear heading length to print.
     C                   Z-ADD     *ZERO         @#HDL
      *
      *================================================================
     CSR   DAEXIT        ENDSR
      /EJECT
     CSR   EAPRTT        BEGSR
      *================================================================
      * Print report Totals.
      *================================================================
      * Print level break totals as required
      * End of file - Print final totals.
     C     W0EOF         IFEQ      '1'
     C                   MOVEL     'Y'           W0PFM
      * USER: Process End of Report
      *CASE:     CUR.No of Calculated Recs is Compare to Zero
     C     ZTNCRC        IFEQ      *ZERO                                        *IF
     C                   MOVEL     @CN(04)       WUALZR                         Alpha Zero
     C                   END                                                    *FI
      *CASE:     PAR.Audit/Request Status Ind is Audit Mode
     C     P1ARSI        IFEQ      @CN(02)                                      *IF
      * Audit/On-Req RTV on FCTL - Standing Data Controls  *
     C                   EXSR      SARVGN
      *CASE:     WRK.work number NE WRK.No of Records on file
     C     WUWKNB        IFNE      WUNORF                                       *IF
     C                   MOVEL     @CN(03)       WUWFLG                         work flag
     C                   END                                                    *FI
      * Audit printfile override - Standing Data Controls  *
     C                   CALL      'SDC540P'                            90      Audit printfile
     C                   PARM      @CN(07)       WQ0005           10            *PROGRAM
     C                   PARM      WUWFLG        WQ0006            1            work flag
     C                   PARM      WUNORI        WQ0007            5 0          No of Records I
     C                   PARM      WUNORA        WQ0008            5 0          No of Records A
     C                   PARM      WUNORD        WQ0009            5 0          No of records D
     C                   PARM      WUWKNB        WQ0010            5 0          work number
     C                   PARM      WUNORF        WQ0011            5 0          No of Records o
     C                   PARM      WUAURT        WQ0012           53            Audit/Request T
     C                   PARM      WUBJNA        WQ0013           53            Underline
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
      *CASE:     PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      @CN(06)                                      *IF
      * Database Error U7 U8 - Standing Data Controls  *
     C*
     C** DATABASE ERROR, SET ON SWITHES U7 AND U8
     C*
     C                   SETON                                        U7U8
     C*
     C                   ELSE
      *CASE:     WRK.work flag is Incorrect
     C     WUWFLG        IFEQ      @CN(03)                                      *IF
      * File Control Error U8 - Standing Data Controls  *
     C*
     C** FILE CONTROLS OUT OF BALANCE SETON U8
     C*
     C                   SETON                                            U8
     C*
     C                   ELSE
      *CASE:     PGM.*Return code is *Field attribute types EX
     C     W0RTN         IFEQ      @CN(08)                                      *IF
     C                   ELSE
      *CASE:     *OTHERWISE
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SBCHRC
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      *CASE:     WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      @CN(01)                                      *IF
      * 00/Copy member SD0490PPER - Profit Centre Dft Matrix  *
     C*Prft Ctre Dft Mtrx ReportProcess End Of Report
     C/COPY WNCPYSRC,SD0490PPER
     C                   END                                                    *FI
     C     W0PFM         IFEQ      'Y'
      * If there is not enough space on the
      * physical page for this format:-
     C     @$PGL         SUB       @$CLN         @#WRK
     C     @#WRK         IFLE      4
      * Signal artificial overflow.
     C                   SETON                                        97
      * Print page headers.
     C                   WRITE     ZZPAGHDR
     C                   END
     C                   MOVEL     '0'           *IN79
     C     WUALZR        IFEQ      @CN(04)                                      *IF
     C                   MOVEL     '1'           *IN79
     C                   END                                                    *FI
      * Print format.
     C                   WRITE     ZZFINTTL
     C                   END
     C                   END
      *
      *================================================================
     CSR   EAEXIT        ENDSR
      /EJECT
     CSR   FASGHD        BEGSR
      *================================================================
      * Signal required header formats.
      *================================================================
      * Cascade skip to new page requests upwards.
      *
     C     *IN97         IFNE      '1'
     C     L0            ANDNE     'Y'
      * Signal overflow if requested headings would cause
      * detail format to start past the overflow line.
     C     W0OFL         SUB       @$CLN         @#WRK
     C     @#WRK         IFLE      @#HDL
     C                   SETON                                        97
     C                   ELSE
      * Signal overflow if requested headings would cause
      * detail format to be printed past end of page
     C                   ADD       4             @#HDL
     C     W0PGL         SUB       @$CLN         @#WRK
     C     @#WRK         IFLE      @#HDL
     C                   SETON                                        97
     C                   END
     C                   END
     C                   END
      * Overflow detected.
     C     *IN97         IFEQ      '1'
      * Request page headings.
     C                   MOVEL     'Y'           L0
      * Request all formats which print on overflow.
     C                   SETOFF                                       97
     C                   END
      *================================================================
     CSR   FAEXIT        ENDSR
      /EJECT
     CSR   GARDRC        BEGSR
      *================================================================
      * Read next record with user selection.
      *================================================================
     C     W0RSL         DOUEQ     'Y'
      *
     C                   READ      SDWTDMD0                               90    *
      *
     C                   MOVEL     *IN90         W0EOF             1
      * Quit if no record read.
     C     W0EOF         CABEQ     '1'           GAEXIT
      * Select record unless user action states otherwise.
     C                   MOVEL     'Y'           W0RSL             1
     C                   END
      *================================================================
     CSR   GAEXIT        ENDSR
      /EJECT
     CSR   SARVGN        BEGSR
      *================================================================
      * Audit/On-Req RTV on FCTL - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define Keylist.
     C     KRSSA         KLIST
     C                   KFLD                    AHFLNM                         Filename
      * Move fields to key list.
     C                   MOVEL     @CN(05)       AHFLNM                         Filename
     C     KRSSA         CHAIN     @AHREAV                            90        *
     C     *IN90         IFEQ      '1'
      * DBF Record not found.
     C                   MOVEL     'USR0020'     W0RTN             7
      * USER: Processing if DBF record not found
     C                   MOVEL     @CN(06)       W0RTN                          *Return code
     C                   GOTO      SAEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process DBF record
      * PAR = DB1 By name
     C                   Z-ADD     AHNORC        WUNORF                         No. of Records
     C                   Z-ADD     AHNOIN        WUNORI                         No. of Inserts
     C                   Z-ADD     AHNOAM        WUNORA                         No. of Amends
     C                   Z-ADD     AHNODL        WUNORD                         No. of Deletes
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SBCHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @AHREAU
     C                   MOVEL     @CN(05)       AHFLNM                         Filename
      *
     C     KLCHSB        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C     KLCHSB        CHAIN     @AHREAU                            9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found.
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      SBEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SBEXIT
     C                   END
      *
      * USER: Processing after DBF read
     C                   ADD       AHNORC        WUNORC                         No. of Records
     C                   ADD       AHNOIN        WUNOIN                         No. of Inserts
     C                   ADD       AHNOAM        WUNOAM                         No. of Amends
     C                   ADD       AHNODL        WUNODL                         No. of Deletes
      * Move Non-key fields to @AHREAU
     C                   Z-ADD     WUNORC        AHNORC                         No. of Records
     C                   Z-ADD     *ZERO         AHNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         AHNOAM                         No. of Amends
     C                   Z-ADD     *ZERO         AHNODL                         No. of Deletes
      *
     C                   UPDATE    @AHREAU                              91      *
     C     *IN91         IFEQ      '1'
      * Change error detected.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF Change successful.
     C                   END
      *================================================================
     CSR   SBEXIT        ENDSR
      /EJECT
     CSR   SCRVGN        BEGSR
      *================================================================
      * Get Bank Title - Bank Details  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define Keylist.
     C     KRSSC         KLIST
     C                   KFLD                    BJBANK                         Bank
      * Move fields to key list.
     C                   MOVEL     @CN(09)       BJBANK                         Bank
     C     KRSSC         CHAIN     @BJREEF                            90        *
     C     *IN90         IFEQ      '1'
      * DBF Record not found.
     C                   MOVEL     'USR0197'     W0RTN             7
      * USER: Processing if DBF record not found
     C                   MOVEL     @CN(06)       W0RTN                          *Return code
      * Setup message data for message.
     C                   MOVEL     @CN(10)       ZA0001                         Filename
      * Send message 'Database Error (ICD)'
     C                   MOVEL     'USR0377'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        99        *
      *
     C                   GOTO      SCEXIT                                       *QUIT
     C                   GOTO      SCEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process DBF record
      * PAR = DB1 By name
     C                   MOVEL     BJURPT        WUURPT                         User Report Tit
     C                   END
      *================================================================
     CSR   SCEXIT        ENDSR
      /EJECT
     CSR   SDRVGN        BEGSR
      *================================================================
      * Obtain WH Tax Rate Def Pty - General Ledger Details  *
      *================================================================
     C                   Eval      P@Op01 = 'WHTDftMtrxPriorities'
     C                   Call      'AOSVALR0'
     C                   Parm      *Blanks       P@Rtcd            7
     C                   Parm                    P@Op01           20
     C                   Parm      *Blanks       P@Vl01          200
     C                   Parm      *Blanks       P@Op02           20
     C                   Parm      *Blanks       P@Vl02          200
     C                   Parm      *Blanks       P@Op03           20
     C                   Parm      *Blanks       P@Vl03          200
     C                   Parm      *Blanks       P@Op04           20
     C                   Parm      *Blanks       P@Vl04          200
     C                   Parm      *Blanks       P@Op05           20
     C                   Parm      *Blanks       P@Vl05          200
     C                   Parm      *Blanks       P@Op06           20
     C                   Parm      *Blanks       P@Vl06          200
     C                   Parm      *Blanks       P@Op07           20
     C                   Parm      *Blanks       P@Vl07          200
     C                   Parm      *Blanks       P@Op08           20
     C                   Parm      *Blanks       P@Vl08          200
     C                   Parm      *Blanks       P@Op09           20
     C                   Parm      *Blanks       P@Vl09          200
     C                   Parm      *Blanks       P@Op10           20
     C                   Parm      *Blanks       P@Vl10          200
 
      **  If the Return Code is blank, set Default Priorities
     C                   If        P@Rtcd = *Blanks
     C                   Eval      DfltPr = P@Vl01
      * PAR = DB1 By name
     C                   Z-ADD     DMBR          WUWMBH                         WH Tax Rate Def Matr
     C                   Z-ADD     DMBO          WUWMBK                         WH Tax Rate Def Matr
     C                   Z-ADD     DMCU          WUWMCY                         WH Tax Rate Def Matr
     C                   Z-ADD     DMCD          WUWMCR                         WH Tax Rate Def Matr
     C                   Z-ADD     DMCT          WUWMCT                         WH Tax Rate Def Matr
     C                   Z-ADD     DMIN          WUWMIS                         WH Tax Rate Def Matr
     C                   Z-ADD     DMMO          WUWMMO                         WH Tax Rate Def Matr
     C                   Z-ADD     DMTY          WUWMTT                         WH Tax Rate Def Matr
     C                   Z-ADD     DMTS          WUWMTS                         WH Tax Rate Def Matr
      *
     C                   Else
      * DBF Record not found.
     C                   MOVEL     'USR0199'     W0RTN             7
      * USER: Processing if DBF record not found
     C                   MOVEL     @CN(14)       W0RTN                          *Return code
     C                   GOTO      SDEXIT
     C                   EndIf
      *
      *================================================================
     CSR   SDEXIT        ENDSR
      /EJECT
     CSR   ZASNMS        BEGSR
      *================================================================
      * Send message to program's message queue.
      *================================================================
     C     ZAPGM         IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGM
     C                   END
      * If no message file specified use default.
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   END
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM            10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message Id.
     C                   PARM                    ZAMSGF           10            Message file.
     C                   PARM                    ZAMSDA          132            Message data.
     C                   PARM                    ZAMSTP            7            Message type.
      * Clear all fields for default mechanism next time.
     C                   MOVEL     *BLANK        ZAPGM                          Program queue
     C                   MOVEL     *BLANK        ZAPGRL                         Rel queue
     C                   MOVEL     *BLANK        ZAMSID                         Message Id.
     C                   MOVEL     *BLANK        ZAMSGF                         Message file.
     C                   MOVEL     *BLANK        ZAMSDA                         Message data.
     C                   MOVEL     *BLANK        ZAMSTP                         Message type.
      *================================================================
     CSR   ZAEXIT        ENDSR
      /EJECT
     CSR   ZXEXPG        BEGSR
      *================================================================
      * Exit program
      *================================================================
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct.
      *================================================================
      * Terminate program.
     C                   SETON                                        LR
      *
      * Exit program.
     C                   RETURN
      *
      *================================================================
     CSR   ZYEXIT        ENDSR
      /EJECT
     CSR   ZZINIT        BEGSR
      *================================================================
      * Initialisation.
      *================================================================
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
      * Setup job date/time.
     C                   Z-ADD     UDATE         ##JDT                          Job date.
     C                   TIME                    ##JTM                          Job time.
     C                   TIME                    ##TME             6 0          Screen time.
      * Define work field S01212
     C                   MOVEL     *BLANK        WUMFTS            1
      * Define work field WH Tax Rate Def Matrix-Branch
     C                   Z-ADD     *ZERO         WUWMBH            2 0
      * Define work field WH Tax Rate Def Matrix-Book
     C                   Z-ADD     *ZERO         WUWMBK            2 0
      * Define work field WH Tax Rate Def Matrix-Currency
     C                   Z-ADD     *ZERO         WUWMCY            2 0
      * Define work field WH Tax Rate Def Matrix-Country of Domicile
     C                   Z-ADD     *ZERO         WUWMCR            2 0
      * Define work field WH Tax Rate Def Matrix-Customer Type
     C                   Z-ADD     *ZERO         WUWMCT            2 0
      * Define work field WH Tax Rate Def Matrix-Institution Code
     C                   Z-ADD     *ZERO         WUWMIS            2 0
      * Define work field WH Tax Rate Def Matrix-Module
     C                   Z-ADD     *ZERO         WUWMMO            2 0
      * Define work field WH Tax Rate Def Matrix-Transaction Type
     C                   Z-ADD     *ZERO         WUWMTT            2 0
      * Define work field WH Tax Rate Def Matrix-Transaction Subtype
     C                   Z-ADD     *ZERO         WUWMTS            2 0
      * Define work field WH Tax Rate Def Matrix-Country of Risk                              AUA012
     C                   Z-ADD     *ZERO         WUWMCK            2 0
      * Define work field Audit/Request Status Ind
     C                   MOVEL     *BLANK        WUARSI            1
      * Define work field work number
     C                   Z-ADD     *ZERO         WUWKNB            5 0
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
      * Define work field Date format flag
     C                   MOVEL     *BLANK        WUDFF             1
      * Define work field Work Converted Date
     C                   Z-ADD     *ZERO         WUWCDT            6 0
      * Define work field Alpha Zero
     C                   MOVEL     *BLANK        WUALZR            1
      * Define work field No of Records on file
     C                   Z-ADD     *ZERO         WUNORF            5 0
      * Define work field No of Records Inserted
     C                   Z-ADD     *ZERO         WUNORI            5 0
      * Define work field No of Records Amended
     C                   Z-ADD     *ZERO         WUNORA            5 0
      * Define work field No of records Deleted
     C                   Z-ADD     *ZERO         WUNORD            5 0
      * Define work field work flag
     C                   MOVEL     *BLANK        WUWFLG            1
      * Define work field Audit/Request Title
     C                   MOVEL     *BLANK        WUAURT           53
      * Define work field Underline
     C                   MOVEL     *BLANK        WUBJNA           53
      * Define work field No. of Records
     C                   Z-ADD     *ZERO         WUNORC            5 0
      * Define work field No. of Inserts
     C                   Z-ADD     *ZERO         WUNOIN            5 0
      * Define work field No. of Amends
     C                   Z-ADD     *ZERO         WUNOAM            5 0
      * Define work field No. of Deletes
     C                   Z-ADD     *ZERO         WUNODL            5 0
      * Define work field Midas Run Date
     C                   MOVEL     *BLANK        WUMRDT            7
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUSUC             1
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUMBIN            1
      * Define work field User Report Title
     C                   MOVEL     *BLANK        WUURPT           53
      * Obtain default message file.
     C     *DTAARA       DEFINE    Y2MGFLA       ZADFMF           10
     C                   IN        ZADFMF
      * Define work field Spool file name
     C                   MOVEL     *BLANK        WUSFNM           10
      * Define work field Spool file number
     C                   Z-ADD     *ZERO         WUSFNB            6 0
      * Define work field ZSFILE error
     C                   MOVEL     *BLANK        WUZSER            1
     C                   MOVEL     *BLANK        W0PFM             1
     C                   Z-ADD     *ZERO         @#WRK             4 0
     C                   Z-ADD     *ZERO         @#HDL             4 0
      * Adjust page length and overflow as necessary.
     C     @$PGL         SUB       2             W0PGL             4 0
     C     @$OFL         IFGE      W0PGL
     C     W0PGL         SUB       2             W0OFL             4 0
     C                   ELSE
     C                   Z-ADD     @$OFL         W0OFL
     C                   END
      * USER: Initialise program
      * Standard RPG Creation PAR - Standard Functions  *
      * Copyright Statement - Standard Functions  *
      * Last Amend Box SD0490P - Profit Centre Dft Matrix  *
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT                         RUN DATE
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB                         RUNDAY NO.
     C                   MOVE      SUC           WUSUC                          SET UP COMPLT
     C                   MOVE      DFF           WUDFF                          DTE FMT FLAG
     C                   MOVE      MBIN          WUMBIN                         MULTI BR. IND
      * Get Title
      * Get Bank Title - Bank Details  *
     C                   EXSR      SCRVGN
      * Move title to header - *Standard header/footer  *
     C* 7.10.89 Missing Source - Inserted During Incorporation
     C* Move User Report Title into Header Field in DDS for PRTF
     C*
     C                   MOVE      WUURPT        ##URPT
      * Get Narrative Title - Narrative Codes  *
     C     *IN99         IFEQ      '1'
     C                   MOVE      1             UIND              1 0
     C                   SETOFF                                           99
     C                   ELSE
     C                   MOVE      0             UIND
     C                   END
      *
      ** CALCULATE END OF TEXT POINT
     C                   Z-ADD     1             UA                2 0
     C                   MOVEA     @CN(11)       UAR(UA)
     C*
     C     *IN99         DOWEQ     '0'
     C     ' '           LOOKUP    UAR(UA)                                99
     C                   ADD       1             UA
     C     UAR(UA)       COMP      ' '                                    99
     C                   END
      *
     C*
     C     P1ARSI        IFEQ      'A'
     C                   MOVEL     UARRAY(1)     UTEMP            53
     C                   MOVEA     UTEMP         UAR(UA)
     C                   ADD       21            UA
     C                   ELSE
      *
     C                   MOVEL     UARRAY(2)     UTEMP
     C                   MOVEA     UTEMP         UAR(UA)                        * IF A THIRD
     C                   ADD       7             UA                             OPTION TO ARRAY
     C                   END                                                    IS ADDED A
      *                                                    TEMP STORAGE
      *                                                    * IS REQUIRED.
      **  STORE  TEXT IN USTORE FIELD
      *
     C                   MOVEA     UAR           USTORE           53
     C                   MOVE      *BLANKS       UAR
      *
     C     53            SUB       UA            UB                2 0
     C     UB            DIV       2             UB
     C                   MVR                     UR                1 0
     C     UB            ADD       UA            UA
     C     UA            SUB       1             UA
      *
      *
      **  INSERT UNDERLINE TO ARRAY
      **
     C                   MOVEA     *ALL'-'       ULN(UB)
     C                   MOVEA     *BLANKS       ULN(UA)
      *
      *
     C     UB            IFGT      0
     C                   MOVEA     USTORE        UAR(UB)
     C                   ELSE
     C                   MOVEA     USTORE        UAR
     C                   END
      *
      **  MOVE ARRAY VALUE  TO SCREEN TEXT FIELD
      *
     C                   MOVEA     UAR           ##AURT           53
     C                   MOVEA     UAR           WUAURT
     C                   MOVEA     ULN           ##BJNA           53
     C                   MOVEA     ULN           WUBJNA
      *
      *
      ** RESET INDICATOR *IN 99
      *
     C     UIND          IFEQ      1
     C                   SETON                                            99
     C                   ELSE
     C                   SETOFF                                           99
     C                   END
      *
      * Set up Spool File Number and call ZSFILE.
      * ZSFILE - log spool file - Standard Functions  *
     C*
     C* Set up spool file number - Standard Functions  *
     C                   Z-ADD     @$FNB         WUSFNB
     C*
     C* ZSFILE - write report rqs - Standard Functions  *
     C                   CALL      'ZSFILE'                             90      ZSFILE - write
     C                   PARM      P2RSQN        UURSQN            5            RCF sequence nu
     C                   PARM      P4ENTY        UUENTY            3            Entity
     C                   PARM      @$FVN         UUSFNM           10            Spool file name
     C                   PARM      WUSFNB        UUSFNB            6 0          Spool file numb
     C     WUZSER        PARM      *BLANK        UUZSER            1            ZSFILE error
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
     C*
     C* CASE: WRK.ZSFILE is error occurred
     C*
     C*          #OZSER    IFEQ 'Y'
     C*                    MOVEL'Y2U0004' P0RTN
     C*                    EXSR ZYEXPG
     C*                    END
      *CASE:     WRK.ZSFILE error is Error Occured
     C     WUZSER        IFEQ      @CN(01)                                      *IF
     C                   MOVEL     @CN(12)       P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
      * Get Profit Centre Default Priorities from General Ledger.
      * Obtain Prof Cent Def Pty - General Ledger Details  *
     C                   EXSR      SDRVGN
     C                   MOVEL     @CN(01)       WUMFTS
      *================================================================
     CSR   ZZEXIT        ENDSR
     O/COPY WNCPYSRC,SD0490POPG
      *
      * Added 'Ctry of' in HDR1 array
      * Added 'Risk' in HDR2 array
**CTDATA HDR3
 Brch
 Book
 
 Ctry of
 Cust
 Inst
 
 Prod.
 Prod.
**CTDATA HDR4
 Code
 Code
  Ccy
 Domic
 Type
 Code
 Mod
 Type
 S.Type
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2007
**CTDATA UARRAY
MAINT. - AUDIT RPT
LISTING
**CTDATA @CN
Y
A
N
0
SDWTDMPD
Y2U0005
SDH022AU
Y2U0021
BANK
SDBANKPD
WITHHOLDING TAX RATE DFT MTX
Y2U0004
GELR
Y2U0003
