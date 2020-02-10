     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Extract Program for CRS Enquiry')             *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000559 - Midas SD Extract Program for CRS Enquiry          *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. MD052566           Date 24Jan19               *
      *  Prev Amend No. CGL177  *CREATE    Date 11Jan16               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD052566 - Indicia "CRS Agreement" was not retrieved from    *
      *             the country of tax code table                     *
      *  CGL177 - CRS Reporting Phase 2                               *
      *                                                               *
      *****************************************************************
      **
     FSDCRSTL0  IF   E           K DISK

      **
     FSDCREFPD  O    E             DISK

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

     C     *LOVAL        SETLL     SDCRSTL0
     C                   READ      SDCRSTL0

     C                   DOW       NOT %EOF(SDCRSTL0)

      ** Exclude all domestic country

     C                   IF        BJCNCD <> CDCTRY
     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C**********         PARM      DS_A8LCCD     WPCTRT                                     MD052566
     C                   PARM      ##CTRY        WPCTRT                                     MD052566
     C                   PARM      CDCTRY        WPCTRR
     C     SDCTTX        PARM      SDCTTX        DSFDY

     C                   IF        PRTCD = '*NRF   '
     C                   EVAL      WPCTRR = *Blanks
     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C**********         PARM      DS_A8LCCD     WPCTRT                                     MD052566
     C                   PARM      ##CTRY        WPCTRT                                     MD052566
     C                   PARM                    WPCTRR
     C     SDCTTX        PARM      SDCTTX        DSFDY
     C                   ENDIF

     C                   IF        PRTCD = *BLANK
     C                   EVAL      F1CRSA = EWCRSA
     C                   ELSE
     C                   EVAL      F1CRSA = *Blanks
     C                   ENDIF

     C                   EVAL      F1CUST = BBCUST
     C                   EVAL      F1RNAM = BBCRNM
     C                   EVAL      F1RTOW = BBCRTN
     C                   EVAL      F1COLC = BBCOLC
     C                   EVAL      F1CTRY = CDCTRY
     C                   EVAL      F1TYPE = CRTYPE
     C                   EVAL      F1STYP = CRSTYP
     C                   EVAL      F1REPT = CDREPT
     C                   EVAL      F1CODO = CDCODO
     C                   EVAL      F1JACM = CDJACM
     C                   EVAL      F1MAIL = CDMAIL
     C                   EVAL      F1PHON = CDPHON
     C                   EVAL      F1REGP = CDRPAY
     C                   EVAL      F1TINS = CDTINS
     C                   EVAL      F1AUHO = CDAUHO

     C                   WRITE     SDCREFD0
     C                   ENDIF

     C                   READ      SDCRSTL0
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

     C                   MOVEL     'SD000559'    DBPGM

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
     C                   PARM                    Pkyst
     C     SDCUSD        PARM      SDCUSD        DSSDY

     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       Prtcd
     C                   PARM      '*KEY   '     Poptn
     C                   PARM      BBBRCD        PBRCH
     C     SDBRCH        PARM      SDBRCH        DSSDY
                                                                                            MD052566
      ** Access Customer detail of branch to retrieve country of loation                    MD052566
      *                                                                                     MD052566
     C                   MOVEL     *BLANKS       ##CTRY            3                        MD052566
     C                   IF        PRTCD = *Blanks                                          MD052566
     C                   CALL      'AOCUSTR0'                                               MD052566
     C                   PARM      *BLANKS       PRTCD                                      MD052566
     C                   PARM      '*KEY   '     POPTN                                      MD052566
     C                   PARM      DS_A8BICN     Pkey1                                      MD052566
     C                   PARM      *BLANKS       Pkyst                                      MD052566
     C     SDCUSD        PARM      SDCUSD        DSSDY                                      MD052566
                                                                                            MD052566
     C                   IF        PRTCD = *BLANKS                                          MD052566
     C                   EVAL      ##CTRY = BBCOLC                                          MD052566
     C                   ENDIF                                                              MD052566
     C                   ENDIF                                                              MD052566
                                                                                            MD052566

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
