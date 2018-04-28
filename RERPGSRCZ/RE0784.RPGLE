     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Retail Advice report for Account Transfer')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE0784 - Midas Retail Advice Detail Report for Account       *
      *           Transfer                                            *
      *                                                               *
      *  Function:  This new program will print the details  from the *
      *             Account Transfer Manual Input file.               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. BUG27563           Date 27Apr10               *
      *  Prev Amend No. CAP204  *CREATE    Date 23Feb10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG27563 - REC78 sequence 00001 ended in error.  GLHATMPD    *
      *             should be accessed by transaction reference and   *
      *             execution date.                                   *
      *  CAP204 - Retail Account Transfer                             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Spool file for Retail advices from Account Transfer
      *
     FRE0782P8  O    E             PRINTER
     F                                     USROPN
     F                                     INFDS(SPOOL8)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
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
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D PSDS           SDS
      ** Program Status Data Structure - gives Job/Workstation name and
      ** User ID
 
     D  JOB                  244    253
     D  WSID                 244    246
     D  USER                 254    263
 
     D SPOOL8          DS
      **  DS for ZSFILE data
     D  SFILE8                83     92
     D  SFNUM8               123    124B 0
 
     D DSEXRT          DS
     D  DSINT13                1      3A
     D  DSINT45                4      5A
     D  DSDEC12                6      7A
     D  DSDEC38                8     13A
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PRTCD           S              7A
     D PBRNM           S             30A
     D PRUNA           S              7A
     D PACNO           S             10A
     D PVALA           S              7A
     D PDRCR           S              1A
     D POPTN           S              7A
     D PCUST           S              6A
     D PCCY            S              3A
     D PACOD           S             10A
     D PACSQ           S              2A
     D PBRCA           S              3A
     D PREF            S             15A
     D PPAMT           S             13A
     D PPSTD           S              5P 0                                                  BUG27563
     D PFAMT           S             13A
     D PAMTAF          S             13A
     D PCCCY           S              3A
     D PCAMT           S             13A
     D PEXRT           S             13A
     D PLINE1          S             35A
     D PLINE2          S             35A
     D PLINE3          S             35A
     D PLINE4          S             35A
 
     D PFLD15          S             15P 0
     D PDECS           S              1P 0
     D PCODE           S              1A
     D POUT21          S             21A
 
     D @RUN            S              1A
     D WEXRT           S             13P 8
     D WCCY            S              3A
 
     D ZSEQ            S              5A
     D ZENT            S              3A
     D ZSNAM           S             10A
     D ZSNUM           S              6P 0
     D ZERR            S              1A
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C                   EXSR      SRMAIN
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
      *****************************************************************
      *                                                               *
      * SRMAIN - Move Parameter fields values to on reference exists  *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRMAIN        BEGSR
 
     C                   IF        PRTCD = *BLANKS
      ** Move parameter values to printer fields
     C                   EXSR      SRMOVVAL
      ** Call RE0046
     C                   EXSR      SRRE0046
      ** Print Details
     C                   EXSR      SRPRINT
 
     C                   ELSE
 
     C                   CLOSE     RE0782P8
     C                   ENDIF
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMOVVAL - Move parameter values to printer fields            *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRMOVVAL      BEGSR
 
     C                   EVAL      RBRNM = PBRNM
     C                   EVAL      RRUNA = PRUNA
 
     C                   IF        PDRCR = '0'
     C                   EVAL      *IN22 = *OFF
     C                   ELSE
     C                   EVAL      *IN22 = *ON
     C                   ENDIF
 
     C                   EVAL      RACCT = *BLANKS
     C                   IF        PACNO <> *BLANKS
     C                   EVAL      RACCT = PACNO
     C                   ELSE
     C                   EVAL      RACCT = PCUST + '-' + PCCY + '-' + PACOD
     C                                   + '-' + PACSQ
     C                   ENDIF
 
     C                   EVAL      RVALA = PVALA
     C                   EVAL      RTREF = PREF
     C                   EVAL      RCNA1 = PLINE1
     C                   EVAL      RCNA2 = PLINE2
     C                   EVAL      RCNA3 = PLINE3
     C                   EVAL      RCNA4 = PLINE4
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRE0046 - Call RE0046                                        *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRRE0046      BEGSR
 
     C                   CALL      'RE0046'      PLIST1
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'RE0046'
     C                   EVAL      DBKEY = '*PGM'
     C                   EVAL      DBPGM = 'RE0782P8'
     C                   EVAL      DBASE = 2
     C                   EXSR      *PSSR
 
     C                   ELSE
 
     C                   EVAL      RCCY = PCCY
     C                   EVAL      WCCY = RCCY
     C                   EXSR      SRCURR
     C                   MOVE      PAMTAF        PFLD15
     C                   EXSR      SRAMOUNT
     C                   EVALR     RPAMT = POUT21
 
     C                   EVAL      RFEEC = PCCY
     C                   EVAL      WCCY  = RFEEC
     C                   EXSR      SRCURR
     C                   MOVE      PFAMT         PFLD15
     C                   EXSR      SRAMOUNT
     C                   EVALR     RFEEA = POUT21
     C                   EVAL      *IN49 = *ON
     C                   IF        PFLD15 = 0
     C                   EVAL      *IN49 = *OFF
     C                   ENDIF
 
     C                   EVAL      *IN50 = *OFF
     C                   IF        PCCY <> PCCCY
     C                   EVAL      *IN50 = *ON
     C                   MOVE      PEXRT         PFLD15
     C                   EVAL      A6NBDP = 8
     C                   EXSR      SRAMOUNT
     C                   EVALR     REXRT = POUT21
 
     C                   EVAL      RECCY = PCCCY
     C                   EVAL      WCCY  = RECCY
     C                   EXSR      SRCURR
     C                   MOVE      PCAMT         PFLD15
     C                   EXSR      SRAMOUNT
     C                   EVALR     REAMT = POUT21
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPRINT  - Print Details                                      *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRPRINT       BEGSR
 
     C                   WRITE     RE0782D8
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCURR   - Subroutine to get currency details                *
      *                                                               *
      *****************************************************************
 
     C     SRCURR        BEGSR
 
      ** Retrieve decimal positions for given currency
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    WCCY
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = 3
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY  = WCCY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAMOUNT - Subroutine to convert amount from number format   *
      *             to reporting format                               *
      *                                                               *
      *****************************************************************
 
     C     SRAMOUNT      BEGSR
 
     C                   CALL      'ZSEDIT'
     C                   PARM                    PFLD15
     C                   PARM      A6NBDP        PDECS
     C                   PARM      'J'           PCODE
     C                   PARM      *BLANKS       POUT21
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initialisation subroutine                            *
      *                                                               *
      * Called by: Automatically called                               *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      ** Return Code
     C                   PARM                    PRTCD
      ** Branch Name
     C                   PARM                    PBRNM
      ** Rundate
     C                   PARM                    PRUNA
      ** Debit/Credit Indicator
     C                   PARM                    PDRCR
      ** Retail Account No
     C                   PARM                    PACNO
      ** Value Date
     C                   PARM                    PVALA
      ** Customer number
     C                   PARM                    PCUST
      ** Currency
     C                   PARM                    PCCY
      ** Account code
     C                   PARM                    PACOD
      ** Account sequence
     C                   PARM                    PACSQ
      ** Branch
     C                   PARM                    PBRCA
      ** Transaction reference
     C                   PARM                    PREF
      ** Posting amount
     C                   PARM                    PPAMT
      ** Posting date                                                                       BUG27563
     C                   PARM                    PPSTD                                      BUG27563
      ** Customer Name and Address Line 1
     C                   PARM                    PLINE1
      ** Customer Name and Address Line 2
     C                   PARM                    PLINE2
      ** Customer Name and Address Line 3
     C                   PARM                    PLINE3
      ** Customer Name and Address Line 4
     C                   PARM                    PLINE4
 
     C     PLIST1        PLIST
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    PCUST
     C                   PARM                    PCCY
     C                   PARM                    PACOD
     C                   PARM                    PACSQ
     C                   PARM                    PBRCA
     C                   PARM                    PREF
     C                   PARM                    PPAMT
     C                   PARM                    PPSTD                                      BUG27563
     C                   PARM      *BLANKS       PFAMT
     C                   PARM      *BLANKS       PAMTAF
     C                   PARM      *BLANKS       PCCCY
     C                   PARM      *BLANKS       PCAMT
     C                   PARM      *BLANKS       PEXRT
      *
     C                   OPEN      RE0782P8
      *
      ** Call ZSFILE to log spool file details for report
      *
     C                   Z-ADD     SFNUM8        ZSNUM
     C                   MOVEL     SFILE8        ZSNAM
     C                   CALL      'ZSFILE'
     C                   PARM                    ZSEQ
     C                   PARM      *BLANKS       ZENT
     C                   PARM                    ZSNAM
     C                   PARM                    ZSNUM
     C                   PARM      *BLANKS       ZERR
      *
      ** If error perform database error handling and exit program
      *
     C                   IF        ZERR = 'Y'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'ZSFILE'
     C                   EVAL      DBKEY  = 'RE0782P8'
     C                   EVAL      DBPGM  = 'RE0782P8'
     C                   EVAL      DBASE  = 1
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
 
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
     C                   END
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
