     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited. 2017')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Nostro Account Activity - GL')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      ***SD0152GL*-*Nostro*Account*Activity***-*GL.********************                     MD052107
      *  SD000152GL - Nostro Account Activity - GL.                   *                     MD052107
      *                                                               *
      *  Function:  This program checks if a Nostro is used by        *
      *             a GL/Retail transactions.                         *
      *                                                               *
      *  Called By: SD000151R                                         *
      *                                                               *
      *   (c) Finastra International Limited. 2017                    *
      *                                                               *
      *  Last Amend No. MD052107           Date 02Jul19               *
      *  Prev Amend No. MD042142           Date 22Jan18               *
      *                 MD048898           Date 11Dec17               *
      *                 MD038440           Date 27Oct17               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD052107  - Reformat Nostro Account Activity Report Layout   *
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
     D**********  TXSTAT         S             20A   DIM(3) CTDATA PERRCD(1)                MD052107
     D  TXSTAT         S             36A   DIM(3) CTDATA PERRCD(1)                          MD052107
     D  NOTES          S             24A   DIM(2) CTDATA PERRCD(1)                          MD052107

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
     D PBTDCIN         S              1A                                                    MD052107
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
     D********** APTRAN          S             40A                                          MD052107
     D APTRAN          S             19A                                                    MD052107

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
      *                                                                                     MD052107
     C                   IF        PMODE <> 'V'                                             MD052107
     C                   WRITE     HEADP1
     C                   ENDIF                                                              MD052107
      *
     C                   EXSR      SRValv
      *
     C                   IF        PMODE <> 'V'                                             MD052107
     C                   WRITE     TRAILP1
     C                   ENDIF                                                              MD052107
      *                                                                                     MD052107
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *****************************************************************
      *                                                               *
      *  SValv  - Retrieve GL/Retail transactions                     *
      *                                                               *
      *****************************************************************
     C     SRValv        BEGSR
      *                                                                                     MD052107
      ** Account Transfer                                                                   MD052107
     C                   IF        XxRtn <> 'R'                                             MD052107
     C                   EXSR      SRAccTrnsfr                                              MD052107
     C                   ENDIF                                                              MD052107
      ** Customer Exchange                                                                  MD052107
     C                   IF        XxRtn <> 'R'                                             MD052107
     C                   EXSR      SRCustExchg                                              MD052107
     C                   ENDIF                                                              MD052107
      *                                                                                     MD052107
      ** Held Items                                                                         MD052107
     C                   IF        XxRtn <> 'R'                                             MD052107
     C                   EXSR      SRHeldItem                                               MD052107
     C                   ENDIF                                                              MD052107
      *                                                                                     MD052107
      ** Journal Entry                                                                      MD052107
     C                   IF        XxRtn <> 'R'                                             MD052107
     C                   EXSR      SRJrnEntry                                               MD052107
     C                   ENDIF                                                              MD052107
      *                                                                                     MD052107
      ** Standing Journal                                                                   MD052107
     C                   IF        XxRtn <> 'R'                                             MD052107
     C                   EXSR      SRStndJourn                                              MD052107
     C                   ENDIF                                                              MD052107
      *                                                                                     MD052107
      ** Standing Orders                                                                    MD052107
     C                   IF        XxRtn <> 'R'                                             MD052107
     C                   EXSR      SRStndOrdr                                               MD052107
     C                   ENDIF                                                              MD052107
      *                                                                                     MD052107
      ** Stopped Cheque                                                                     MD052107
     C                   IF        XxRtn <> 'R'                                             MD052107
     C                   EXSR      SRStopChq                                                MD052107
     C                   ENDIF                                                              MD052107
      *                                                                                     MD052107
     C                   ENDSR                                                              MD052107
      *****************************************************************                     MD052107
      /EJECT                                                                                MD052107
      *****************************************************************                     MD052107
      *                                                               *                     MD052107
      *  SRJrnEntry - Retrieve Journal Entry                          *                     MD052107
      *                                                               *                     MD052107
      *****************************************************************                     MD052107
     C     SRJrnEntry    BEGSR                                                              MD052107
      *
      ** Set file pointer to first record of GLJENPPD
      *
     C/exec SQL
     C+ declare GLLIST1 cursor for
     C**********+ select BTBTNB, BTBINB  from GLJENPPD                                      MD052107
     C+ select BTBTNB, BTBINB, BTDCIN from GLJENPPD                                         MD052107
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
     C**********+ into :pBTBTNB, :pBTBINB                                                   MD052107
     C+ into :pBTBTNB, :pBTBINB, :pBTDCIN                                                   MD052107
     C/end-exec

     C                   DOW       SQLCode <> 100

     C**********         MOVEL     pBTBINB       nBTBINB                                    MD052107
     C                   MOVE      pBTBINB       nBTBINB                                    MD052107
     C                   EVAL      APTRAN = 'Journal Entry'
     C**********         EVAL      DATAP = APTRAN + TXSTAT(1)+ ' ' + pBTBTNB +              MD052107
     C**********                   ' ' + nBTBINB                                            MD052107
     C                   IF        pBTDCIN = 'D'                                            MD052107
     C                   EVAL      DATAP = TXSTAT(1) + ' ' + APTRAN +                       MD052107
     C                             ' Batch Number ' + pBTBTNB + ' ' + nBTBINB +             MD052107
     C                             '                                  ' +                   MD052107
     C                             NOTES(1)                                                 MD052107
     C                   ELSE                                                               MD052107
     C                   EVAL      DATAP = TXSTAT(1) + ' ' + APTRAN +                       MD052107
     C                             ' Batch Number ' + pBTBTNB + ' ' + nBTBINB +             MD052107
     C                             '                                  ' +                   MD052107
     C                             NOTES(2)                                                 MD052107
     C                   ENDIF                                                              MD052107
      *                                                                                     MD052107
     C                   IF        PMODE = 'V'                                              MD052107
     C                   EVAL      XxRtn  = 'R'                                             MD052107
     C                   ENDIF                                                              MD052107
      *                                                                                     MD052107
     C                   IF        XxRtn <> 'R'                                             MD052107
     C                   IF        *IN60 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
     C                   WRITE     DETAIL1
     C                   ENDIF                                                              MD052107
     C**********         IF        PMODE = 'V'                                              MD052107
     C**********         EVAL      XxRtn  = 'R'                                             MD052107
     C**********         GOTO      VALEXIT                                                  MD052107
     C**********         ENDIF                                                              MD052107

     C/exec SQL
     C+ fetch next
     C+ from GLLIST1
     C**********+ into  :pBTBTNB, :pBTBINB                                                  MD052107
     C+ into :pBTBTNB, :pBTBINB, :pBTDCIN                                                   MD052107
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close GLLIST1
     C/end-exec
     C                   ENDSR                                                              MD052107
      *****************************************************************                     MD052107
      /EJECT                                                                                MD052107
      *****************************************************************                     MD052107
      *                                                               *                     MD052107
      *  SRAccTrnsfr - Retrieve Account Transfer                      *                     MD052107
      *                                                               *                     MD052107
      *****************************************************************                     MD052107
     C     SRAccTrnsfr   BEGSR                                                              MD052107
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
     C**********         EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pR1TREF +             MD052107
     C**********                    ' ' +  pR1TRTY + ' ' +  pR1TRST                         MD052107
     C                   EVAL      DATAP = TXSTAT(1) + ' ' + APTRAN + ' ' +                 MD052107
     C                             pR1TREF + '                       ' +                    MD052107
     C                             pR1TRTY + ' ' +  pR1TRST                                 MD052107
      *                                                                                     MD052107
     C                   IF        PMODE = 'V'                                              MD052107
     C                   EVAL      XxRtn  = 'R'                                             MD052107
     C                   ENDIF                                                              MD052107
      *                                                                                     MD052107
     C                   IF        XxRtn <> 'R'                                             MD052107
     C                   IF        *IN60 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
     C                   WRITE     DETAIL1
     C                   ENDIF                                                              MD052107
     C**********         IF        PMODE = 'V'                                              MD052107
     C**********         EVAL      XxRtn  = 'R'                                             MD052107
     C**********         GOTO      VALEXIT                                                  MD052107
     C**********         ENDIF                                                              MD052107

     C/exec SQL
     C+ fetch next
     C+ from GLLIST2
     C+ into   :pR1TREF, :pR1TRTY, :pR1TRST
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close GLLIST2
     C/end-exec
     C                   ENDSR                                                              MD052107
      *****************************************************************                     MD052107
      /EJECT                                                                                MD052107
      *****************************************************************                     MD052107
      *                                                               *                     MD052107
      *  SRStopChq - Retrieve Stopped Cheque                          *                     MD052107
      *                                                               *                     MD052107
      *****************************************************************                     MD052107
     C     SRStopChq     BEGSR                                                              MD052107
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

     C**********         MOVEL     pSTCR         nSTCR                                      MD052107
     C                   MOVE      pSTCR         nSTCR                                      MD052107
     C                   EVAL      APTRAN = 'Stopped Cheque'
     C**********         EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + nSTCR +
     C**********                   ' ' + pSTPN
     C                   EVAL      DATAP = TXSTAT(1) + ' ' + APTRAN + ' ' +                 MD052107
     C                             nSTCR + ' ' + pSTPN                                      MD052107
      *                                                                                     MD052107
     C                   IF        PMODE = 'V'                                              MD052107
     C                   EVAL      XxRtn  = 'R'                                             MD052107
     C                   ENDIF                                                              MD052107
      *                                                                                     MD052107
     C                   IF        XxRtn <> 'R'                                             MD052107
     C                   IF        *IN60 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
     C                   WRITE     DETAIL1
     C                   ENDIF                                                              MD052107
     C**********         IF        PMODE = 'V'                                              MD052107
     C**********         EVAL      XxRtn  = 'R'                                             MD052107
     C**********         GOTO      VALEXIT                                                  MD052107
     C**********         ENDIF                                                              MD052107

     C/exec SQL
     C+ fetch next
     C+ from GLLIST3
     C+ into  :pSTCR, :pSTPN
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close GLLIST3
     C/end-exec
     C                   ENDSR                                                              MD052107
      *****************************************************************                     MD052107
      /EJECT                                                                                MD052107
      *****************************************************************                     MD052107
      *                                                               *                     MD052107
      *  SRHeldItem - Retrieve Held Items                             *                     MD052107
      *                                                               *                     MD052107
      *****************************************************************                     MD052107
     C     SRHeldItem    BEGSR                                                              MD052107
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
     C**********         MOVEL     pHIRF         nHIRF                                      MD052107
     C                   MOVE      pHIRF         nHIRF                                      MD052107
     C**********         EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + nHIRF +               MD052107
     C**********                   ' ' + pHLDN                                              MD052107
     C                   EVAL      DATAP = TXSTAT(1) + ' ' + APTRAN + ' ' +                 MD052107
     C                             nHIRF + ' '+ pHLDN                                       MD052107
      *                                                                                     MD052107
     C                   IF        PMODE = 'V'                                              MD052107
     C                   EVAL      XxRtn  = 'R'                                             MD052107
     C                   ENDIF                                                              MD052107
      *                                                                                     MD052107
     C                   IF        XxRtn <> 'R'                                             MD052107
     C                   IF        *IN60 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
     C                   WRITE     DETAIL1
     C                   ENDIF                                                              MD052107
     C**********         IF        PMODE = 'V'                                              MD052107
     C**********         EVAL      XxRtn  = 'R'                                             MD052107
     C**********         GOTO      VALEXIT                                                  MD052107
     C**********         ENDIF                                                              MD052107

     C/exec SQL
     C+ fetch next
     C+ from GLLIST4
     C+ into :pHIRF, :pHLDN
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close GLLIST4
     C/end-exec
     C                   ENDSR                                                              MD052107
      *****************************************************************                     MD052107
      /EJECT                                                                                MD052107
      *****************************************************************                     MD052107
      *                                                               *                     MD052107
      *  SRStndOrdr - Retrieve Standing Orders                        *                     MD052107
      *                                                               *                     MD052107
      *****************************************************************                     MD052107
     C     SRStndOrdr    BEGSR                                                              MD052107
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

     C**********         MOVEL     pSTOR         nSTOR                                      MD052107
     C                   MOVE      pSTOR         nSTOR                                      MD052107
     C                   EVAL      APTRAN = 'Standing Order'
     C**********         EVAL      DATAP = APTRAN + TXSTAT(1)+' ' + nSTOR +
     C**********                    ' ' + pPNAR
     C                   EVAL      DATAP = TXSTAT(1) + ' ' + APTRAN + ' ' +                 MD052107
     C                             nSTOR + ' ' + pPNAR                                      MD052107
      *                                                                                     MD052107
     C                   IF        PMODE = 'V'                                              MD052107
     C                   EVAL      XxRtn  = 'R'                                             MD052107
     C                   ENDIF                                                              MD052107
      *                                                                                     MD052107
     C                   IF        XxRtn <> 'R'                                             MD052107
     C                   IF        *IN60 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
     C                   WRITE     DETAIL1
     C                   ENDIF                                                              MD052107
     C**********         IF        PMODE = 'V'                                              MD052107
     C**********         EVAL      XxRtn  = 'R'                                             MD052107
     C**********         GOTO      VALEXIT                                                  MD052107
     C**********         ENDIF                                                              MD052107

     C/exec SQL
     C+ fetch next
     C+ from GLLIST5
     C+ into :pSTOR, :pPNAR
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close GLLIST5
     C/end-exec
     C                   ENDSR                                                              MD052107
      *****************************************************************                     MD052107
      /EJECT                                                                                MD052107
      *****************************************************************                     MD052107
      *                                                               *                     MD052107
      *  SRCustExchg - Retrieve Customer Exchange                     *                     MD052107
      *                                                               *                     MD052107
      *****************************************************************                     MD052107
     C     SRCustExchg   BEGSR                                                              MD052107
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
     C**********         EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pIPDN                 MD052107
     C                   EVAL      DATAP = TXSTAT(1) + ' ' + APTRAN + ' ' +                 MD052107
     C                             pIPDN                                                    MD052107
      *                                                                                     MD052107
     C                   IF        PMODE = 'V'                                              MD052107
     C                   EVAL      XxRtn  = 'R'                                             MD052107
     C                   ENDIF                                                              MD052107
      *                                                                                     MD052107
     C                   IF        XxRtn <> 'R'                                             MD052107
     C                   IF        *IN60 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
     C                   WRITE     DETAIL1
     C                   ENDIF                                                              MD052107
     C**********         IF        PMODE = 'V'                                              MD052107
     C**********         EVAL      XxRtn  = 'R'                                             MD052107
     C**********         GOTO      VALEXIT                                                  MD052107
     C**********         ENDIF                                                              MD052107

     C/exec SQL
     C+ fetch next
     C+ from GLLIST6
     C+ into  :pIPDN
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close GLLIST6
     C/end-exec
     C                   ENDSR                                                              MD052107
      *****************************************************************                     MD052107
      /EJECT                                                                                MD052107
      *****************************************************************                     MD052107
      *                                                               *                     MD052107
      *  SRStndJourn - Retrieve Standing Journal                      *                     MD052107
      *                                                               *                     MD052107
      *****************************************************************                     MD052107
     C     SRStndJourn   BEGSR                                                              MD052107
      *                                                                                     MD052107
      ** Set file pointer to first record of GLJESPPD
      *
     C/exec SQL
     C+ declare GLLIST7 cursor for
     C**********+ select BTBTNB, BTBINB  from GLJESPPD                                      MD052107
     C+ select BTBTNB, BTBINB, BTDCIN from GLJESPPD                                         MD052107
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
     C**********+ into :pBTBTNB, :pBTBINB                                                   MD052107
     C+ into :pBTBTNB, :pBTBINB, :pBTDCIN                                                   MD052107
     C/end-exec

     C                   DOW       SQLCode <> 100

     C**********         MOVEL     pBTBTNB       nBTBINB                                    MD042142
     C**********         MOVEL     pBTBINB       nBTBINB                           MD042142 MD052107
     C                   MOVEL     pBTBINB       nBTBINB                                    MD052107
     C**********         EVAL      APTRAN = 'Spread Journal'                                MD052107
     C                   EVAL      APTRAN = 'Standing Journal'                              MD052107
     C**********         EVAL      DATAP = APTRAN + TXSTAT(2)+ ' ' + pBTBTNB +              MD052107
     C**********                    ' ' +  nBTBINB                                          MD052107
     C                   IF        pBTDCIN = 'D'                                            MD052107
     C                   EVAL      DATAP = TXSTAT(1) + ' ' + APTRAN +                       MD052107
     C                             ' Batch Number ' + pBTBTNB + ' ' + nBTBINB +             MD052107
     C                             '                                  ' +                   MD052107
     C                             NOTES(1)                                                 MD052107
     C                   ELSE                                                               MD052107
     C                   EVAL      DATAP = TXSTAT(1) + ' ' + APTRAN +                       MD052107
     C                             ' Batch Number ' + pBTBTNB + ' ' + nBTBINB +             MD052107
     C                             '                                  ' +                   MD052107
     C                             NOTES(2)                                                 MD052107
     C                   ENDIF                                                              MD052107
     C                   IF        *IN60 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
     C                   WRITE     DETAIL1

     C/exec SQL
     C+ fetch next
     C+ from GLLIST7
     C**********+ into  :pBTBTNB, :pBTBINB                                                  MD052107
     C+ into :pBTBTNB, :pBTBINB, :pBTDCIN                                                   MD052107
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close GLLIST7
     C/end-exec
      *
     C**********     VALEXIT       ENDSR                                                    MD052107
     C                   ENDSR                                                              MD052107
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
      *****************************************************************                     MD052107
      /EJECT                                                                                MD052107
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
BLOCKING NOSTRO ACCOUNT DELETION                                                            MD052107
FOR INFORMATION ONLY                                                                        MD052107
DEAD TRANSACTION TO BE REVIEWED                                                             MD052107
** NOTES                                                                                    MD052107
Debit                                                                                       MD052107
Credit                                                                                      MD052107
