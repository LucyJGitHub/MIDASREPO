     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Group Account Hierarchy Imbalance Report')    *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100509 - Group Account Hierarchy Imbalance Exception       *
      *             Report                                            *
      *                                                               *
      *  Function: This program produces a report that lists all      *
      *            Group Account Hierarchies with imbalances.         *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. AR937671           Date 03Apr12               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR676213           Date 19Nov10               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR937671 - Incorrect header printed due to overprinting.     *
      *             Increase line required. (Child:AR937672)          *
      *  MD046248 - Finastra Rebranding                               *
      *  AR676213 - Incorrect definition of CLGLAI field              *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    37         By Branch                                       *
      *    60         Chain failed                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRINIT       - Initialisation                                 *
      * SRPROC       - Detail processing                              *
      * SRSYSLEV     - System level detail processing                 *
      * SRALLBRCH    - All branch detail processing                   *
      * SRSNGBRCH    - Single branch detail processing                *
      * SRCHKIMBAL   - Check hierarchy imbalance                      *
      * SRSUBTOTAL   - Compute sub-totals                             *
      * SRPDETL      - Print hierarch details                         *
      * SRPIMBAL     - Print imbalance details                        *
      * SRFMTDATA    - Format data for output                         *
      * CNV_GAHEADER - Convert group A/C header                       *
      * CNV_CMHEADER - Convert cash management header                 *
      * ACS_HIER     - Access hierarchy detail                        *
      * ACS_ACCNT    - Access A/C details                             *
      * ACS_CURR     - Access a currency                              *
      * SRRCFP1      - Detail spool file recorded by RCF              *
      * SRRCFAU      - Audit spool file recorded by RCF               *
      * SRCHKLIN     - Checks for printer file overflow condition     *
      * SRAUDIT      - Output audit report                            *
      * ZSEDIT       - Edit a signed field                            *
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
 
      ** RE Group Account Hierarchy Imbalance - Report
     FRE100509P1O    E             PRINTER USROPN
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
 
      ** RE Group Account Hierarchy Imbalance - Audit
     FRE100509AUO    E             PRINTER
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
 
      ** RE Cash Management Hierarchy Details - by Hierarchy ID
     FRECMHDL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** RE Cash Management Hierarchy Details - by Branch & Hierarchy ID
     FRECMHDL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(RECMHDD0:RECMHDP0)
 
      ** RE Cash Management Hierarchy Links - by Parent
     FRECMHLL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(RECMHLD0:RECMHLPA)
     F                                     PREFIX(P_)
 
      ** RE Cash Management Hierarchy Links - by GLAI Chain
     FRECMHLL5  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(RECMHLD0:RECMHLGL)
 
      ** RE Cash Management Hierarchy Links - by Ret A/c Chain
     FRECMHLL6  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(RECMHLD0:RECMHLRA)
 
      ** GL Account Master Details
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(ACCNTABF)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      *****************************************************************
 
      ** Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Externally described DS for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Externally described DS for retail details
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
 
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
 
      ** Externally described DS CM Hierarchy Details
     D O_CMHD        E DS                  EXTNAME(RECMHDPD)
 
      ** Externally described DS for Group Account Details
     D O_GAHD        E DS                  EXTNAME(REGAHDPD)
 
      ** Externally described DS for Zero Balancing/Sweeping Details
     D O_ZSHD        E DS                  EXTNAME(REZSHDPD)
 
 
      ** File Information Data Structure for RE100509P1
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
     D  OflLn1               188    189B 0
     D  PrtLn1               367    368B 0
 
      ** File Information Data Structure for RE100509AU
     D SPOOLU          DS
     D  PSFileU               83     92
     D  PSFNumU              123    124B 0
 
      ** Work data structures
     D                 DS
     D RDACCS                  1    125
     D AccsAR                  1    125    DIM(125)
 
     D                 DS
     D WAccsAR                 1    150    DIM(150)
 
     D                 DS
     D BRC                     1      3
     D*CUS******               4      9S 0                                                    CSD027
     D CUS                     4      9A                                                      CSD027
     D CCY                    10     12
     D*ACD******              13     16S 0                                                    CGL029
     D*ASN******              17     18S 0                                                    CGL029
     D ACD                    13     22S 0                                                    CGL029
     D ASN                    23     24S 0                                                    CGL029
 
     D                 DS
     D ZOUT21                  1     21
     D ZOUT21Sign             21     21
     D ZOUT21Edit              1     22
 
 
      ** Work Arrays
     D***X_GLAI*         S             18    DIM(99)                                        AR676213
     D X_GLAI          S             24    DIM(99)                                          AR676213
     D X_RAN           S             10    DIM(99)
     D***GLDashes        S              1    DIM(18)  CTDATA PERRCD(18)                     AR676213
     D GLDashes        S              1    DIM(24)  CTDATA PERRCD(24)                       AR676213
     D REDashes        S              1    DIM(10)  CTDATA PERRCD(10)
 
      ** Parameters for RE100601
     D I_HIER          S              9  0
     D I_HTYP          S              2A
 
      ** Parameters for RE100311
     D I_DATFMT        S              1A
     D I_DEFR          S              5P 0
     D I_RVDT          S              5P 0
     D I_LCDT          S              5P 0
     D DDDEFR          S              7A
     D DDRVDT          S              7A
     D DDLCDT          S              7A
 
      ** Parameters for RE100311
     D I_TOPB          S              1A
     D I_LELC          S              1A
     D I_UELC          S              1A
     D DDTOPB          S              3A
     D DDLELC          S              3A
     D DDUELC          S              3A
 
      ** Parameters for ZSEDIT
     D ZFLD15          S             15  0
     D ZDECS           S              1  0
     D ZECODE          S              1A
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PLevel          S              1
     D PEnty           S              3
     D ZSnum           S              6P 0
     D ZSnumU          S              6P 0
     D ZSerr           S              1
 
      ** Parameters for access object programs
     D PRTCD           S              7A
     D POPTN           S              7A
 
      ** Work variables
     D KBRCA           S              3A
     D WBRCA           S              3A
     D RTOTAL          S              4S 0
     D ScnBal          S             18A
     D WImbalance      S              1A
     D X               S              3S 0
     D Y               S              3S 0
     D LDBL_DIFF       S             15  0
     D CLBL_DIFF       S             15  0
 
     D RqdLn1          S              3P 0
     D DifLn1          S              4P 0
 
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   EXSR      SRINIT
 
     C                   EXSR      SRPROC
 
     C                   IF        RTOTAL = *ZERO
     C                   EXSR      SRAUDIT
     C                   ENDIF
 
     C                   EVAL      *INLR = *On
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
      ** Initialisation
      *****************************************************************
     C     SRINIT        BEGSR
 
      ** RCF Processing for printer file
 
     C                   EXSR      SRRCFAU
 
      ** Report work fields
 
     C                   EVAL      RqdLn1  = *ZERO
     C                   EVAL      DifLn1  = *ZERO
     C                   EVAL      RTOTAL  = *ZERO
     C                   EVAL      PrtLn1  = *ZERO
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      ** Detail Processing
      *****************************************************************
     C     SRPROC        BEGSR
 
      **  Process report according to level requested:
 
     C                   SELECT
 
      ** System Level
 
     C     PLevel        WHENEQ    'S'
     C                   EXSR      SRSYSLEV
 
      ** All Branch
 
     C     PLevel        WHENEQ    'B'
     C     PEnty         AndEq     'ALL'
     C                   EXSR      SRALLBRCH
 
      ** Single Branch
 
     C     PLevel        WHENEQ    'B'
     C     PEnty         ANDNE     'ALL'
     C                   EXSR      SRSNGBRCH
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      ** System Level Detail Processing
      *****************************************************************
     C     SRSYSLEV      BEGSR
 
     C                   EVAL      *IN37 = *OFF
 
      ** RCF processing for printer file
 
     C                   CLOSE     RE100509P1
     C                   OPEN      RE100509P1
     C                   EXSR      SRRCFP1
 
     C     *LOVAL        SETLL     RECMHDL0
 
      ** Read Cash Management Hierarchy Details
 
     C                   READ      RECMHDL0                               01
 
     C                   DOW       *IN01 = *OFF
 
      ** Check for imbalance
 
     C                   EXSR      SRCHKIMBAL
 
      ** Process if type is group account and hierarchy is imbalanced
 
     C                   IF        CDHTYP = 'GA' AND
     C                             WImbalance = 'Y'
     C                   EXSR      SRPDETL
     C                   ENDIF
 
     C                   READ      RECMHDL0                               01
 
     C                   ENDDO
 
      ** When EOF, write trailer
 
     C                   IF        *IN01 = *ON
     C**********         EVAL      RqdLn1 = 8                                               AR937671
     C                   EVAL      RqdLn1 = 11                                              AR937671
     C                   EXSR      SRCHKLIN
 
     C                   IF        RTOTAL <> *ZERO
     C                   WRITE     TRAILP1
     C                   ENDIF
 
     C                   CLOSE     RE100509P1
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      ** All Branch Detail Processing
      *****************************************************************
     C     SRALLBRCH     BEGSR
 
     C                   EVAL      *IN37 = *ON
 
     C     *LOVAL        SETLL     RECMHDL1
 
      ** Open printer file and enroll to RCF
 
     C                   CLOSE     RE100509P1
     C                   OPEN      RE100509P1
     C                   EXSR      SRRCFP1
 
      ** Read Cash Management Hierarchy Details
 
     C                   READ      RECMHDL1                               01
 
     C                   DOW       *IN01 = *OFF
 
      ** Check for imbalance
 
     C                   EXSR      SRCHKIMBAL
 
      ** Process if type is group account and hierarchy is imbalanced
 
     C                   IF        CDHTYP = 'GA' AND
     C                             WImbalance = 'Y'
     C                   EXSR      SRPDETL
     C                   ENDIF
 
     C                   EVAL      WBRCA = CDBRCA
 
     C                   READ      RECMHDL1                               01
 
      ** Generate a new P1 on change of branch
 
     C                   IF        CDBRCA <> WBRCA AND
     C                             *IN01 = *OFF
     C                   WRITE     TRAILP1
     C                   CLOSE     RE100509P1
     C                   OPEN      RE100509P1
     C                   EXSR      SRRCFP1
     C                   WRITE     HEADP1                                                   AR937671
     C                   ENDIF
 
     C                   ENDDO
 
      ** When EOF, write trailer
 
     C                   IF        *IN01 = *ON
     C**********         EVAL      RqdLn1 = 8                                               AR937671
     C                   EVAL      RqdLn1 = 11                                              AR937671
     C                   EXSR      SRCHKLIN
 
     C                   IF        RTOTAL <> *ZERO
     C                   WRITE     TRAILP1
     C                   ENDIF
 
     C                   CLOSE     RE100509P1
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      ** Single Branch Detail Processing
      *****************************************************************
     C     SRSNGBRCH     BEGSR
 
     C                   EVAL      *IN37 = *ON
     C                   EVAL      KBRCA = PEnty
 
 
     C     KBRCA         SETLL     RECMHDL1
 
      ** Open printer file and enroll to RCF
 
     C                   CLOSE     RE100509P1
     C                   OPEN      RE100509P1
     C                   EXSR      SRRCFP1
 
      ** Read Cash Management Hierarchy Details
 
     C     KBRCA         READE     RECMHDL1                               01
 
     C                   DOW       *IN01 = *OFF
 
      ** Check for imbalance
 
     C                   EXSR      SRCHKIMBAL
 
      ** Process if type is group account and hierarchy is imbalanced
 
     C                   IF        CDHTYP = 'GA' AND
     C                             WImbalance = 'Y'
     C                   EXSR      SRPDETL
     C                   ENDIF
 
     C     KBRCA         READE     RECMHDL1                               01
 
     C                   ENDDO
 
      ** When EOF, write trailer
 
     C                   IF        *IN01 = *ON
     C**********         EVAL      RqdLn1 = 8                                               AR937671
     C                   EVAL      RqdLn1 = 11                                              AR937671
     C                   EXSR      SRCHKLIN
 
     C                   IF        RTOTAL <> *ZERO
     C                   WRITE     TRAILP1
     C                   ENDIF
 
     C                   CLOSE     RE100509P1
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      ** Check hierarchy for imbalance
      *****************************************************************
     C     SRCHKIMBAL    BEGSR
 
     C                   EVAL      WImbalance = 'N'
     C**********         EVAL      CLGLAI = *BLANKS                                         AR676213
     C                   EVAL      CLGLAC = *BLANKS                                         AR676213
     C                   EVAL      CLRAN = *BLANKS
 
      ** Get first record
 
     C     BMRANR        IFNE      'Y'
     C     RECMHLK_GL    SETLL     RECMHLGL
     C     CDHIER        READE     RECMHLGL                               02
     C                   ELSE
     C     RECMHLK_RA    SETLL     RECMHLRA
     C     CDHIER        READE     RECMHLRA                               02
     C                   ENDIF
 
      ** Do while not end of file
 
     C                   DOW       *IN02 = *OFF AND
     C                             WImbalance = 'N'
 
     C                   IF        CLCCAT <> 'S'
 
      ** Child A/C
 
     C                   MOVEL     CLCBRC        BRC
     C                   MOVEL     CLCCUS        CUS
     C                   MOVEL     CLCCCY        CCY
     C                   MOVEL     CLCACD        ACD
     C                   MOVEL     CLCASN        ASN
 
      ** Access A/C details for the child A/C
 
     C                   EXSR      ACS_ACCNT
 
      ** Compute for sub-totals
 
     C                   EXSR      SRSUBTOTAL
 
      ** Check for imbalance
 
     C                   IF        LDBL_DIFF <> *ZERO OR
     C                             CLBL_DIFF <> *ZERO
     C                   EVAL      WImbalance = 'Y'
     C                   ENDIF
 
     C                   ENDIF
 
     C     BMRANR        IFNE      'Y'
     C     CDHIER        READE     RECMHLGL                               02
     C                   ELSE
     C     CDHIER        READE     RECMHLRA                               02
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      ** Compute for sub-totals
      *****************************************************************
     C     SRSUBTOTAL    BEGSR
 
      ** Start with this a/c's ledger and cleared balance
 
     C                   Z-ADD     LDBL          LDBL_DIFF
     C                   Z-ADD     CLBL          CLBL_DIFF
 
      ** Read all A/Cs who have a parent equal to this A/C
 
     C     RECMHLK_PA    SETLL     RECMHLPA
     C     RECMHLK_PA    READE     RECMHLPA                               02
 
     C                   DOW       *IN02 = *OFF
 
      ** Access child A/C
 
     C     ACCNTK_CH     CHAIN     ACCNTABF                           60
 
     C                   SUB       LDBL          LDBL_DIFF
     C                   SUB       CLBL          CLBL_DIFF
 
     C     RECMHLK_PA    READE     RECMHLPA                               02
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      ** Print Hierarchy Details
      *****************************************************************
     C     SRPDETL       BEGSR
 
      ** Convert Cash Management Header
 
     C                   EXSR      CNV_CMHEADER
 
      ** Put hierarchy details to printer fields
 
      ** Print Header
 
     C                   WRITE     HEADP1
 
      ** Print Hierarchy Details
 
     C                   WRITE     CMHD
 
      ** Access hierarchy detail group detail record
 
     C                   MOVEL     CDHTYP        I_HTYP
     C                   EXSR      ACS_HIER
 
      ** Print Group Account Details
 
      ** Convert Group A/c Header
 
     C                   EXSR      CNV_GAHEADER
 
      ** Print Group Account Details
 
     C                   WRITE     GAHD
 
      ** Print Imbalance Details
 
     C                   EXSR      SRPIMBAL
 
      ** Increment number of detail records processed
 
     C                   EVAL      RTOTAL = RTOTAL + 1
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      ** Print imbalance details
      *****************************************************************
     C     SRPIMBAL      BEGSR
 
      ** Get first record
 
     C**********         EVAL      CLGLAI = *BLANKS                                         AR676213
     C                   EVAL      CLGLAC = *BLANKS                                         AR676213
     C                   EVAL      CLRAN = *BLANKS
 
     C     BMRANR        IFNE      'Y'
     C     RECMHLK_GL    SETLL     RECMHLGL
     C     CDHIER        READE     RECMHLGL                               02
     C                   ELSE
     C     RECMHLK_RA    SETLL     RECMHLRA
     C     CDHIER        READE     RECMHLRA                               02
     C                   ENDIF
 
      ** Do while not end of file
 
     C                   DOW       *IN02 = *OFF
 
      ** Format output
 
     C                   EXSR      SRFMTDATA
 
      ** Check for overflow
 
     C**********         Z-ADD     2             RqdLn1                                     AR937671
     C                   Z-ADD     11            RqdLn1                                     AR937671
     C                   EXSR      SRCHKLIN
 
      ** Check for overflow
 
     C                   WRITE     IDTL
 
     C     BMRANR        IFNE      'Y'
     C     CDHIER        READE     RECMHLGL                               02
     C                   ELSE
     C     CDHIER        READE     RECMHLRA                               02
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      ** Format data for output
      *****************************************************************
     C     SRFMTDATA     BEGSR
 
     C                   MOVEL     *BLANK        RDACCS
 
      ** Output account to printer field (General Ledger ID)
 
     C     BMRANR        IFNE      'Y'
 
     C**********         MOVEA     CLGLAI        X_GLAI                                     AR676213
     C                   MOVEA     CLGLAC        X_GLAI                                     AR676213
     C                   Z-ADD     1             X
     C                   Z-ADD     2             Y
     C     X_GLAI(Y)     DOWNE     *BLANK
     C                   MOVEA     GLDashes      X_GLAI(X)
     C                   ADD       1             X
     C                   ADD       1             Y
     C                   ENDDO
 
     C                   MOVEA     X_GLAI        WAccsAR
 
      ** A/cs - Retail A/c Number
      ** ------------------------
 
     C                   ELSE
 
     C                   MOVEA     CLRAN         X_RAN
     C                   Z-ADD     1             X
     C                   Z-ADD     2             Y
     C     X_RAN(Y)      DOWNE     *BLANK
     C                   MOVEA     REDashes      X_RAN(X)
     C                   ADD       1             X
     C                   ADD       1             Y
     C                   ENDDO
 
     C                   MOVEA     X_RAN         WAccsAR
 
     C                   ENDIF
 
      ** Remove fillers
 
     C                   Z-ADD     1             X
     C                   Z-ADD     1             Y
     C     X             DOUGT     150
     C     Y             ORGT      75
     C     WAccsAR(X)    IFNE      '!'
     C                   MOVEL     WAccsAR(X)    AccsAR(Y)
     C                   ADD       1             Y
     C                   ENDIF
     C                   ADD       1             X
     C                   ENDDO
 
      ** Child A/C
 
     C                   MOVEL     CLCBRC        BRC
     C                   MOVEL     CLCCUS        CUS
     C                   MOVEL     CLCCCY        CCY
     C                   MOVEL     CLCACD        ACD
     C                   MOVEL     CLCASN        ASN
 
      ** Access A/C details for the child A/C
 
     C                   EXSR      ACS_ACCNT
 
      ** Output customer to printer field
 
     C                   MOVEA     *BLANKS       AccsAR(45)
     C                   MOVEA     ANAM          AccsAR(45)
 
      ** Compute for sub-totals
 
     C                   IF        CLCCAT <> 'S'
 
     C                   EXSR      SRSUBTOTAL
 
      ** Check for imbalance
 
     C                   IF        LDBL_DIFF <> *ZERO OR
     C                             CLBL_DIFF <> *ZERO
 
      ** Access currency details
 
     C                   EXSR      ACS_CURR
 
      ** Edit differences in ledger and cleared balances
 
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      LDBL_DIFF     ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21Edit    ScnBal
     C                   MOVEA     ScnBal        AccsAR(70)
 
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      CLBL_DIFF     ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21Edit    ScnBal
     C                   MOVEA     ScnBal        AccsAR(95)
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      ** Convert Group A/c Header
      ********************************************************************
     C     CNV_GAHEADER  BEGSR
 
     C                   CALLB     'RE100313'
 
      ** Return code
      ** Error Message
     C                   PARM      *BLANKS       X_RTCD
     C                   PARM      *BLANKS       X_ERMS
      ** INPUTS
 
      ** Top on Balance Sheet
      ** Link Effective At Last Capitalization Date
      ** Unlink Effective At Last Capitalization Date
     C                   PARM      GDTOPB        I_TOPB
     C                   PARM      GDLELC        I_LELC
     C                   PARM      GDUELC        I_UELC
 
      ** OUTPUTS
 
      ** Top on Balance Sheet
      ** Link Effective At Last Capitalization Date
      ** Unlink Effective At Last Capitalization Date
     C                   PARM                    DDTOPB
     C                   PARM                    DDLELC
     C                   PARM                    DDUELC
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN GROUP A/C HEADER'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      ** Convert Cash Management Header
      *****************************************************************
     C     CNV_CMHEADER  BEGSR
 
     C                   CALLB     'RE100311'
 
      ** Return code
      ** Error Message
     C                   PARM      *BLANKS       X_RTCD
     C                   PARM      *BLANKS       X_ERMS
 
      ** INPUTS
 
      ** Date format
     C                   PARM      'A'           I_DATFMT
      ** Date Effective From
      ** Review Date
      ** Last Change Date
     C                   PARM      CDDEFR        I_DEFR
     C                   PARM      CDRVDT        I_RVDT
     C                   PARM      CDLCDT        I_LCDT
 
 
      ** BANK details
     C                   PARM                    SDBANK
 
      ** OUTPUTS
      ** Date Effective From
      ** Review Date
      ** Last Change Date
     C                   PARM                    DDDEFR
     C                   PARM                    DDRVDT
     C                   PARM                    DDLCDT
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN CASH MANAGEMENT HEADER'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      ** Access Hierarchy Detail
      *****************************************************************
     C     ACS_HIER      BEGSR
 
     C                   CALLB     'RE100601'
      ** Return code
      ** Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      ** Option
     C                   PARM      '*EXCLCM'     X_OPTN
      ** Hierarchy ID
     C                   PARM      CDHIER        I_HIER
      ** Hierarchy Type
     C                   PARM                    I_HTYP
 
     C                   PARM                    O_CMHD
     C                   PARM                    O_ZSHD
     C                   PARM                    O_GAHD
 
      ** Database error if record not found
 
     C     X_RTCD        IFEQ      '*ERROR'
     C     X_RTCD        OREQ      '*NOREC'
     C                   MOVEL     CDHIER        DBKEY
     C                   EVAL      X_ERMS = 'BAD HIERARCHY DETAIL:' + DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      ** Access A/C details
      *****************************************************************
     C     ACS_ACCNT     BEGSR
 
     C     ACCNTK        CHAIN     ACCNTABF                           60
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      ** Access a currency
      *****************************************************************
     C     ACS_CURR      BEGSR
 
     C                   CALLB     'ZAACSCURR'
     C                   PARM                    CCY
     C                   PARM                    SDCURR
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      ** Detail Spool File Recorded by RCF
      *****************************************************************
     C     SRRCFP1       BEGSR
 
     C                   Z-ADD     PSFNUM1       ZSnum
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFile1
     C                   PARM                    ZSnum
     C                   PARM      *BLANKS       ZSerr
 
      ** If Error occurs during ZSFILE processing, then end abnormally
 
     C     ZSERR         IFEQ      'Y'
     C                   EVAL      X_ERMS = 'Call to ZSFILE in error'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      ** Audit Spool File Recorded by RCF
      *****************************************************************
     C     SRRCFAU       BEGSR
 
     C                   Z-ADD     PSFNUMU       ZSnum
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFileU
     C                   PARM                    ZSnum
     C                   PARM      *BLANKS       ZSerr
 
      ** If Error occurs during ZSFILE processing, then end abnormally
 
     C     ZSERR         IFEQ      'Y'
     C                   EVAL      X_ERMS = 'Call to ZSFILE in error'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      ** Checks for Printer File Overflow Condition
      *****************************************************************
     C     SRCHKLIN      BEGSR
 
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
 
      ** If not EOF, print continuation line
 
     C                   IF        NOT %EOF
     C                   WRITE     CMHDCONT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      ** Output Audit Report
      *****************************************************************
     C     SRAUDIT       BEGSR
 
      ** Output Report Header and File Controls
 
     C                   WRITE     HEADAU
 
      ** Output "No Details" message
 
     C                   WRITE     NODTLS
 
      ** End program
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      ** Edit a signed field
      *****************************************************************
     C     ZSEDIT        BEGSR
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM      'J'           ZECODE
     C                   PARM                    ZOUT21
     C     ZOUT21Sign    IFEQ      '-'
     C                   MOVE      'CR'          ZOUT21Edit
     C                   ELSE
     C                   MOVE      '  '          ZOUT21Edit
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      ** *INZSR - Program Initialisation Routine
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PSeq
     C                   PARM                    PLevel
     C                   PARM                    PEnty
 
     C/COPY ZACPYSRC,DBFIELDS
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      X_ERMS = 'Call to AOBANKR0 in error'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Retail Details
 
     C                   CALL      'AORETLR0'
     C                   PARM      '*DBERR  '    PRTCD
     C                   PARM      '*FIRST  '    POPTN
     C     SDRETL        PARM      SDRETL        DSFDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      X_ERMS = 'Call to AORETLR0 in error'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Key lists
 
     C     RECMHLK_GL    KLIST
     C                   KFLD                    CDHIER
     C**********         KFLD                    CLGLAI                                     AR676213
     C                   KFLD                    CLGLAC                                     AR676213
 
     C     RECMHLK_RA    KLIST
     C                   KFLD                    CDHIER
     C                   KFLD                    CLRAN
 
     C     RECMHLK_PA    KLIST
     C                   KFLD                    CDHIER
     C                   KFLD                    BRC
     C                   KFLD                    CUS
     C                   KFLD                    CCY
     C                   KFLD                    ACD
     C                   KFLD                    ASN
 
     C     ACCNTK_CH     KLIST
     C                   KFLD                    P_CLCCUS
     C                   KFLD                    P_CLCCCY
     C                   KFLD                    P_CLCACD
     C                   KFLD                    P_CLCASN
     C                   KFLD                    P_CLCBRC
 
     C     ACCNTK        KLIST
     C                   KFLD                    CUS
     C                   KFLD                    CCY
     C                   KFLD                    ACD
     C                   KFLD                    ASN
     C                   KFLD                    BRC
 
     C                   ENDSR
      *****************************************************************
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
      /EJECT
      *****************************************************************
** GLdashes
!!!!!!!!!!!!!!!!!!!!!___                                                                    AR676213
** REdashes
!!!!!!!___
