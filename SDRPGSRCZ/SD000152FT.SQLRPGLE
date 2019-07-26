     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited. 2017')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Nostro Account Activity - FT')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      ***SD0152FT*-*Nostro*Account*Activity***-*FT.********************                     MD052107
      *  SD000152FT - Nostro Account Activity - FT.                   *                     MD052107
      *                                                               *
      *  Function:  This program checks if a Nostro is used by        *
      *             a Fund Transfer transactions.                     *
      *                                                               *
      *  Called By: SD000151R                                         *
      *                                                               *
      *   (c) Finastra International Limited. 2017                    *
      *                                                               *
      *  Last Amend No. MD052107           Date 02Jul19               *
      *  Prev Amend No. MD042142           Date 08May18               *
      *                 MD038440A          Date 08May18               *
      *                 MD048898           Date 11Dec17               *
      *                 MD038440           Date 27Oct17               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD052107  - Reformat Nostro Account Activity Report Layout   *
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
      *  SValv  - Retrieve FT transactions                            *
      *                                                               *
      *****************************************************************
     C     SRValv        BEGSR
      *                                                                                     MD052107
      ** Cheques for Collection (Debit)                                                     MD052107
     C                   IF        XxRtn <> 'R'                                             MD052107
     C                   EXSR      SRChqColDr                                               MD052107
     C                   ENDIF                                                              MD052107
      ** Cheques for Collection (Credit)                                                    MD052107
     C                   IF        XxRtn <> 'R'                                             MD052107
     C                   EXSR      SRChqColCr                                               MD052107
     C                   ENDIF                                                              MD052107
      *                                                                                     MD052107
      ** Cheques to be Paid (Debit)                                                         MD052107
     C                   IF        XxRtn <> 'R'                                             MD052107
     C                   EXSR      SRChqPayDr                                               MD052107
     C                   ENDIF                                                              MD052107
      *                                                                                     MD052107
      ** Cheques to be Paid (Crebit)                                                        MD052107
     C                   IF        XxRtn <> 'R'                                             MD052107
     C                   EXSR      SRChqPayCr                                               MD052107
     C                   ENDIF                                                              MD052107
      *                                                                                     MD052107
      ** Ext. Settlement Instruction                                                        MD052107
     C                   IF        CFT045 = 'Y'                                             MD052107
     C                   IF        XxRtn <> 'R'                                             MD052107
     C                   EXSR      SRExSett                                                 MD052107
     C                   ENDIF                                                              MD052107
     C                   ENDIF                                                              MD052107
      *                                                                                     MD052107
      ** Incoming Payment                                                                   MD052107
     C                   IF        XxRtn <> 'R'                                             MD052107
     C                   EXSR      SRInPaymnt                                               MD052107
     C                   ENDIF                                                              MD052107
      *                                                                                     MD052107
      ** Nostro Transfers                                                                   MD052107
     C                   IF        XxRtn <> 'R'                                             MD052107
     C                   EXSR      SRNosTrnsfr                                              MD052107
     C                   ENDIF                                                              MD052107
      *                                                                                     MD052107
      ** Outgoing Payment                                                                   MD052107
     C                   IF        XxRtn <> 'R'                                             MD052107
     C                   EXSR      SROutPaymnt                                              MD052107
     C                   ENDIF                                                              MD052107
      *                                                                                     MD052107
     C                   IF        CFT006 = 'Y'                                             MD052107
     C                   IF        XxRtn <> 'R'                                             MD052107
      ** Request for Transfer                                                               MD052107
     C                   EXSR      SRReqTrnsfr                                              MD052107
      ** Customer Credit Transfer                                                           MD052107
     C                   EXSR      SRCusCrTrnsfr                                            MD052107
     C                   ENDIF                                                              MD052107
     C                   ENDIF                                                              MD052107
      *                                                                                     MD052107
     C                   ENDSR                                                              MD052107
      *****************************************************************                     MD052107
      /EJECT                                                                                MD052107
      *****************************************************************                     MD052107
      *                                                               *                     MD052107
      *  SROutPaymnt  - Retrieve Outgoing Payments                    *                     MD052107
      *                                                               *                     MD052107
      *****************************************************************                     MD052107
     C     SROutPaymnt   BEGSR                                                              MD052107
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
     C**********+       PREF                                                                MD052107
     C+       PREF, PYTP, PYST                                                              MD052107
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
     C**********         EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pPREF +
     C**********                   ' ' + pPYTP +  ' ' + pPYST
     C                   EVAL      DATAP = TXSTAT(1) + ' ' + APTRAN + ' ' +                 MD052107
     C                             pPREF + '  ' + pPYTP + ' '                               MD052107
     C                              + pPYST                                                 MD052107
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
     C+ from FTLIST1
     C+ into :pPREF, :pPYTP, :pPYST
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close FTLIST1
     C/end-exec
     C                   ENDSR                                                              MD052107
      *****************************************************************                     MD052107
      /EJECT                                                                                MD052107
      *****************************************************************                     MD052107
      *                                                               *                     MD052107
      *  SRInPaymnt  - Retrieve Incoming Payments                     *                     MD052107
      *                                                               *                     MD052107
      *****************************************************************                     MD052107
     C     SRInPaymnt    BEGSR                                                              MD052107
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
     C**********+       PREF                                                                MD052107
     C+       PREF, PYTP, PYST                                                              MD052107
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
     C**********         EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pPREF +               MD052107
     C**********                   ' ' + pPYTP + ' ' + pPYST                                MD052107
     C                   EVAL      DATAP = TXSTAT(1) + ' ' + APTRAN + ' ' +                 MD052107
     C                             pPREF + '  ' + pPYTP + ' '                               MD052107
     C                              + pPYST                                                 MD052107
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
     C+ from FTLIST2
     C+ into :pPREF, :pPYTP, :pPYST
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close FTLIST2
     C/end-exec
     C                   ENDSR                                                              MD052107
      *****************************************************************                     MD052107
      /EJECT                                                                                MD052107
      *****************************************************************                     MD052107
      *                                                               *                     MD052107
      *  SRChqColDr  - Retrieve Cheques for Collection (Debit)        *                     MD052107
      *                                                               *                     MD052107
      *****************************************************************                     MD052107
     C     SRChqColDr    BEGSR                                                              MD052107
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
     C**********+       PREF                                                                MD052107
     C+       PREF, PYTP, PYST                                                              MD052107
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
     C**********         EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pPREF +               MD052107
     C**********                   ' ' + pPYTP + ' ' + pPYST                                MD052107
     C                   EVAL      DATAP = TXSTAT(1) + ' ' + APTRAN + ' ' +                 MD052107
     C                             pPREF + '  ' + pPYTP + ' '                               MD052107
     C                              + pPYST + '         ' + NOTES(1)                        MD052107
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
     C+ from FTLIST3
     C+ into :pPREF, :pPYTP, :pPYST
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close FTLIST3
     C/end-exec
     C                   ENDSR                                                              MD052107
      *****************************************************************                     MD052107
      /EJECT                                                                                MD052107
      *****************************************************************                     MD052107
      *                                                               *                     MD052107
      *  SRChqColCr  - Retrieve Cheques for Collection (Credit)       *                     MD052107
      *                                                               *                     MD052107
      *****************************************************************                     MD052107
     C     SRChqColCr    BEGSR                                                              MD052107
      *
      ** Set file pointer to first record of CQCOCDD
      *
     C/exec SQL
     C+ declare FTLIST4 cursor for
     C**********+ select PREF, CQSQ, CRPT from CQCOCDD                                      MD052107
     C+ select PREF from CQCOCDD                                                            MD052107
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
     C**********+ into :pPREF, :pPYTP, :pPYST                                               MD052107
     C+ into :pPREF                                                                         MD052107
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   EVAL      APTRAN = 'Cheques for Collection'
     C**********         EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pPREF +               MD052107
     C**********                   ' ' + pPYTP + ' ' + pPYST                                MD052107
     C                   EVAL      DATAP = TXSTAT(1) + ' ' + APTRAN + ' ' +                 MD052107
     C                             pPREF + '                ' + NOTES(2)                    MD052107
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
     C+ from FTLIST4
     C**********+ into :pPREF, :pPYTP, :pPYST                                               MD052107
     C+ into :pPREF                                                                         MD052107
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close FTLIST4
     C/end-exec
     C                   ENDSR                                                              MD052107
      *****************************************************************                     MD052107
      /EJECT                                                                                MD052107
      *****************************************************************                     MD052107
      *                                                               *                     MD052107
      *  SRChqPayCr  - Retrieve Cheques to be Paid (Credit)           *                     MD052107
      *                                                               *                     MD052107
      *****************************************************************                     MD052107
     C     SRChqPayCr    BEGSR                                                              MD052107
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
     C**********+       PREF                                                                MD052107
     C+       PREF, PYTP, PYST                                                              MD052107
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

     C**********         EVAL      APTRAN = 'Cheques for Paid'                              MD052107
     C**********         EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pPREF +               MD052107
     C**********                   ' ' + pPYTP + ' ' + pPYST                                MD052107
     C                   EVAL      APTRAN = 'Cheques to be Paid'                            MD052107
     C                   EVAL      DATAP = TXSTAT(1) + ' ' + APTRAN + ' ' +                 MD052107
     C                             pPREF + '  ' + pPYTP + ' '                               MD052107
     C                              + pPYST + '         ' + NOTES(2)                        MD052107
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
     C+ from FTLIST5
     C+ into :pPREF, :pPYTP, :pPYST
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close FTLIST5
     C/end-exec
     C                   ENDSR                                                              MD052107
      *****************************************************************                     MD052107
      /EJECT                                                                                MD052107
      *****************************************************************                     MD052107
      *                                                               *                     MD052107
      *  SRChqPayDr  - Retrieve Cheques to be Paid (Debit)            *                     MD052107
      *                                                               *                     MD052107
      *****************************************************************                     MD052107
     C     SRChqPayDr    BEGSR                                                              MD052107
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

     C**********         EVAL      APTRAN = 'Cheques for Paid'                              MD052107
     C**********         EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pPREF                 MD052107
     C                   EVAL      APTRAN = 'Cheques to be Paid'                            MD052107
     C                   EVAL      DATAP = TXSTAT(1) + ' ' + APTRAN + ' ' +                 MD052107
     C                             pPREF + '                ' + NOTES(1)                    MD052107
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
     C+ from FTLIST6
     C+ into :pPREF
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close FTLIST6
     C/end-exec
     C                   ENDSR                                                              MD052107
      *****************************************************************                     MD052107
      /EJECT                                                                                MD052107
      *****************************************************************                     MD052107
      *                                                               *                     MD052107
      *  SRExSett  - Retrieve Extended Settlement Instruction         *                     MD052107
      *                                                               *                     MD052107
      *****************************************************************                     MD052107
     C     SRExSett      BEGSR                                                              MD052107
      *
      ** Set file pointer to first record of SDOPESPD
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
     C**********         EVAL      DATAP = APTRAN + TXSTAT(2) + ' ' + pESESIN      MD042142 MD052107
     C                   EVAL      DATAP = TXSTAT(2) + ' ' + APTRAN + ' ' +                 MD052107
     C                             pESESIN                                                  MD052107
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
     C                   ENDSR                                                              MD052107
      *****************************************************************                     MD052107
      /EJECT                                                                                MD052107
      *****************************************************************                     MD052107
      *                                                               *                     MD052107
      *  SRNosTrnsfr  - Retrieve Nostro Transfers                     *                     MD052107
      *                                                               *                     MD052107
      *****************************************************************                     MD052107
     C     SRNosTrnsfr   BEGSR                                                              MD052107
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
     C**********+       TFRF                                                                MD052107
     C+       TFRF, PYTP, PYST                                                              MD052107
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
     C**********         EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pPREF +               MD052107
     C**********                    ' ' + pPYTP +  ' ' + pPYST                              MD052107
     C                   EVAL      DATAP = TXSTAT(1) + ' ' + APTRAN + ' ' +                 MD052107
     C                             pPREF + '  ' + pPYTP + ' '                               MD052107
     C                              + pPYST                                                 MD052107
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
     C+ from FTLIST8
     C+ into :pPREF, :pPYTP, :pPYST
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close FTLIST8
     C/end-exec
     C                   ENDSR                                                              MD052107
      *****************************************************************                     MD052107
      /EJECT                                                                                MD052107
      *****************************************************************                     MD052107
      *                                                               *                     MD052107
      *  SRReqTrnsfr  - Retrieve Request for Transfer                 *                     MD052107
      *                                                               *                     MD052107
      *****************************************************************                     MD052107
     C     SRReqTrnsfr   BEGSR                                                              MD052107
      *
      ** Set file pointer to first record of FT101HPD
      *
     C/exec SQL
     C+ declare FTLIST9 cursor for
     C+ select RFTID, PYTP, PYST   from FT101HPD
     C+ where HOCUS1 = :FulNost or
     C+       RFTDST = :FulNost
     C+ order by
     C**********+       RFTID                                                               MD052107
     C+       RFTID, PYTP, PYST                                                             MD052107
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
     C**********         EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pRFTID +              MD052107
     C**********                   ' ' + pPYTP +   ' ' + pPYST                              MD052107
     C                   EVAL      DATAP = TXSTAT(1) + ' ' + APTRAN + ' ' +                 MD052107
     C                             pPREF + '  ' + pPYTP + ' '                               MD052107
     C                              + pPYST                                                 MD052107
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
     C+ from FTLIST9
     C+ into :pRFTID, :pPYTP, :pPYST
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close FTLIST9
     C/end-exec
     C                   ENDSR                                                              MD052107
      *****************************************************************                     MD052107
      /EJECT                                                                                MD052107
      *****************************************************************                     MD052107
      *                                                               *                     MD052107
      *  SRCusCrTrnsfr - Retrieve Customer Credit Transfer            *                     MD052107
      *                                                               *                     MD052107
      *****************************************************************                     MD052107
     C     SRCusCrTrnsfr BEGSR                                                              MD052107
      *
      ** Set file pointer to first record of FT102HPD
      *
     C/exec SQL
     C+ declare FTLIST10 cursor for
     C+ select FILREF, CCTTYP, CCTTST  from FT102HPD
     C+ where TOCUS1 = :FulNost or
     C+       CCTDST = :FulNost
     C+ order by
     C**********+       FILREF                                                              MD052107
     C+       FILREF, CCTTYP, CCTTST                                                        MD052107
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
     C**********         EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pFILREF +             MD052107
     C**********                         ' ' +  pCCTTYP +   ' ' + pCCTTST                   MD052107
     C                   EVAL      DATAP = TXSTAT(1) + ' ' + APTRAN + ' ' +                 MD052107
     C                             pFILREF + '  ' + pCCTTYP + ' '                           MD052107
     C                              + pCCTTST                                               MD052107
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
     C+ from FTLIST10
     C+ into :pFILREF, :pCCTTYP, :pCCTTST
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close FTLIST10
     C/end-exec
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
