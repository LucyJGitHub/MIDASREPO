     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Display Withholding Tax Rate Matrix')         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  sd000207 - Display Withholding Tax Rate Matrix               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2015            *
      *                                                               *
      *  Last Amend No. CGL165  *CREATE    Date 23Feb15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax                                *
      *                                                               *
      *****************************************************************
     FSD000207DFCF   E             WORKSTN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
      * DSP: Midas SD Display Withholding Tax Rate Default Matrix
      *
     FSDWTDML1  IF   E           K DISK
     F                                     INFDS(INFDS1)
      * RTV: Withholding Tax Rate Default Matrix Retrieval index
      *
     D HDR1            S             14    DIM(9)
     D HDR2            S             14    DIM(9)
     D** Withholding Tax Rate Default Matrix Arrays to hold ordered Base Field
     D** headings according to their associated field priorities.
     D**
     D HDR3            S             14    DIM(9) CTDATA PERRCD(1)
     D HDR4            S             14    DIM(9) CTDATA PERRCD(1)
     D** Withholding Tax Rate Default Matrix Arrays to hold Heading Text for all
     D** base fields.
     D**
     D HD1             S              1    DIM(62)
     D HD2             S              1    DIM(62)
     D** Withholding Tax Rate Default Matrix Output Array
     D**
     D/EJECT
     D**
     D PARR            S             14    DIM(9)
     D** Withholding Tax Rate Default Matrix Array to hold ordered Base Fields
     D** according to their priorities.
     D**
     D AR1             S              1    DIM(63)
     D** Withholding Tax Rate Default Matrix Output Array
     D**
     D/EJECT
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
     D SCHD            S             78    DIM(2) CTDATA PERRCD(1)
     D* MOVE THE CORRECT TEXT INTO THE DISPLAY FILE'S FOOTER DEPENDING ON THE
     D* MODE
     D AENA            S             78    DIM(2) CTDATA PERRCD(1)
      *
     D @CN             S             25    DIM(13) CTDATA PERRCD(1)             Long constants.
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
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
      *
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
 
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file information data structure.
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure.
      *
      * Outward parameters.
     D PARC            DS            35
      * RCD: Withholding Tax Rate Default Matrix Retrieval index
      * I:MAP Branch code
     D  PABRCH                 1      3
      * I:MAP Book Code
     D  PABOOK                 4      5
      * I:MAP Currency
     D  PACURY                 6      8
      * I:MAP Country of Domicile
     D  PACTRY                 9     10
      * I:MAP Customer Type
     D  PACUTY                11     11
      * I:MAP Institution Code
     D  PAINST                12     13
      * I:MAP Module
     D  PAMODU                14     15
      * I:MAP Transaction Type
     D  PATRTY                16     25
      * I:MAP Transaction Subtype
     D  PATRST                26     27
      * I:MAP Default Main Tax Rate Code
     D  PATXR1                28     29
      * I:MAP Default Secondary Tax Rate Code
     D  PATXR2                30     31
      * I:MAP Last Change Date
     D  PALCD                 32     34P 0
      * I:MAP Type of Last Change
     D  PATYPC                35     35
      *
      * Outward parameters.
     D PBRC            DS            33
      * RCD: Withholding Tax Rate Default Matrix  Retrieval index
      * I:MAP Branch code
     D  PBBRCH                 1      3
      * I:MAP Book Code
     D  PBBOOK                 4      5
      * I:MAP Currency
     D  PBCURY                 6      8
      * I:MAP Country of Domicile
     D  PBCTRY                 9     10
      * I:MAP Customer Type
     D  PBCUTY                11     11
      * I:MAP Institution Code
     D  PBINST                12     13
      * I:MAP Module
     D  PBMODU                14     15
      * I:MAP Transaction Type
     D  PBTRTY                16     25
      * I:MAP Transaction Subtype
     D  PBTRST                26     27
      * I:MAP Default Main Tax Rate Code
     D  PBTXR1                28     29
      * I:MAP Default Secondary Tax Rate Code
     D  PBTXR2                30     31
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
      * I:    Display file mode
     D  P1DFMD                 1      1
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'value for field not valid'
      * *SFLSEL
     D  ZA0001                 1      1
      * Message data for 'value for field not valid'
      * *SFLSEL
     D  ZA0002                 1      1
      /EJECT
      *****************************************************************
     C     *ENTRY        PLIST                                                  Entry parameter
     C                   PARM                    P0RTN             7            Return code
     C     P1DFMD        PARM                    WP0001            1            Display file mo
      *****************************************************************
      * Initialise
     C                   EXSR      ZZINIT
      *
     C                   DO        *HIVAL
      * Initialise & load subfile page.
     C                   EXSR      BAIZSF
     C                   MOVEL     'N'           W0RSF             1
      * Display screen until reload requested:
     C     W0RSF         DOWEQ     'N'
      * Display screen.
     C                   EXSR      CAEXFM
      *   Process response:
      * Cancel & exit program.
     C   03              CAS                     ZXEXPG
      * HOME: Request subfile reload.
     C   05              CAS                     FBRQRL
      *   Display next SFL page.
     C   27              CAS                     BBLDSF
      *   Process screen input.
     C                   CAS                     DAPR##
     C                   END
      *
     C                   END                                                    OD W0RSF
     C                   END                                                    OD *HIVAL
      *****************************************************************
      /EJECT
     CSR   BAIZSF        BEGSR
      *================================================================
      * Initialise & Load subfile page.
      *================================================================
      * Clear subfile.
     C                   SETON                                        80
     C                   WRITE     #SFLCTL
     C                   SETOFF                                       80
      * Reset no of records in subfile.
     C                   Z-ADD     *ZERO         ##RRMX            5 081         SETOF 81
      * USER: Initialise subfile control
      * Setup the Subfile Record Header Field Text
      * Base Field Set-up Hdr - Withholding Tax Rate Dft Matrix  *
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
     C** UUHHD1- Move ' Brch      06' into Line 1
     C** UUHHD2- Move ' Code      06' into Line 2
     C**                   ¦
     C                   MOVE      '06'          UUHHD1
     C                   MOVE      '06'          UUHHD2
     C** Move Headings 1 & 2 into array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEL     UUHHD1        HDR1(H)
     C                   MOVEL     UUHHD2        HDR2(H)
     C                   END                                                      IF 1
     C**                                                                  LN0592
     C                   END                                                                   LN059
     C/EJECT
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
     C** UUBHD1- Move ' Book       06' into Line 1
     C** UUBHD2- Move ' Code       06' into Line 2
     C**                   ¦
     C                   MOVE      '06'          UUBHD1
     C                   MOVE      '06'          UUBHD2
     C** Move Headings 1 & 2 into array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEL     UUBHD1        HDR1(B)
     C                   MOVEL     UUBHD2        HDR2(B)
     C                   END                                                      IF 1
     C/EJECT
     C** Set-up Currency Heading
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
     C** UUBHD1- Move ' Ccy        05' into Line 1
     C** UUBHD2- Move ' Code       05' into Line 2
     C**                   ¦
     C                   MOVE      '05'          UUCHD1
     C                   MOVE      '05'          UUCHD2
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
     C** UUAHD1- Move ' Ctry of    09' into Line 1
     C** UUAHD2- Move ' Domic      09' into Line 2
     C**                   ¦
     C                   MOVE      '09'          UUDHD1
     C                   MOVE      '09'          UUDHD2
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
     C** UUBHD1- Move '  Cust      06' into Line 1
     C** UUBHD2- Move '  Type      06' into Line 2
     C**                   ¦
     C                   MOVE      '06'          UUUHD1
     C                   MOVE      '06'          UUUHD2
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
     C** UUDHD1- Move ' Inst       06' into Line 1
     C** UUDHD2- Move ' Code       06' into Line 2
     C**                   ¦
     C                   MOVE      '06'          UUIHD1
     C                   MOVE      '06'          UUIHD2
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
     C** UUAHD1- Move ' Mod        05' into Line 1
     C** UUAHD2- Move '            05' into Line 2
     C**                   ¦
     C                   MOVE      '05'          UUMHD1
     C                   MOVE      '05'          UUMHD2
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
     C** UUTHD1- Move ' Trans      07' into Line 1
     C** UUTHD2- Move ' Type       07' into Line 2
     C**                   ¦
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
     C** UUSHD1- Move ' Trans      07' into Line 1
     C** UUSHD2- Move ' Subtype    07' into Line 2
     C**                   ¦
     C                   MOVE      '07'          UUSHD1
     C                   MOVE      '06'          UUSHD2
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
      *
      ** Move blanks to the end of the header                                                 AUA012
     C     Z             IFLT      63
     C                   MOVEA     *BLANKS       HD1(Z)
     C                   MOVEA     *BLANKS       HD2(Z)
     C                   ENDIF
     C**
     C**
     C** Move Final Array Contents to Output Screen Field
     C**
     C                   MOVEA     HD1           #CWMH1
     C                   MOVEA     HD2           #CWMH2
     C**
      * Position DBF file:
     C     KPOS          KLIST
     C                   KFLD                    BRCH                           Branch Code
     C                   KFLD                    BOOK                           Book Code
     C                   KFLD                    CURY                           Currency
     C                   KFLD                    CTRY                           Country of Domicile
     C                   KFLD                    CUTY                           Customer Type
     C                   KFLD                    INST                           Institution Code
     C                   KFLD                    MODU                           Module
     C                   KFLD                    TRTY                           Transaction Type
     C                   KFLD                    TRST                           Transaction Subtype
      *
      * Setup key.
     C                   MOVEL     #2BRCH        BRCH                           Branch Code
     C                   MOVEL     #2BOOK        BOOK                           Book Code
     C                   MOVEL     #2CURY        CURY                           Currency
     C                   MOVEL     #2CTRY        CTRY                           Country of Domicile
     C                   MOVEL     #2CUTY        CUTY                           Customer Type
     C                   MOVEL     #2INST        INST                           Institution Code
     C                   MOVEL     #2MODU        MODU                           Module
     C                   MOVEL     #2TRTY        TRTY                           Transaction Type
     C                   MOVEL     #2TRST        TRST                           Transaction Subtype
     C                   MOVEL     #2TXR1        TXR1                           Default Tax Rate Cod
      *
     C     KPOS          SETLL     SDWTDMD0
     C                   READ      SDWTDMD0                             8782    *82=EOF
      *
      * Save previous selector values.
     C     *LIKE         DEFINE    #2BRCH        WZBRCH
     C                   MOVEL     #2BRCH        WZBRCH                         Branch Code
     C     *LIKE         DEFINE    #2BOOK        WZBOOK
     C                   MOVEL     #2BOOK        WZBOOK                         Book Code
     C     *LIKE         DEFINE    #2CURY        WZCURY
     C                   MOVEL     #2CURY        WZCURY                         Currency
     C     *LIKE         DEFINE    #2CTRY        WZCTRY
     C                   MOVEL     #2CTRY        WZCTRY                         Country of Domicile
     C     *LIKE         DEFINE    #2CUTY        WZCUTY
     C                   MOVEL     #2CUTY        WZCUTY                         Customer Type
     C     *LIKE         DEFINE    #2INST        WZINST
     C                   MOVEL     #2INST        WZINST                         Institution Code
     C     *LIKE         DEFINE    #2MODU        WZMODU
     C                   MOVEL     #2MODU        WZMODU                         Module
     C     *LIKE         DEFINE    #2TRTY        WZTRTY
     C                   MOVEL     #2TRTY        WZTRTY                         Transaction Type
     C     *LIKE         DEFINE    #2TRST        WZTRST
     C                   MOVEL     #2TRST        WZTRST                         Transaction Subtype
     C     *LIKE         DEFINE    #2TXR1        WZTXR1
     C                   MOVEL     #2TXR1        WZTXR1                         Default Tax Rate Cod
     C     *LIKE         DEFINE    #2LCD         WZLCD
     C                   MOVEL     #2LCD         WZLCD                          Last Change Dat
     C     *LIKE         DEFINE    #2TYPC        WZTYPC
     C                   MOVEL     #2TYPC        WZTYPC                         Type of Last Ch
      *
      * Load subfile page.
     C                   Z-ADD     0             ##RROK            5 0
     C                   EXSR      BBLDSF
      *================================================================
     CSR   BAEXIT        ENDSR
      /EJECT
     CSR   BBLDSF        BEGSR
      *================================================================
      * Load subfile page.
      *================================================================
      * Re-establish fields in read-ahead record.
     C   27              DO
      *
     C  N82              READP     SDWTDMD0                               90    *
     C  N82              READ      SDWTDMD0                               90    *
      *
     C                   END
      *
      * Setof record error indicators.
     C                   MOVEL     *ALL'0'       WKIND0            1
     C                   MOVEA     WKIND0        *IN(33)
      * Start at previous highest record in SFL.
     C                   Z-ADD     ##RRMX        ##RR              5 0
      * Reset count of DBF records read.
     C                   Z-ADD     0             ##RRRD            5 0
      *................................................................
      * Load next SFL page until SFL page full, or :
      * scan limit reached.
     C     *IN82         DOWEQ     '0'                                          DO
     C     ##RROK        ANDLT     ##SFPG
     C     ##RRRD        ANDLT     W0SLM
      * Check selection fields - if fail, read next record.
     C     #2BRCH        IFEQ      *BLANK                                       Branch Code
     C     #2BOOK        IFNE      *BLANK                                       Book Code
     C     BOOK          CABLT     #2BOOK        BB020                          Book Code
     C                   END
     C                   END
     C     #2BRCH        IFEQ      *BLANK                                       Branch Code
     C     #2BOOK        OREQ      *BLANK                                       Book Code
     C     #2CURY        IFNE      *BLANK                                       Currency
     C     CURY          CABLT     #2CURY        BB020                          Currency
     C                   END
     C                   END
     C     #2BRCH        IFEQ      *BLANK                                       Branch Code
     C     #2BOOK        OREQ      *BLANK                                       Book Code
     C     #2CURY        OREQ      *BLANK                                       Currency
     C     #2CTRY        IFNE      *BLANK                                       Country of Domicile
     C     CTRY          CABLT     #2CTRY        BB020                          Country of Domicile
     C                   END
     C                   END
     C     #2BRCH        IFEQ      *BLANK                                       Branch Code
     C     #2BOOK        OREQ      *BLANK                                       Book Code
     C     #2CURY        OREQ      *BLANK                                       Currency
     C     #2CTRY        OREQ      *BLANK                                       Country of Domicile
     C     #2CUTY        IFNE      *BLANK                                       Customer Type
     C     CUTY          CABLT     #2CUTY        BB020                          Customer Type
     C                   END
     C                   END
     C     #2BRCH        IFEQ      *BLANK                                       Branch Code
     C     #2BOOK        OREQ      *BLANK                                       Book Code
     C     #2CURY        OREQ      *BLANK                                       Currency
     C     #2CTRY        OREQ      *BLANK                                       Country of Domicile
     C     #2CUTY        OREQ      *BLANK                                       Customer Type
     C     #2INST        IFNE      *BLANK                                       Institution Code
     C     INST          CABLT     #2INST        BB020                          Institution Code
     C                   END
     C                   END
     C     #2BRCH        IFEQ      *BLANK                                       Branch Code
     C     #2BOOK        OREQ      *BLANK                                       Book Code
     C     #2CURY        OREQ      *BLANK                                       Currency
     C     #2CTRY        OREQ      *BLANK                                       Country of Domicile
     C     #2CUTY        OREQ      *BLANK                                       Customer Type
     C     #2INST        OREQ      *BLANK                                       Institution Code
     C     #2MODU        IFNE      *BLANK                                       Module
     C     MODU          CABLT     #2MODU        BB020                          Module
     C                   END
     C                   END
     C     #2BRCH        IFEQ      *BLANK                                       Branch Code
     C     #2BOOK        OREQ      *BLANK                                       Book Code
     C     #2CURY        OREQ      *BLANK                                       Currency
     C     #2CTRY        OREQ      *BLANK                                       Country of Domicile
     C     #2CUTY        OREQ      *BLANK                                       Customer Type
     C     #2INST        OREQ      *BLANK                                       Institution Code
     C     #2MODU        OREQ      *BLANK                                       Module
     C     #2TRTY        IFNE      *BLANK                                       Transaction Type
     C     TRTY          CABLT     #2TRTY        BB020                          Transaction Type
     C                   END
     C                   END
     C     #2BRCH        IFEQ      *BLANK                                       Branch Code
     C     #2BOOK        OREQ      *BLANK                                       Book Code
     C     #2CURY        OREQ      *BLANK                                       Currency
     C     #2CTRY        OREQ      *BLANK                                       Country of Domicile
     C     #2CUTY        OREQ      *BLANK                                       Customer Type
     C     #2INST        OREQ      *BLANK                                       Institution Code
     C     #2MODU        OREQ      *BLANK                                       Module
     C     #2TRTY        OREQ      *BLANK                                       Transaction Type
     C     #2TRST        IFNE      *BLANK                                       Transaction Subtype
     C     TRST          CABLT     #2TRST        BB020                          Transaction Subtype
     C                   END
     C                   END
     C     #2LCD         IFNE      *ZERO                                        Last Change Dat
     C     LCD           CABNE     #2LCD         BB020                          Last Change Dat
     C                   END
     C     #2TYPC        IFNE      *BLANK                                       Type of Last Ch
     C     TYPC          CABNE     #2TYPC        BB020                          Type of Last Ch
     C                   END
     C     #2TXR1        IFNE      *BLANK                                       Default Tax Rate Cod
      * Scan for search string.
     C                   CALL      'QCLSCAN'
     C                   PARM                    TXR1                           Default Tax Rate Cod
     C                   PARM      2             WQA3N             3 0          Length
     C                   PARM      1             WQB3N             3 0          Start
     C                   PARM                    #2TXR1                         Mask
     C                   PARM      2             WQC3N             3 0          Length
     C                   PARM      '1'           WQD1              1            Translate
     C                   PARM      '1'           WQE1              1            Trim
     C                   PARM      '?'           WQF1              1            Wild
     C                   PARM                    WQG3N             3 0          Result
     C     WQG3N         CABLT     1             BB020
     C                   END
      * Load SFL fields.
     C                   EXSR      MBFL#1
     C                   MOVEL     'Y'           W0RSL             1
      * USER: Initialise subfile record from DBF record
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
     C     #1BRCH        IFNE      '***'
     C                   MOVE      #1BRCH        UUBCH
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
     C                   MOVE      '06'          UUBCH2
     C** Move Long Store Bch Code  to array element according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEA     UUBCH2        PARR(H)
     C                   END                                                      IF 1
     C**                                                                  LN0592
     C                   END                                                                   LN059
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
     C     #1BOOK        IFNE      '**'
     C                   MOVE      #1BOOK        UUBOK
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
     C                   MOVE      '06'          UUBOK2
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
     C                   MOVE      *BLANKS       UUCCY             4
     C                   MOVE      *BLANKS       UUCCY2           14
     C** UUCCY - Move Currency to Store Currency 5 Long to hold
     C**         bbXXX where bb are blanks and XX is the Currency
     C**                   ¦
     C     #1CURY        IFNE      '***'
     C                   MOVE      #1CURY        UUCCY
     C                   END
     C** UUCCY2 - Move Store Currency to Store Currency Code 14 Long
     C** bXXXbbbbbbbbbb where b's are blanks and XXX is the Currency.
     C**                   ¦
     C                   MOVEL     UUCCY         UUCCY2
     C** Find Length if Field Required To be Displayed from Compile
     C** time array data - Currency element is 3
     C**                   ¦
     C** Move length of field required to be printed into last 2 Chars
     C** of Long Store Currency giving - bXXXbbbbbbbb05 in the field.
     C** where b's are blanks and XX is the Currency, 05 Len of Fld.
     C**                   ¦
     C                   MOVE      '05'          UUCCY2
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
     C                   MOVE      *BLANKS       UUCTR             5
     C                   MOVE      *BLANKS       UUCTR2           14
     C** UUCTR - Move Country of Domicile to Store Country of Domicile
     C** 4 Long to hold bbXX where b is blank and X's is the Country of Domicile .
     C**                   ¦
     C     #1CTRY        IFNE      '**'
     C                   MOVE      #1CTRY        UUCTR
     C                   END
     C** UUCTR2- Move Store Country of Domicile to Store Country of Domicile
     C** Code 14 Long bbbXXbbbbbbbbb where b's are blanks and X's is the
     C** Country of Domicile.
     C**
     C                   MOVEL     UUCTR         UUCTR2
     C** Find Length if Field Required To be Displayed from Compile
     C** time array data - Country of Domicile is 4
     C**                   ¦
     C** Move length of field required to be printed into last 2 Chars
     C** of Long Store Country of Domicile giving - bbXXbbbbbbbb09 in the field.
     C** where b's are blanks and XX is the Country of Domicile 09 Len of Fld.
     C**                   ¦
     C                   MOVE      '09'          UUCTR2
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
     C     #1CUTY        IFNE      '*'
     C                   MOVE      #1CUTY        UUCUS
     C                   END
     C** UUCUS2- Move Store Customer Type to Store Customer Type 14 Long
     C** bbXbbbbbbbbbbb where b's are blanks and X's is the Customer Type
     C**                   ¦
     C                   MOVEL     UUCUS         UUCUS2
     C** Find Length if Field Required To be Displayed from Compile
     C** time array data - Customer Type element is 5
     C**                   ¦
     C** Move length of field required to be printed into last 2 Chars
     C** of Long Store Customer Type giving - bbXbbbbbbbbb06 in the field.
     C** where b's are blanks and XX is the Customer Type, 06 Len of Fld.
     C**                   ¦
     C                   MOVE      '06'          UUCUS2
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
     C     #1INST        IFNE      '**'
     C                   MOVE      #1INST        UUINS
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
     C                   MOVE      '06'          UUINS2
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
     C     #1MODU        IFNE      '**'
     C                   MOVE      #1MODU        UUMOD
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
     C                   MOVE      '05'          UUMOD2
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
     C                   MOVE      *BLANKS       UUTTY            12
     C                   MOVE      *BLANKS       UUTTY2           14
     C** UUTTY-Move Transaction Type to Store Transaction Type to 06 Long to hold
     C** bbXXXX where b is blank and X's is the Transaction Type.
     C**                   ¦
     C     #1TRTY        IFNE      '****'
     C                   MOVE      #1TRTY        UUTTY
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
     C                   MOVE      *BLANKS       UUTST             5
     C                   MOVE      *BLANKS       UUTST2           14
     C** UUCUS-Move Transaction Subtype to Store Transaction Subtype 04 Long to hold
     C** bbbXX where b is blank and X's is the Transaction Subtype.
     C**                   ¦
     C     #1TRST        IFNE      '**'
     C                   MOVE      #1TRST        UUTST
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
     C                   MOVE      '06'          UUTST2
     C** Move Long Store Transaction Subtype to according to the
     C** fields priority on General Ledger Details.
     C**                   ¦
     C                   MOVEA     UUTST2        PARR(S)
     C                   END                                                      IF 1
      *
     C/EJECT
     C/EJECT
     C** Load 70 Character 1 Bit Array with all Field Values
     C**
     C                   Z-ADD     1             Y                 2 0
     C                   Z-ADD     1             Z                 2 0
     C** Load AR1 with all 9 Base Fields according to their priorities
     C** and there length.
     C**
     C     Y             DOWNE     10                                            DO
     C**                   ¦
     C     PARR(Y)       IFNE      *BLANK                                        IF 1
     C**                   ¦¦
     C                   MOVEA     PARR(Y)       AR1(Z)
     C                   MOVE      PARR(Y)       PTR               2 0
     C     Z             ADD       PTR           Z
     C**                   ¦¦
     C                   END                                                     FI 1
     C**                   ¦
     C                   ADD       1             Y
     C**                   ¦
     C                   END                                                     WOD
     C**
     C     Z             IFLT      63
     C                   MOVEA     *BLANKS       AR1(Z)
     C                   END
     C**
     C**
     C** Move Final Array Contents to Output Screen Field
     C**
     C                   MOVEA     AR1           #RWDMO
     C**
     C**
      * DBF Record not selected.
     C     W0RSL         CABNE     'Y'           BB020
      * Output to subfile.
     C                   ADD       1             ##RR                 81        *
     C                   ADD       1             ##RROK
     C                   WRITE     #SFLRCD
     C     BB020         TAG
      * Increment scan check count.
     C                   ADD       1             ##RRRD
      *
     C                   READ      SDWTDMD0                               82    *82=EOF
      *
     C                   END                                                    OD 1 - ##SFPG
      *................................................................
      * If no DBF records found, display error message.
     C     ##RR          IFEQ      *ZERO
     C     *IN82         ANDEQ     '1'
      * Send message '*No data to display'
     C                   MOVEL     'Y2U0008'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   END                                                    FI ##RR = *ZERO
      *
      *................................................................
      * Save highest SFL record load can continue at end point.
     C     ##RR          IFGT      ##RRMX
     C     ##RRMX        ADD       1             ##SFRC
     C                   Z-ADD     ##RR          ##RRMX
     C                   END
      * If scan limit reached, display error message.
     C     ##RRRD        IFGE      W0SLM
      * Send message '*Scan limit reached'
     C                   MOVEL     'Y2U0017'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE
     C                   Z-ADD     0             ##RROK
     C                   END
      *================================================================
     CSR   BBEXIT        ENDSR
      /EJECT
     CSR   CAEXFM        BEGSR
      *================================================================
      * Display screen.
      *================================================================
     C     W0HLP         DOUEQ     'N'
      * Update screen time.
     C                   TIME                    ##TME                          Screen time.
      * PUTOVR unless conditioned fields change.
     C                   SETON                                        86
     C     *IN81         IFNE      CAIN81
     C                   SETOFF                                       86
     C                   END
     C                   MOVE      *IN81         CAIN81            1
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #SFLCTL
     C                   MOVEL     'N'           W0HLP             1            Reset help requ
      * If help requested, display help text.
     C   25              EXSR      ZHHPKY                                       Display help te
     C                   END
      * Update job time.
     C                   TIME                    ##JTM                          Job time.
      * Clear messages from program message queue.
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag.
     C                   MOVEL     'Y'           ZAFSMS            1      99    *
     C                   SETOFF                                         8388    *
      *================================================================
     CSR   CAEXIT        ENDSR
      /EJECT
     CSR   DAPR##        BEGSR
      *================================================================
      * Process screen input.
      *================================================================
      * Maintain subfile position where possible.
     C     @#SFRC        IFGT      *ZERO
     C                   Z-ADD     @#SFRC        ##SFRC
     C                   END
      *
      * Confirm/update is not defered.
     C                   MOVEL     'N'           W0DCF             1
      * CALC: Subfile control function fields
      * .Check Each Field for Priority Of '1'
      * .and then position the subfile to the value entered in the
      * .screen positioner field.
      * Position to Branch Code
      *CASE:     WRK.Withhold Tax Rate Def Matrix-Branch is First
     C     WUWMBH        IFEQ      1                                            *IF
     C                   MOVEL     #CWDMP        #2BRCH                         Branch Code
      *CASE:     CTL.Branch Code NE WRK.Branch Code
     C     #2BRCH        IFNE      WUBRCH                                       *IF
     C                   MOVEL     @CN(02)       W0RSF                          *Reload subfile
     C                   MOVEL     #2BRCH        WUBRCH                         Branch Code
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Position to Book Code
      *CASE:     WRK.Withhold Tax Rate Def Matrix-Book is First
     C     WUBOOK        IFEQ      @CN(01)                                      *IF
     C                   MOVEL     #CWDMP        #2BOOK                         Book Code
      *CASE:     CTL.Book Code  NE WRK.Book Code
     C     #2BOOK        IFNE      WUBOOK                                       *IF
     C                   MOVEL     @CN(02)       W0RSF                          *Reload subfile
     C                   MOVEL     #2BOOK        WUBOOK                         Book Code
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Position to Currency
      *CASE:     WRK.Withhold Tax Rate Def Matrix-Currency is First
     C     WUCURY        IFEQ      @CN(01)                                      *IF
     C                   MOVEL     #CWDMP        #2CURY                         Currency
      *CASE:     CTL.Currency NE WRK.Currency
     C     #2CURY        IFNE      WUCURY                                       *IF
     C                   MOVEL     @CN(02)       W0RSF                          *Reload subfile
     C                   MOVEL     #2CURY        WUCURY                         Currency
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Position to Country of Domicile
      *CASE:     WRK.Wdithhold Tax Rate Def Matrix-Ctry of Domicile is First
     C     WUCTRY        IFEQ      @CN(01)                                      *IF
     C                   MOVEL     #CWDMP        #2CTRY                         Country of Domicile
      *CASE:     CTL.Country of Domicile NE WRK.Country of Domicile
     C     #2CTRY        IFNE      WUCTRY                                       *IF
     C                   MOVEL     @CN(02)       W0RSF                          *Reload subfile
     C                   MOVEL     #2CTRY        WUCTRY                         Country of Domicile
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Position to Customer Type
      *CASE:     WRK.Withhold Tax Rate Def Matrix-Customer Type is First
     C     WUCUTY        IFEQ      @CN(01)                                      *IF
     C                   MOVEL     #CWDMP        #2CUTY                         Customer Type
      *CASE:     CTL.Customer Type NE WRK.Customer Type
     C     #2CUTY        IFNE      WUCUTY                                       *IF
     C                   MOVEL     @CN(02)       W0RSF                          *Reload subfile
     C                   MOVEL     #2CUTY        WUCUTY                         Customer Type
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Position to Institution Code
      *CASE:     WRK.WH Tax Rate Matrix-User is First
     C     WUINST        IFEQ      @CN(01)                                      *IF
     C                   MOVEL     #CWDMP        #2INST                         Institution Code
      *CASE:     CTL.Institution Code NE WRK.Institution Code
     C     #2INST        IFNE      WUINST                                       *IF
     C                   MOVEL     @CN(02)       W0RSF                          *Reload subfile
     C                   MOVEL     #2INST        WUINST                         Institution Code
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Position to Module
      *CASE:     WRK.Withhold Tax Rate Def Matrix-Module is First
     C     WUMODU        IFEQ      @CN(01)                                      *IF
     C                   MOVEL     #CWDMP        #2MODU                         Module
      *CASE:     CTL.Module NE WRK.Module
     C     #2MODU        IFNE      WUMODU                                       *IF
     C                   MOVEL     @CN(02)       W0RSF                          *Reload subfile
     C                   MOVEL     #2MODU        WUMODU                         Module
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Position to Transaction Type
      *CASE:     WRK.Withhold Tax Rate Def Matrix-Transaction Type is First
     C     WUTRTY        IFEQ      @CN(01)                                      *IF
     C                   MOVEL     #CWDMP        #2TRTY                         Transaction Type
      *CASE:     CTL.Transaction Type NE WRK.Transaction Type
     C     #2TRTY        IFNE      WUTRTY                                       *IF
     C                   MOVEL     @CN(02)       W0RSF                          *Reload subfile
     C                   MOVEL     #2TRTY        WUTRTY                         Transaction Type
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Position to Transaction Subtype
      *CASE:     WRK.Withhold Tax Rate Def Matrix-Transaction Subtype is First
     C     WUTRST        IFEQ      @CN(01)                                      *IF
     C                   MOVEL     #CWDMP        #2TRST                         Transaction Subtype
      *CASE:     CTL.Transaction Subtype NE WRK.Transaction Subtype
     C     #2TRST        IFNE      WUTRST                                       *IF
     C                   MOVEL     @CN(02)       W0RSF                          *Reload subfile
     C                   MOVEL     #2TRST        WUTRST                         Transaction Subtype
     C                   END                                                    *FI
     C                   END                                                    *FI
      *
      * Change of position specified.
     C     WZTXR1        CASNE     #2TXR1        FBRQRL
     C                   END
      * Reload subfile requested:
     C     W0RSF         CABEQ     'Y'           DAEXIT
     C     *IN81         IFEQ      '1'
      * Process subfile records.
     C                   EXSR      DBPRSF
     C                   END
      * If error, Quit processing:
     C     *IN99         CABEQ     '1'           DAEXIT
      * Defer confirm/update requested:
     C     W0DCF         CABEQ     'Y'           DAEXIT
      * USER: Process command keys
      *CASE:     PAR.Display file mode is Maintenance mode
     C     P1DFMD        IFEQ      @CN(05)                                      *IF
      *CASE:     CTL.*CMD key is *Go to 'Add' mode
     C     *IN09         IFEQ      '1'                                          *IF
      * STRCMTCTL For PMTRCD - Withholding Tax Rate Default Matrix *
     C                   CALL      'Y2BGCMC'
     C                   PARM                    W0RTN             7
     C     W0RTN         IFNE      *BLANK
     C     W0RTN         ANDNE     'CPF8351'
     C                   EXSR      ZYEXPG
     C                   END
      *
      * Maintain Withholding Tax Rate Dft  - Withholding Tax Rate Default Matrix *
     C                   MOVEL     *BLANK        PARC
     C                   MOVEL     *BLANK        PABRCH                         Branch Code
     C                   MOVEL     *BLANK        PABOOK                         Book Code
     C                   MOVEL     *BLANK        PACURY                         Currency
     C                   MOVEL     *BLANK        PACTRY                         Country of Domicile
     C                   MOVEL     *BLANK        PACUTY                         Customer Type
     C                   MOVEL     *BLANK        PAINST                         Institution Code
     C                   MOVEL     *BLANK        PAMODU                         Module
     C                   MOVEL     *BLANK        PATRTY                         Transaction Type
     C                   MOVEL     *BLANK        PATRST                         Transaction Subtype
     C                   MOVEL     *BLANK        PATXR1                         Default Tax Rate Cod
     C                   MOVEL     *BLANK        PATXR2                         Default Tax Rate Cod
     C                   Z-ADD     WURDNB        PALCD                          Last Change Dat
     C                   MOVEL     @CN(06)       PATYPC                         Type of Last Ch
      *
     C                   CALL      'SD000208'                           90      Maintain WH Tax Rate
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM                    PARC                           RCD: Tax Rate Cd
     C                   PARM      @CN(06)       WQ0001            1            Action Code
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
      * Error detected ?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      * Exit Program Processing - Fast Exit
      *CASE:     PGM.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      @CN(07)                                      *IF
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
     C                   MOVEL     @CN(02)       W0RSF                          *Reload subfile
     C                   END                                                    *FI
     C                   ELSE
      *CASE:     *OTHERWISE
      *CASE:     CTL.*CMD key is *Go to 'Add' mode
     C     *IN09         IFEQ      '1'                                          *IF
      * Send message 'Function key not allowed'
     C                   MOVEL     'USR0533'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        99        *
      *
     C                   GOTO      DAEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
      *================================================================
     CSR   DAEXIT        ENDSR
      /EJECT
     CSR   DBPRSF        BEGSR
      *================================================================
      * Process modified subfile records.
      *================================================================
     C                   READC     #SFLRCD                                88    *
     C     *IN88         DOWEQ     '0'
      * Process SFL record.
     C                   EXSR      DCPRSR
     C                   UPDATE    #SFLRCD
     C                   READC     #SFLRCD                                88    *
     C                   END
      *================================================================
     CSR   DBEXIT        ENDSR
      /EJECT
     CSR   DCPRSR        BEGSR
      *================================================================
      * Process subfile record.
      *================================================================
      * Setof error indicators and SFLNXTCHG.
     C                   MOVEA     WKIND0        *IN(33)
     C                   SETOFF                                       98        *
      * USER: Process subfile record (Pre-confirm)
      * User Requests E - Enquire
      *CASE:     RCD.*SFLSEL is *Enquire
     C     #1SEL         IFEQ      @CN(08)                                      *IF
      * Display Withholding Tax Rate Dft - Withholding Tax Rate Dft Matrix  *
     C                   MOVEL     *BLANK        PBRC
     C                   MOVEL     #1BRCH        PBBRCH                         Branch Code
     C                   MOVEL     #1BOOK        PBBOOK                         Book Code
     C                   MOVEL     #1CURY        PBCURY                         Currency
     C                   MOVEL     #1CTRY        PBCTRY                         Country of Domicile
     C                   MOVEL     #1CUTY        PBCUTY                         Customer Type
     C                   MOVEL     #1INST        PBINST                         Institution Code
     C                   MOVEL     #1MODU        PBMODU                         Module
     C                   MOVEL     #1TRTY        PBTRTY                         Transaction Type
     C                   MOVEL     #1TRST        PBTRST                         Transaction Subtype
     C                   MOVEL     #1TXR1        PBTXR1                         Default Tax Rate Cod
     C                   MOVEL     #1TXR2        PBTXR2                         Default Tax Rate Cod
      *
     C                   CALL      'SD000209'                           90      Display WH Tax Rate
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM                    PBRC                           RCD: Tax Rate Code
     C                   PARM      @CN(08)       WQ0002            1            Action Code
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
      * Error detected ?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        98        *
     C                   END
     C                   MOVEL     @CN(02)       W0RSF                          *Reload subfile
     C                   END                                                    *FI
      * User Requests File Maintenance
      *CASE:     PAR.Display file mode is Maintenance mode
     C     P1DFMD        IFEQ      @CN(05)                                      *IF
      *CASE:     RCD.*SFLSEL is *Amend
     C     #1SEL         IFEQ      @CN(09)                                      *IF
      * STRCMTCTL For PMTRCD - Withholding Tax Rate Default Matrix *
     C                   CALL      'Y2BGCMC'
     C                   PARM                    W0RTN             7
     C     W0RTN         IFNE      *BLANK
     C     W0RTN         ANDNE     'CPF8351'
     C                   EXSR      ZYEXPG
     C                   END
      * Maintain WH Tax Rate Dft - Withholding Tax Rate Default Matrix *
     C                   MOVEL     *BLANK        PARC
     C                   MOVEL     #1BRCH        PABRCH                         Branch Code
     C                   MOVEL     #1BOOK        PABOOK                         Book Code
     C                   MOVEL     #1CURY        PACURY                         Currency
     C                   MOVEL     #1CTRY        PACTRY                         Country of Domicile
     C                   MOVEL     #1CUTY        PACUTY                         Customer Type
     C                   MOVEL     #1INST        PAINST                         Institution Code
     C                   MOVEL     #1MODU        PAMODU                         Module
     C                   MOVEL     #1TRTY        PATRTY                         Transaction Type
     C                   MOVEL     #1TRST        PATRST                         Transaction Subtype
     C                   MOVEL     #1TXR1        PATXR1                         Default Tax Rate Cod
     C                   MOVEL     #1TXR2        PATXR2                         Default Tax Rate Cod
     C                   Z-ADD     #1LCD         PALCD                          Last Change Dat
     C                   MOVEL     #1TYPC        PATYPC                         Type of Last Ch
      *
     C                   CALL      'SD000208'                           90      Maintain WH Tax Rate
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM                    PARC                           RCD: WH Tax Rate
     C                   PARM      @CN(09)       WQ0003            1            Action Code
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
      * Error detected ?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        98        *
     C                   END
     C                   MOVEL     @CN(02)       W0RSF                          *Reload subfile
     C                   END                                                    *FI
      *CASE:     RCD.*SFLSEL is *Delete
     C     #1SEL         IFEQ      @CN(10)                                      *IF
      * STRCMTCTL For PMTRCD - Withholding Tax Rate Default Matrix *
     C                   CALL      'Y2BGCMC'
     C                   PARM                    W0RTN             7
     C     W0RTN         IFNE      *BLANK
     C     W0RTN         ANDNE     'CPF8351'
     C                   EXSR      ZYEXPG
     C                   END
      * Maintain WH Tax Rate Dft - Withholding Tax Rate Default Matrix *
     C                   MOVEL     *BLANK        PARC
     C                   MOVEL     #1BRCH        PABRCH                         Branch Code
     C                   MOVEL     #1BOOK        PABOOK                         Book Code
     C                   MOVEL     #1CURY        PACURY                         Currency
     C                   MOVEL     #1CTRY        PACTRY                         Country of Domicile
     C                   MOVEL     #1CUTY        PACUTY                         Customer Type
     C                   MOVEL     #1INST        PAINST                         Institution Code
     C                   MOVEL     #1MODU        PAMODU                         Module
     C                   MOVEL     #1TRTY        PATRTY                         Transaction Type
     C                   MOVEL     #1TRST        PATRST                         Transaction Subtype
     C                   MOVEL     #1TXR1        PATXR1                         Default Tax Rate Cod
     C                   MOVEL     #1TXR2        PATXR2                         Default Tax Rate Cod
     C                   Z-ADD     #1LCD         PALCD                          Last Change Dat
     C                   MOVEL     #1TYPC        PATYPC                         Type of Last Ch
      *
     C                   CALL      'SD000208'                           90      Maintain WH Tax Rate
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM                    PARC                           RCD: Tax Rate Code
     C                   PARM      @CN(10)       WQ0004            1            Action Code
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
      * Error detected ?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        98        *
     C                   END
     C                   MOVEL     @CN(02)       W0RSF                          *Reload subfile
     C                   END                                                    *FI
     C                   ELSE
      *CASE:     *OTHERWISE
      *CASE:     RCD.*SFLSEL is *Amend
     C     #1SEL         IFEQ      @CN(09)                                      *IF
      * Setup message data for message.
     C                   MOVEL     #1SEL         ZA0001                         *SFLSEL
      * Send message 'value for field not valid'
     C                   MOVEL     'USR0553'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        9833      *
      *
     C                   GOTO      DCEXIT                                       *QUIT
     C                   ELSE
      *CASE:     RCD.*SFLSEL is *Delete
     C     #1SEL         IFEQ      @CN(10)                                      *IF
      * Setup message data for message.
     C                   MOVEL     #1SEL         ZA0002                         *SFLSEL
      * Send message 'value for field not valid'
     C                   MOVEL     'USR0553'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        9833      *
      *
     C                   GOTO      DCEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Exit Program Processing - Fast Exit
      *CASE:     PGM.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      @CN(07)                                      *IF
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
     C     *IN98         IFEQ      '1'
      * SFLRCD invalid.
     C  N99              Z-ADD     ##RR          ##SFRC               99        Invalid SFLRCD
     C                   SETON                                        84        SFLNXTCHG
     C                   ELSE
      * SFLRCD valid.
     C                   SETOFF                                       84        SFLNXTCHG
     C                   MOVEL     *BLANK        #1SEL
     C                   END                                                    FI *IN98
      *================================================================
     CSR   DCEXIT        ENDSR
      /EJECT
     CSR   FBRQRL        BEGSR
      *================================================================
      * Request subfile reload.
      *================================================================
     C                   MOVEL     'Y'           W0RSF
      *================================================================
     CSR   FBEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move SDWTDMD0   fields to subfile.
      *================================================================
     C                   MOVEL     *BLANK        #1SEL
     C                   MOVEL     BRCH          #1BRCH                         Branch Code
     C                   MOVEL     BOOK          #1BOOK                         Book Code
     C                   MOVEL     CURY          #1CURY                         Currency
     C                   MOVEL     CTRY          #1CTRY                         Country of Domicile
     C                   MOVEL     CUTY          #1CUTY                         Customer Type
     C                   MOVEL     INST          #1INST                         Institution Code
     C                   MOVEL     MODU          #1MODU                         Module
     C                   MOVEL     TRTY          #1TRTY                         Transaction Type
     C                   MOVEL     TRST          #1TRST                         Transaction Subtype
      *
     C                   MOVEL     TXR1          #1TXR1                         Default Tax Rate Cod
     C                   MOVEL     TXR2          #1TXR2                         Default Tax Rate Cod
     C                   Z-ADD     LCD           #1LCD                          Last Change Dat
     C                   MOVEL     TYPC          #1TYPC                         Type of Last Ch
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
     C                   MOVEL     *BLANK        #RWDMO                         WH Tax Rate Def M
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MEIZ#2        BEGSR
      *================================================================
      * Initialise subfile control.
      *================================================================
     C                   MOVEL     *BLANK        #2BRCH                         Branch Code
     C                   MOVEL     *BLANK        #2BOOK                         Book Code
     C                   MOVEL     *BLANK        #2CURY                         Currency
     C                   MOVEL     *BLANK        #2CTRY                         Country of Domicile
     C                   MOVEL     *BLANK        #2CUTY                         Customer Type
     C                   MOVEL     *BLANK        #2INST                         Institution Code
     C                   MOVEL     *BLANK        #2MODU                         Module
     C                   MOVEL     *BLANK        #2TRTY                         Transaction Type
     C                   MOVEL     *BLANK        #2TRST                         Transaction Subtype
     C                   MOVEL     *BLANK        #2TXR1                         Default Tax Rate Cod
     C                   Z-ADD     *ZERO         #2LCD                          Last Change Dat
     C                   MOVEL     *BLANK        #2TYPC                         Type of Last Ch
     C                   MOVEL     *BLANK        #CWDMP                         WH Tax Rate Def M
     C                   MOVEL     *BLANK        #CWMH1                         WH Tax Rate Def M
     C                   MOVEL     *BLANK        #CWMH2                         WH Tax Rate Def M
      *
      *================================================================
     CSR   MEEXIT        ENDSR
      /EJECT
     CSR   SBRVGN        BEGSR
      *================================================================*
      * Obtain WH Tax Rate Def Pty - System Value WHTDftMtrxPriorities *
      *================================================================*
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
      * USER: Process DBF record
     C                   MOVEL     @CN(13)       W0RTN                          *Return code
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
      *
      * DBF Record not found.
     C                   MOVEL     'USR0199'     W0RTN             7
      * USER: Processing if DBF record not found
     C                   MOVEL     @CN(12)       W0RTN                          *Return code
     C                   GOTO      SBEXIT
     C                   EndIf
      *
      *================================================================
     CSR   SBEXIT        ENDSR
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
     CSR   ZHHPKY        BEGSR
      *================================================================
      * Display HELP text.
      *================================================================
     C                   MOVEL     'Y'           W0HLP             1            Signal help req
     C                   CALL      'YDDSHPR'
     C                   PARM      ##PGM         W0HPMB           10            Member name.
     C                   PARM      *BLANK        YYHPFL           10            *DFT text file.
     C                   PARM      *BLANK        YYHPLB           10            Help text lib.
     C                   PARM                    W0RTN             7            Return Code.
      *================================================================
     CSR   ZHEXIT        ENDSR
      /EJECT
     CSR   ZXEXPG        BEGSR
      *================================================================
      * Cancel & exit program.
      *================================================================
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
      * Define work field Branch Code
     C                   MOVEL     *BLANK        WUBRCH            2
      * Define work field Book Code
     C                   MOVEL     *BLANK        WUBOOK            5
      * Define work field Currency
     C                   MOVEL     *BLANK        WUCURY            2
      * Define work field Country of Domicile
     C                   MOVEL     *BLANK        WUCTRY            3
      * Define work field Customer Type
     C                   MOVEL     *BLANK        WUCUTY            3
      * Define work field Institution Code
     C                   MOVEL     *BLANK        WUINST           10
      * Define work field Module
     C                   MOVEL     *BLANK        WUMODU            2
      * Define work field Transaction Type
     C                   MOVEL     *BLANK        WUTRTY           10
      * Define work field Transaction Subtype
     C                   MOVEL     *BLANK        WUTRST            6
      *
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
      * Obtain default message file.
     C     *DTAARA       DEFINE    Y2MGFLA       ZADFMF           10
     C                   IN        ZADFMF
      * Define work field Midas Run Date
     C                   MOVEL     *BLANK        WUMRDT            7
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUSUC             1
      * Define work field Date format flag
     C                   MOVEL     *BLANK        WUDFF             1
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUMBIN            1
     C                   Z-ADD     13            ##SFPG            3 0          SFLPAG
     C                   Z-ADD     1             ##SFRC
     C                   Z-ADD     *ZERO         ##RRMX                         MAX RECNO
     C                   Z-ADD     500           W0SLM             5 0          SCAN LIMIT
      *................................................................
      * USER: Initialise program
      * Standard RPG Creation PAR - Standard Functions  *
      * Last Amend Box SD0490D - Withholding Tax Rate Default Matrix *
      * Copyright Statement - Standard Functions  *
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT                         RUN DATE
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB                         RUNDAY NO.
     C                   MOVE      SUC           WUSUC                          SET UP COMPLT
     C                   MOVE      DFF           WUDFF                          DTE FMT FLAG
     C                   MOVE      MBIN          WUMBIN                         MULTI BR. IND
      * Depending upon the program mode ( Maintenace or Enquiry )
      * Change the screen heading to one of the following
      *       'Withholding Tax Rate Default Matrix Enquiry'
      *     'Withholding Tax Rate Default Matrix Maintenance'
      * Set Up Screen Heading - Withholding Tax Rate Default Matrix *
     C*
     C     P1DFMD        IFEQ      'M'                                          .-If 1
     C                   MOVEA     SCHD(1)       ##URPT                         ¦
     C                   ELSE                                                   ¦- X 1
     C     P1DFMD        IFEQ      'E'                                          ¦.-If 2
     C                   MOVEA     SCHD(2)       ##URPT                         ¦¦
     C                   END                                                    ¦'-Fi 2
     C                   END                                                    '- Fi 1
      *
      * Set-up Dsp. file footer - Standard Functions  *
     C     P1DFMD        IFEQ      'E'                                               S01216    S0122
     C                   MOVEA     AENA(1)       ##CTX1                                        S0122
     C                   END
     C     P1DFMD        IFEQ      'M'                                               S01216    S0122
     C                   MOVEA     AENA(2)       ##CTX1                                        S0122
     C                   END
      * Get Withhold Tax Rate Default Priorities off General Ledger ICD
      * Obtain Withholding Tax Rate Def Mtrx Def Pty - General Ledger Details  *
     C                   EXSR      SBRVGN
     C                   Z-ADD     99999         W0SLM                          *Scan limit
      * Initialise subfile control.
     C                   EXSR      MEIZ#2
      *================================================================
     CSR   ZZEXIT        ENDSR
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
**CTDATA SCHD
      Withholding Tax Rate Default Matrix Maintenance
        Withholding Tax Rate Default Matrix                            Mode
**CTDATA AENA
E=Enquire   F3=Main Menu   F5=Refresh
A=Amend  D=Delete  E=Enquire  F3=Main Menu  F5=Refresh  F9=Go to 'Add' Mode
**CTDATA @CN
1
Y
*NOSNOF
*CUSFND
M
I
Y2U9999
E
A
D
GELR
Y2U0005
Y2U0003
