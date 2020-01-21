     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Payment Amounts Collection')                  *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000612 - Midas GL Payment Amounts Collection               *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD054989           Date 16Jan20               *
      *  Prev Amend No. MD052581           Date 23Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 MD044378           Date 03Mar17               *
      *                 MD043672           Date 19Jan17               *
      *                 CGL154  *CREATE    Date 13Oct14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054989 - Interest Capitalisation not included in report    *
      *  MD052581 - Missing Credit capitalized interests of Retail    *
      *             A/Cs in file GLCAPAPD                             *
      *  MD046248 - Finastra Rebranding                               *
      *  MD044378 - Capitalised interest is being reported as payment *
      *             by the alternate account                          *
      *  MD043672 - Do not capture debit payments                     *
      *  CGL154 - FATCA Reporting.                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    LR         Last Record Indicator (program termination)     *
      *    U7 and U8  DB Error Processing Indicator                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  Main Process - This routine reads through all the Events     *
      *              with Transactions types.                         *
      *  SRIdTranType - This routine identifies Payment Type defined  *
      *                 for the Transaction Type                      *
      *  SRWrite - This routine adds a record on the Customer         *
      *            Activity and Payment Amounts File                  *
      *                                                               *
      *  *INZSR - Initialise                                          *
      *  *PSSR - Error processing                                     *
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
 
      ** Midas Retail Transaction Types Update index
     FSDRETRL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas GL Accounts postings - post 1
     FGLACPOL1  IF   F  620    18AIDISK    INFSR(*PSSR)
 
      ** Midas GL Non-Retail Manual Postings
     FMANPOL3   IF   F  620    18AIDISK    INFSR(*PSSR)
 
     FSDJACCL0  IF   E           K DISK    INFSR(*PSSR)
                                                                                            MD044378
     FGLGEICL2  IF   E           K DISK    INFSR(*PSSR)                                     MD044378
     F                                     PREFIX(S_)                                       MD044378
 
      ** Midas GL FATCA Customer Activity/Payment Amounts File
     FGLCAPAPD  UF A E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work variables
     D WTrat           S              5
     D WFTPT           S              1
     D WRun            S              1
     D WRCUSD          S              6
     D WRACOD          S             10
     D WRACSQ          S              2
     D WRVALD          S              5S 0
     D WACN2           S             10                                                     MD044378
     D WWRITE          S              1                                                     MD044378
     D KAcno           S             10S 0                                                  MD044378
     D KPnar           S             30A                                                    MD044378
     D KPsta           S             13P 0                                                  MD044378
 
      ** Work DS
     DACPOKDS          DS           620
     D ACCNUM                  2      7
     D ACTRAT                 39     43
     D ACBRCA                103    105
     D ACCCY                   8     10
     D ACACOD                590    599
     D ACACSQ                 15     16
     D ACPSTA                 74     80P 0
     D ACDRCR                 81     81
     D ACVALD                 36     38P 0
     D ACACNO                 23     32S 0                                                  MD044378
     D ACPNAR                 44     73                                                     MD044378
     D ACSPOS                 96    102                                                     MD044378
 
      ** Data Structure used by GLCAPAPD
     D GLCAPA        E DS                  EXTNAME(GLCAPAPD)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Read through all the Events with Transactions types from GLACPOL1
 
     C     *LOVAL        SETLL     GLACPOL1
     C                   READ      GLACPOL1      ACPOKDS
 
     C                   DOW       NOT %EOF(GLACPOL1)
 
      ** Initialize the Work fields for Transactions & FATCA Payment Types
 
     C                   EVAL      WTrat = *BLANKS
     C                   EVAL      WFTPT = *BLANKS
 
     C                   IF        ACTRAT <> *ZERO AND ACTRAT <> *BLANKS
     C                   MOVE      ACTRAT        WTrat
 
      ** Check Transaction Type, execute SRIdTranType
 
     C                   EXSR      SRIdTranType
 
      ** If Payment type equal to "D-Dividend,I-Interest,G-Gross Proceeds /
      **    Redemptions or O-Other", execute SRWrite
 
     C                   IF        WFTPT = 'D' OR WFTPT = 'I' OR
     C                             WFTPT = 'G' OR WFTPT = 'O'
                                                                                            MD044378
     C                   EVAL      WWRITE = 'Y'                                             MD044378
     C                   IF        ACACNO = *ZERO                                           MD044378
     C                   EVAL      WWRITE = ' '                                             MD044378
     C                   ENDIF                                                              MD044378
                                                                                            MD044378
     C                   IF        %SUBST(ACPNAR:1:8) = 'Interest'                          MD044378
     C                             AND ACSPOS = '  GE-IC'                                   MD044378
                                                                                            MD044378
     C                   EVAL      WACN2 = %SUBST(ACPNAR:10:10)                             MD044378
     C                   IF        WACN2 <> *Blanks                                         MD044378
     C                   MOVE      WACN2         Kacno                                      MD044378
     C                   IF        KACNO <> ACACNO                                          MD044378
     C                             AND ACACNO <> *ZERO                                      MD044378
     C                   EVAL      KPnar = 'Interest'                                       MD044378
     C                   EVAL      KPsta = ACPSTA                                           MD044378
     C     KGeic         CHAIN     GLGEICL2                                                 MD044378
     C                   IF        %FOUND(GLGEICL2)                                         MD044378
     C                   EVAL      WWRITE = ' '                                             MD044378
     C                   ENDIF                                                              MD044378
     C                   ENDIF                                                              MD044378
     C                   ENDIF                                                              MD044378
     C                   ENDIF                                                              MD044378
                                                                                            MD044378
     C                   IF        WWRITE = 'Y'                                             MD044378
     C                   EXSR      SRWrite
     C                   ENDIF                                                              MD044378
 
     C                   ELSE                                                               MD052581
     C                   IF        WFTPT = ' '                                              MD052581
     C                             AND ACACNO <> 0                                          MD052581
     C                             AND ACTRAT = '91060'                                     MD052581
     C                             AND ACSPOS = '  GE-IC'                                   MD052581
     C                             AND ACDRCR = '1'                                         MD052581
     C                   EVAL      WFTPT = 'I'                                              MD054989
     C                   EXSR      SRWrite                                                  MD052581
     C                   ENDIF                                                              MD052581
     C                   ENDIF
 
     C                   ENDIF
 
     C                   READ      GLACPOL1      ACPOKDS
     C                   ENDDO
 
      ** Read through all Debit Journal Entries from
 
     C     *LOVAL        SETLL     MANPOL3
     C                   READ      MANPOL3       ACPOKDS
 
     C                   DOW       NOT %EOF(MANPOL3)
 
      ** Initialize the Work fields for Transactions & FATCA Payment Types
 
     C                   EVAL      WTrat = *BLANKS
     C                   EVAL      WFTPT = *BLANKS
 
     C                   IF        ACTRAT <> *ZERO AND ACTRAT <> *BLANKS
     C                   MOVE      ACTRAT        WTrat
 
      ** Check Transaction Type, execute SRIdTranType
 
     C                   EXSR      SRIdTranType
 
      ** If Payment type equal to "D-Dividend,I-Interest,G-Gross Proceeds /
      **    Redemptions or O-Other", execute SRWrite
 
     C                   IF        WFTPT = 'D' OR WFTPT = 'I' OR
     C                             WFTPT = 'G' OR WFTPT = 'O'
 
     C                   EXSR      SRWrite
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   READ      MANPOL3       ACPOKDS
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRIdTranType - Identifies Payment Type defined for the        *
      *                Transaction Type                               *
      *                                                               *
      *****************************************************************
 
     C     SRIdTranType  BEGSR
 
      ** Access Transaction Types to get FATCA Payment Type
 
     C     WTrat         CHAIN     @A1RECW
 
     C                   IF        %FOUND(SDRETRL0)
 
     C                   EVAL      WFTPT = A1FTPT
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWrite - Write Customer Activity and Payment Amounts File    *
      *                                                               *
      *****************************************************************
 
     C     SRWrite       BEGSR
 
     C                   CLEAR                   GLCAPA
 
     C                   MOVEL     ACCNUM        CPCUSD
     C                   MOVEL     ACCNUM        WRCUSD
     C                   MOVEL     ACACOD        WRACOD
     C                   MOVEL     ACACSQ        WRACSQ
     C                   EVAL      WRVALD = ACVALD
 
     C                   EVAL      CPACNO = (ACBRCA + WRCUSD + ACCCY +
     C                                       WRACOD + WRACSQ)
     C                   EVAL      CPCCY = ACCCY
     C**********         IF        ACDRCR = '0'                                             MD043672
     C**********         EVAL      CPPSTA = ACPSTA * (-1)                                   MD043672
     C**********         ELSE                                                               MD043672
     C                   IF        ACDRCR = '1'                                             MD043672
     C                   EVAL      CPPSTA = ACPSTA
     C**********         ENDIF                                                              MD043672
     C                   MOVEL     WRVALD        CPVDAT
     C                   MOVEL     ACTRAT        CPTYPE
     C                   IF        CPTYPE = *Blanks
     C                   EVAL      CPTYPE = 'RECAP'
     C                   ENDIF
     C**********         EVAL      CPPAYT = A1FTPT                                          MD054989
     C                   EVAL      CPPAYT = WFTPT                                           MD054989
     C                   EVAL      CPBRCH = ACBRCA
 
     C                   EVAL      CPJANO = *BLANKS
     C                   EVAL      CPACHL = CPCUSD
     C                   EVAL      CPACTY = 'CUST'
     C                   EVAL      CPJATP = ' '
     C
     C                   WRITE     GLCAPAD0
 
     C                   EVAL      JCJANO = CPCUSD
     C     JCJANO        SETLL     SDJACCL0
     C     JCJANO        READE     SDJACCL0
 
     C                   DOW       NOT %EOF(SDJACCL0)
     C                   EVAL      CPJANO = JCJANO
     C                   EVAL      CPCUSD = JCCUST
     C                   IF        JCCUST <> *BLANKS
     C                   EVAL      CPACHL = JCCUST
     C                   EVAL      CPACTY = 'CUST'
     C                   ELSE
     C                   EVAL      CPACHL = JCNAHO
     C                   EVAL      CPACTY = 'NAHO'
     C                   ENDIF
     C                   EVAL      CPJATP = 'M'
     C                   WRITE     GLCAPAD0
 
     C     JCJANO        READE     SDJACCL0
     C                   ENDDO
     C                   ENDIF                                                              MD043672
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C                   CLEAR                   GLCAPA
                                                                                            MD044378
     C     KGeic         KLIST                                                              MD044378
     C                   KFLD                    KAcno                                      MD044378
     C                   KFLD                    KPnar                                      MD044378
     C                   KFLD                    KPsta                                      MD044378
 
 
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
     C                   ENDSR
 
