     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL FATCA Closed Accounts Balances')              *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  GL000613 - Midas GL FATCA Closed Accounts Balances           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. MD042828           Date 15Dec16               *
      *  Prev Amend No. MD042683           Date 22Nov16               *
      *                 CGL154  *CREATE    Date 13Oct14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD042828 - Daily Accounts Closed/Transferred File cannot     *
      *             capture other FATCA Accounts                      *
      *  MD042683 - Daily Accounts Closed/Transferred File cant store *
      *             reported closed/transferred Accounts under        *
      *             Joint Account Members                             *
      *  CGL154 - FATCA Reporting.                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR       - Initialise                                    *
      *  *PSSR        - Error processing                              *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas GL FATCA Closed Accounts Balances
     FGLFCABPD  O    E             DISK    INFSR(*PSSR)

      ** Midas GL Account Master Details
     F***ACCNTL16  IF   E           K DISK    INFSR(*PSSR)                                  MD042683
     FACCNTL18  IF   E           K DISK    INFSR(*PSSR)                                     MD042683

      ** Midas RE Retail History File
     FREHISL0   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(R1)

     FSDJACCL0  IF   E           K DISK    INFSR(*PSSR)                                     MD042683
                                                                                            MD042683
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+

      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)

      ** Data Structures used by Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Data Structures used by Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+

      ** Variables used

     D WRUND           S              5  0
     D Retcd           S              7A
     D Option          S              7A
     D WHIS            S              5  0

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

      ** Read the first record from Account Details File

     C*****WRUND         SETLL     ACCNTL16                                                 MD042683
     C*****WRUND         READE     ACCNTL16                                                 MD042683
     C     WRUND         SETLL     ACCNTL18                                                 MD042683
     C     WRUND         READE     ACCNTL18                                                 MD042683

      ** Do while end of file not reached.

     C**********         DOW       NOT %EOF(ACCNTL16)                                       MD042683
     C                   DOW       NOT %EOF(ACCNTL18)                                       MD042683

     C                   EVAL      CBCNUM = CNUM
     C                   EVAL      CBCURR = CCY
     C                   EVAL      CBBRCH = BRCA
     C                   EVAL      CBACOD = ACOD
     C                   EVAL      CBSEQ  = ACSQ
     C                   EVAL      CBDACC = DACC
     C                   EVAL      CCACHL = CNUM                                            MD042683
     C                   EVAL      CCACTY = 'CUST'                                          MD042683
     C                   EVAL      CCTYPE = 'RECLD'                                         MD042828
     C                   EVAL      CCTRNN = *BLANKS                                         MD042683
     C                   EVAL      CCJANO = *BLANKS                                         MD042683
     C                   EVAL      CCJATP = *BLANKS                                         MD042683

      ** Get last history record to get previous day balance before closing account

     C                   EVAL      WHIS = *HIVAL

     C     WACCT1        SETGT     REHISL0
     C     WACCT2        READPE    REHISL0

     C                   IF        %FOUND (REHISL0)
     C                   EVAL      CBAMNT = R1HISB
     C                   ELSE
     C                   EVAL      CBAMNT = *ZERO
     C                   ENDIF

     C                   WRITE     GLFCABD0

                                                                                            MD042683
     C                   EVAL      CBACOD = 0                                               MD042683
     C                   EVAL      CBSEQ  = 0                                               MD042683
     C                   EVAL      JCJANO = CBCNUM                                          MD042683
     C     JCJANO        SETLL     SDJACCL0                                                 MD042683
     C     JCJANO        READE     SDJACCL0                                                 MD042683
                                                                                            MD042683
     C                   DOW       NOT %EOF(SDJACCL0)                                       MD042683
     C                   EVAL      CCJANO = JCJANO                                          MD042683
     C                   EVAL      CBCNUM = JCCUST                                          MD042683
     C                   IF        JCCUST <> *BLANKS                                        MD042683
     C                   EVAL      CCACHL = JCCUST                                          MD042683
     C                   EVAL      CCACTY = 'CUST'                                          MD042683
     C                   ELSE                                                               MD042683
     C                   EVAL      CCACHL = JCNAHO                                          MD042683
     C                   EVAL      CCACTY = 'NAHO'                                          MD042683
     C                   ENDIF                                                              MD042683
     C                   EVAL      CCJATP = 'M'                                             MD042683
     C                   WRITE     GLFCABD0                                                 MD042683
                                                                                            MD042683
     C                   EVAL      CCJANO = *BLANKS                                         MD042683
     C                   EVAL      CCACHL = *BLANKS                                         MD042683
     C                   EVAL      CCACTY = *BLANKS                                         MD042683
     C                   EVAL      CCJATP = *BLANKS                                         MD042683
                                                                                            MD042683
     C     JCJANO        READE     SDJACCL0                                                 MD042683
     C                   ENDDO                                                              MD042683

      ** Read next record.

     C*****WRUND         READE     ACCNTL16                                                 MD042683
     C     WRUND         READE     ACCNTL18                                                 MD042683

     C                   ENDDO

     C                   MOVE      *ON           *INLR

      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  'GL000613'
     C                   OUT       LDA

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       Retcd
     C                   PARM      '*FIRST '     Option
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database error

     C     Retcd         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     Option        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      WRUND  =  BJRDNB

      ** Initialize enhancements indicator


     C     WACCT1        KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C                   KFLD                    WHIS

     C     WACCT2        KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBFILE = 'GLFCABPD'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA

     C                   DUMP

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   RETURN

     C                   ENDSR
      *****************************************************************
