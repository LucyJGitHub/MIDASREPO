     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited. 2017')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Nostro Account Activity - GL')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SD0152GL - Nostro Account Activity   - GL.                   *
      *                                                               *
      *  Function:  This program checks if a Nostro is used by        *
      *             a GL/Retail transactions.                         *
      *                                                               *
      *  Called By: SD000151R                                         *
      *                                                               *
      *   (c) Finastra International Limited. 2017                    *
      *                                                               *
      *  Last Amend No. MD042142           Date 22Jan18               *
      *  Prev Amend No. MD048898           Date 11Dec17               *
      *                 MD038440           Date 27Oct17               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD042142 - Refine MD038440 and MD048898 fixes.               *
      *           - Applied for MD038440A                             *
      *  MD048898 - No reports produced. conditon RCF processing      *
      *  MD038440 - Nostro deletion issue. Revise validation process. *
      *                                                               *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FSD000152P3O    E             PRINTER OFLIND(*IN60)
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

     D PBTBTNB         S              3A
     D PBTBINB         S              2  0
     D nBTBINB         S              2A
     D FULNOST         s              5A
     D PR1TREF         S             15A
     D PR1TRTY         S              2A
     D PR1TRST         S              5A
     D pSTCR           S              3  0
     D nSTCR           S              3A
     D pSTPN           S             20A
     D pHIRF           S              3  0
     D nHIRF           S              3A
     D pHLDN           S             20A
     D PSTOR           S              5  0
     D NSTOR           S              5A
     D PIPDN           S              6A
     D PPNAR           S             30A
     D KACNO           S             17A
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
     C                   EVAL      FulNost =   YyCcy +  XxNost                              MD048898
     C                   EVAL      XxRtn  = ' '

     C                   EVAL      PACNO= YYCCY + XXNOST + '   ' +
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
      *  SValv  - Retrieve GL/Retail transactions                     *
      *                                                               *
      *****************************************************************
     C     SRValv        BEGSR
      *
      ** Set file pointer to first record of GLJENPPD
      *
     C/exec SQL
     C+ declare GLLIST1 cursor for
     C+ select BTBTNB, BTBINB  from GLJENPPD
     C+ where BTCYCD = :YyCcy and
     C+       BTNNBI = :XxNost
     C+ order by
     C+       BTBTNB
     C/end-exec

     C/exec SQL
     C+ open GLLIST1
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
     C+ from GLLIST1
     C+ into :pBTBTNB, :pBTBINB
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   MOVEL     pBTBINB       nBTBINB
     C                   EVAL      APTRAN = 'Journal Entry'
     C                   EVAL      DATAP = APTRAN + TXSTAT(1)+ ' ' + pBTBTNB +
     C                             ' ' + nBTBINB
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
     C+ from GLLIST1
     C+ into  :pBTBTNB, :pBTBINB
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close GLLIST1
     C/end-exec
      *
      **  Set file pointer to first record of GLATMIPD
      *
     C/exec SQL
     C+ declare GLLIST2 cursor for
     C+ select R1TREF, R1TRTY, R1TRST  from GLATMIPD
     C**where R1DBAI = :FulNost and                                                         MD048898
     C+ where R1DBAI = :FulNost or                                                          MD048898
     C+       R1CRAI = :FulNost
     C+ order by
     C+       R1TREF
     C/end-exec

     C/exec SQL
     C+ open GLLIST2
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
     C+ from GLLIST2
     C+ into :pR1TREF, :pR1TRTY, :pR1TRST
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   EVAL      APTRAN = 'Account Transfer'
     C                   EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pR1TREF +
     C                              ' ' +  pR1TRTY + ' ' +  pR1TRST
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
     C+ from GLLIST2
     C+ into   :pR1TREF, :pR1TRTY, :pR1TRST
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close GLLIST2
     C/end-exec
      *
      **  Set file pointer to first record of STOPCSD
      *
     C/exec SQL
     C+ declare GLLIST3 cursor for
     C+ select STCR, STPN   from STOPCSD
     C+ where CNUM = :YyCnum and
     C+       CCY = :YyCcy and
     C+       ACOD = :NnAcod and
     C+       ACSQ = :NnAcsq and
     C+       BRCA = :YyBrca and
     C+       EXPD >= :BJRDNB
     C+ order by
     C+       STCR
     C/end-exec

     C/exec SQL
     C+ open GLLIST3
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
     C+ from GLLIST3
     C+ into :pSTCR, :pSTPN
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   MOVEL     pSTCR         nSTCR
     C                   EVAL      APTRAN = 'Stopped Cheque'
     C                   EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + nSTCR +
     C                             ' ' + pSTPN
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
     C+ from GLLIST3
     C+ into  :pSTCR, :pSTPN
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close GLLIST3
     C/end-exec
      *
      **  Set file pointer to first record of HELDIHB
      *
     C/exec SQL
     C+ declare GLLIST4 cursor for
     C+ select HIRF, HLDN   from HELDIHB
     C+ where CNUM = :YyCnum and
     C+       CCY = :YyCcy and
     C+       ACOD = :NnAcod and
     C+       ACSQ = :NnAcsq and
     C+       BRCA = :YyBrca and
     C+       HEXP >= :BJRDNB
     C+ order by
     C+       HIRF
     C/end-exec

     C/exec SQL
     C+ open GLLIST4
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
     C+ from GLLIST4
     C+ into :pHIRF, :pHLDN
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   EVAL      APTRAN = 'Held Items'
     C                   MOVEL     pHIRF         nHIRF
     C                   EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + nHIRF +
     C                             ' ' + pHLDN
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
     C+ from GLLIST4
     C+ into :pHIRF, :pHLDN
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close GLLIST4
     C/end-exec
      *
      **  Set file pointer to first record of STANDSB
      *
     C/exec SQL
     C+ declare GLLIST5 cursor for
     C+ select STOR, PNAR   from STANDSB
     C+ where DCUS = :YyCnum and
     C+       CCY = :YyCcy and
     C+       DACD = :NnAcod and
     C+       DACS = :NnAcsq and
     C+       DRBR = :YyBrca and
     C+       DLPY >= :BJRDNB or
     C+       CCUS = :YyCnum and
     C+       CCY = :YyCcy and
     C+       CSCA = :NnAcod and
     C+       CACD = :NnAcsq and
     C+       DRBR = :YyBrca and
     C+       DLPY >= :BJRDNB
     C+ order by
     C+       STOR
     C/end-exec

     C/exec SQL
     C+ open GLLIST5
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
     C+ from GLLIST5
     C+ into  :pSTOR, :pPNAR
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   MOVEL     pSTOR         nSTOR
     C                   EVAL      APTRAN = 'Standing Order'
     C                   EVAL      DATAP = APTRAN + TXSTAT(1)+' ' + nSTOR +
     C                              ' ' + pPNAR
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
     C+ from GLLIST5
     C+ into :pSTOR, :pPNAR
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close GLLIST5
     C/end-exec
      *
      **  Set file pointer to first record of CUSEXCE
      *
     C/exec SQL
     C+ declare GLLIST6 cursor for
     C+ select IPDN   from CUSEXCE
     C+ where DCUS = :YyCnum and
     C+       DRCY = :YyCcy and
     C+       DCOD = :NnAcod and
     C+       DACS = :NnAcsq and
     C+       DRBR = :YyBrca and
     C+       DRVD >= :BJRDNB or
     C+       CCUS = :YyCnum and
     C+       CRCY = :YyCcy and
     C+       CCOD = :NnAcod and
     C+       CACS = :NnAcsq and
     C+       DRBR = :YyBrca and
     C+       CRVD >= :BJRDNB
     C+ order by
     C+       IPDN
     C/end-exec

     C/exec SQL
     C+ open GLLIST6
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
     C+ from GLLIST6
     C+ into  :pIPDN
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   EVAL      APTRAN = 'Customer Exchange'
     C                   EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pIPDN
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
     C+ from GLLIST6
     C+ into  :pIPDN
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close GLLIST6
     C/end-exec
      ** Set file pointer to first record of GLJESPPD
      *
     C/exec SQL
     C+ declare GLLIST7 cursor for
     C+ select BTBTNB, BTBINB  from GLJESPPD
     C+ where BTCYCD = :YyCcy and
     C+       BTNNBI = :XxNost
     C+ order by
     C+       BTBTNB
     C/end-exec

     C/exec SQL
     C+ open GLLIST7
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
     C+ from GLLIST7
     C+ into :pBTBTNB, :pBTBINB
     C/end-exec

     C                   DOW       SQLCode <> 100

     C**********         MOVEL     pBTBTNB       nBTBINB                                    MD042142
     C                   MOVEL     pBTBINB       nBTBINB                                    MD042142
     C                   EVAL      APTRAN = 'Spread Journal'
     C                   EVAL      DATAP = APTRAN + TXSTAT(2)+ ' ' + pBTBTNB +
     C                              ' ' +  nBTBINB
     C                   IF        *IN60 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
     C                   WRITE     DETAIL1

     C/exec SQL
     C+ fetch next
     C+ from GLLIST7
     C+ into  :pBTBTNB, :pBTBINB
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close GLLIST7
     C/end-exec
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
      *
     C                   MOVEL     YyAcsq        NnAcsq            2 0
     C                   MOVEL     YyAcod        NnAcod           10 0
      *
      ** Access bank details.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey = @OPTN
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
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
