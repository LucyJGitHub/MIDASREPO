     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cash Management Exceptions Report')           *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100505  - Cash Management Exceptions Report                *
      *                                                               *
      *  Function: This module lists records on the cash management   *
      *            exceptions file.                                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FRECMEXL0  IF   E           K DISK    INFSR(*PSSR)
     FRECMHLL4  IF   E           K DISK    INFSR(*PSSR)
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     FRE100505P1O    E             PRINTER INFSR(*PSSR) USROPN
     F                                     INFDS(SPOOL1)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
     D #_INF           S             70    DIM(7)  CTDATA PERRCD(1)
     D POSTDTLS        S             60                                                       CGL029
 
 
      * Input Entry
     D I_ENTRY       E DS                  EXTNAME(APOSTPD)
     D                                     PREFIX(E_)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency Details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs
 
 
      ** File Information Data Structure for RE100505P1
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
 
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PLevel          S              1
     D PEnty           S              3
     D ZSnum           S              6  0
     D ZSerr           S              1
 
 
 
      * Read the cash management exceptions
 
 
     C                   READ      RECMEXD0                               60
 
      * Read until EOF
 
     C     *IN60         DOWEQ     '0'
 
      * Print Exceptions
 
     C                   EXSR      PRT_EXCEPT
 
     C                   READ      RECMEXD0                               60
     C                   ENDDO
 
      *  Produce end of report
 
     C                   EXSR      END_OF_REP
     C                   CLOSE     RE100505P1
 
      * Return
 
     C                   SETON                                        LR
     C                   RETURN
      *
      /SPACE 5
      ********************************************************************
      * Print Exceptions
      ********************************************************************
     C     PRT_EXCEPT    BEGSR
 
     C                   MOVE      *OFF          *IN30
     C                   MOVE      *OFF          *IN31
     C                   MOVE      *OFF          *IN35
     C                   MOVE      *OFF          *IN36
 
      * Account details
 
     C     EXLINK        IFNE      *ZERO                                        *
 
     C     RECMHLK       CHAIN     RECMHLD0                           99
 
     C                   Z-ADD     *ZERO         C_ACNO
     C                   Z-ADD     *ZERO         P_ACNO
     C     *IN99         IFEQ      '0'
     C     CACCNTK       CHAIN     ACCNTABF                           99
     C  N99              MOVE      *ON           *IN30
     C  N99              Z-ADD     ACNO          C_ACNO           10 03535
     C     PACCNTK       CHAIN     ACCNTABF                           99
     C  N99              MOVE      *ON           *IN31
     C  N99              Z-ADD     ACNO          P_ACNO           10 03636
     C                   ENDIF
     C                   ENDIF
 
      * Posting details
 
     C                   MOVEL     *BLANK        POSTDTLS
     C     EXZSEN        IFNE      *BLANK
     C                   MOVEL     EXZSEN        POSTDTLS
     C                   ELSE
     C     EXOREN        IFNE      *BLANK
     C                   EVAL      I_ENTRY = EXOREN
 
      * Access currency
 
     C                   MOVEL     CLCCCY        CCY
     C                   EXSR      ACS_CURR
 
      * Edit value date of entry
 
     C                   Z-ADD     E_VALD        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        R_VALD            7
 
      * Edit posting amount of entry
 
     C                   MOVE      *ZERO         ZFIELD
     C                   MOVE      E_PSTA        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        R_PSTA           15
 
      * Edit posting dr/cr indicator
 
     C     E_DRCR        IFEQ      0
     C                   MOVEL     'D'           R_DRCR
     C                   ELSE
     C                   MOVEL     'C'           R_DRCR            1
     C                   ENDIF
 
      * Exception entry details
 
     C                   EVAL      POSTDTLS = R_VALD + ' ' + R_PSTA
     C                                      + '  ' + R_DRCR + '   ' + E_PNAR
     C                   ENDIF
     C                   ENDIF
 
      ** Exception/Reason                                                                     CGL029
                                                                                              CGL029
     C                   MOVEL     EXEXCP        EXEXCP1                                      CGL029
     C                   MOVE      EXEXCP        EXEXCP2                                      CGL029
     C                   IF        EXEXCP2 = *BLANKS                                          CGL029
     C                   EVAL      *IN37 = *OFF                                               CGL029
     C                   ELSE                                                                 CGL029
     C                   EVAL      *IN37 = *ON                                                CGL029
     C                   ENDIF                                                                CGL029
                                                                                              CGL029
     C                   MOVEL     EXREAS        EXREAS1                                      CGL029
     C                   MOVE      EXREAS        EXREAS2                                      CGL029
     C                   IF        EXREAS2 = *BLANKS                                          CGL029
     C                   EVAL      *IN38 = *OFF                                               CGL029
     C                   ELSE                                                                 CGL029
     C                   EVAL      *IN38 = *ON                                                CGL029
     C                   ENDIF                                                                CGL029
                                                                                              CGL029
     C                   MOVEL     POSTDTLS      POSTDTLS1                                    CGL029
     C                   MOVE      POSTDTLS      POSTDTLS2                                    CGL029
     C                   IF        POSTDTLS2 = *BLANKS                                        CGL029
     C                   EVAL      *IN39 = *OFF                                               CGL029
     C                   ELSE                                                                 CGL029
     C                   EVAL      *IN39 = *ON                                                CGL029
     C                   ENDIF                                                                CGL029
                                                                                              CGL029
      * Time
 
     C     EXTIME        COMP      *ZERO                              4040      *
 
     C                   Z-ADD     4             CHLINE            3 0
     C                   EXSR      PAG
     C                   WRITE     EXCEPTION
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Access a currency
      ********************************************************************
     C     ACS_CURR      BEGSR
 
     C                   CALLB     'ZAACSCURR'
     C                   PARM                    CCY               3
     C                   PARM                    SDCURR
 
      * Database error if currency not found
 
     C     A6CYCD        IFEQ      *BLANK
     C                   EVAL      X_ERMS = 'BAD CCY CODE:' + CCY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * Convert a day number into a date
      ********************************************************************
     C     ZDATE2        BEGSR
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      'M'           ZDFIN             1
     C                   PARM      *ZERO         ZDATEN            6 0
     C                   PARM      *BLANK        ZADATE            7
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * Edit an amount
      ********************************************************************
     C     ZEDIT         BEGSR
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM      A6NBDP        ZADEC             1 0
     C                   ENDSR
      *********************************************************************
     C/SPACE 5
      ********************************************************************
      * End of Report
      ********************************************************************
     C     END_OF_REP    BEGSR
 
      * Output 'end of report'
 
     C                   Z-ADD     3             CHLINE
     C                   EXSR      PAG
     C                   WRITE     ENDOFREP
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Throw page headings (if required)
      ********************************************************************
     C     PAG           BEGSR
 
     C                   ADD       CHLINE        LINENO
     C     LINENO        IFGT      59
     C                   ADD       1             PAGNUM
     C                   WRITE     PAGEHEAD
     C     4             ADD       CHLINE        LINENO            3 0
     C                   ENDIF
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * Register P1 printer file with RCF
      ********************************************************************
     C     RCFP1         BEGSR
 
     C                   EVAL      ZSnum = PSFNum1
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFile1
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSErr
 
      ** If Error occurs during ZSFILE processing, then end abnormally
 
     C                   IF        ZSErr = 'Y'
     C                   EVAL      X_ERMS = 'Call to ZSFILE in error'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      * INPUTS
      * Mode
     C                   PARM                    I_MODE            3
     C                   PARM                    PSeq
     C                   PARM                    PLevel
     C                   PARM                    PEnty
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Throw a page
 
     C                   Z-ADD     99            LINENO
 
      * Open files
     C                   OPEN      RE100505P1
 
      * Register P1 printer file with RCF
     C                   EXSR      RCFP1
 
      * Set mode narrative printed on report
 
     C                   SELECT
     C     I_MODE        WHENEQ    'PUR'
     C                   MOVEL     #_INF(1)      MODENARR
     C     I_MODE        WHENEQ    'ASC'
     C                   MOVEL     #_INF(2)      MODENARR
     C     I_MODE        WHENEQ    '1  '
     C                   MOVEL     #_INF(3)      MODENARR
     C     I_MODE        WHENEQ    '1PC'
     C                   MOVEL     #_INF(4)      MODENARR
     C     I_MODE        WHENEQ    '5  '
     C                   MOVEL     #_INF(5)      MODENARR
     C     I_MODE        WHENEQ    '5PC'
     C                   MOVEL     #_INF(6)      MODENARR
     C     I_MODE        WHENEQ    'I/C'
     C                   MOVEL     #_INF(7)      MODENARR
     C                   ENDSL
 
      * Key lists
 
     C     RECMHLK       KLIST
     C                   KFLD                    EXHIER
     C                   KFLD                    EXLINK
 
     C     CACCNTK       KLIST
     C                   KFLD                    CLCCUS
     C                   KFLD                    CLCCCY
     C                   KFLD                    CLCACD
     C                   KFLD                    CLCASN
     C                   KFLD                    CLCBRC
     C     PACCNTK       KLIST
     C                   KFLD                    CLPCUS
     C                   KFLD                    CLPCCY
     C                   KFLD                    CLPACD
     C                   KFLD                    CLPASN
     C                   KFLD                    CLPBRC
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
** #_INF
* PURGE OF VALUE DATE BALANCES *
* NEW ACCOUNT ASSOCIATIONS *
* DAILY *
* DAILY - POST CAPITALIZATION *
* ANWD *
* ANWD - POST CAPITALIZATION *
* INPUT CYCLE *
