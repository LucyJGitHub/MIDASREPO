     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited. 2017')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Nostro Account Activity - DL')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      ***SD0152DL*-*Nostro*Account*Activity**-*DL.*********************                     MD052107
      *  SD000152DL - Nostro Account Activity - DL.                   *                     MD052107
      *                                                               *
      *  Function:  This program checks if a Nostro is used by        *
      *             a Dealing transaction.                            *
      *                                                               *
      *  Called By: SD000151R                                         *
      *                                                               *
      *   (c) Finastra International Limited. 2017                    *
      *                                                               *
      *  Last Amend No. MD054189           Date 03Sep19               *
      *  Prev Amend No. MD052107           Date 02Jul19               *
      *                 MD042142A          Date 13Jan19               *
      *                 MD042142           Date 08May18               *
      *                 MD038440A          Date 08May18               *
      *                 MD048898           Date 11Dec17               *
      *                 MD038440           Date 27Oct17               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054189  - Misaligned Nostro Report Layout and Duplicate    *
      *              Pay Settlement Leg                               *
      *  MD052107  - Reformat Nostro Account Activity Report Layout   *
      *  MD042142A - Cannot close Nostro Account.                     *
      *            - Applied for MD052616.                            *
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

     D********** pDLNO           S              6                                           MD052107
     D pDLNO           S              6  0                                                  MD052107
     D wDLNO           S              6                                                     MD052107
     D pDTYP           S              2
     D pDLST           S              2
     D PVDAT           S              5  0
     D PMDAT           S              5  0                                                  MD054189
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
      *                                                                                     MD052107
     C                   IF        PMODE <> 'V'                                             MD052107
     C                   WRITE     TRAILP1
     C                   ENDIF                                                              MD052107
      *                                                                                     MD052107
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *****************************************************************
      *                                                               *
      *   SRValv - Retrieve Dealing transactions                      *
      *                                                               *
      *****************************************************************
     C     SRValv        BEGSR
      *                                                                                     MD052107
      ** CLS Pay-in Schedule                                                                MD052107
     C                   IF        XxRtn <> 'R'                                             MD052107
     C                   IF        CDL008 = 'Y'                                             MD052107
     C                   EXSR      SRCLSPay                                                 MD052107
     C                   ENDIF                                                              MD052107
     C                   ENDIF                                                              MD052107
      ** Deals Amendment                                                                    MD052107
     C                   IF        XxRtn <> 'R'                                             MD052107
     C                   EXSR      SRDLAmend                                                MD052107
     C                   ENDIF                                                              MD052107
      *                                                                                     MD052107
      ** Dealing Fee                                                                        MD052107
     C                   IF        XxRtn <> 'R'                                             MD052107
     C                   IF        CAS009 = 'Y'                                             MD052107
     C                   EXSR      SRDLFee                                                  MD052107
     C                   ENDIF                                                              MD052107
     C                   ENDIF                                                              MD052107
      *                                                                                     MD052107
      ** FRA / IRS / CACF                                                                   MD052107
     C                   IF        XxRtn <> 'R'                                             MD052107
     C                   EXSR      SRFRADeal                                                MD052107
     C                   ENDIF                                                              MD052107
      *                                                                                     MD052107
      ** Foreign Exchange                                                                   MD052107
     C                   IF        XxRtn <> 'R'                                             MD052107
     C                   EXSR      SRFXDeal                                                 MD052107
     C                   ENDIF                                                              MD052107
      *                                                                                     MD052107
      ** FX Confirmed Nets                                                                  MD052107
     C                   IF        XxRtn <> 'R'                                             MD052107
     C                   IF        CDL002 = 'Y'                                             MD052107
     C                   EXSR      SRFXCNet                                                 MD052107
     C                   ENDIF                                                              MD052107
     C                   ENDIF                                                              MD052107
      *                                                                                     MD052107
      ** FX Netting Multiple Settlements                                                    MD052107
     C                   IF        XxRtn <> 'R'                                             MD052107
     C                   IF        CDL025  = 'Y'                                            MD052107
     C                   EXSR      SRFXNetM                                                 MD052107
     C                   ENDIF                                                              MD052107
     C                   ENDIF                                                              MD052107
      *                                                                                     MD052107
      ** Money Market                                                                       MD052107
     C                   IF        XxRtn <> 'R'                                             MD052107
     C                   EXSR      SRMMDeal                                                 MD052107
     C                   ENDIF                                                              MD052107
      *                                                                                     MD052107
      ** Negotiable Assets Purchased                                                        MD052107
     C                   IF        XxRtn <> 'R'                                             MD052107
     C                   EXSR      SRNASP                                                   MD052107
     C                   ENDIF                                                              MD052107
      *                                                                                     MD052107
      ** Negotiable Assets Sold                                                             MD052107
     C                   IF        XxRtn <> 'R'                                             MD052107
     C                   EXSR      SRNASS                                                   MD052107
     C                   ENDIF                                                              MD052107
      *                                                                                     MD052107
     C                   ENDSR                                                              MD052107
      *****************************************************************                     MD052107
      /EJECT                                                                                MD052107
      *****************************************************************                     MD052107
      *  SRMMDeal  - Retrieve MM Dealing transactions                 *                     MD052107
      *                                                               *                     MD052107
      *****************************************************************                     MD052107
     C     SRMMDeal      BEGSR                                                              MD052107
      *
      ** Set file pointer to first record of DEALSDC
      *
     C/exec SQL
     C+ declare DLLIST0 cursor for
     C**********select DLNO, DTYP, DLST, VDAT   from DEALSDC                               MD038440A
     C**********+ select DLNO, DTYP, DLST, VDAT, PONS, RONS from DEALSDC          MD038440A MD054189
     C+ select DLNO, DTYP, DLST, VDAT, MDAT, PONS, RONS from DEALSDC                        MD054189
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
     C**********+       DLNO                                                                MD052107
     C**********+       DLNO, VDAT DESC, DTYP, DLST                                MD052107 MD054189
     C+       DLNO, VDAT DESC, MDAT DESC, DTYP, DLST                                        MD054189
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
     C**********+ into  :pdlno, :pdtyp, :pdlst, :pvdat, :ppons, :prons            MD038440A MD054189
     C+ into  :pdlno, :pdtyp, :pdlst, :pvdat, :pmdat, :ppons, :prons                        MD054189
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   IF        PRONS = XXNOST                                          MD038440A
     C                   EVAL      APTRAN = 'Money Market'                                  MD052107
     C                   MOVE      pDLNO         wDLNO                                      MD052107
     C                   IF        PVDAT <  BJRDNB
     C**********         EVAL      APTRAN = 'Money Market'                                  MD052107
     C**********         EVAL      DATAP = APTRAN + TXSTAT(3) + ' ' + pDLNO +               MD052107
     C**********                    ' ' +  pDTYP + ' ' + pDLST                              MD052107
     C                   EVAL      DATAP = TXSTAT(3) + ' ' + APTRAN + ' ' +                 MD052107
     C                             wDLNO + '      ' + pDTYP + ' '  +                        MD052107
     C                             pDLST + '         ' + NOTES(1)                           MD052107
     C                   ELSE
     C**********         EVAL      APTRAN = 'Money Market'                         MD048898 MD052107
     C**********         EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pDLNO +               MD052107
     C**********                    ' ' +  pDTYP + ' ' + pDLST + '           '              MD052107
     C                   EVAL      DATAP = TXSTAT(1) + ' ' + APTRAN + ' ' +                 MD052107
     C                             wDLNO + '      ' + pDTYP + ' '  +                        MD052107
     C                             pDLST + '         ' + NOTES(1)                           MD052107
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
      *
     C                   IF        PPONS = XXNOST                                          MD038440A
     C                   EVAL      APTRAN = 'Money Market'                                  MD052107
     C                   MOVE      pDLNO         wDLNO                                      MD052107
     C                   IF        PMDAT >=  BJRDNB                                         MD054189
     C**********         IF        PVDAT <  BJRDNB                                MD038440A MD054189
     C**********         EVAL      APTRAN = 'Money Market'                        MD038440A MD052107
     C**********         EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pDLNO +     MD038440A MD052107
     C**********                    ' ' +  pDTYP + ' ' + pDLST                    MD038440A MD052107
     C                   EVAL      DATAP = TXSTAT(1) + ' ' + APTRAN + ' ' +                 MD052107
     C                             wDLNO + '      ' + pDTYP + ' '  +                        MD052107
     C                             pDLST + '         ' + NOTES(2)                           MD052107
     C                   IF        PMODE = 'V'                                             MD038440A
     C                   EVAL      XxRtn  = 'R'                                            MD038440A
     C**********         GOTO      VALEXIT                                        MD038440A MD052107
     C                   ENDIF                                                             MD038440A
     C                   IF        XxRtn <> 'R'                                             MD054189
     C                   IF        *IN60 = *ON                                              MD054189
     C                   WRITE     HEADP1                                                   MD054189
     C                   EVAL      *IN60 = *OFF                                             MD054189
     C                   ENDIF                                                              MD054189
      *                                                                                     MD054189
     C                   WRITE     DETAIL1                                                  MD054189
     C                   ENDIF                                                              MD054189
     C                   ENDIF                                                             MD038440A
      *                                                                                    MD038440A
     C**********         IF        XxRtn <> 'R'                                             MD052107
     C**********         IF        *IN60 = *ON                                             MD038440A
     C**********         WRITE     HEADP1                                                  MD038440A
     C**********         EVAL      *IN60 = *OFF                                            MD038440A
     C**********         ENDIF                                                             MD038440A
      *                                                                                    MD038440A
     C**********         WRITE     DETAIL1                                                 MD038440A
     C**********         ENDIF                                                              MD052107
     C                   ENDIF                                                             MD038440A
      *                                                                                    MD038440A

     C/exec SQL
     C+ fetch next
     C+ from DLLIST0
     C**********Into  :pdlno, :pdtyp, :pdlst, :pvdat                                       MD038440A
     C**********+ into  :pdlno, :pdtyp, :pdlst, :pvdat, :ppons, :prons            MD038440A MD054189
     C+ into  :pdlno, :pdtyp, :pdlst, :pvdat, :pmdat, :ppons, :prons                        MD054189
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close DLLIST0
     C/end-exec
      *
     C/exec SQL
     C+ declare DLLIST0B cursor for
     C**select*DLNO, DTYP, DLST, VDAT   from DEALSDC                                       MD038440A
     C**********+ select DLNO, DTYP, DLST, VDAT, PONS, RONS from DEALSDC          MD038440A MD054189
     C+ select DLNO, DTYP, DLST, VDAT, MDAT, PONS, RONS from DEALSDC                        MD054189
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
     C**********+       DLNO                                                                MD052107
     C**********+       DLNO, VDAT DESC, DTYP, DLST                                MD052107 MD054189
     C+       DLNO, VDAT DESC, MDAT DESC, DTYP, DLST                                        MD054189
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
     C**********+ into  :pdlno, :pdtyp, :pdlst, :pvdat, :ppons, :prons            MD038440A MD054189
     C+ into  :pdlno, :pdtyp, :pdlst, :pvdat, :pmdat, :ppons, :prons                        MD054189
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   IF        PPONS =  XXNOST                                         MD038440A
     C                   EVAL      APTRAN = 'Money Market'                                  MD052107
     C                   MOVE      pDLNO         wDLNO                                      MD052107
     C                   IF        PVDAT <  BJRDNB
     C**********         EVAL      APTRAN = 'Money Market'                                  MD052107
     C**********         EVAL      DATAP = APTRAN + TXSTAT(3) + ' ' + pDLNO +               MD052107
     C**********                    ' ' +  pDTYP + ' ' + pDLST                              MD052107
     C                   EVAL      DATAP = TXSTAT(3) + ' ' + APTRAN + ' ' +                 MD052107
     C                             wDLNO + '      ' + pDTYP + ' '                           MD052107
     C                              + pDLST + '         ' + NOTES(1)                        MD052107
     C                   ELSE
     C**********         EVAL      APTRAN = 'Money Market'                         MD048898 MD052107
     C**********         EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pDLNO +               MD052107
     C**********                    ' ' +  pDTYP + ' ' + pDLST                              MD052107
     C                   EVAL      DATAP = TXSTAT(1) + ' ' + APTRAN + ' ' +                 MD052107
     C                             wDLNO + '      ' + pDTYP + ' '                           MD052107
     C                              + pDLST + '         ' + NOTES(1)                        MD052107
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
      *
     C                   IF        PRONS =  XXNOST                                         MD038440A
     C                   EVAL      APTRAN = 'Money Market'                                 MD038440A
     C                   MOVE      pDLNO         wDLNO                                      MD052107
     C                   IF        PMDAT >=  BJRDNB                                         MD054189
     C**********         IF        PVDAT <  BJRDNB                                MD038440A MD054189
     C**********         EVAL      APTRAN = 'Money Market'                        MD038440A MD052107
     C**********         EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pDLNO +     MD038440A MD052107
     C**********                    ' ' +  pDTYP + ' ' + pDLST                    MD038440A MD052107
     C                   EVAL      DATAP = TXSTAT(1) + ' ' + APTRAN + ' ' +                 MD052107
     C                             wDLNO + '      ' + pDTYP + ' '                           MD052107
     C                              + pDLST + '         ' + NOTES(2)                        MD052107
     C                   IF        PMODE = 'V'                                             MD038440A
     C                   EVAL      XxRtn  = 'R'                                            MD038440A
     C**********         GOTO      VALEXIT                                        MD038440A MD052107
     C                   ENDIF                                                             MD038440A
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
     C**********         ENDIF                                                    MD038440A MD054189
     C                   ENDIF                                                             MD038440A
      *

     C/exec SQL
     C+ fetch next
     C+ from DLLIST0B
     C**********into  :pdlno, :pdtyp, :pdlst, :pvdat                                       MD038440A
     C**********+ into  :pdlno, :pdtyp, :pdlst, :pvdat, :ppons, :prons            MD038440A MD054189
     C+ into  :pdlno, :pdtyp, :pdlst, :pvdat, :pmdat, :ppons, :prons                        MD054189
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close DLLIST0B
     C/end-exec
     C                   ENDSR                                                              MD052107
      *****************************************************************                     MD052107
      /EJECT                                                                                MD052107
      *****************************************************************                     MD052107
      *                                                               *                     MD052107
      *  SRFXDeal  - Retrieve FX Dealing transactions                 *                     MD052107
      *                                                               *                     MD052107
      *****************************************************************                     MD052107
     C     SRFXDeal      BEGSR                                                              MD052107
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
     C**********+       DLNO                                                                MD052107
     C+       DLNO, DTYP, DLST                                                              MD052107
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
     C                   MOVE      pDLNO         wDLNO                                      MD052107
     C**********         EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pDLNO +               MD052107
     C**********                    ' ' + pDTYP +   ' ' + pDLST                             MD052107
     C                   EVAL      DATAP = TXSTAT(1) + ' ' + APTRAN + ' ' +                 MD052107
     C                             wDLNO + '      ' + pDTYP + ' '                           MD052107
     C                              + pDLST                                                 MD052107
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
     C+ from DLLIST1
     C+ into :pdlno, :pdtyp, :pdlst
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close DLLIST1
     C/end-exec
      *
     C                   ENDSR                                                              MD052107
      *****************************************************************                     MD052107
      /EJECT                                                                                MD052107
      *****************************************************************                     MD052107
      *                                                               *                     MD052107
      *  SRFRADeal  - Retrieve FRA Dealing transactions               *                     MD052107
      *                                                               *                     MD052107
      *****************************************************************                     MD052107
     C     SRFRADeal     BEGSR                                                              MD052107
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
     C**********+       DLNO                                                                MD052107
     C+       DLNO, DTYP, DLST                                                              MD052107
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
     C                   MOVE      pDLNO         wDLNO                                      MD052107
     C**********         EVAL      DATAP = APTRAN +  TXSTAT(1) + ' ' + pDLNO +              MD052107
     C**********                   ' ' + pDTYP +  ' ' + pDLST                               MD052107
     C                   EVAL      DATAP = TXSTAT(1) + ' ' + APTRAN + ' ' +                 MD052107
     C                             wDLNO + '      ' + pDTYP + ' '                           MD052107
     C                              + pDLST                                                 MD052107
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
     C**********         EVAL      XxRtn  = 'R'                                             MD052107
     C**********         IF        PMODE = 'V'                                              MD052107
     C**********         GOTO      VALEXIT                                                  MD052107
     C**********         ENDIF                                                              MD052107

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
     C                   ENDSR                                                              MD052107
      *****************************************************************                     MD052107
      /EJECT                                                                                MD052107
      *****************************************************************                     MD052107
      *                                                               *                     MD052107
      *  SRDLAmend  - Retrieve Deals Amendment transactions           *                     MD052107
      *                                                               *                     MD052107
      *****************************************************************                     MD052107
     C     SRDLAmend     BEGSR                                                              MD052107
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
     C**********+       DLNO                                                                MD052107
     C+       DLNO, DTYP, DLST                                                              MD052107
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
     C                   MOVE      pDLNO         wDLNO                                      MD052107
     C**********         EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pDLNO +               MD052107
     C**********                   ' ' + pDTYP + ' ' + pDLST                                MD052107
     C                   EVAL      DATAP = TXSTAT(1) + ' ' + APTRAN + ' ' +                 MD052107
     C                             wDLNO + '      ' + pDTYP + ' '                           MD052107
     C                              + pDLST                                                 MD052107
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
     C**********         EVAL      XxRtn  = 'R'                                             MD052107
     C**********         IF        PMODE = 'V'                                              MD052107
     C**********         GOTO      VALEXIT                                                  MD052107
     C**********         ENDIF                                                              MD052107

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
     C                   ENDSR                                                              MD052107
      *****************************************************************                     MD052107
      /EJECT                                                                                MD052107
      *****************************************************************                     MD052107
      *                                                               *                     MD052107
      *  SRNASP  - Retrieve NASP transactions                         *                     MD052107
      *                                                               *                     MD052107
      *****************************************************************                     MD052107
     C     SRNASP        BEGSR                                                              MD052107
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
     C**********+       DLNO                                                                MD052107
     C+       DLNO, DTYP, DLST                                                              MD052107
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

     C                   EVAL      APTRAN = 'Negotiable Assets Purchased'
     C                   MOVE      pDLNO         wDLNO                                      MD052107
     C**********         EVAL      DATAP = APTRAN + TXSTAT(1) + ' '  + pDLNO +              MD052107
     C**********                   ' ' + pDTYP +  ' ' + pDLST                               MD052107
     C                   EVAL      DATAP = TXSTAT(1) + ' ' + APTRAN + ' ' +                 MD052107
     C                             wDLNO + '      ' + pDTYP + ' '                           MD052107
     C                              + pDLST                                                 MD052107
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
     C                   ENDSR                                                              MD052107
      *****************************************************************                     MD052107
      /EJECT                                                                                MD052107
      *****************************************************************                     MD052107
      *                                                               *                     MD052107
      *  SRNASS  - Retrieve NASS transactions                         *                     MD052107
      *                                                               *                     MD052107
      *****************************************************************                     MD052107
     C     SRNASS        BEGSR                                                              MD052107
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
     C**********+       DLNO                                                                MD052107
     C+       DLNO, DTYP, DLST                                                              MD052107
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

     C**********         EVAL      APTRAN = 'Negotiable Assests Sold'                       MD052107
     C                   EVAL      APTRAN = 'Negotiable Assets Sold'                        MD052107
     C                   MOVE      pDLNO         wDLNO                                      MD052107
     C**********         EVAL      DATAP = APTRAN +  TXSTAT(1) + ' ' + pDLNO +              MD052107
     C**********                    ' ' + pDTYP + ' ' + pDLST                               MD052107
     C                   EVAL      DATAP = TXSTAT(1) + ' ' + APTRAN + ' ' +                 MD052107
     C                             wDLNO + '      ' + pDTYP + ' '                           MD052107
     C                              + pDLST                                                 MD052107
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
     C**********         EVAL      XxRtn  = 'R'                                             MD052107
     C**********         IF        PMODE = 'V'                                              MD052107
     C**********         GOTO      VALEXIT                                                  MD052107
     C**********         ENDIF                                                              MD052107

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
     C                   ENDSR                                                              MD052107
      *****************************************************************                     MD052107
      /EJECT                                                                                MD052107
      *****************************************************************                     MD052107
      *                                                               *                     MD052107
      *  SRFXCNet  - Retrieve FX Confirmed Nets                       *                     MD052107
      *                                                               *                     MD052107
      *****************************************************************                     MD052107
     C     SRFXCNet      BEGSR                                                              MD052107
      ** Set file pointer to first record of FXNETMPD
      *
     C**********         IF        CDL002 = 'Y'                                             MD052107
     C/exec SQL
     C+ declare DLLIST6 cursor for
     C+ select AMNETR from FXNETMPD
     C+ where AMCCYD = :YyCcy and
     C********AMOURN = :XxNost                                                             MD042142A
     C+       AMOURN = :XxNost  and                                                        MD042142A
     C+       AMRECI = 'C'                                                                 MD042142A
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
     C**********         EVAL      DATAP =  APTRAN +  TXSTAT(1) + ' ' +  pAMNETR            MD052107
     C                   EVAL      DATAP = TXSTAT(1) + ' ' + APTRAN + ' ' +                 MD052107
     C                             pAMNETR                                                  MD052107
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
     C**********         EVAL      XxRtn  = 'R'                                             MD052107
     C**********         IF        PMODE = 'V'                                              MD052107
     C**********         GOTO      VALEXIT                                                  MD052107
     C**********         ENDIF                                                              MD052107

     C/exec SQL
     C+ fetch next
     C+ from DLLIST6
     C+ into :pAMNETR
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close DLLIST6
     C/end-exec
     C**********         ENDIF                                                              MD052107
      *                                                                                     MD052107
     C                   ENDSR                                                              MD052107
      *****************************************************************                     MD052107
      /EJECT                                                                                MD052107
      *****************************************************************                     MD052107
      *                                                               *                     MD052107
      *  SRDLFee  - Retrieve Dealing Fees                             *                     MD052107
      *                                                               *                     MD052107
      *****************************************************************                     MD052107
     C     SRDLFee       BEGSR                                                              MD052107
      *
      ** Set file pointer to first record of DLFEED
      *
     C**********         IF        CAS009 = 'Y'                                             MD052107
      *
     C/exec SQL
     C+ declare DLLIST7 cursor for
     C+ select DFDLNO, DFDTYP, DFSTYP from DLFEED
     C+ where DFFCCY = :YyCcy and
     C+       DFRONS = :XxNost or
     C+       DFFCCY = :YyCcy and
     C+       DFPONS = :XxNost
     C+ order by
     C**********+       DFDLNO                                                              MD052107
     C+       DFDLNO, DFDTYP, DFSTYP                                                        MD052107
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
     C**********         EVAL      DATAP =APTRAN +  TXSTAT(1) + ' ' + pDLNO +      MD048898 MD052107
     C**********                    ' ' + pDTYP + ' ' + pDLST                      MD048898 MD052107
     C                   MOVE      pDLNO         wDLNO                                      MD052107
     C                   EVAL      DATAP = TXSTAT(1) + ' ' + APTRAN + ' ' +                 MD052107
     C                             wDLNO + '      ' + pDTYP + ' '                           MD052107
     C                              + pDLST                                                 MD052107
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
     C**********         EVAL      XxRtn  = 'R'                                             MD052107
     C**********         IF        PMODE = 'V'                                              MD052107
     C**********         GOTO      VALEXIT                                                  MD052107
     C**********         ENDIF                                                              MD052107

     C/exec SQL
     C+ fetch next
     C+ from DLLIST7
     C+ into :pdlno, :pdtyp, :pdlst
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close DLLIST7
     C/end-exec
     C**********         ENDIF                                                              MD052107
      *
     C                   ENDSR                                                              MD052107
      *****************************************************************                     MD052107
      /EJECT                                                                                MD052107
      *****************************************************************                     MD052107
      *                                                               *                     MD052107
      *  SRCLSPay - Retrieve CLS Pay-in Schedule                      *                     MD052107
      *                                                               *                     MD052107
      *****************************************************************                     MD052107
     C     SRCLSPay      BEGSR                                                              MD052107
      ** Set file pointer to first record of FXCLSPSD
      *                                                                                     MD052107
     C**********         IF        CDL008 = 'Y'
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
     C**********         EVAL      DATAP =APTRAN +  TXSTAT(1) + ' ' + pPYCCY +              MD042142
     C**********                   pPYNOST + ' ' + pPYSEQN                                  MD042142
     C                   EVAL      DATAP = TXSTAT(1) + ' ' + APTRAN + ' ' +                 MD052107
     C                             pPYCCY + pPYNOST + ' ' + pPYSEQN                         MD052107
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
     C**********         EVAL      XxRtn  = 'R'                                             MD052107
     C**********         IF        PMODE = 'V'                                              MD052107
     C**********         GOTO      VALEXIT                                                  MD052107
     C**********         ENDIF                                                              MD052107

     C/exec SQL
     C+ fetch next
     C+ from DLLIST8
     C+ into :pPYCCY, :pPYNOST, :pPYVDAT, :pPYSEQN
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close DLLIST8
     C/end-exec
     C**********         ENDIF                                                              MD052107
      *
     C                   ENDSR                                                              MD052107
      *****************************************************************                     MD052107
      /EJECT                                                                                MD052107
      *****************************************************************                     MD052107
      *                                                               *                     MD052107
      *  SRFXNetM - Retrieve FX Netting Multiple Settlements          *                     MD052107
      *                                                               *                     MD052107
      *****************************************************************                     MD052107
     C     SRFXNetM      BEGSR                                                              MD052107
      ** Set file pointer to first record of SDFNMSPD
      *
     C**********         IF        CDL025  = 'Y'                                            MD052107
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
     C**********         EVAL      DATAP =APTRAN +  TXSTAT(2) + ' ' + pLCUST +     MD042142 MD052107
     C**********                   ' ' + cLSEQN                                             MD052107
     C                   EVAL      DATAP = TXSTAT(2) + ' ' + APTRAN + ' ' +                 MD052107
     C                             pLCUST + ' ' + cLSEQN                                    MD052107
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
     C**********         ENDIF                                                              MD052107
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
** TXSTAT
BLOCKING NOSTRO ACCOUNT DELETION                                                            MD052107
FOR INFORMATION ONLY                                                                        MD052107
DEAD TRANSACTION TO BE REVIEWED                                                             MD052107
** NOTES                                                                                    MD052107
Receiving Settlement Leg                                                                    MD052107
Pay Settlement Leg                                                                          MD052107
