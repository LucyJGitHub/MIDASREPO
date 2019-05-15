     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Extract Program for CRS Enquiry')             *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000560 - Midas SD Extract Program for CRS Enquiry          *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. MD039670           Date 26Jul16               *
      *  Prev Amend No. CGL177  *CREATE    Date 11Jan16               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD039670 - FATCA Housekeeping program                        *
      *  CGL177 - CRS Reporting Phase 2                               *
      *                                                               *
      *****************************************************************
      **
     FSDCRNTL0  IF   E           K DISK

      **
     FSDCRNNPD  O    E             DISK

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D DSSDY         E DS                  EXTNAME(DSSDY)

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDCUSD        E DS                  EXTNAME(SDCUSTPD)
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D                                     PREFIX(DS_)
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)                                MD039670

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D PRTCD           S              7    INZ(*Blanks)
     D POPTN           S              7    INZ(*Blanks)
     D PKEY1           S             10    INZ(*Blanks)
     D PKYST           S              7    INZ(*Blanks)
     D PBRCH           S              3
     D Recursive       S              1    INZ('N')
     D WPCTRT          S              2
     D WPCTRR          S              2

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

     C     *LOVAL        SETLL     SDCRNTL0
     C                   READ      SDCRNTL0

     C                   DOW       NOT %EOF(SDCRNTL0)
     C                   EVAL      PKEY1 = NHNAHO                                           MD039670
     C                   CALL      'AONAHOR0'                                               MD039670
     C                   PARM      *Blanks       PRTCD                                      MD039670
     C                   PARM      '*KEY   '     POPTN                                      MD039670
     C                   PARM                    PKEY1                                      MD039670
     C     SDNAHO        PARM      SDNAHO        DSSDY                                      MD039670
                                                                                            MD039670
     C                   IF        PRTCD = '*NRF'                                           MD039670
     C                             OR NHCHTP = 'D'                                          MD039670
     C                   READ      SDCRNTL0                                                 MD039670
     C                   ITER                                                               MD039670
     C                   ENDIF                                                              MD039670
                                                                                            MD039670

      ** Exclude all domestic country

     C                   IF        BJCNCD <> CNCTRY
     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DS_A8LCCD     WPCTRT
     C                   PARM      CNCTRY        WPCTRR
     C     SDCTTX        PARM      SDCTTX        DSFDY

     C                   IF        PRTCD = '*NRF   '
     C                   EVAL      WPCTRR = *Blanks
     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DS_A8LCCD     WPCTRT
     C                   PARM                    WPCTRR
     C     SDCTTX        PARM      SDCTTX        DSFDY
     C                   ENDIF

     C                   IF        PRTCD = *BLANK
     C                   EVAL      F2CRSA = EWCRSA
     C                   ELSE
     C                   EVAL      F2CRSA = *Blanks
     C                   ENDIF

     C                   EVAL      F2NAHO = NHNAHO
     C                   EVAL      F2NARN = NHNARN
     C                   EVAL      F2NATW = NHNATW
     C                   EVAL      F2COLC = NHCOLC
     C                   EVAL      F2CTRY = CNCTRY
     C                   EVAL      F2TYPE = NRTYPE
     C                   EVAL      F2STYP = NRSTYP
     C                   EVAL      F2REPT = CNREPT
     C                   EVAL      F2CODO = CNCODO
     C                   EVAL      F2JACM = CNJACM
     C                   EVAL      F2MAIL = CNMAIL
     C                   EVAL      F2PHON = CNPHON
     C                   EVAL      F2REGP = CNRPAY
     C                   EVAL      F2TINS = CNTINS

     C                   WRITE     SDCRNND0
     C                   ENDIF

     C                   READ      SDCRNTL0
     C                   ENDDO

     C                   SETON                                        LR
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************

     C     *INZSR        BEGSR

      ** Initialize program name

     C                   MOVEL     'SD000560'    DBPGM

      ** ACCESS BANK DETAILS

     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      ** DATABASE ERROR

     C                   IF        PRTCD <> *Blanks
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     POPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       Prtcd
     C                   PARM      '*KEY   '     Poptn
     C                   PARM      BJCUST        Pkey1
     C                   PARM      *Blanks       Pkyst
     C     SDCUSD        PARM      SDCUSD        DSSDY

     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       Prtcd
     C                   PARM      '*KEY   '     Poptn
     C                   PARM      BBBRCD        PBRCH
     C     SDBRCH        PARM      SDBRCH        DSSDY

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
