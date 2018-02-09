     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Determine Top A/c Balance and Overdraft')     *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100615 - Determine Top A/c Balance and Overdraft           *
      *                                                               *
      *  Function:  This program gets the top a/c balance and         *
      *             overdraft for a zero balancing/sweeping hierarchy.*
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR976539           Date 25Feb13               *
      *                 AR679670           Date 26Nov10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP204             Date 03Mar10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR976539 - Purge request fails. CAP204 should be reversed.   *
      *             (Child:AR976540)                                  *
      *  AR679670 - Apply fix 235082                                  *
      *  235082 - Adjust overdraft line correctly                     *
      *  CAP204 - Retail Account Transfer                             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     FRECMHLL2  IF   E           K DISK    INFSR(*PSSR)
     FGLACBTL0  IF   E           K DISK    INFSR(*PSSR)
     F***ACPO1     IF   F  400    18AIDISK    KEYLOC(2) USROPN                                CGL029
     F***ACPO1     IF   F  400    24AIDISK    KEYLOC(2) USROPN                         CGL029 CAP204
     F***GLACPML0  IF   F  400    24AIDISK    KEYLOC(2) USROPN                       CAP204 AR976539
     FACPO1     IF   F  620    24AIDISK    KEYLOC(2) USROPN                                 AR976539
     FRSACMTL6  IF   E           K DISK    USROPN
     F                                     PREFIX(E_)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
      ** Currency Details                                                                     235082
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                  235082
 
      * Key to A/c postings file
     D                 DS
     D*ACPOK****               1     18                                                       CGL029
     D ACPOK                   1     24                                                       CGL029
     D**CUS*****               1      6  0                                                    CSD027
     D  CUS                    1      6                                                       CSD027
     D  CCY                    7      9
     D**ACD*****              10     13  0                                                    CGL029
     D**ASN*****              14     15  0                                                    CGL029
     D**BRC*****              16     18                                                       CGL029
     D  ACD                   10     19  0                                                    CGL029
     D  ASN                   20     21  0                                                    CGL029
     D  BRC                   22     24                                                       CGL029
 
 
      * Input Entry
     D I_ENTRY       E DS                  EXTNAME(APOSTPD)
     D                                     PREFIX(E_)
 
 
     I***ACPO1     NS                                                                         CAP204
     I***GLACPML0  NS                                                                CAP204 AR976539
     I**********                        1  400  INREC                                       AR976539
     IACPO1     NS                                                                          AR976539
     I                                  1  620  INREC                                       AR976539
 
     IRSACMTPO      01
     I              PTDT                        E_PSTD
     I              VUDT                        E_VALD
     I              NRTD                        E_PNAR
     I              MVAM                        E_PSTA
     I              DORC                        E_DRCR
     I              XRFI                        E_XRFI
     I              XRFN                        E_XRFN
     IFFACMVDF      02
     I              PTDT                        E_PSTD
     I              VUDT                        E_VALD
     I              NRTD                        E_PNAR
     I              MVAM                        E_PSTA
     I              DORC                        E_DRCR
     I              XRFI                        E_XRFI
     I              XRFN                        E_XRFN
     I              NRTC                        ZZNRTC
     IAPOSTPDF      03
 
 
 
      * Get top account
 
     C                   Z-ADD     *ZERO         CLLEVL
     C     RECMHLK       CHAIN     RECMHLL2                           60
     C     *IN60         IFEQ      '1'
     C                   EVAL      X_ERMS = 'NO TOP ACCOUNT FOR HIERARCHY '
     C                                      + I_HISN
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Source a/c ID ( = Child a/c ID)
 
     C                   MOVEL     CLCBRC        BRC
     C                   MOVEL     CLCCUS        CUS
     C                   MOVEL     CLCCCY        CCY
     C                   MOVEL     CLCACD        ACD
     C                   MOVEL     CLCASN        ASN
 
      * Access account details
 
     C                   EXSR      ACS_ACCNT
 
     C                   Z-ADD     LDBL          O_TopBalance
     C**********         Z-ADD     ODLN          O_TopOverDft                                 235082
      ** Adjust overdraft limit with currency decimal places                                  235082
                                                                                              235082
     C                   CALLB     'ZAACSCURR'                                                235082
     C                   PARM                    CCY                                          235082
     C                   PARM                    SDCURR                                       235082
                                                                                              235082
     C                   SELECT                                                               235082
     C     A6NBDP        WHENEQ    0                                                          235082
     C     1             MULT      ODLN          WOdlnNum         15 0                        235082
     C     A6NBDP        WHENEQ    1                                                          235082
     C     10            MULT      ODLN          WOdlnNum                                     235082
     C     A6NBDP        WHENEQ    2                                                          235082
     C     100           MULT      ODLN          WOdlnNum                                     235082
     C     A6NBDP        WHENEQ    3                                                          235082
     C     1000          MULT      ODLN          WOdlnNum                                     235082
     C                   ENDSL                                                                235082
     C                   Z-ADD     WOdlnNum      O_TopOverDft                                 235082
 
      * If mode = new a/c associations, daily, or daily post capitalization
      *   Access opening ledger balance for child a/c
 
     C     I_MODE        IFEQ      'ASC'
     C     I_MODE        OREQ      '1  '
     C     I_MODE        OREQ      '1PC'
     C     GLACBLK       CHAIN     GLACBLF                            60        *
     C     *IN60         IFEQ      '0'
     C                   Z-ADD     LDBL          O_TopBalance
     C                   ENDIF
     C                   ENDIF
 
      * Read first child a/c entry
 
     C     I_MODE        IFEQ      'I/C'
     C     RSACMTK       SETLL     RSACMTL6
     C                   ELSE
     C*****ACPOK         SETLL     ACPO1                                                      CAP204
     C*****ACPOK         SETLL     GLACPML0                                          CAP204 AR976539
     C     ACPOK         SETLL     ACPO1                                                    AR976539
     C                   ENDIF
 
     C                   EXSR      READ_ENTRY
 
 
      * Do until more more child a/c entries are read
 
     C     *IN60         DOWEQ     '0'
 
      * Update balance
      * (if entry has not yet been posted)
 
     C     I_MODE        IFEQ      'I/C'
     C                   SETON                                        99
     C                   ELSE
     C                   TESTB     '4'           E_PRIN               99        *
     C                   ENDIF
 
     C     *IN99         IFEQ      '1'
     C     E_DRCR        IFEQ      0
     C                   ADD       E_PSTA        O_TopBalance
     C                   ELSE
     C                   SUB       E_PSTA        O_TopBalance
     C                   ENDIF
     C                   ENDIF
 
      * Read next child a/c entry
 
     C                   EXSR      READ_ENTRY
 
     C                   ENDDO
 
 
     C                   RETURN
 
      /SPACE 5
      ********************************************************************
      * Read an entry
      ********************************************************************
     C     READ_ENTRY    BEGSR
 
     C     I_MODE        IFEQ      'I/C'
 
     C                   SETOFF                                       010203
     C     RSACMTK       READE     RSACMTL6                               60    *
     C  N03              MOVEL     *BLANK        E_SPOS
     C  N03E_PNAR        IFEQ      *BLANK
     C                   EVAL      E_PNAR = E_TRYP + ' ' + E_TNMR
     C                   ENDIF
 
     C                   ELSE
 
     C*****ACPOK         READE     ACPO1                                  60    *             CAP204
     C*****ACPOK         READE     GLACPML0                               60    *    CAP204 AR976539
     C     ACPOK         READE     ACPO1                                  60                AR976539
     C  N60              MOVEL     INREC         I_ENTRY
     C     *IN60         DOWEQ     '0'
     C     E_RECI        ANDNE     'P'
     C*****ACPOK         READE     ACPO1                                  60    *             CAP204
     C*****ACPOK         READE     GLACPML0                               60    *    CAP204 AR976539
     C     ACPOK         READE     ACPO1                                  60                AR976539
     C  N60              MOVEL     INREC         I_ENTRY
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Access a/c details
      ********************************************************************
     C     ACS_ACCNT     BEGSR
 
     C     ACCNTK        CHAIN     ACCNTABF                           60        *
     C     *IN60         IFEQ      '1'
     C                   EVAL      X_ERMS = 'BAD TOP ACCOUNT ON HIERARCHY '
     C                                      + I_HISN
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      * Return code
      * Error Message
     C                   PARM                    X_RTCD
     C                   PARM                    X_ERMS
 
      * INPUTS
      * Mode
     C                   PARM                    I_MODE            3
      * Hierarchy ID
      * Hierarchy Shortname
     C                   PARM                    I_HIER            9 0
     C                   PARM                    I_HISN           10
 
      * OUTPUTS
      * Top a/c balance
      * Top a/c overdraft
     C                   PARM                    O_TopBalance     15 0
     C                   PARM                    O_TopOverDft     15 0
 
      * Open files
     C     I_MODE        IFEQ      'I/C'
     C                   OPEN      RSACMTL6
     C                   ELSE
     C**********         OPEN      ACPO1                                                      CAP204
     C**********         OPEN      GLACPML0                                          CAP204 AR976539
     C                   OPEN      ACPO1                                                    AR976539
     C                   ENDIF
 
      * Key lists
 
     C     RECMHLK       KLIST
     C                   KFLD                    I_HIER
     C                   KFLD                    CLLEVL
     C     ACCNTK        KLIST
     C                   KFLD                    CUS
     C                   KFLD                    CCY
     C                   KFLD                    ACD
     C                   KFLD                    ASN
     C                   KFLD                    BRC
     C     GLACBLK       KLIST
     C                   KFLD                    CUS
     C                   KFLD                    CCY
     C                   KFLD                    ACD
     C                   KFLD                    ASN
     C                   KFLD                    BRC
     C     RSACMTK       KLIST
     C                   KFLD                    BRC
     C                   KFLD                    CUS
     C                   KFLD                    CCY
     C                   KFLD                    ACD
     C                   KFLD                    ASN
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
