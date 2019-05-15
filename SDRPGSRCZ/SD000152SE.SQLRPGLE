     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited. 2017')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Nostro Account Activity - OM')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SD0152OM - Nostro Account Activity - SE.                     *
      *                                                               *
      *  Function:  This program checks if a Nostro is used by        *
      *             a Other transactions.                             *
      *                                                               *
      *  Called By: SD000151R                                         *
      *                                                               *
      *   (c) Finastra International Limited. 2017                    *
      *                                                               *
      *  Last Amend No. MD042142           Date 08May18               *
      *  Prev Amend No. MD048898           Date 11Dec17               *
      *                 MD038440           Date 27Oct17               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD042142 - Refine MD038440 and MD048898 fixes.               *
      *           - Applied for MD038440A.                            *
      *  MD048898 - No reports produced. conditon RCF processing      *
      *  MD038440 - Nostro deletion issue. Revise validation process. *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FSD000152P5O    E             PRINTER OFLIND(*IN60)
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

     D PTDRF           S              6A
     D PTDSS           S             10A
     D PTDTP           S              2A
     D PPSSH           S             10A
     D PPEVT           S              2A
     D PBHCUST         S              6A
     D PCSTM           S              6A
     D PSBRA           S              3A                                                    MD042142
     D PCYSI           S              3A                                                    MD042142
     D PITSI           S              3A                                                    MD042142
     D PTNBR           S              6  0                                                  MD042142
     D nTNBR           S              6A                                                    MD042142
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
      *  SValv  - Retrieve Securities transactions                    *
      *                                                               *
      *****************************************************************
     C     SRValv        BEGSR

      ** Set file pointer to first record of TRADSD
      *
     C/exec SQL
     C+ declare SELIST1 cursor for
     C+ select TDRF, TDSS, TDTP from TRADSD
     C+ where SETC = :YyCcy and
     C+       PYFM = :XxNost and
     C+       RECI = 'D'
     C+       or SETC = :YyCcy and                                                          MD042142
     C+       PAYT = :XxNost and                                                            MD042142
     C+       RECI = 'D'                                                                    MD042142
     C+ order by
     C+       TDRF
     C/end-exec

     C/exec SQL
     C+ open SELIST1
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
     C+ from SELIST1
     C+ into :pTDRF, :pTDSS, :pTDTP
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   EVAL      APTRAN = 'Security Trade'
     C                   EVAL      DATAP = APTRAN +  TXSTAT(1) + ' ' + pTDRF +
     C                             ' ' + pTDSS +     ' ' + pTDTP
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
     C+ from SELIST1
     C+ into  :pTDRF, :pTDSS, :pTDTP
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close SELIST1
     C/end-exec
      ** Set file pointer to first record of POSETD
      *
     C/exec SQL
     C+ declare SELIST2 cursor for
     C+ select PSSH, PEVT from POSETD
     C+ where PSCU = :YyCcy and
     C+       PSEA = :XxNost
     C+ order by
     C+       PSSH
     C/end-exec

     C/exec SQL
     C+ open SELIST2
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
     C+ from SELIST2
     C+ into :pPSSH, :pPEVT
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   EVAL      APTRAN = 'Position Settlement'
     C                   EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pPSSH +
     C                             ' ' + pPEVT
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
     C+ from SELIST2
     C+ into :pPSSH, :pPEVT
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close SELIST2
     C/end-exec
      ** Set file pointer to first record of SDFOCSPD
      *
     C/exec SQL
     C+ declare SELIST3 cursor for
     C+ select BHCUST   from SDFOCSPD
     C+ where BHCYCD = :YyCcy and
     C+       BHSMAC = :XxNost
     C+ order by
     C+       BHCUST
     C/end-exec

     C/exec SQL
     C+ open SELIST3
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
     C+ from SELIST3
     C+ into :pBHCUST
     C/end-exec

     C                   DOW       SQLCode <> 100

     C**********         EVAL      APTRAN = 'Futures and Options'                           MD042142
     C                   EVAL      APTRAN = 'Futures and Options - Cust Details'            MD042142
     C                   EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pBHCUST
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
     C+ from SELIST3
     C+ into  :pBHCUST
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close SELIST3
     C/end-exec
      ** Set file pointer to first record of STDSED
      *
     C/exec SQL
     C+ declare SELIST4 cursor for
     C**********+ select CSTM     from STDSED                                               MD042142
     C+ select SBRA, CSTM, CYSI, ITSI     from STDSED                                       MD042142
     C+ where CYSI = :YyCcy and
     C+       SPAT = :XxNost or
     C+       CYSI = :YyCcy and
     C+       SRAC = :XxNost
     C+ order by
     C**********+       CSTM                                                                MD042142
     C+       SBRA, CSTM, ITSI                                                              MD042142
     C/end-exec

     C/exec SQL
     C+ open SELIST4
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
     C+ from SELIST4
     C**********+ into :pBHCUST                                                             MD042142
     C+ into :pSBRA, :pCSTM, :pCYSI, :pITSI                                                 MD042142
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   EVAL      APTRAN = 'Standard Settlement'
     C**********         EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pCSTM                 MD042142
     C                   EVAL      DATAP = APTRAN + TXSTAT(2) + ' ' + pSBRA +               MD042142
     C                             '-' + pCSTM + '-' + pCYSI + '-' + pITSI                  MD042142
     C                   IF        *IN60 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
     C                   WRITE     DETAIL1

     C/exec SQL
     C+ fetch next
     C+ from SELIST4
     C**********+ into  :pCSTM                                                              MD042142
     C+ into :pSBRA, :pCSTM, :pCYSI, :pITSI                                                 MD042142
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close SELIST4
     C/end-exec
      *
      ** Set file pointer to first record of TRSETD                                         MD042142
      *                                                                                     MD042142
     C/exec SQL                                                                             MD042142
     C+ declare SELIST5 cursor for                                                          MD042142
     C+ select A.TNBR from FFTRANSL0 A                                                      MD042142
     C+ LEFT JOIN TRSET1 B on                                                               MD042142
     C+ A.TNBR = B.TNBR                                                                     MD042142
     C+ where A.ISCY = :YyCcy and                                                           MD042142
     C+       B.CSLA = :XxNost and                                                          MD042142
     C+       A.RECI = 'D' or                                                               MD042142
     C+       A.ISCY = :YyCcy and                                                           MD042142
     C+       B.BSLA = :XxNost and                                                          MD042142
     C+       A.RECI = 'D'                                                                  MD042142
     C+ order by                                                                            MD042142
     C+       A.TNBR                                                                        MD042142
     C/end-exec                                                                             MD042142

     C/exec SQL                                                                             MD042142
     C+ open SELIST5                                                                        MD042142
     C/end-exec                                                                             MD042142

      ** Handle SQL Error (If not %EOF)                                                     MD042142

     C                   IF        SQLCOD < 0                                               MD042142

     C     *LOCK         IN        LDA                                                      MD042142
     C                   EVAL      DBASE = 5                                                MD042142
     C                   EVAL      DBFILE = 'SQL STM'                                       MD042142
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT                             MD042142
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)                   MD042142
     C                   OUT       LDA                                                      MD042142
     C                   EXSR      *PSSR                                                    MD042142

     C                   ENDIF                                                              MD042142

     C/exec SQL                                                                             MD042142
     C+ fetch next                                                                          MD042142
     C+ from SELIST5                                                                        MD042142
     C+ into :pTNBR                                                                         MD042142
     C/end-exec                                                                             MD042142

     C                   DOW       SQLCode <> 100                                           MD042142
     C                   MOVEL     pTNBR         nTNBR                                      MD042142
     C                   EVAL      APTRAN = 'OTC / Exchange-Traded Transaction'             MD042142
     C                   EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + nTNBR                 MD042142
     C                   IF        *IN60 = *ON                                              MD042142
     C                   WRITE     HEADP1                                                   MD042142
     C                   EVAL      *IN60 = *OFF                                             MD042142
     C                   ENDIF                                                              MD042142
      *
     C                   WRITE     DETAIL1                                                  MD042142

     C/exec SQL                                                                             MD042142
     C+ fetch next                                                                          MD042142
     C+ from SELIST5                                                                        MD042142
     C+ into  :pTNBR                                                                        MD042142
     C/end-exec                                                                             MD042142

     C                   ENDDO                                                              MD042142

     C/exec SQL                                                                             MD042142
     C+ close SELIST5                                                                       MD042142
     C/end-exec                                                                             MD042142
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
      *                                                                                    MD038440A
     C                   CALL      'AOBANKR0'                                              MD038440A
     C                   PARM      *BLANKS       @RTCD             7                       MD038440A
     C                   PARM      '*FIRST '     @OPTN             7                       MD038440A
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
      ********************************************************************
      /EJECT
      ********************************************************************
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
