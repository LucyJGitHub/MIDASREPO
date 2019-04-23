     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited. 2017')
      *****************************************************************
/*STD *  RPGSQLBND                                                   *
/*EXI *  TEXT('Nostro Account Activity - OM')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SD000152OM - Nostro Account Activity - OM.                   *
      *                                                               *
      *  Function:  This program checks if a Nostro is used by        *
      *             a Other transactions.                             *
      *                                                               *
      *  Called By: SD000151R                                         *
      *                                                               *
      *   (c) Finastra International Limited. 2017                    *
      *                                                               *
      *  Last Amend No. MD038440A          Date 08May18               *
      *  Prev Amend No. MD048898           Date 11Dec17               *
      *                 MD038440           Date 27Oct17               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD038440A - MGOREFPD records should not block transmitted    *
      *              messages. Change to Info only.                   *
      *  MD048898 - No validation for default Nostro in SDCURRPD      *
      *  MD038440 - Nostro deletion issue. Revise validation process. *
      *                                                               *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FSD000152P6O    E             PRINTER OFLIND(*IN60)
     F                                     INFDS(SPOOLU)
     F                                     INFSR(*PSSR)
     FSDNOSTL0  IF   E           K DISK    INFSR(*PSSR)                                     MD048898

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

     D POMNWRK         S              6A
     D POMMTPY         S              3A
     D POMMTAG         S              5A
     D PTRNO           S             16A
     D PFHAJOB         S             10A
     D PFHAUSR         S             10A
     D PA6CYCD         S              3A
     D PBYCUST         S              6A
     D PBYTRTY         S              2A
     D PMGST           S              4A
     D KACNO           S             17A
     D APTRAN          S             40A
     D FULNOST         S              5A

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
     C                   EVAL      XxRtn  = 'Y'

     C     KLCRSL        KLIST                                                              MD048898
     C                   KFLD                    YyCcy                                      MD048898
     C                   KFLD                    XxNost                                     MD048898
      *                                                                                     MD048898
     C     KLCRSL        CHAIN     SDNOSTL0                           99                    MD048898
      ** Database error                                                                     MD048898
     C                   IF        *IN99 = *ON                                              MD048898
     C                   EVAL      DBKEY  = FulNost                                         MD048898
     C                   EVAL      DBFILE = 'SDNOSTPD'                                      MD048898
     C                   EVAL      DBASE  = 901                                             MD048898
     C                   EXSR      *PSSR                                                    MD048898
     C                   ENDIF                                                              MD048898
      *                                                                                     MD048898
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
      *  SValv  - Retrieve transactions                               *
      *                                                               *
      *****************************************************************
     C     SRValv        BEGSR

      **  Set file pointer to first record of MEOUFMPD
      *
     C/exec SQL
     C+ declare EXLIST2 cursor for
     C+ select OMNWRK, OMMTPY, OMMTAG  from MEOUFMPD
     C+ where OMCURR = :YyCcy and
     C+       OMNOST = :XxNost
     C+ order by
     C+       OMNWRK
     C/end-exec

     C/exec SQL
     C+ open EXLIST2
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
     C+ from EXLIST2
     C+ into :pOMNWRK, :pOMMTPY, :pOMMTAG
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   EVAL      APTRAN = 'Outgoing Message Field Management'
     C                   EVAL      DATAP = APTRAN + TXSTAT(2)+ ' ' + pOMNWRK +
     C                              ' ' +  pOMMTPY + ' ' +  pOMMTAG
     C                   IF        *IN60 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
     C                   WRITE     DETAIL1

     C/exec SQL
     C+ fetch next
     C+ from EXLIST2
     C+ into   :pOMNWRK, :pOMMTPY, :pOMMTAG
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close EXLIST2
     C/end-exec
      *
      **  Set file pointer to first record of MGOREFPD
      *
     C/exec SQL
     C+ declare EXLIST3 cursor for
     C********** select TRNO   from MGOREFPD                                               MD038440A
     C+ select TRNO, MGST from MGOREFPD                                                    MD038440A
     C+ where CCY = :YyCcy and
     C+       NSNO = :XxNost
     C+ order by
     C+       TRNO
     C/end-exec

     C/exec SQL
     C+ open EXLIST3
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
     C+ from EXLIST3
     C********** into :pTRNO                                                               MD038440A
     C+ into :pTRNO,  :pMGST                                                               MD038440A
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   IF        pMGST <> 'TRAN'                                         MD038440A
     C                   EVAL      APTRAN = 'OPAY messages by Nostro'
     C                   EVAL      DATAP = APTRAN + TXSTAT(1) +' ' + pTRNO
     C                   IF        *IN60 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
     C                   WRITE     DETAIL1
     C                   IF        PMODE = 'V'
     C                   EVAL      XxRtn  = 'R'
     C                   GOTO      VALEXIT
     C                   ENDIF
      *
     C                   ELSE                                                              MD038440A
     C                   EVAL      APTRAN = 'OPAY messages by Nostro'                      MD038440A
     C                   EVAL      DATAP = APTRAN + TXSTAT(2) +' ' + pTRNO                 MD038440A
     C                   IF        *IN60 = *ON                                             MD038440A
     C                   WRITE     HEADP1                                                  MD038440A
     C                   EVAL      *IN60 = *OFF                                            MD038440A
     C                   ENDIF                                                             MD038440A
     C                   WRITE     DETAIL1                                                 MD038440A
     C                   ENDIF                                                             MD038440A

     C/exec SQL
     C+ fetch next
     C+ from EXLIST3
     C********** into :pTRNO                                                               MD038440A
     C+ into :pTRNO,  :pMGST                                                               MD038440A
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close EXLIST3
     C/end-exec
      *
      **  Set file pointer to first record of MEFNODPD
      *
     C                   IF        CGL009 = 'Y'
     C/exec SQL
     C+ declare EXLIST4 cursor for
     C+ select FHAJOB,FHAUSR   from MEFNODPD
     C+ where FHCYCD = :YyCcy and
     C+       FHNOSN = :XxNost
     C+ order by
     C+       FHAJOB
     C/end-exec

     C/exec SQL
     C+ open EXLIST4
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
     C+ from EXLIST4
     C+ into :pFHAJOB,:pFHAUSR
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   EVAL      APTRAN = 'Midas-Fontis TPP Nostro Default'
     C                   EVAL      DATAP = APTRAN + TXSTAT(1) +' ' + pFHAJOB +
     C                                      ' ' + pFHAUSR
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
     C+ from EXLIST4
     C+ into   :pTRNO
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close EXLIST5
     C/end-exec
     C                   ENDIF
      *
      **  Set file pointer to first record of SDCURRPD
      *
     C/exec SQL
     C+ declare EXLIST7 cursor for
     C+ select A6CYCD    from SDCURRPD
     C+ where A6CYCD = :YyCcy and
     C+       A6ECDN = :XxNost or
     C+       A6CYCD = :YyCcy and
     C********A6CDFN = :XxNost
     C+       A6CDFN = :XxNost or                                                           MD048898
     C+       A6NOSN = :A7NOSN                                                              MD048898
     C+ order by
     C+       A6CYCD
     C/end-exec

     C/exec SQL
     C+ open EXLIST7
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
     C+ from EXLIST7
     C+ into :pA6CYCD
     C/end-exec

     C                   DOW       SQLCode <> 100

     C**********         EVAL      APTRAN = 'MNCP Pool'                                     MD048898
     C                   EVAL      APTRAN = 'Treasury Currency'                             MD048898
     C                   EVAL      DATAP = APTRAN + TXSTAT(1) + ' ' + pA6CYCD
     C                   IF        *IN60 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
     C                   WRITE     DETAIL1
     C                   IF        PMODE = 'V'                                              MD048898
     C                   EVAL      XxRtn  = 'R'
     C                   GOTO      VALEXIT                                                  MD048898
     C                   ENDIF

     C/exec SQL
     C+ fetch next
     C+ from EXLIST7
     C+ into   :pA6CYCD
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close EXLIST7
     C/end-exec
      *
      **  Set file pointer to first record of SDEXSTPD
      *
     C/exec SQL
     C+ declare EXLIST8 cursor for
     C+ select BYCUST, BYTRTY   from SDEXSTPD
     C+ where BYCYCD  = :YyCcy and
     C+       BYRONO = :XxNost or
     C+       BYCYCD  = :YyCcy and
     C+       BYPONO = :XxNost
     C+ order by
     C+       BYCUST
     C/end-exec

     C/exec SQL
     C+ open EXLIST8
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
     C+ from EXLIST8
     C+ into :pBYCUST, :pBYTRTY
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   EVAL      APTRAN = 'Extended Settlements '
     C                   EVAL      DATAP = APTRAN + TXSTAT(2) + ' ' + pBYCUST +
     C                              ' '  + pBYTRTY
     C                   IF        *IN60 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
      *
     C                   WRITE     DETAIL1

     C/exec SQL
     C+ fetch next
     C+ from EXLIST8
     C+ into    :pBYCUST, :pBYTRTY
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close EXLIST8
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
      ** Establish switchable features
      *
     C                   MOVE      'N'           CGL155            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM      'CGL155'      @KEY6             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CGL155
     C                   ENDIF
      *
     C                   MOVE      'N'           CGL009            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM      'CGL009'      @KEY6             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CGL009
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
