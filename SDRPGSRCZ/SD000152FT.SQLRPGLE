     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited. 2017')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Nostro Account Activity - FT')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SD0152FT - Nostro Account Activity   - FT.                   *
      *                                                               *
      *  Function:  This program checks if a Nostro is used by        *
      *             a Fund Transfer transactions.                     *
      *                                                               *
      *  Called By: SD000151R                                         *
      *                                                               *
      *   (c) Finastra International Limited. 2017                    *
      *                                                               *
      *  Last Amend No. MD042142           Date 08May18               *
      *  Prev Amend No. MD038440A          Date 08May18               *
      *                 MD048898           Date 11Dec17               *
      *                 MD038440           Date 27Oct17               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD042142 - Refine MD038440 and MD048898 fixes.               *
      *           - Applied for MD038440A                             *
      *  MD038440A - Date on report missing. Retrieve SDBANK          *
      *  MD048898 - No reports produced. conditon RCF processing      *
      *  MD038440 - Nostro deletion issue. Revise validation process. *
      *                                                               *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FSD000152P2O    E             PRINTER OFLIND(*IN60)
     F                                     INFDS(SPOOLU)
     F                                     INFSR(*PSSR)

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D  TXSTAT         S             20A   DIM(3) CTDATA PERRCD(1)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D YyBrca          S              3A
     D YyCnum          S              6A
     D YyCcy           S              3A
     D YyAcod          S             10A
     D YyAcsq          S              2A
     D XxNost          S              2A
     D XxRtn           S              1A
     D PMODE           S              1A

     D pPREF           S             15A
     D pPYTP           S              2A
     D pPYST           S              2A
     D pESESIN         S              5A
     D pRFTID          S             15A
     D pFILREF         S             16A
     D PCCTTYP         S              2A
     D pCCTTST         S              2A
     D KACNO           S             17A
     D FULNOST         S              5A
     D APTRAN          S             40A

     D PSEQ            S              5
     D PSFILE          S             10
     D PZSNUM          S              6  0
     D PZSERR          S              1
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External DS for SAR Details
     D LDA           E DS                  EXTNAME(LDA) DTAARA(LDA)
      ** Local Data Area Data Structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details Data Structure
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+


      ** +--------------------------------------+
      ** ¦ End of I-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
     C                   EVAL      FulNost =   YyCcy +  XxNost
     C                   EVAL      XxRtn  = ' '

     C                   EVAL      PACNO= YYCCY + XXNOST  + '   ' +
     C                                    YYBRCA + '-' + YYCNUM + '-' + YYCCY +
     C                                    '-' + YYACOD + '-' + YYACSQ
     C                   EVAL      KACNO= YYBRCA + YYCNUM + YYACOD + YYACSQ
     C                   WRITE     HEADP1
      *
     C                   EXSR      SRValv
      *
     C                   WRITE     TRAILP1
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *****************************************************************
      *                                                               *
      *  SValv  - Retrieve FT transactions                            *
      *                                                               *
      *****************************************************************
     C     SRValv        BEGSR
      *
      ** Set file pointer to first record of OTPAYDD
      *
     C/exec SQL
     C+ declare FTLIST1 cursor for
     C+ select PREF, PYTP, PYST from OTPAYDD
     C+ where SMCY = :YyCcy and
     C+       SNCO = :XxNost and
     C+       RECI = 'D' or
     C+       SMCY = :YyCcy and
     C+       ORBK = :XxNost and
     C+       RECI = 'D' or
     C+       SMCY = :YyCcy and
     C+       CDRO = :XxNost and
     C+       RECI = 'D' or
     C+       DST1 = :FulNost  and
     C+       RECI = 'D' or
     C+       ORC1 = :FulNost  and
     C+       RECI = 'D'
     C+ order by
     C+       PREF
     C/end-exec

     C/exec SQL
     C+ open FTLIST1
     C/end-exec

      ** Handle SQL Error (If not %EOF)

     C                   IF        SQLCOD < 0

     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 5
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ENDIF

     C/exec SQL
     C+ fetch next
     C+ from FTLIST1
     C+ into :pPREF, :pPYTP, :pPYST
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   EVAL      APTRAN = 'Outgoing Payment'
     C                   EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pPREF +
     C                             ' ' + pPYTP +  ' ' + pPYST
     C                   IF        *IN60 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
     C                   WRITE     DETAIL1
     C                   IF        PMODE = 'V'
     C                   EVAL      XxRtn  = 'R'
     C                   GOTO      VALEXIT
     C                   ENDIF

     C/exec SQL
     C+ fetch next
     C+ from FTLIST1
     C+ into :pPREF, :pPYTP, :pPYST
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close FTLIST1
     C/end-exec
      *
      ** Set file pointer to first record of INPAYDD
      *
     C/exec SQL
     C+ declare FTLIST2 cursor for
     C+ select PREF, PYTP, PYST from INPAYDD
     C+ where SMCY = :YyCcy and
     C+       ACBK = :XxNost and
     C+       RECI = 'D'   or
     C+       SMCY = :YyCcy and
     C+       CDRO = :XxNost and
     C+       RECI = 'D'   or
     C+       SNTP = :FulNost  and
     C+       RECI = 'D'   or
     C+       RCCO = :FulNost  and
     C+       RECI = 'D'   or
     C+       SNC1 = :FulNost  and
     C+       RECI = 'D'   or
     C+       INRCO1 = :FulNost and
     C+       RECI = 'D'   or
     C+       INB1 = :FulNost   and
     C+       RECI = 'D'
     C+ order by
     C+       PREF
     C/end-exec

     C/exec SQL
     C+ open FTLIST2
     C/end-exec

      ** Handle SQL Error (If not %EOF)

     C                   IF        SQLCOD < 0

     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 5
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ENDIF

     C/exec SQL
     C+ fetch next
     C+ from FTLIST2
     C+ into :pPREF, :pPYTP, :pPYST
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   EVAL      APTRAN = 'Incoming Payment'
     C                   EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pPREF +
     C                             ' ' + pPYTP + ' ' + pPYST
     C                   IF        *IN60 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
     C                   WRITE     DETAIL1
     C                   IF        PMODE = 'V'
     C                   EVAL      XxRtn  = 'R'
     C                   GOTO      VALEXIT
     C                   ENDIF

     C/exec SQL
     C+ fetch next
     C+ from FTLIST2
     C+ into :pPREF, :pPYTP, :pPYST
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close FTLIST2
     C/end-exec
      *
      ** Set file pointer to first record of CQCODDD
      *
     C/exec SQL
     C+ declare FTLIST3 cursor for
     C+ select PREF, PYTP, PYST from CQCODDD
     C+ where SMCY = :YyCcy and
     C+       RCCO = :XxNost or
     C+       COB1 = :FulNost
     C+ order by
     C+       PREF
     C/end-exec

     C/exec SQL
     C+ open FTLIST3
     C/end-exec

      ** Handle SQL Error (If not %EOF)

     C                   IF        SQLCOD < 0

     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 5
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ENDIF

     C/exec SQL
     C+ fetch next
     C+ from FTLIST3
     C+ into :pPREF, :pPYTP, :pPYST
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   EVAL      APTRAN = 'Cheques for Collection'
     C                   EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pPREF +
     C                             ' ' + pPYTP + ' ' + pPYST
     C                   IF        *IN60 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
     C                   WRITE     DETAIL1
     C                   IF        PMODE = 'V'
     C                   EVAL      XxRtn  = 'R'
     C                   GOTO      VALEXIT
     C                   ENDIF

     C/exec SQL
     C+ fetch next
     C+ from FTLIST3
     C+ into :pPREF, :pPYTP, :pPYST
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close FTLIST3
     C/end-exec
      *
      ** Set file pointer to first record of CQCOCDD
      *
     C/exec SQL
     C+ declare FTLIST4 cursor for
     C+ select PREF, CQSQ, CRPT from CQCOCDD
     C+ where CRCY = :YyCcy and
     C+       CRPY  = :XxNost or
     C+       CRCY = :YyCcy and
     C+       CDRO  = :XxNost
     C+ order by
     C+       PREF
     C/end-exec

     C/exec SQL
     C+ open FTLIST4
     C/end-exec

      ** Handle SQL Error (If not %EOF)

     C                   IF        SQLCOD < 0

     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 5
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ENDIF

     C/exec SQL
     C+ fetch next
     C+ from FTLIST4
     C+ into :pPREF, :pPYTP, :pPYST
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   EVAL      APTRAN = 'Cheques for Collection'
     C                   EVAL      DATAP = APTRAN + TXSTAT(1) + ' '  + pPREF +
     C                              ' ' + pPYTP +   ' ' + pPYST
     C                   IF        *IN60 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
     C                   WRITE     DETAIL1
     C                   IF        PMODE = 'V'
     C                   EVAL      XxRtn  = 'R'
     C                   GOTO      VALEXIT
     C                   ENDIF

     C/exec SQL
     C+ fetch next
     C+ from FTLIST4
     C+ into :pPREF, :pPYTP, :pPYST
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close FTLIST4
     C/end-exec
      *
      ** Set file pointer to first record of CQPACDD
      *
     C/exec SQL
     C+ declare FTLIST5 cursor for
     C+ select PREF, PYTP, PYST from CQPACDD
     C+ where PCCY = :YyCcy and
     C+       SNCO  = :XxNost or
     C+       PCCY = :YyCcy and
     C+       DRW1  = :XxNost or
     C+       RBK1 = :FulNost or
     C+       RCO1 = :FulNost or
     C+       ACB1 = :FulNost
     C+ order by
     C+       PREF
     C/end-exec

     C/exec SQL
     C+ open FTLIST5
     C/end-exec

      ** Handle SQL Error (If not %EOF)

     C                   IF        SQLCOD < 0

     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 5
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ENDIF

     C/exec SQL
     C+ fetch next
     C+ from FTLIST5
     C+ into :pPREF, :pPYTP, :pPYST
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   EVAL      APTRAN = 'Cheques for Paid'
     C                   EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pPREF +
     C                             ' ' + pPYTP + ' ' + pPYST
     C                   IF        *IN60 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
     C                   WRITE     DETAIL1
     C                   IF        PMODE = 'V'
     C                   EVAL      XxRtn  = 'R'
     C                   GOTO      VALEXIT
     C                   ENDIF

     C/exec SQL
     C+ fetch next
     C+ from FTLIST5
     C+ into :pPREF, :pPYTP, :pPYST
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close FTLIST5
     C/end-exec
      *
      ** Set file pointer to first record of CQPADDD
      *
     C/exec SQL
     C+ declare FTLIST6 cursor for
     C+ select PREF  from CQPADDD
     C+ where DRCY = :YyCcy and
     C+       DRPY  = :XxNost or
     C+       DRCY = :YyCcy and
     C+       CDRO  = :XxNost
     C+ order by
     C+       PREF
     C/end-exec

     C/exec SQL
     C+ open FTLIST6
     C/end-exec

      ** Handle SQL Error (If not %EOF)

     C                   IF        SQLCOD < 0

     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 5
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ENDIF

     C/exec SQL
     C+ fetch next
     C+ from FTLIST6
     C+ into :pPREF
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   EVAL      APTRAN = 'Cheques for Paid'
     C                   EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pPREF
     C                   IF        *IN60 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
     C                   WRITE     DETAIL1
     C                   IF        PMODE = 'V'
     C                   EVAL      XxRtn  = 'R'
     C                   GOTO      VALEXIT
     C                   ENDIF

     C/exec SQL
     C+ fetch next
     C+ from FTLIST6
     C+ into :pPREF
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close FTLIST6
     C/end-exec
      *
      ** Set file pointer to first record of SDOPESPD
      *
     C                   IF        CFT045 = 'Y'
      *
     C/exec SQL
     C+ declare FTLIST7 cursor for
     C+ select ESESIN  from SDOPESPD
     C+ where ESCCY = :YyCcy and
     C+       ESNSTR  = :XxNost
     C+ order by
     C+       ESESIN
     C/end-exec

     C/exec SQL
     C+ open FTLIST7
     C/end-exec

      ** Handle SQL Error (If not %EOF)

     C                   IF        SQLCOD < 0

     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 5
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ENDIF

     C/exec SQL
     C+ fetch next
     C+ from FTLIST7
     C+ into :pESESIN
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   EVAL      APTRAN = 'Ext. Settlement Instruction'
     C**********         EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pESESIN               MD042142
     C                   EVAL      DATAP = APTRAN + TXSTAT(2) + ' ' + pESESIN               MD042142
     C                   IF        *IN60 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
     C                   WRITE     DETAIL1

     C/exec SQL
     C+ fetch next
     C+ from FTLIST7
     C+ into :pESESIN
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close FTLIST7
     C/end-exec

     C                   ENDIF
      *
      ** Set file pointer to first record of NTRANDD
      *
     C/exec SQL
     C+ declare FTLIST8 cursor for
     C+ select TFRF, PYTP, PYST from NTRANDD
     C+ where CCY = :YyCcy and
     C+       DEST = :XxNost or
     C+       CCY = :YyCcy and
     C+       ACBN = :XxNost
     C+ order by
     C+       TFRF
     C/end-exec

     C/exec SQL
     C+ open FTLIST8
     C/end-exec

      ** Handle SQL Error (If not %EOF)

     C                   IF        SQLCOD < 0

     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 5
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ENDIF

     C/exec SQL
     C+ fetch next
     C+ from FTLIST8
     C+ into :pPREF, :pPYTP, :pPYST
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   EVAL      APTRAN = 'Nostro Transfers'
     C                   EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pPREF +
     C                              ' ' + pPYTP +  ' ' + pPYST
     C                   IF        *IN60 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
     C                   WRITE     DETAIL1
     C                   IF        PMODE = 'V'
     C                   EVAL      XxRtn  = 'R'
     C                   GOTO      VALEXIT
     C                   ENDIF

     C/exec SQL
     C+ fetch next
     C+ from FTLIST8
     C+ into :pPREF, :pPYTP, :pPYST
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close FTLIST8
     C/end-exec
      *
      ** Set file pointer to first record of FT101HPD
      *
     C                   IF        CFT006 = 'Y'
     C/exec SQL
     C+ declare FTLIST9 cursor for
     C+ select RFTID, PYTP, PYST   from FT101HPD
     C+ where HOCUS1 = :FulNost or
     C+       RFTDST = :FulNost
     C+ order by
     C+       RFTID
     C/end-exec

     C/exec SQL
     C+ open FTLIST9
     C/end-exec

      ** Handle SQL Error (If not %EOF)

     C                   IF        SQLCOD < 0

     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 5
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ENDIF

     C/exec SQL
     C+ fetch next
     C+ from FTLIST9
     C+ into :pRFTID, :pPYTP, :pPYST
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   EVAL      APTRAN = 'Request for Transfer'
     C                   EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pRFTID +
     C                             ' ' + pPYTP +   ' ' + pPYST
     C                   IF        *IN60 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
     C                   WRITE     DETAIL1
     C                   IF        PMODE = 'V'
     C                   EVAL      XxRtn  = 'R'
     C                   GOTO      VALEXIT
     C                   ENDIF

     C/exec SQL
     C+ fetch next
     C+ from FTLIST9
     C+ into :pRFTID, :pPYTP, :pPYST
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close FTLIST9
     C/end-exec
      *
      ** Set file pointer to first record of FT102HPD
      *
     C
      *
     C/exec SQL
     C+ declare FTLIST10 cursor for
     C+ select FILREF, CCTTYP, CCTTST  from FT102HPD
     C+ where TOCUS1 = :FulNost or
     C+       CCTDST = :FulNost
     C+ order by
     C+       FILREF
     C/end-exec

     C/exec SQL
     C+ open FTLIST10
     C/end-exec

      ** Handle SQL Error (If not %EOF)

     C                   IF        SQLCOD < 0

     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 5
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ENDIF

     C/exec SQL
     C+ fetch next
     C+ from FTLIST10
     C+ into :pFILREF, :pCCTTYP, :pCCTTST
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   EVAL      APTRAN = 'Customer Credit Transfer'
     C                   EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pFILREF +
     C                                   ' ' +  pCCTTYP +   ' ' + pCCTTST
     C                   IF        *IN60 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
     C                   WRITE     DETAIL1
     C                   IF        PMODE = 'V'
     C                   EVAL      XxRtn  = 'R'
     C                   GOTO      VALEXIT
     C                   ENDIF

     C/exec SQL
     C+ fetch next
     C+ from FTLIST10
     C+ into :pFILREF, :pCCTTYP, :pCCTTST
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close FTLIST10
     C/end-exec
     C                   ENDIF
      *
     C     VALEXIT       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PMODE
     C                   PARM                    YyBrca
     C                   PARM                    YyCnum
     C                   PARM                    YyCcy
     C                   PARM                    YyAcod
     C                   PARM                    YyAcsq
     C                   PARM                    XxNost
     C                   PARM                    XxRtn
     C                   PARM                    PSEQ
      *                                                                                    MD038440A
      ** Access bank details.                                                              MD038440A
      *                                                                                    MD038440A
     C                   CALL      'AOBANKR0'                                              MD038440A
     C                   PARM      *BLANKS       @RTCD                                     MD038440A
     C                   PARM      '*FIRST '     @OPTN                                     MD038440A
     C     SDBANK        PARM      SDBANK        DSFDY                                     MD038440A
      *                                                                                    MD038440A
     C                   IF        @RTCD <> *BLANKS                                        MD038440A
     C     *LOCK         IN        LDA                                                     MD038440A
     C                   EVAL      DBFile = 'SDBANKPD'                                     MD038440A
     C                   EVAL      DBKey = @OPTN                                           MD038440A
     C                   EVAL      DBase = 001                                             MD038440A
     C                   OUT       LDA                                                     MD038440A
     C                   EXSR      *PSSR                                                   MD038440A
     C                   ENDIF                                                             MD038440A
      *
      ** Establish switchable features
      *
     C                   MOVE      'N'           CFT045            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM      'CFT045'      @KEY6             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CFT045
     C                   ENDIF
      *
     C                   MOVE      'N'           CFT006            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM      'CFT006'      @KEY6             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CFT006
     C                   ENDIF
      *
     C                   Z-ADD     SFNUMU        PZSNUM
     C                   MOVE      SFILEU        PSFILE
     C                   IF        PMODE <> 'V'                                             MD048898
     C                   EXSR      SRRCFProc
     C                   ENDIF                                                              MD048898
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SRRCFProc - RCF processing                                   *
      *                                                               *
      *****************************************************************

     C     SRRCFProc     BEGSR

      ** Ensure Detail Spool File recorded by RCF.

     C                   CALL      'ZSFILE'
     C                   PARM                    PSEQ
     C                   PARM      *BLANKS       PENTY             3
     C                   PARM                    PSFILE
     C                   PARM                    PZSNUM
     C                   PARM      *BLANK        PZSERR

      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.

     C     PZSERR        IFEQ      'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception subroutine.                        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** TXSTAT
BLOCKING DELETION
INFORMATION
DEAD TRANSACTION
