     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited. 2017')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Nostro Account Activity - LE')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SD000152LE - Nostro Account Activity - LE.                   *
      *                                                               *
      *  Function:  This program checks if a Nostro is used by        *
      *             a GL/Retail transactions.                         *
      *                                                               *
      *  Called By: SD000151R                                         *
      *                                                               *
      *   (c) Finastra International Limited. 2017                    *
      *                                                               *
      *  Last Amend No. MD051081           Date 29May18               *
      *  Prev Amend No. MD042142           Date 08May18               *
      *                 MD038440A          Date 08May18               *
      *                 MD048898           Date 11Dec17               *
      *                 MD038440           Date 27Oct17               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD051081 - Program loop, semi colon missing                  *
      *  MD042142 - Refine MD038440 and MD048898 fixes.               *
      *           - Applied for MD038440A                             *
      *  MD038440A - No validation for amendable side of a dead txn   *
      *              Block deletion of Nostro if used.                *
      *  MD048898 - No reports produced. conditon RCF processing      *
      *  MD038440 - Nostro deletion issue. Revise validation process. *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FSD000152P4O    E             PRINTER OFLIND(*IN60)
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

     D pLNRF           S              6A
     D pLTYP           S              2A
     D pSUTP           S              2A
     D pPONS           S             12A                                                   MD038440A
     D pRONS           S             12A                                                   MD038440A
     D pFELOAN         S              6A
     D pFEFSEQ         S              2  0
     D pFEFCOD         S              2  0
     D nFEFSEQ         S              2A
     D nFEFCOD         S              2A
     D**********pFALOANS              6A                                                    MD042142
     D pFAFACL         S              5  0                                                  MD042142
     D nFAFACL         S              5A                                                    MD042142
     D pFAFSEQ         S              2  0
     D nFAFSEQ         S              2A
     D PCNUM           S              6A
     D PFACT           S              2  0
     D PFCNO           S              2  0
     D PVDAT           S              5  0
     D nFACT           S              2A
     D nFCNO           S              2A
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
      *  SValv  - Retrieve Lending transactions                       *
      *                                                               *
      *****************************************************************
     C     SRValv        BEGSR
      *
      ** Set file pointer to first record of CLOANCL
      *
     C/exec SQL
     C+ declare LELIST1 cursor for
     C**select*LNRF, LTYP, SUTP, VDAT from CLOANCL                                         MD038440A
     C+ select LNRF, LTYP, SUTP, VDAT, PONS, RONS from CLOANCL                             MD038440A
     C+ where CCY = :YyCcy and
     C+       PONS = :XxNost and
     C+       RECI = 'D' and
     C********PTYP in (61, 62, 63, 70, 80, 64, 65, 68, 71 )                                MD038440A
     C+       PTYP in (61, 62, 63, 70, 80, 64, 65, 68, 71 )  or                            MD038440A
     C+       CCY = :YyCcy and                                                             MD038440A
     C+       RONS = :XxNost and                                                           MD038440A
     C+       RECI = 'D' and                                                               MD038440A
     C+       PTYP in (61, 62, 63, 70, 80, 64, 65, 68, 71 )
     C+ order by
     C+       LNRF
     C/end-exec

     C/exec SQL
     C+ open LELIST1
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
     C+ from LELIST1
     C**into**pLNRF, :pLTYP, :pSUTP, :pVDAT                                                MD038440A
     C+ into :pLNRF, :pLTYP, :pSUTP, :pVDAT, :pPONS, :pRONS                                MD038440A
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   EVAL      APTRAN = 'Customer Lending'
     C                   IF        PPONS = XXNOST                                          MD038440A
     C                   IF        PVDAT <  BJRDNB
     C                   EVAL      DATAP = APTRAN + TXSTAT(3) + ' ' + pLNRF +
     C                             ' ' + pLTYP + ' ' + pSUTP
     C                   ELSE
     C                   EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pLNRF +
     C                             ' ' + pLTYP + ' ' + pSUTP
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
      *                                                                                    MD038440A
     C                   IF        PRONS = XXNOST                                          MD038440A
     C                   IF        PVDAT <  BJRDNB                                         MD038440A
     C                   EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pLNRF +              MD038440A
     C                             ' ' + pLTYP + ' ' + pSUTP                               MD038440A
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

     C/exec SQL
     C+ fetch next
     C+ from LELIST1
     C**into*:pLNRF, :pLTYP, :pSUTP, :pVDAT                                                MD038440A
     C+ into :pLNRF, :pLTYP, :pSUTP, :pVDAT, :pPONS, :pRONS                                MD038440A
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LELIST1
     C/end-exec
      *
     C/exec SQL
     C+ declare LELIST1B cursor for
     C**select LNRF, LTYP, SUTP, VDAT from CLOANCL                                         MD038440A
     C+ select LNRF, LTYP, SUTP, VDAT, PONS, RONS from CLOANCL                             MD038440A
     C+ where CCY = :YyCcy and
     C+       RONS = :XxNost and
     C+       RECI = 'D' and
     C********PTYP in (66, 67, 69, 72)                                                     MD038440A
     C+       PTYP in (66, 67, 69, 72)   or                                                MD038440A
     C+       CCY = :YyCcy and                                                             MD038440A
     C+       PONS = :XxNost and                                                           MD038440A
     C+       RECI = 'D' and                                                               MD038440A
     C+       PTYP in (66, 67, 69, 72)                                                     MD038440A
     C+ order by
     C+       LNRF
     C/end-exec

     C/exec SQL
     C+ open LELIST1B
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
     C+ from LELIST1B
     C*********into :pLNRF, :pLTYP, :pSUTP, :pVDAT                                         MD038440A
     C+ into :pLNRF, :pLTYP, :pSUTP, :pVDAT, :pPONS, :pRONS                                MD038440A
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   EVAL      APTRAN = 'Customer Lending'
     C                   IF        PRONS =  XXNOST                                         MD038440A
     C                   IF        PVDAT <  BJRDNB
     C                   EVAL      DATAP = APTRAN + TXSTAT(3) + ' ' + pLNRF +
     C                             ' ' + pLTYP + ' ' + pSUTP
     C                   ELSE
     C                   EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pLNRF +
     C                             ' ' + pLTYP + ' ' + pSUTP
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
      *                                                                                    MD038440A
     C                   IF        PPONS =  XXNOST                                         MD038440A
     C                   IF        PVDAT <  BJRDNB                                         MD038440A
     C                   EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pLNRF +              MD038440A
     C                             ' ' + pLTYP + ' ' + pSUTP                               MD038440A
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

     C/exec SQL
     C+ fetch next
     C+ from LELIST1B
     C**into*:pLNRF, :pLTYP, :pSUTP, :pVDAT                                                MD038440A
     C**into*:pLNRF, :pLTYP, :pSUTP, :pVDAT, :pPONS,  pRONS                       MD038440A MD051081
     C+ into :pLNRF, :pLTYP, :pSUTP, :pVDAT, :pPONS, :pRONS                                 MD051081
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LELIST1B
     C/end-exec
      ** Set file pointer to first record of LEFEED
      *
     C/exec SQL
     C+ declare LELIST2  cursor for
     C+ select FELOAN, FEFSEQ, FEFCOD from LEFEED
     C+ where FEFCCY = :YyCcy and
     C+       RONS = :XxNost or
     C+       FEFCCY = :YyCcy and
     C+       FEOURS = :XxNost
     C+ order by
     C+       FELOAN
     C/end-exec

     C/exec SQL
     C+ open LELIST2
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
     C+ from LELIST2
     C+ into :pFELOAN, :pFEFSEQ, :pFEFCOD
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   MOVEL     pFEFSEQ       nFEFSEQ
     C                   MOVEL     pFEFCOD       nFEFCOD
     C                   EVAL      APTRAN = 'Fees'
     C                   EVAL      DATAP = APTRAN + TXSTAT(1)+ ' ' + pFELOAN +
     C                             ' ' +  nFEFSEQ + ' ' + nFEFCOD
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
     C+ from LELIST2
     C+ into :pFELOAN, :pFEFSEQ, :pFEFCOD
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LELIST2
     C/end-exec
      *
      ** Set file pointer to first record of LEFEEAD
      *
     C/exec SQL
     C+ declare LELIST3  cursor for
     C**********+ select FALOAN, FAFSEQ   from LEFEEAD                                      MD042142
     C+ select FAFACL, FAFSEQ   from LEFEEAD                                                MD042142
     C+ where FAFCCY = :YyCcy and
     C+       RONS = :XxNost or
     C+       FAFCCY = :YyCcy and
     C+       FAOURS = :XxNost
     C+ order by
     C********FALOAN                                                                        MD042142
     C+       FAFACL                                                                        MD042142
     C/end-exec

     C/exec SQL
     C+ open LELIST3
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
     C+ from LELIST3
     C**********+ into :pFALOAN, :pFAFSEQ                                                   MD042142
     C+ into :pFAFACL, :pFAFSEQ                                                             MD042142
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   MOVEL     pFAFSEQ       nFAFSEQ
     C                   MOVEL     pFAFACL       nFAFACL                                    MD042142
     C                   EVAL      APTRAN = 'Fee Settlements'
     C**********         EVAL      DATAP = APTRAN + TXSTAT(1)+ ' ' + pFALOAN +              MD042142
     C                   EVAL      DATAP = APTRAN + TXSTAT(1)+ ' ' + nFAFACL +              MD042142
     C                             ' ' + nFAFSEQ
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
     C+ from LELIST3
     C**********+ into :pFALOAN, :pFAFSEQ                                                   MD042142
     C+ into :pFAFACL, :pFAFSEQ                                                             MD042142
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LELIST3
     C/end-exec
      *
      ** Set file pointer to first record of LOAMSDK
      *
     C/exec SQL
     C+ declare LELIST4 cursor for
     C+ select LNRF, LTYP, SUTP from LOAMSDK
     C+ where CCY = :YyCcy and
     C+       RONS = :XxNost and
     C+       AMTP = 'MR' or
     C+       CCY = :YyCcy and
     C+       PONS = :XxNost and
     C+       AMTP = 'MR'  or
     C+       CCY = :YyCcy and
     C+       RONS = :XxNost and
     C+       AMTP = 'RE' or
     C+       CCY = :YyCcy and
     C+       PONS = :XxNost and
     C+       AMTP = 'RE'  or
     C+       CCY = :YyCcy and
     C+       RONS = :XxNost and
     C+       AMTP = 'PI' or
     C+       CCY = :YyCcy and
     C+       PONS = :XxNost and
     C+       AMTP = 'PI'
     C+ order by
     C+       LNRF
     C/end-exec

     C/exec SQL
     C+ open LELIST4
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
     C+ from LELIST4
     C+ into :pLNRF, :pLTYP, :pSUTP
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   EVAL      APTRAN = 'Loan Events'
     C                   EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pLNRF +
     C                             ' ' + pLTYP +      ' ' + pSUTP
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
     C+ from LELIST4
     C+ into :pLNRF, :pLTYP, :pSUTP
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LELIST4
     C/end-exec
      *
      ** Set file pointer to first record of CLOANCK
      *
     C/exec SQL
     C+ declare LELIST7 cursor for
     C**********+ select LNRF  from CLOANCK                                                 MD042142
     C+ select LNRF  from CLOANL1                                                           MD042142
     C**********+ where RRSC  = :YyCcy and                                                  MD042142
     C+ where CCY  = :YyCcy and                                                             MD042142
     C+       RRON = :XxNost
     C+ order by
     C+       LNRF
     C/end-exec

     C/exec SQL
     C+ open LELIST7
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
     C+ from LELIST7
     C+ into :pLNRF
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   EVAL      APTRAN = 'Rollover'
     C                   EVAL      DATAP = APTRAN +  TXSTAT(1) + ' ' + pLNRF
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
     C+ from LELIST7
     C+ into :pLNRF
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LELIST7
     C/end-exec
      *
      ** Set file pointer to first record of FCLTYFM
      *
     C/exec SQL
     C+ declare LELIST8 cursor for
     C+ select CNUM, FACT, FCNO  from FCLTYFM
     C+ where FCCY  = :YyCcy and
     C+       RONS = :XxNost or
     C+       FCCY  = :YyCcy and
     C+       PONS = :XxNost
     C+ order by
     C+       CNUM
     C/end-exec

     C/exec SQL
     C+ open LELIST8
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
     C+ from LELIST8
     C+ into :pCNUM, :pFACT, :pFCNO
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   MOVEL     pFACT         nFACT
     C                   MOVEL     pFCNO         nFCNO
     C                   EVAL      APTRAN = 'Facility'
     C                   EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pCNUM +
     C                               ' ' +   nFACT + ' ' +  nFCNO
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
     C+ from LELIST8
     C+ into :pCNUM, :pFACT, :pFCNO
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LELIST8
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
      ********************************************************************
      /EJECT
      ********************************************************************
** TXSTAT
BLOCKING DELETION
INFORMATION
DEAD TRANSACTION
