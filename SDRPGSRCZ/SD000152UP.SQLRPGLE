     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited. 2017')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Nostro Account Activity Update')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      ***SD0152OM*-*Nostro*Account*Activity*-*Update*******************                     MD054142
      *  SD000152UP - Nostro Account Activity - Update                *                     MD054142
      *                                                               *
      *  Function:  This program updates transactions used by Nostro  *
      *                                                               *
      *  Called By: SDNOSRUPD                                         *
      *                                                               *
      *   (c) Finastra International Limited. 2017                    *
      *                                                               *
      *  Last Amend No. MD054142           Date 20Aug19               *
      *  Prev Amend No. MD052129           Date 19Oct18               *
      *                 MD042142           Date 08May18               *
      *                 MD038440A          Date 08May18               *
      *                 MD048898           Date 11Dec17               *
      *                 MD038440           Date 27Oct17               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054142 - Amend Nostro Account Maintenance program due to   *
      *             reformatting of Nostro A/C Activity Report Layout *
      *  MD052129 - Settlement not updated. Extend fix MD038440A to   *
      *             the update other fields.                          *
      *  MD042142 - Refine MD038440 and MD048898 fixes.               *
      *           - Applied for MD038440A                             *
      *  MD038440A - Incorrect side is being updated for dead trans.  *
      *              Interchange Pay and Receipt during update.       *
      *  MD048898 - Deals file not updated. Incorrect select crit.    *
      *  MD038440 - Nostro deletion issue. Revise validation process. *
      *                                                               *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FSD000152P1O    E             PRINTER OFLIND(*IN60)

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+


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

     D PLNRF           S              6
     D PLTYP           S              2
     D PSUTP           S              2
     D********** pDLNO           S              6                                           MD054142
     D pDLNO           S              6  0                                                  MD054142
     D wDLNO           S              6                                                     MD054142
     D PDTYP           S              2
     D PDLST           S              2
     D KACNO           S             17A
     D********** APTRAN          S             40A                                          MD054142
     D APTRAN          S             31A                                                    MD054142
     D UPD             S             20A
     D TXSTAT          S             36A                                                    MD054142
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
      *
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
     C                   EVAL      XxRtn  = 'Y'
     C                   EVAL      *IN70 = *ON
     C                   EVAL      UPD = 'UPDATED'

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
      *  SValv  - Retrieve and update dead transactions               *
      *                                                               *
      *****************************************************************
     C     SRValv        BEGSR
      *
      ** Set file pointer to first record of CLOANCL
      *
     C/exec SQL
     C+ declare UPLIST1 cursor for
     C+ select LNRF, LTYP, SUTP from CLOANCL
     C+ where CCY = :YyCcy and
     C********PONS = :XxNost and                                                           MD038440A
     C********RONS = :XxNost and                                                 MD038440A  MD052129
     C+       PONS = :XxNost and                                                            MD052129
     C+       RECI = 'D' and
     C+       PTYP in (61, 62, 63, 70, 80, 64, 65, 68, 71 )
     C+ order by
     C**********+       LNRF                                                                MD054142
     C+       LNRF, LTYP, SUTP                                                              MD054142
     C/end-exec

     C/exec SQL
     C+ open UPLIST1
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
     C+ from UPLIST1
     C+ into :pLNRF, :pLTYP, :pSUTP
     C/end-exec

     C                   DOW       SQLCode <> 100


     C                   EVAL      APTRAN = 'Customer Lending'
     C**********         EVAL      DATAP = APTRAN + UPD +  ' ' + pLNRF +                    MD054142
     C**********                    ' ' + pLTYP + ' ' + pSUTP                               MD054142
     C                   EVAL      DATAP = TXSTAT + ' ' + APTRAN + ' ' +                    MD054142
     C                             pLNRF + '      ' + pLTYP + ' '  +                        MD054142
     C                             pSUTP + '         ' + UPD                                MD054142
     C                   IF        *IN60 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
     C                   WRITE     DETAIL1

     C/exec SQL
     C+ fetch next
     C+ from UPLIST1
     C+ into :pLNRF, :pLTYP, :pSUTP
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ update CLOANCL
     C+ set   PSTM = 00
     C********PONS = '  '                                                                  MD038440A
     C********RONS = '  '                                                         MD038440A MD052129
     C+      ,PONS = '  '                                                                   MD052129
     C+      ,BENN = ''                                                                     MD042142
     C+      ,POBN = ''                                                                     MD042142
     C+      ,POCN = ''                                                                     MD042142
     C+      ,MDST = 00                                                                     MD042142
     C+      ,FACO = ''                                                                     MD042142
     C+ where CCY = :YyCcy and
     C********PONS = :XxNost and                                                           MD038440A
     C********RONS = :XxNost and                                                  MD038440A MD052129
     C+       PONS = :XxNost and                                                            MD052129
     C+       RECI = 'D' and
     C+       PTYP in (61, 62, 63, 70, 80, 64, 65, 68, 71 )
     C/end-exec

     C/exec SQL
     C+ close UPLIST1
     C/end-exec
      *
     C/exec SQL
     C+ declare UPLIST1B cursor for
     C+ select LNRF, LTYP, SUTP, VDAT from CLOANCL
     C+ where CCY = :YyCcy and
     C********RONS = :XxNost and                                                           MD038440A
     C********PONS = :XxNost and                                                  MD038440A MD052129
     C+       RONS = :XxNost and                                                            MD052129
     C+       RECI = 'D' and
     C+       PTYP in (66, 67, 69, 72)
     C+ order by
     C**********+       LNRF                                                                MD054142
     C+       LNRF, VDAT DESC, LTYP, SUTP                                                   MD054142
     C/end-exec

     C/exec SQL
     C+ open UPLIST1B
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
     C+ from UPLIST1B
     C+ into :pLNRF, :pLTYP, :pSUTP
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   EVAL      APTRAN = 'Customer Lending'
     C                   EVAL      UPD = 'UPDATED'
     C**********         EVAL      DATAP = APTRAN + UPD +  ' ' + pLNRF +                    MD054142
     C**********                    ' ' + pLTYP + ' ' + pSUTP                               MD054142
     C                   EVAL      DATAP = TXSTAT + ' ' + APTRAN + ' ' +                    MD054142
     C                             pLNRF + '      ' + pLTYP + ' '  +                        MD054142
     C                             pSUTP + '         ' + UPD                                MD054142
     C                   IF        *IN60 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
     C                   WRITE     DETAIL1

     C/exec SQL
     C+ fetch next
     C+ from UPLIST1B
     C+ into :pLNRF, :pLTYP, :pSUTP
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ update CLOANCL
     C+ set   RSTM = 00                                                                     MD052129
     C********RONS = '  '                                                                  MD038440A
     C********PONS = '  '                                                         MD038440A MD052129
     C+      ,RONS = '  '                                                                   MD052129
     C+      ,ROBN = ''                                                            MD042142 MD052129
     C+      ,ROCN = ''                                                            MD042142 MD052129
     C+      ,MDST = 00                                                                     MD042142
     C+ where CCY = :YyCcy and
     C********RONS = :XxNost and                                                           MD038440A
     C********PONS = :XxNost and                                                  MD038440A MD052129
     C+       RONS = :XxNost and                                                            MD052129
     C+       RECI = 'D' and
     C+       PTYP in (66, 67, 69, 72)
     C/end-exec

     C/exec SQL
     C+ close UPLIST1B
     C/end-exec
      *
      ** Set file pointer to first record of DEALSDC
      *
     C/exec SQL
     C+ declare UPLIST2 cursor for
     C+ select DLNO, DTYP, DLST from DEALSDC
     C+ where CCY = :YyCcy and
     C********PONS = :XxNost and                                                           MD038440A
     C+       RONS = :XxNost and                                                           MD038440A
     C+       RECI = 'D' and
     C+       DTYP in ('IT', 'TD', 'CI', 'CD' )
     C+ order by
     C**********+       DLNO                                                                MD054142
     C+       DLNO, DTYP, DLST                                                              MD054142
     C/end-exec

     C/exec SQL
     C+ open UPLIST2
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
     C+ from UPLIST2
     C+ into :pdlno, :pdtyp, :pdlst
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   EVAL      APTRAN = 'Money Market'
     C                   MOVE      pDLNO         wDLNO                                      MD054142
     C**********         EVAL      DATAP = APTRAN + UPD + ' ' + pDLNO +                     MD054142
     C**********                   ' ' + pDTYP +  ' ' + pDLST                               MD054142
     C                   EVAL      DATAP = TXSTAT + ' ' + APTRAN + ' ' +                    MD054142
     C                             wDLNO + '      ' + pDTYP + ' '  +                        MD054142
     C                             pDLST + '         ' + UPD                                MD054142
     C                   IF        *IN60 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
     C                   WRITE     DETAIL1

     C/exec SQL                                                                             MD042142
     C+ update MMDELDPP                                                                     MD042142
     C**set HKPSTM = 00                                                            MD042142 MD052129
     C+ set HKRSTM = 00                                                                     MD052129
     C*******HKPONS = ''                                                          MD042142 MD038440A
     C+     ,HKRONS = ''                                                                   MD038440A
     C+     ,HKBENN = ''                                                           MD042142 MD052129
     C*******HKPOBN = ''                                                           MD042142 MD052129
     C*******HKPOCN = ''                                                           MD042142 MD052129
     C*******HKDOPM = ''                                                           MD042142 MD052129
     C*******HKMOPM = 00                                                           MD042142 MD052129
     C*******HKDOPI = ''                                                           MD042142 MD052129
     C*******HKMOPI = ''                                                           MD042142 MD052129
     C*******HKPOBR = ''                                                           MD042142 MD052129
     C+     ,HKROBN = ''                                                                    MD052129
     C+     ,HKROCN = ''                                                                    MD052129
     C+     ,HKDORM = ''                                                                    MD052129
     C+     ,HKORCM = 00                                                                    MD052129
     C+     ,HKDORI = ''                                                                    MD052129
     C+     ,HKMORI = ''                                                                    MD052129
     C+     ,HKROBR = ''                                                                    MD052129
     C+ where HKDN38 = :pDLNO                                                               MD042142
     C/end-exec                                                                             MD042142
     C/exec SQL
     C+ fetch next
     C+ from UPLIST2
     C+ into :pdlno, :pdtyp, :pdlst
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ update DEALSDC
     C**set***PSTM = 00                                                                     MD052129
     C+ set   RSTM = 00                                                                     MD052129
     C********PONS = '  '                                                                  MD038440A
     C+      ,RONS = '  '                                                                  MD038440A
     C+      ,OMDA = '  '                                                                   MD048898
     C+      ,BENN = '        '                                                             MD042142
     C********POBN = '      '                                                      MD042142 MD052129
     C********POCN = '      '                                                      MD042142 MD052129
     C+      ,ROBN = '      '                                                               MD052129
     C+      ,ROCN = '      '                                                               MD052129
     C+      ,MDST = 00                                                                     MD042142
     C********POBR = ''                                                            MD042142 MD052129
     C+      ,ROBR = ''                                                                     MD052129
     C+      ,FACO = ''                                                                     MD042142
     C+ where CCY = :YyCcy and
     C********RONS = :XxNost and                                                            MD048898
     C********PONS = :XxNost and                                                  MD048898 MD038440A
     C+       RONS = :XxNost and                                                            MD048898
     C+       RECI = 'D' and
     C+       DTYP in ('IT', 'TD', 'CI', 'CD' )
     C/end-exec

     C/exec SQL
     C+ close UPLIST2
     C/end-exec
      *
      **
     C/exec SQL
     C+ declare UPLIST2B cursor for
     C+ select DLNO, DTYP, DLST from DEALSDC
     C+ where CCY = :YyCcy and
     C********RONS = :XxNost and                                                           MD038440A
     C+       PONS = :XxNost and                                                           MD038440A
     C+       RECI = 'D' and
     C+       DTYP in ('CF', 'CL' , 'DL', 'IP', 'TI' )
     C+ order by
     C**********+       DLNO                                                                MD054142
     C+       DLNO, DTYP, DLST                                                              MD054142
     C/end-exec

     C/exec SQL
     C**open UPLIST2                                                                        MD048898
     C+ open UPLIST2B                                                                       MD048898
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
     C**from UPLIST2                                                                        MD048898
     C+ from UPLIST2B                                                                       MD048898
     C+ into :pdlno, :pdtyp, :pdlst
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   EVAL      APTRAN = 'Money Market'
     C                   MOVE      pDLNO         wDLNO                                      MD054142
     C**********         EVAL      DATAP = APTRAN + UPD + ' ' + pDLNO +                     MD054142
     C**********                   ' ' + pDTYP +  ' ' + pDLST                               MD054142
     C                   EVAL      DATAP = TXSTAT + ' ' + APTRAN + ' ' +                    MD054142
     C                             wDLNO + '      ' + pDTYP + ' '  +                        MD054142
     C                             pDLST + '         ' + UPD                                MD054142
     C                   IF        *IN60 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
     C                   WRITE     DETAIL1

     C/exec SQL                                                                             MD042142
     C+ update MMDELDPP                                                                     MD042142
     C+ set HKPSTM = 00                                                                     MD042142
     C+     ,HKPONS = ''                                                                    MD042142
     C+     ,HKBENN = ''                                                                    MD042142
     C+     ,HKPOBN = ''                                                                    MD042142
     C+     ,HKPOCN = ''                                                                    MD042142
     C+     ,HKDOPM = ''                                                                    MD042142
     C+     ,HKMOPM = 00                                                                    MD042142
     C+     ,HKDOPI = ''                                                                    MD042142
     C+     ,HKMOPI = ''                                                                    MD042142
     C+     ,HKPOBR = ''                                                                    MD042142
     C+ where HKDN38 = :pDLNO                                                               MD042142
     C/end-exec                                                                             MD042142
     C/exec SQL
     C+ fetch next
     C**from UPLIST2                                                                        MD048898
     C+ from UPLIST2B                                                                       MD048898
     C+ into :pdlno, :pdtyp, :pdlst
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ update DEALSDC
     C**set***RSTM = 00                                                                     MD052129
     C+ set   PSTM = 00                                                                     MD052129
     C********RONS = '  '                                                                  MD038440A
     C********RONS = '  '                                                         MD038440A MD052129
     C+      ,PONS = '  '                                                                   MD052129
     C+      ,OMDA = '  '                                                                   MD048898
     C+      ,BENN = '        '                                                             MD042142
     C+      ,POBN = '      '                                                               MD042142
     C+      ,POCN = '      '                                                               MD042142
     C+      ,MDST = 00                                                                     MD042142
     C+      ,POBR = ''                                                                     MD042142
     C+      ,FACO = ''                                                                     MD042142
     C+ where CCY = :YyCcy and
     C********PONS = :XxNost and                                                            MD048898
     C********RONS = :XxNost and                                                  MD048898 MD038440A
     C+       PONS = :XxNost and                                                           MD038440A
     C+       RECI = 'D' and
     C+       DTYP in ('CF', 'CL' , 'DL', 'IP', 'TI' )
     C/end-exec

     C/exec SQL
     C**close UPLIST2                                                                       MD048898
     C+ close UPLIST2B                                                                      MD048898
     C/end-exec
     C                   ENDSR
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
     C                   PARM                    PMODE             1
     C                   PARM                    YyBrca
     C                   PARM                    YyCnum
     C                   PARM                    YyCcy
     C                   PARM                    YyAcod
     C                   PARM                    YyAcsq
     C                   PARM                    XxNost
     C                   PARM                    XxRtn
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
