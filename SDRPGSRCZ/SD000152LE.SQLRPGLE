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
      *  Last Amend No. MD054551           Date 14Oct19               *
      *  Prev Amend No. MD054189           Date 03Sep19               *
      *                 MD052107           Date 02Jul19               *
      *                 MD051081           Date 29May18               *
      *                 MD042142           Date 08May18               *
      *                 MD038440A          Date 08May18               *
      *                 MD048898           Date 11Dec17               *
      *                 MD038440           Date 27Oct17               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054551 -  SRFacility subroutine not invoked                *
      *  MD054189  - Misaligned Nostro Report Layout and Duplicate    *
      *              Pay/Receive Settlement Leg                       *
      *  MD052107  - Reformat Nostro Account Activity Report Layout   *
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
     D pFEFACL         S              5  0                                                  MD052107
     D nFEFACL         S              5A                                                    MD052107
     D**********pFALOANS              6A                                                    MD042142
     D pFAFACL         S              5  0                                                  MD042142
     D nFAFACL         S              5A                                                    MD042142
     D pFAFSEQ         S              2  0
     D nFAFSEQ         S              2A
     D PCNUM           S              6A
     D********** PFACT           S              2  0                                        MD054551
     D PFACT           S              3  0                                                  MD054551
     D PFCNO           S              2  0
     D PVDAT           S              5  0
     D PMDAT           S              5  0                                                  MD054189
     D********** nFACT           S              2A                                          MD054551
     D nFACT           S              3A                                                    MD054551
     D nFCNO           S              2A
     D KACNO           S             17A
     D********** APTRAN          S             40A                                          MD052107
     D APTRAN          S             31A                                                    MD052107

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
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *****************************************************************
      *                                                               *
      *  SValv  - Retrieve Lending transactions                       *
      *                                                               *
      *****************************************************************
     C     SRValv        BEGSR
      *                                                                                     MD052107
      **  Customer Lending                                                                  MD052107
     C                   IF        XxRtn <> 'R'                                             MD052107
     C                   EXSR      SRCustLend                                               MD052107
     C                   ENDIF                                                              MD052107
      *                                                                                     MD054551
      **  Facilities                                                                        MD054551
     C                   IF        XxRtn <> 'R'                                             MD054551
     C                   EXSR      SRFacility                                               MD054551
     C                   ENDIF                                                              MD054551
      *                                                                                     MD052107
      **  Fees                                                                              MD052107
     C                   IF        XxRtn <> 'R'                                             MD052107
     C                   EXSR      SRLendFee                                                MD052107
     C                   ENDIF                                                              MD052107
      *                                                                                     MD052107
      **  Fee Settlements                                                                   MD052107
     C                   IF        XxRtn <> 'R'                                             MD052107
     C                   EXSR      SRFeeSett                                                MD052107
     C                   ENDIF                                                              MD052107
      *                                                                                     MD052107
      **  Loan Events                                                                       MD052107
     C                   IF        XxRtn <> 'R'                                             MD052107
     C                   EXSR      SRLoanEvnt                                               MD052107
     C                   ENDIF                                                              MD052107
      *                                                                                     MD052107
      **  Rollovers                                                                         MD052107
     C                   IF        XxRtn <> 'R'                                             MD052107
     C                   EXSR      SRRollOver                                               MD052107
     C                   ENDIF                                                              MD052107
      *                                                                                     MD052107
     C                   ENDSR                                                              MD052107
      *****************************************************************                     MD052107
      /EJECT                                                                                MD052107
      *****************************************************************                     MD052107
      *  SRCustLend - Retrieve Customer Lending transactions          *                     MD052107
      *                                                               *                     MD052107
      *****************************************************************                     MD052107
     C     SRCustLend    BEGSR                                                              MD052107
      *
      ** Set file pointer to first record of CLOANCL
      *
     C/exec SQL
     C+ declare LELIST1 cursor for
     C**select*LNRF, LTYP, SUTP, VDAT from CLOANCL                                         MD038440A
     C**********+ select LNRF, LTYP, SUTP, VDAT, PONS, RONS from CLOANCL          MD038440A MD054189
     C+ select LNRF, LTYP, SUTP, VDAT, MDAT, PONS, RONS from CLOANCL                        MD054189
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
     C**********+       LNRF                                                                MD052107
     C**********+       LNRF, VDAT DESC, LTYP, SUTP                                MD052107 MD054189
     C+       LNRF, VDAT DESC, MDAT DESC, LTYP, SUTP                                        MD054189
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
     C**********+ into :pLNRF, :pLTYP, :pSUTP, :pVDAT, :pPONS, :pRONS             MD038440A MD054189
     C+ into :pLNRF, :pLTYP, :pSUTP, :pVDAT, :pMDAT, :pPONS, :pRONS                         MD054189
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   EVAL      APTRAN = 'Customer Lending'
     C                   IF        PPONS = XXNOST                                          MD038440A
     C                   IF        PVDAT <  BJRDNB
     C**********         EVAL      DATAP = APTRAN + TXSTAT(3) + ' ' + pLNRF +               MD052107
     C**********                   ' ' + pLTYP + ' ' + pSUTP                                MD052107
     C                   EVAL      DATAP = TXSTAT(3) + ' ' + APTRAN + ' ' +                 MD052107
     C                             pLNRF + '         ' + pLTYP + ' '  +                     MD052107
     C                             pSUTP + '         ' + NOTES(2)                           MD052107
     C                   ELSE
     C**********         EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pLNRF +               MD052107
     C**********                   ' ' + pLTYP + ' ' + pSUTP                                MD052107
     C                   EVAL      DATAP = TXSTAT(1) + ' ' + APTRAN + ' ' +                 MD052107
     C**********                   pLNRF + '      ' + pLTYP + ' '  +               MD052107 MD054189
     C                             pLNRF + '         ' + pLTYP + ' '  +                     MD054189
     C                             pSUTP + '         ' + NOTES(2)                           MD052107
     C                   IF        PMODE = 'V'
     C                   EVAL      XxRtn  = 'R'
     C**********         GOTO      VALEXIT                                                  MD052107
     C                   ENDIF
     C                   ENDIF
      *                                                                                     MD052107
     C                   IF        XxRtn <> 'R'                                             MD052107
     C                   IF        *IN60 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
     C                   WRITE     DETAIL1
     C                   ENDIF                                                             MD052107
     C                   ENDIF                                                             MD038440A
      *                                                                                    MD038440A
     C                   IF        PRONS = XXNOST                                          MD038440A
     C                   IF        (PMDAT >= BJRDNB)                                        MD054189
     C                              Or PMDAT = *Zeros                                       MD054189
     C**********         IF        PVDAT <  BJRDNB                                MD038440A MD054189
     C**********         EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pLNRF +     MD038440A MD052107
     C**********                   ' ' + pLTYP + ' ' + pSUTP                      MD038440A MD052107
     C                   EVAL      DATAP = TXSTAT(1) + ' ' + APTRAN + ' ' +                 MD052107
     C                             pLNRF + '         ' + pLTYP + ' '  +                     MD052107
     C                             pSUTP + '         ' + NOTES(1)                           MD052107
     C                   IF        PMODE = 'V'                                             MD038440A
     C                   EVAL      XxRtn  = 'R'                                            MD038440A
     C**********         GOTO      VALEXIT                                        MD038440A MD052107
     C                   ENDIF                                                             MD038440A
                                                                                            MD054189
     C                   IF        XxRtn <> 'R'                                             MD054189
     C                   IF        *IN60 = *ON                                              MD054189
     C                   WRITE     HEADP1                                                   MD054189
     C                   EVAL      *IN60 = *OFF                                             MD054189
     C                   ENDIF                                                              MD054189
      *                                                                                     MD054189
     C                   WRITE     DETAIL1                                                  MD054189
     C                   ENDIF                                                              MD054189
     C                   ENDIF                                                             MD038440A
      *                                                                                     MD052107
     C**********         IF        XxRtn <> 'R'                                    MD052107 MD054189
     C**********         IF        *IN60 = *ON                                    MD038440A MD054189
     C**********         WRITE     HEADP1                                         MD038440A MD054189
     C**********         EVAL      *IN60 = *OFF                                   MD038440A MD054189
     C**********         ENDIF                                                    MD038440A MD054189
      *                                                                                    MD038440A
     C**********         WRITE     DETAIL1                                        MD038440A MD054189
     C**********         ENDIF                                                     MD052107 MD054189
     C                   ENDIF                                                             MD038440A

     C/exec SQL
     C+ fetch next
     C+ from LELIST1
     C**into*:pLNRF, :pLTYP, :pSUTP, :pVDAT                                                MD038440A
     C**********+ into :pLNRF, :pLTYP, :pSUTP, :pVDAT, :pPONS, :pRONS             MD038440A MD054189
     C+ into :pLNRF, :pLTYP, :pSUTP, :pVDAT, :pMDAT, :pPONS, :pRONS                         MD054189
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LELIST1
     C/end-exec
      *
     C/exec SQL
     C+ declare LELIST1B cursor for
     C**select LNRF, LTYP, SUTP, VDAT from CLOANCL                                         MD038440A
     C**********+ select LNRF, LTYP, SUTP, VDAT, PONS, RONS from CLOANCL          MD038440A MD054189
     C+ select LNRF, LTYP, SUTP, VDAT, MDAT, PONS, RONS from CLOANCL                        MD054189
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
     C**********+       LNRF                                                                MD052107
     C**********+       LNRF, VDAT DESC, LTYP, SUTP                                MD052107 MD054189
     C+       LNRF, VDAT DESC, MDAT DESC, LTYP, SUTP                                        MD054189
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
     C**********+ into :pLNRF, :pLTYP, :pSUTP, :pVDAT, :pPONS, :pRONS             MD038440A MD054189
     C+ into :pLNRF, :pLTYP, :pSUTP, :pVDAT, :pMDAT, :pPONS, :pRONS                         MD054189
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   EVAL      APTRAN = 'Customer Lending'
     C                   IF        PRONS =  XXNOST                                         MD038440A
     C                   IF        PVDAT <  BJRDNB
     C***********        EVAL      DATAP = APTRAN + TXSTAT(3) + ' ' + pLNRF +               MD052107
     C***********                  ' ' + pLTYP + ' ' + pSUTP                                MD052107
     C                   EVAL      DATAP = TXSTAT(3) + ' ' + APTRAN + ' ' +                 MD052107
     C                             pLNRF + '         ' + pLTYP + ' '  +                     MD052107
     C                             pSUTP + '         ' + NOTES(1)                           MD052107
     C                   ELSE
     C**********         EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pLNRF +               MD052107
     C**********                   ' ' + pLTYP + ' ' + pSUTP                                MD052107
     C                   EVAL      DATAP = TXSTAT(1) + ' ' + APTRAN + ' ' +                 MD052107
     C                             pLNRF + '         ' + pLTYP + ' '  +                     MD052107
     C                             pSUTP + '         ' + NOTES(1)                           MD052107
     C                   IF        PMODE = 'V'
     C                   EVAL      XxRtn  = 'R'
     C**********         GOTO      VALEXIT                                                  MD052107
     C                   ENDIF
     C                   ENDIF
      *                                                                                     MD052107
     C                   IF        XxRtn <> 'R'                                             MD052107
     C                   IF        *IN60 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
     C                   WRITE     DETAIL1
     C                   ENDIF                                                              MD052107
     C                   ENDIF                                                             MD038440A
      *                                                                                    MD038440A
     C                   IF        PPONS =  XXNOST                                         MD038440A
     C                   IF        (PMDAT >= BJRDNB)                                        MD054189
     C                              Or PMDAT = *Zeros                                       MD054189
     C**********         IF        PVDAT <  BJRDNB                                MD038440A MD054189
     C**********         EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pLNRF +     MD038440A MD052107
     C**********                   ' ' + pLTYP + ' ' + pSUTP                      MD038440A MD052107
     C                   EVAL      DATAP = TXSTAT(1) + ' ' + APTRAN + ' ' +                 MD052107
     C                             pLNRF + '         ' + pLTYP + ' '  +                     MD052107
     C                             pSUTP + '         ' + NOTES(2)                           MD052107
     C                   IF        PMODE = 'V'                                             MD038440A
     C                   EVAL      XxRtn  = 'R'                                            MD038440A
     C**********         GOTO      VALEXIT                                                 MD038440A
     C                   ENDIF                                                             MD038440A
     C**********         IF        XxRtn <> 'R'                                             MD054189
     C**********         IF        *IN60 = *ON                                              MD054189
     C**********         WRITE     HEADP1                                                   MD054189
     C**********         EVAL      *IN60 = *OFF                                             MD054189
     C**********         ENDIF                                                              MD054189
      *                                                                                     MD054189
     C**********         WRITE     DETAIL1                                                  MD054189
     C**********         ENDIF                                                              MD054189
     C                   ENDIF                                                             MD038440A
      *                                                                                     MD052107
     C**********         IF        XxRtn <> 'R'                                    MD052107 MD054189
     C**********         IF        *IN60 = *ON                                    MD038440A MD054189
     C**********         WRITE     HEADP1                                         MD038440A MD054189
     C**********         EVAL      *IN60 = *OFF                                   MD038440A MD054189
     C**********         ENDIF                                                    MD038440A MD054189
      *                                                                                    MD038440A
     C**********         WRITE     DETAIL1                                        MD038440A MD054189
     C**********         ENDIF                                                     MD052107 MD054189
     C                   ENDIF                                                             MD038440A

     C/exec SQL
     C+ fetch next
     C+ from LELIST1B
     C**into*:pLNRF, :pLTYP, :pSUTP, :pVDAT                                                MD038440A
     C**into*:pLNRF, :pLTYP, :pSUTP, :pVDAT, :pPONS,  pRONS                       MD038440A MD051081
     C**********+ into :pLNRF, :pLTYP, :pSUTP, :pVDAT, :pPONS, :pRONS              MD051081 MD054189
     C+ into :pLNRF, :pLTYP, :pSUTP, :pVDAT, :pMDAT, :pPONS, :pRONS                         MD054189
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LELIST1B
     C/end-exec
     C                   ENDSR                                                              MD052107
      *****************************************************************                     MD052107
      /EJECT                                                                                MD052107
      *****************************************************************                     MD052107
      *  SRLendFee - Retrieve Customer Lending Fees                   *                     MD052107
      *                                                               *                     MD052107
      *****************************************************************                     MD052107
     C     SRLendFee     BEGSR                                                              MD052107
      *                                                                                     MD052107
      ** Set file pointer to first record of LEFEED
      *
     C/exec SQL
     C+ declare LELIST2  cursor for
     C**********+ select FELOAN, FEFSEQ, FEFCOD from LEFEED                                 MD052107
     C+ select FEFACL, FELOAN, FEFSEQ, FEFCOD from LEFEED                                   MD052107
     C+ where FEFCCY = :YyCcy and
     C+       RONS = :XxNost or
     C+       FEFCCY = :YyCcy and
     C+       FEOURS = :XxNost
     C+ order by
     C**********+       FELOAN                                                              MD052107
     C+       FEFACL DESC, FELOAN                                                           MD052107
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
     C**********+ into :pFELOAN, :pFEFSEQ, :pFEFCOD                                         MD052107
     C+ into :pFEFACL, :pFELOAN, :pFEFSEQ, :pFEFCOD                                         MD052107
     C/end-exec

     C                   DOW       SQLCode <> 100

     C**********         MOVEL     pFEFSEQ       nFEFSEQ                                    MD052107
     C**********         MOVEL     pFEFCOD       nFEFCOD                                    MD052107
     C                   MOVE      pFEFSEQ       nFEFSEQ                                    MD052107
     C                   MOVE      pFEFCOD       nFEFCOD                                    MD052107
     C**********         EVAL      APTRAN = 'Fees'                                          MD052107
     C**********         EVAL      DATAP = APTRAN + TXSTAT(1)+ ' ' + pFELOAN +              MD052107
     C**********                   ' ' +  nFEFSEQ + ' ' + nFEFCOD                           MD052107
     C                   IF        pFEFACL <> 0                                             MD052107
     C                   MOVE      pFEFACL       nFEFACL                                    MD052107
     C                   EVAL      APTRAN = 'Facility Fee'                                  MD052107
     C                   EVAL      DATAP = TXSTAT(1) + ' ' + APTRAN + ' ' +                 MD052107
     C                             nFEFACL + ' ' + nFEFSEQ + ' '  +                         MD052107
     C                             nFEFCOD                                                  MD052107
     C                   ELSE                                                               MD052107
     C                   EVAL      APTRAN = 'Loan Fee'                                      MD052107
     C                   EVAL      DATAP = TXSTAT(1) + ' ' + APTRAN + ' ' +                 MD052107
     C                             pFELOAN + ' ' + nFEFSEQ + ' '  +                         MD052107
     C                             nFEFCOD                                                  MD052107
     C                   ENDIF                                                              MD052107
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
     C+ from LELIST2
     C**********+ into :pFELOAN, :pFEFSEQ, :pFEFCOD                                         MD052107
     C+ into :pFEFACL, :pFELOAN, :pFEFSEQ, :pFEFCOD                                         MD052107
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LELIST2
     C/end-exec
     C                   ENDSR                                                              MD052107
      *****************************************************************                     MD052107
      /EJECT                                                                                MD052107
      ***********************t*****************************************                     MD052107
      *  SRFeeSett - Retrieve Fee Settlements                         *                     MD052107
      *                                                               *                     MD052107
      *****************************************************************                     MD052107
     C     SRFeeSett     BEGSR                                                              MD052107
      *
      ** Set file pointer to first record of LEFEEAD
      *
     C/exec SQL
     C+ declare LELIST3  cursor for
     C**********+ select FALOAN, FAFSEQ   from LEFEEAD                                      MD042142
     C+ select FAFACL, FAFSEQ   from LEFEEAD                                                MD042142
     C+ where (FAFCCY = :YyCcy and                                                          MD052107
     C+       FAOURS = :XxNost) or                                                          MD052107
     C+       (FASCCY = :YyCcy and                                                          MD052107
     C+       FAOURS = :XxNost) or                                                          MD052107
     C+       (FAICCY = :XxNost and                                                         MD052107
     C+       FAOURS = :XxNost)                                                             MD052107
     C**********+ where FAFCCY = :YyCcy and                                                 MD052107
     C**********+       RONS = :XxNost or                                                   MD052107
     C**********+       FAFCCY = :YyCcy and                                                 MD052107
     C**********+       FAOURS = :XxNost                                                    MD052107
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

     C**********         MOVEL     pFAFSEQ       nFAFSEQ                                    MD052107
     C**********         MOVEL     pFAFACL       nFAFACL                           MD042142 MD052107
     C                   MOVE      pFAFSEQ       nFAFSEQ                                    MD052107
     C                   MOVE      pFAFACL       nFAFACL                                    MD052107
     C                   EVAL      APTRAN = 'Fee Settlements'
     C**********         EVAL      DATAP = APTRAN + TXSTAT(1)+ ' ' + pFALOAN +              MD042142
     C**********         EVAL      DATAP = APTRAN + TXSTAT(1)+ ' ' + nFAFACL +     MD042142 MD052107
     C**********                   ' ' + nFAFSEQ                                            MD052107
     C                   EVAL      DATAP = TXSTAT(1) + ' ' + APTRAN + ' ' +                 MD052107
     C                             nFAFACL + ' ' + nFAFSEQ                                  MD052107
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
     C+ from LELIST3
     C**********+ into :pFALOAN, :pFAFSEQ                                                   MD042142
     C+ into :pFAFACL, :pFAFSEQ                                                             MD042142
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LELIST3
     C/end-exec
     C                   ENDSR                                                              MD052107
      *****************************************************************                     MD052107
      /EJECT                                                                                MD052107
      ***********************t*****************************************                     MD052107
      *  SRLoanEvnt - Retrieve Loan Events                            *                     MD052107
      *                                                               *                     MD052107
      *****************************************************************                     MD052107
     C     SRLoanEvnt    BEGSR                                                              MD052107
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
     C**********         EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pLNRF +               MD052107
     C**********                   ' ' + pLTYP +      ' ' + pSUTP                           MD052107
     C                   EVAL      DATAP = TXSTAT(1) + ' ' + APTRAN + ' ' +                 MD052107
     C                             pLNRF + '         ' + pLTYP + ' '  +                     MD052107
     C                             pSUTP                                                    MD052107
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
     C+ from LELIST4
     C+ into :pLNRF, :pLTYP, :pSUTP
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LELIST4
     C/end-exec
     C                   ENDSR                                                              MD052107
      *****************************************************************                     MD052107
      /EJECT                                                                                MD052107
      ***********************t*****************************************                     MD052107
      *  SRRollOver - Retrieve Rollovers                              *                     MD052107
      *                                                               *                     MD052107
      *****************************************************************                     MD052107
     C     SRRollOver    BEGSR                                                              MD052107
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
     C**********         EVAL      DATAP = APTRAN +  TXSTAT(1) + ' ' + pLNRF                MD052107
     C                   EVAL      DATAP = TXSTAT(1) + ' ' + APTRAN + ' ' +                 MD052107
     C                             pLNRF                                                    MD052107
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
     C+ from LELIST7
     C+ into :pLNRF
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LELIST7
     C/end-exec
     C                   ENDSR                                                              MD052107
      *****************************************************************                     MD052107
      /EJECT                                                                                MD052107
      ***********************t*****************************************                     MD052107
      *  SRFacility - Retrieve Facility                               *                     MD052107
      *                                                               *                     MD052107
      *****************************************************************                     MD052107
     C     SRFacility    BEGSR                                                              MD052107
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
     C**********         EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pCNUM +               MD052107
     C**********                     ' ' +   nFACT + ' ' +  nFCNO                           MD052107
     C                   EVAL      DATAP = TXSTAT(1) + ' ' + APTRAN + ' ' +                 MD052107
     C                             pCNUM + ' ' + nFACT + ' '                                MD052107
     C                             + nFCNO                                                  MD052107
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
     C+ from LELIST8
     C+ into :pCNUM, :pFACT, :pFCNO
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LELIST8
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
      ********************************************************************
      /EJECT
      ********************************************************************
** TXSTAT
BLOCKING NOSTRO ACCOUNT DELETION                                                            MD052107
FOR INFORMATION ONLY                                                                        MD052107
DEAD TRANSACTION TO BE REVIEWED                                                             MD052107
** NOTES                                                                                    MD052107
Receiving Settlement Leg                                                                    MD052107
Pay Settlement Leg                                                                          MD052107
