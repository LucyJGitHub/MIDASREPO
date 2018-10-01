     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('TAKE-ON - Initialise New Fields on SDCLNDPD')          *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  SDCLE13405 - Initialise New Fields on SDCLNDPD               *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. CLE071             Date 18Jul18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE134  *CREATE    Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE071 - Value Dating of Rate Changes to Fees (Recompile)    *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************
     FSDCLNDL1  UP   E           K DISK

     FSDBANKPD  IF   E           K DISK

      *****************************************************************
     D/EJECT
      *****************************************************************

      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC

      *****************************************************************
     C/EJECT
      *****************************************************************

      ** Main Processing Control

      ** Process Record.

     C                   EXSR      SRSDCLNDL1

      *****************************************************************
     C/EJECT
      *****************************************************************
      * SRSDCLNDL1 - Process Lending ICD Details                      *
      *****************************************************************
     C     SRSDCLNDL1    BEGSR

      ** Initialise Miscellaneous Values

     C                   EVAL      BPLCCY = BJCYCD
     C                   EVAL      BPAMNT = 0
     C                   EVAL      BPPERC = 0
     C                   EVAL      BPMXCH = 10

      ** Initialise Basel II Past Due Classification Details

     C                   EVAL      BPCLD1 = '** INITIAL SETTING **'
     C                   EVAL      BPCLD2 = *BLANKS
     C                   EVAL      BPCLD3 = *BLANKS
     C                   EVAL      BPCLD4 = *BLANKS
     C                   EVAL      BPCLD5 = *BLANKS
     C                   EVAL      BPCLD6 = *BLANKS
     C                   EVAL      BPCLD7 = *BLANKS
     C                   EVAL      BPCLD8 = *BLANKS
     C                   EVAL      BPCLD9 = *BLANKS

     C                   EVAL      BPCLN1 = 999
     C                   EVAL      BPCLN2 = 0
     C                   EVAL      BPCLN3 = 0
     C                   EVAL      BPCLN4 = 0
     C                   EVAL      BPCLN5 = 0
     C                   EVAL      BPCLN6 = 0
     C                   EVAL      BPCLN7 = 0
     C                   EVAL      BPCLN8 = 0
     C                   EVAL      BPCLN9 = 0

     C                   EVAL      BPMTDL = 'A'

      ** Initialise Reporting Past Due Classification Details

     C                   EVAL      BPRCD1 = '** INITIAL SETTING **'
     C                   EVAL      BPRCD2 = *BLANKS
     C                   EVAL      BPRCD3 = *BLANKS
     C                   EVAL      BPRCD4 = *BLANKS
     C                   EVAL      BPRCD5 = *BLANKS
     C                   EVAL      BPRCD6 = *BLANKS
     C                   EVAL      BPRCD7 = *BLANKS
     C                   EVAL      BPRCD8 = *BLANKS
     C                   EVAL      BPRCD9 = *BLANKS

     C                   EVAL      BPRCN1 = 999
     C                   EVAL      BPRCN2 = 0
     C                   EVAL      BPRCN3 = 0
     C                   EVAL      BPRCN4 = 0
     C                   EVAL      BPRCN5 = 0
     C                   EVAL      BPRCN6 = 0
     C                   EVAL      BPRCN7 = 0
     C                   EVAL      BPRCN8 = 0
     C                   EVAL      BPRCN9 = 0

     C                   EVAL      BPRMTL = 'A'

      ** Update Details

     C                   UPDATE(E) @BPREER

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
     C     *INZSR        BEGSR

      ** *INZSR: Initialisation Rountine

      ** Access Bank Details

     C                   READ(E)   SDBANKPD

     C                   IF        %EOF(SDBANKPD) OR
     C                             %ERROR
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      *INU8 = *ON
     C                   DUMP
     C                   RETURN
     C                   ENDIF

     C                   ENDSR
