     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Determine Today's Debit Totals')              *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100616 - Determine Today's Debit Totals                    *
      *                                                               *
      *  Function:  This program determines the count and value       *
      *             of debits made to an account today.               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. AR976539           Date 25Feb13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. CAP204             Date 03Mar10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 245968             Date 26Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 217028             Date 24Apr03               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR976539 - Purge request fails. CAP204 should be reversed.   *
      *             (Child:AR976540)                                  *
      *  CAP204 - Retail Account Transfer                             *
      *  245968 - Change length of variables pertaining to account    *
      *           codes to 10.                                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  217028 - Error with sweeping gross                           *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     F***ACPO1**   IF   F  400    18AIDISK    KEYLOC(2)                                       245968
     F***ACPO1     IF   F  400    24AIDISK    KEYLOC(2)                                245968 CAP204
     F***GLACPML0  IF   F  400    24AIDISK    KEYLOC(2)                              CAP204 AR976539
     FACPO1     IF   F  620    24AIDISK    KEYLOC(2)                                        AR976539
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
      * Key to A/c postings file
     D                 DS
     D*ACPOK***                1     18                                                       245968
     D ACPOK                   1     24                                                       245968
     D**CUS*****               1      6  0                                                    CSD027
     D  CUS                    1      6A                                                      CSD027
     D  CCY                    7      9
     D**ACD*****              10     13  0                                                    245968
     D**ASN*****              14     15  0                                                    245968
     D**BRC******             16     18                                                       245968
     D  ACD                   10     19  0                                                    245968
     D  ASN                   20     21  0                                                    245968
     D  BRC                   22     24                                                       245968
 
 
      * Input Entry
     D I_ENTRY       E DS                  EXTNAME(APOSTPD)
     D                                     PREFIX(E_)
 
 
     I***ACPO1     NS                                                                         CAP204
     I***GLACPML0  NS                                                                CAP204 AR976539
     I**********                        1  400  INREC                                       AR976539
     IACPO1     NS                                                                          AR976539
     I                                  1  620  INREC                                       AR976539
 
 
      * Source a/c ID ( = Child a/c ID)
 
     C                   MOVEL     I_CBRC        BRC
     C                   MOVEL     I_CCUS        CUS
     C                   MOVEL     I_CCCY        CCY
     C                   MOVEL     I_CACD        ACD
     C                   MOVEL     I_CASN        ASN
 
     C                   Z-ADD     *zero         O_TVDR
     C                   Z-ADD     *zero         O_TCDR
 
      * Read first child a/c entry
 
     C*****ACPOK         SETLL     ACPO1                                                      CAP204
     C*****ACPOK         SETLL     GLACPML0                                          CAP204 AR976539
     C     ACPOK         SETLL     ACPO1                                                    AR976539
 
     C                   EXSR      READ_ENTRY
 
 
      * Do until more more child a/c entries are read
 
     C     *IN60         DOWEQ     '0'
 
      * If entry has not yet been posted
      * Accumulate today's dr totals
 
     C                   TESTB     '4'           E_PRIN               99        *
 
     C     *IN99         IFEQ      '1'
     C     E_SPOS        IFNE      '  GE-CX'
     C     E_SPOS        ANDNE     '  GE-SF'                                    217028
     C     E_SPOS        ANDNE     '  GE-IC'                                    217028
     C     E_DRCR        ANDEQ     0
     C                   ADD       E_PSTA        O_TVDR
     C                   ADD       1             O_TCDR
     C                   ENDIF
     C                   ENDIF
 
      * Read next child a/c entry
 
     C                   EXSR      READ_ENTRY
 
     C                   ENDDO
 
      * If today's debit totals are exceeded
 
     C     O_TVDR        IFGT      I_MDVD
     C     *zero         ANDNE     I_MDVD
     C     O_TCDR        ORGT      I_MDCD
     C     *zero         ANDNE     I_MDCD
     C                   MOVEL     'Y'           I_Max_Dr_Excd
     C                   ELSE
     C                   MOVEL     'N'           I_Max_Dr_Excd
     C                   ENDIF
 
 
     C                   RETURN
 
      /SPACE 5
      ********************************************************************
      * Read an entry
      ********************************************************************
     C     READ_ENTRY    BEGSR
 
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
      * Child branch
      * Child customer
      * Child currency
      * Child a/c code
      * Child a/c seq.
     C                   PARM                    I_CBRC            3
     C**********         PARM                    I_CCUS            6 0                        CSD027
     C                   PARM                    I_CCUS            6                          CSD027
     C                   PARM                    I_CCCY            3
     C**********         PARM                    I_CACD            4 0                        245968
     C                   PARM                    I_CACD           10 0                        245968
     C                   PARM                    I_CASN            2 0
 
      * Maximum Debit Value in a Day
      * Maximum Debit Count in a Day
     C                   PARM                    I_MDVD           15 0
     C                   PARM                    I_MDCD            3 0
 
      * OUTPUTS
      * Maximum Debit Value/Debit Count in a Day Exceeded
     C                   PARM                    I_Max_Dr_Excd     1
      * Today's total dr value
      * Today's total dr count
     C                   PARM                    O_TVDR           15 0
     C                   PARM                    O_TCDR            3 0
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
