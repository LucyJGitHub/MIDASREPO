     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Populate CLOANCL Orig. Branch')               *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LE000400 - Midas LE Populate CLOANCL Originating branch      *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD054707 *CREATE   Date 06Nov19               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD054707 - CER050 Comp LEC06A 00010 failed during COB Run    *
      *                                                               *
      *****************************************************************

     FCLOANLB   UF   E           K DISK

      ** Upd ORBR Field from Customer Lending Loan Printer File
     FLE000400P1O    E             PRINTER USROPN
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL1)

      ** Upd ORBR Field from Customer Lending Loan Printer File (Audit)
     FLE000400AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

      ** File Information Data Structure for LE000400P1
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
     D  OflLn1               188    189B 0
     D  PrtLn1               367    368B 0

      ** File Information Data Structure for LE000400AU
     D SPOOLU          DS
     D  PSFileU               83     92
     D  PSFNumU              123    124B 0

     D SDMMOD        E DS                  EXTNAME(SDMMODPD)

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D PRTCD           S              7A   INZ(*Blanks)
     D POPTN           S              7A   INZ(*Blanks)
     D Recursive       S              1A
     D RqdLn1          S              3P 0
     D DifLn1          S              4P 0
     D WorkNum         S              5P 0
     D WError          S              1
     D NewPage         S              1

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *

      *****************************************************************
      *                                                               *
      * M A I N   P R O C E D U R E                                   *
      *                                                               *
      *****************************************************************

      ** Initialise Report Work fields
     C                   EVAL      RqdLn1  = 0
     C                   EVAL      DifLn1  = 0
     C                   EVAL      PRTOTD  = 0
     C                   EVAL      PrtLn1  = 0
     C                   EVAL      WorkNum = 0
     C                   EVAL      WError = 'N'
     C                   EVAL      NewPage = 'N'

     C                   WRITE     HEADP1

     C                   IF        BGMBIN = 'Y'

     C     *LOVAL        SETLL     CLOANLB
     C                   READ      CLOANLB

     C                   DOW       NOT %EOF(CLOANLB)

     C                   IF        ORBR = *Blanks
     C                   EVAL      WorkNum = WorkNum + 1
     C                   EVAL      ORBR = BRCA

     C                   EXSR      SRPRNT

     C                   UPDATE    CLOANCLF
     C                   ENDIF

     C                   READ      CLOANLB

     C                   ENDDO

      ** When EOF, write trailer
     C                   IF        %EOF(CLOANLB)

     C                   EVAL      RqdLn1 = 8
     C                   EXSR      SRCHKLIN

     C                   WRITE     TRAILP1

     C                   ENDIF
     C                   ENDIF

     C                   EXSR      SRAUDT

     C                   SETON                                        LR
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAUDT - Audit Processing                                     *
      *                                                               *
      * Called by: Main Processing, *INZSR                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRAUDT        BEGSR

     C                   WRITE     HEADAU

     C                   IF        WError = 'Y'
     C                   WRITE     DBERROR
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        WorkNum > 0
     C                   Z-ADD     WorkNum       RCOUNT
     C                   WRITE     CONTROL
     C                   ELSE
     C                   WRITE     NODTLS
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCHKLIN - Checks for printer file overflow condition         *
      *                                                               *
      * Called by: SRPROC, SRPRNT                                     *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRCHKLIN      BEGSR

     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1

     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   EVAL      NewPage = 'Y'
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPRNT - Detail Printing                                      *
      *                                                               *
      * Called by: SRPROC                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRPRNT        BEGSR

      ** Check for overflow
     C                   EVAL      RqdLn1 = 14
     C                   EXSR      SRCHKLIN

      ** Put details to printer fields.

     C                   EVAL      PRLOAN = LNRF
     C                   EVAL      PRORBR = ORBR

     C                   EVAL      PRTOTD = PRTOTD + 1

      ** Write Detail
     C                   WRITE     DETAIL

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************

     C     *INZSR        BEGSR

      ** Initialize program name

     C                   MOVEL     'LE000400'    DBPGM

      ** Access Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        PRTCD <> *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     POPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access Midas modules details
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDMMOD        PARM      SDMMOD        DSFDY

     C                   IF        PRTCD <> *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     POPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   OPEN      LE000400P1

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  -   Program exception error routine                    *
      *            Called automatically if a program error occurs,    *
      *            or directly by the program code using EXSR.        *
      *            This subroutine DUMPs the program just once.       *
      *                                                               *
      * Called by: *INZSR                                             *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   IF        Recursive = *BLANK
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

      *****************************************************************
