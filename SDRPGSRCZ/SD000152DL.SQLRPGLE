     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited. 2017')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Nostro Account Activity - DL')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SD0152DL - Nostro Account Activity  - DL.                    *
      *                                                               *
      *  Function:  This program checks if a Nostro is used by        *
      *             a Dealing transaction.                            *
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
      *  MD038440A - No validation for amendable side of a dead txn   *
      *              Block deletion of Nostro if used.                *
      *  MD048898 - No reports produced. conditon RCF processing      *
      *  MD038440 - Nostro deletion issue. Revise validation process  *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FSD000152P1O    E             PRINTER OFLIND(*IN60)
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

     D pDLNO           S              6
     D pDTYP           S              2
     D pDLST           S              2
     D PVDAT           S              5  0
     D pPONS           S             12                                                    MD038440A
     D pRONS           S             12                                                    MD038440A
     D********** pPYCCYS              2                                                     MD042142
     D pPYCCY          S              3                                                     MD042142
     D pPYNOST         S              2
     D pPYVDAT         S              2
     D pPYSEQN         S              2
     D pAMNETR         S             19A
     D PLCYCD          S              3A
     D PLCUST          S              6A
     D PLSEQN          S              4  0
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
      *  SValv  - Retrieve Dealing transactions                       *
      *                                                               *
      *****************************************************************
     C     SRValv        BEGSR
      *
      ** Set file pointer to first record of DEALSDC
      *
     C/exec SQL
     C+ declare DLLIST0 cursor for
     C**********select DLNO, DTYP, DLST, VDAT   from DEALSDC                               MD038440A
     C+ select DLNO, DTYP, DLST, VDAT, PONS, RONS from DEALSDC                             MD038440A
     C+ where CCY = :YyCcy and
     C+       PONS = :XxNost and
     C+       RECI = 'D' and
     C********DTYP in ('IT', 'TD', 'CI', 'CD' )                                            MD038440A
     C+       DTYP in ('IT', 'TD', 'CI', 'CD' )  or                                        MD038440A
     C+       CCY = :YyCcy and                                                             MD038440A
     C+       RONS = :XxNost and                                                           MD038440A
     C+       RECI = 'D' and                                                               MD038440A
     C+       DTYP in ('IT', 'TD', 'CI', 'CD' )                                            MD038440A
     C+ order by
     C+       DLNO
     C/end-exec

     C/exec SQL
     C+ open DLLIST0
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
     C+ from DLLIST0
     C**********Into  :pdlno, :pdtyp, :pdlst, :pvdat                                       MD038440A
     C+ into  :pdlno, :pdtyp, :pdlst, :pvdat, :ppons, :prons                               MD038440A
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   IF        PRONS = XXNOST                                          MD038440A
     C                   IF        PVDAT <  BJRDNB
     C                   EVAL      APTRAN = 'Money Market'
     C                   EVAL      DATAP = APTRAN + TXSTAT(3) + ' ' + pDLNO +
     C                              ' ' +  pDTYP + ' ' + pDLST
     C                   ELSE
     C                   EVAL      APTRAN = 'Money Market'                                  MD048898
     C                   EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pDLNO +
     C                              ' ' +  pDTYP + ' ' + pDLST
     C                   IF        PMODE = 'V'
     C                   EVAL      XxRtn  = 'R'
     C                   GOTO      VALEXIT
     C                   ENDIF
     C                   ENDIF
     C                   IF        *IN60 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
     C                   WRITE     DETAIL1
     C                   ENDIF                                                             MD038440A
      *
     C                   IF        PPONS = XXNOST                                          MD038440A
     C                   IF        PVDAT <  BJRDNB                                         MD038440A
     C                   EVAL      APTRAN = 'Money Market'                                 MD038440A
     C                   EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pDLNO +              MD038440A
     C                              ' ' +  pDTYP + ' ' + pDLST                             MD038440A
     C                   IF        PMODE = 'V'                                             MD038440A
     C                   EVAL      XxRtn  = 'R'                                            MD038440A
     C                   GOTO      VALEXIT                                                 MD038440A
     C                   ENDIF                                                             MD038440A
     C                   ENDIF                                                             MD038440A
      *                                                                                    MD038440A
     C                   IF        *IN60 = *ON                                             MD038440A
     C                   WRITE     HEADP1                                                  MD038440A
     C                   EVAL      *IN60 = *OFF                                            MD038440A
     C                   ENDIF                                                             MD038440A
      *                                                                                    MD038440A
     C                   WRITE     DETAIL1                                                 MD038440A
     C                   ENDIF                                                             MD038440A
      *                                                                                    MD038440A

     C/exec SQL
     C+ fetch next
     C+ from DLLIST0
     C**********Into  :pdlno, :pdtyp, :pdlst, :pvdat                                       MD038440A
     C+ into  :pdlno, :pdtyp, :pdlst, :pvdat, :ppons, :prons                               MD038440A
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close DLLIST0
     C/end-exec
      *
     C/exec SQL
     C+ declare DLLIST0B cursor for
     C**select*DLNO, DTYP, DLST, VDAT   from DEALSDC                                       MD038440A
     C+ select DLNO, DTYP, DLST, VDAT, PONS, RONS from DEALSDC                             MD038440A
     C+ where CCY = :YyCcy and
     C+       RONS = :XxNost and
     C+       RECI = 'D' and
     C********DTYP in ('CF', 'CL' , 'DL', 'IP', 'TI' )                                     MD038440A
     C+       DTYP in ('CF', 'CL' , 'DL', 'IP', 'TI' ) or                                  MD038440A
     C+       CCY = :YyCcy and                                                             MD038440A
     C+       PONS = :XxNost and                                                           MD038440A
     C+       RECI = 'D' and                                                               MD038440A
     C+       DTYP in ('CF', 'CL' , 'DL', 'IP', 'TI' )                                     MD038440A
     C+ order by
     C+       DLNO
     C/end-exec

     C/exec SQL
     C+ open DLLIST0B
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
     C+ from DLLIST0B
     C**into**:pdlno, :pdtyp, :pdlst, :pvdat                                               MD038440A
     C+ into  :pdlno, :pdtyp, :pdlst, :pvdat, :ppons, :prons                               MD038440A
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   IF        PPONS =  XXNOST                                         MD038440A
     C                   IF        PVDAT <  BJRDNB
     C                   EVAL      APTRAN = 'Money Market'
     C                   EVAL      DATAP = APTRAN + TXSTAT(3) + ' ' + pDLNO +
     C                              ' ' +  pDTYP + ' ' + pDLST
     C                   ELSE
     C                   EVAL      APTRAN = 'Money Market'                                  MD048898
     C                   EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pDLNO +
     C                              ' ' +  pDTYP + ' ' + pDLST
     C                   IF        PMODE = 'V'
     C                   EVAL      XxRtn  = 'R'
     C                   GOTO      VALEXIT
     C                   ENDIF
     C                   ENDIF
     C                   IF        *IN60 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
     C                   WRITE     DETAIL1
     C                   ENDIF                                                             MD038440A
      *
     C                   IF        PRONS =  XXNOST                                         MD038440A
     C                   IF        PVDAT <  BJRDNB                                         MD038440A
     C                   EVAL      APTRAN = 'Money Market'                                 MD038440A
     C                   EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pDLNO +              MD038440A
     C                              ' ' +  pDTYP + ' ' + pDLST                             MD038440A
     C                   IF        PMODE = 'V'                                             MD038440A
     C                   EVAL      XxRtn  = 'R'                                            MD038440A
     C                   GOTO      VALEXIT                                                 MD038440A
     C                   ENDIF                                                             MD038440A
     C                   ENDIF                                                             MD038440A
     C                   IF        *IN60 = *ON                                             MD038440A
     C                   WRITE     HEADP1                                                  MD038440A
     C                   EVAL      *IN60 = *OFF                                            MD038440A
     C                   ENDIF                                                             MD038440A
      *                                                                                    MD038440A
     C                   WRITE     DETAIL1                                                 MD038440A
     C                   ENDIF                                                             MD038440A
      *

     C/exec SQL
     C+ fetch next
     C+ from DLLIST0B
     C**********into  :pdlno, :pdtyp, :pdlst, :pvdat                                       MD038440A
     C+ into  :pdlno, :pdtyp, :pdlst, :pvdat, :ppons, :prons                               MD038440A
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close DLLIST0B
     C/end-exec
      ** Set file pointer to first record of DEALSDB
      *
     C/exec SQL
     C+ declare DLLIST1 cursor for
     C+ select DLNO, DTYP, DLST from DEALSDB
     C+ where PUCY = :YyCcy and
     C+       RONS = :XxNost and
     C+       RECI = 'D' or
     C+       SLCY = :YyCcy and
     C+       PONS = :XxNost and
     C+       RECI = 'D'
     C+ order by
     C+       DLNO
     C/end-exec

     C/exec SQL
     C+ open DLLIST1
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
     C+ from DLLIST1
     C+ into :pdlno, :pdtyp, :pdlst
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   EVAL      APTRAN = 'Foreign Exchange'
     C                   EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pDLNO +
     C                              ' ' + pDTYP +   ' ' + pDLST
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
     C+ from DLLIST1
     C+ into :pdlno, :pdtyp, :pdlst
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close DLLIST1
     C/end-exec
      *
      ** Set file pointer to first record of DEALSDG
      *
     C/exec SQL
     C+ declare DLLIST2 cursor for
     C+ select DLNO, DTYP, DLST from DEALSDG
     C+ where UCUCY = :YyCcy and
     C**********+       RONS = :XxNost and                                                  MD042142
     C+       PONS = :XxNost and                                                            MD042142
     C+       RECI = 'D'  or
     C+       TCUCY = :YyCcy and
     C**********+       RONS = :XxNost and                                                  MD042142
     C+       PONS = :XxNost and                                                            MD042142
     C+       RECI = 'D'
     C+ order by
     C+       DLNO
     C/end-exec

     C/exec SQL
     C+ open DLLIST2
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
     C+ from DLLIST2
     C+ into :pdlno, :pdtyp, :pdlst
     C/end-exec

     C                   DOW       SQLCode <> 100

     C**********         EVAL      APTRAN = 'Forward Rate Agreement'                        MD042142
     C                   EVAL      APTRAN = 'FRA / IRS / CACF'                              MD042142
     C                   EVAL      DATAP = APTRAN +  TXSTAT(1) + ' ' + pDLNO +
     C                             ' ' + pDTYP +  ' ' + pDLST
     C                   IF        *IN60 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
     C                   WRITE     DETAIL1
     C                   EVAL      XxRtn  = 'R'
     C                   IF        PMODE = 'V'
     C                   GOTO      VALEXIT
     C                   ENDIF

     C/exec SQL
     C+ fetch next
     C+ from DLLIST2
     C+ into :pdlno, :pdtyp, :pdlst
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close DLLIST2
     C/end-exec
      *
      ** Set file pointer to first record of DEAMSDI
      *
     C/exec SQL
     C+ declare DLLIST3 cursor for
     C+ select DLNO, DTYP, DLST from DEAMSDI
     C+ where CCY = :YyCcy and
     C+       RONS = :XxNost and
     C+       AMTP in ('EM', 'PD', 'PI', 'SI' ) or
     C+       CCY = :YyCcy and
     C+       PONS = :XxNost  and
     C+       AMTP in ('EM', 'PD', 'PI', 'SI' )
     C+ order by
     C+       DLNO
     C/end-exec

     C/exec SQL
     C+ open DLLIST3
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
     C+ from DLLIST3
     C+ into :pdlno, :pdtyp, :pdlst
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   EVAL      APTRAN = 'Deals Amendment'
     C                   EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pDLNO +
     C                             ' ' + pDTYP + ' ' + pDLST
     C                   IF        *IN60 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
     C                   WRITE     DETAIL1
     C                   EVAL      XxRtn  = 'R'
     C                   IF        PMODE = 'V'
     C                   GOTO      VALEXIT
     C                   ENDIF

     C/exec SQL
     C+ fetch next
     C+ from DLLIST3
     C+ into :pdlno, :pdtyp, :pdlst
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close DLLIST3
     C/end-exec
      *
      ** Set file pointer to first record of DEALSDD
      *
     C/exec SQL
     C+ declare DLLIST4 cursor for
     C+ select DLNO, DTYP, DLST from DEALSDD
     C+ where CCY = :YyCcy and
     C+       RONS = :XxNost and
     C+       RECI = 'D'  or
     C+       CCY = :YyCcy and
     C+       PONS = :XxNost and
     C+       RECI = 'D'
     C+ order by
     C+       DLNO
     C/end-exec

     C/exec SQL
     C+ open DLLIST4
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
     C+ from DLLIST4
     C+ into :pdlno, :pdtyp, :pdlst
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   EVAL      APTRAN = 'Negotiable Assests Purchased'
     C                   EVAL      DATAP = APTRAN + TXSTAT(1) + ' '  + pDLNO +
     C                             ' ' + pDTYP +  ' ' + pDLST
     C                   IF        *IN60 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
     C                   WRITE     DETAIL1

     C/exec SQL
     C+ fetch next
     C+ from DLLIST4
     C+ into :pdlno, :pdtyp, :pdlst
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close DLLIST4
     C/end-exec
      *
      ** Set file pointer to first record of DEALSDE
      *
     C/exec SQL
     C+ declare DLLIST5 cursor for
     C+ select DLNO, DTYP, DLST from DEALSDE
     C+ where CCY = :YyCcy and
     C+       RONS = :XxNost or
     C+       CCY = :YyCcy and
     C+       PONS = :XxNost
     C+ order by
     C+       DLNO
     C/end-exec

     C/exec SQL
     C+ open DLLIST5
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
     C+ from DLLIST5
     C+ into :pdlno, :pdtyp, :pdlst
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   EVAL      APTRAN = 'Negotiable Assests Sold'
     C                   EVAL      DATAP = APTRAN +  TXSTAT(1) + ' ' + pDLNO +
     C                              ' ' + pDTYP + ' ' + pDLST
     C                   IF        *IN60 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
     C                   WRITE     DETAIL1
     C                   EVAL      XxRtn  = 'R'
     C                   IF        PMODE = 'V'
     C                   GOTO      VALEXIT
     C                   ENDIF

     C/exec SQL
     C+ fetch next
     C+ from DLLIST5
     C+ into :pdlno, :pdtyp, :pdlst
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close DLLIST5
     C/end-exec
      *
      ** Set file pointer to first record of FXNETMPD
      *
     c                   IF        CDL002 = 'Y'
     C/exec SQL
     C+ declare DLLIST6 cursor for
     C+ select AMNETR from FXNETMPD
     C+ where AMCCYD = :YyCcy and
     C+       AMOURN = :XxNost
     C+ order by
     C+       AMNETR
     C/end-exec

     C/exec SQL
     C+ open DLLIST6
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
     C+ from DLLIST6
     C+ into :pAMNETR
     C/end-exec

     C                   DOW       SQLCode <> 100

     C**********         EVAL      APTRAN = 'Negotiable Assests Sold'                       MD042142
     C                   EVAL      APTRAN = 'FX Confirmed Nets'                             MD042142
     C                   EVAL      DATAP =  APTRAN +  TXSTAT(1) + ' ' +  pAMNETR
     C                   IF        *IN60 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
     C                   WRITE     DETAIL1
     C                   EVAL      XxRtn  = 'R'
     C                   IF        PMODE = 'V'
     C                   GOTO      VALEXIT
     C                   ENDIF

     C/exec SQL
     C+ fetch next
     C+ from DLLIST6
     C+ into :pAMNETR
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close DLLIST6
     C/end-exec
     C                   ENDIF
      *
      ** Set file pointer to first record of DLFEED
      *
     C                   IF        CAS009 = 'Y'
      *
     C/exec SQL
     C+ declare DLLIST7 cursor for
     C+ select DFDLNO, DFDTYP, DFSTYP from DLFEED
     C+ where DFFCCY = :YyCcy and
     C+       DFRONS = :XxNost or
     C+       DFFCCY = :YyCcy and
     C+       DFPONS = :XxNost
     C+ order by
     C+       DFDLNO
     C/end-exec

     C/exec SQL
     C+ open DLLIST7
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
     C+ from DLLIST7
     C+ into :pdlno, :pdtyp, :pdlst
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   EVAL      APTRAN = 'Dealing Fees'
     C**********         EVAL      DATAP =pDLNO +  TXSTAT(1) + ' ' + pDTYP +                MD048898
     C                   EVAL      DATAP =APTRAN +  TXSTAT(1) + ' ' + pDLNO +               MD048898
     C                              ' ' + pDTYP + ' ' + pDLST                               MD048898
     C                   IF        *IN60 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
     C                   WRITE     DETAIL1
     C                   EVAL      XxRtn  = 'R'
     C                   IF        PMODE = 'V'
     C                   GOTO      VALEXIT
     C                   ENDIF

     C/exec SQL
     C+ fetch next
     C+ from DLLIST7
     C+ into :pdlno, :pdtyp, :pdlst
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close DLLIST7
     C/end-exec
     C                   ENDIF
      *
      ** Set file pointer to first record of FXCLSPSD
      *
     C                   IF        CDL008 = 'Y'
      *
     C/exec SQL
     C+ declare DLLIST8 cursor for
     C+ select PYCCY, PYNOST, PYVDAT, PYSEQN from FXCLSPSD
     C+ where PYCCY = :YyCcy and
     C+       PYNOST = :XxNost
     C/end-exec

     C/exec SQL
     C+ open DLLIST8
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
     C+ from DLLIST8
     C+ into :pPYCCY, :pPYNOST, :pPYVDAT, :pPYSEQN
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   EVAL      APTRAN = 'CLS Pay-in Schedule'                           MD042142
     C**********         EVAL      DATAP =pPYCCY +  TXSTAT(1) + ' ' + pPYNOST +             MD042142
     C**********                   ' ' + pPYVDAT + ' ' + pPYSEQN                            MD042142
     C                   EVAL      DATAP =APTRAN +  TXSTAT(1) + ' ' + pPYCCY +              MD042142
     C                             pPYNOST + ' ' + pPYSEQN                                  MD042142
     C                   IF        *IN60 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
     C                   WRITE     DETAIL1
     C                   EVAL      XxRtn  = 'R'
     C                   IF        PMODE = 'V'
     C                   GOTO      VALEXIT
     C                   ENDIF

     C/exec SQL
     C+ fetch next
     C+ from DLLIST8
     C+ into :pPYCCY, :pPYNOST, :pPYVDAT, :pPYSEQN
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close DLLIST8
     C/end-exec
     C                   ENDIF
      *
      ** Set file pointer to first record of SDFNMSPD
      *
     C                   IF        CDL025  = 'Y'
      *
     C/exec SQL
     C+ declare DLLIST9 cursor for
     C+ select LCYCD, LCUST, LSEQN from SDFNMSPD
     C+ where LCYCD = :YyCcy and
     C+       LRONO = :XxNost or
     C+       LCYCD = :YyCcy and
     C+       LPONO = :XxNost
     C+ order by
     C+       LCYCD
     C/end-exec

     C/exec SQL
     C+ open DLLIST9
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
     C+ from DLLIST9
     C+ into :pLCYCD, :pLCUST, :pLSEQN
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   MOVEL     PLSEQN        CLSEQN            4
     C                   EVAL      APTRAN = 'FX Netting Multiple Settlements'               MD042142
     C**********         EVAL      DATAP =pLCYCD +  TXSTAT(1) + ' ' + pLCUST +              MD042142
     C                   EVAL      DATAP =APTRAN +  TXSTAT(2) + ' ' + pLCUST +              MD042142
     C                             ' ' + cLSEQN
     C                   IF        *IN60 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
     C                   WRITE     DETAIL1

     C/exec SQL
     C+ fetch next
     C+ from DLLIST9
     C+ into :pLCYCD, :pLCUST, :pLSEQN
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close DLLIST9
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
      *
      ** Establish switchable features
      *
     C                   MOVE      'N'           CDL018            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM      'CDL018'      @KEY6             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CDL018
     C                   ENDIF
      *
     C                   MOVE      'N'           CDL002            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM      'CDL002'      @KEY6             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CDL002
     C                   ENDIF
      *
     C                   MOVE      'N'           CAS009            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM      'CAS009'      @KEY6             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CAS009
     C                   ENDIF
      *
     C                   MOVE      'N'           CDL025            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM      'CDL025'      @KEY6             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CDL025
     C                   ENDIF
      *
     C                   MOVE      'N'           CDL008            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM      'CDL008'      @KEY6             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CDL008
     C                   ENDIF
      *
      ** Access bank details.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
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
** TXSTAT
BLOCKING DELETION
INFORMATION
DEAD TRANSACTION
