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
      *  Last Amend No. MD054707 *CREATE   Date 06Nov19               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD054707 - CER050 Comp LEC06A 00010 failed during COB Run    *
      *                                                               *
      *****************************************************************

     FCLOANLB   UF   E           K DISK

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

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

     C                   IF        BGMBIN = 'Y'

     C     *LOVAL        SETLL     CLOANLB
     C                   READ      CLOANLB

     C                   DOW       NOT %EOF(CLOANLB)

     C                   IF        ORBR = *Blanks
     C                   EVAL      ORBR = BRCA
     C                   UPDATE    CLOANCLF
     C                   ENDIF

     C                   READ      CLOANLB

     C                   ENDDO

     C                   ENDIF

     C                   SETON                                        LR
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************

     C     *INZSR        BEGSR

      ** Initialize program name

     C                   MOVEL     'LE000400'    DBPGM

      ** Access Midas modules details
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDMMOD        PARM      SDMMOD        DSFDY

     C                   IF        PRTCD <> *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     POPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF

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
