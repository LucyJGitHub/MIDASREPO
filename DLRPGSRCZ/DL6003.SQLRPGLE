     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas DL APR MM Deals files Take on')                  *
      *****************************************************************
      *                                                               *
      *   Midas - Dealing Module                                      *
      *                                                               *
      *  DL6003 - Utility program to update PF/DEALSDC, MMDELDPP and  *
      *           DLCHISPD                                            *
      *                                                               *
      *  (C) Copyright Finastra International Limited, 2016           *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050  *Create    Date 16Jun19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  CER050 - Annualised Percentage Rate                          *
      *                                                               *
      *****************************************************************
      *  Subroutine Index                                             *
      *  #IMAIN - Main processing                                     *
      *****************************************************************
      *
      *****************************************************************
      *
      * Array containing Copyright statement
     D ARRCPY          S             80    DIM(1) CTDATA PERRCD(1)
      *
     D SDACUS        E DS                  EXTNAME(SDACUSPD)
     D DEALDC        E DS                  EXTNAME(DEALSDC)
     D                                     Prefix(L)
     D DLCHIS        E DS                  EXTNAME(DLCHISPD)
     D                                     Prefix(H)
     D MMDELD        E DS                  EXTNAME(MMDELDPP)
     D                                     Prefix(L)
      *
     D LDA            UDS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      *
      * DS for AOSVALR0
     D P@VL01          DS           200
     D  SVAL11                 1      1
      *
      * AOSVALR0 key for Deposit Interest Retention Period
     D SVALK1          C                   CONST('APRMMLoans')
     D SVALK2          C                   CONST('APRMMDeposits')
      *
     D @APRC           S              1A
     D @Cnum           S              6A
      *
      *****************************************************************
      *
      * Main processing
     C                   EXSR      SRMAIN
      *
      * End program
     C                   SETON                                        LR
     C                   RETURN
      *
      *****************************************************************
      *                                                               *
      * SRMAIN    - Main processing                                   *
      *                                                               *
      * Calls     -                                                   *
      *                                                               *
      * Called by - MAIN                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRMAIN        BEGSR
      *
     C                   If        WKMMLN = 'N'
     C/exec SQL
     C+ update DEALSDC
     C+   set APRC = 'N'
     C+ where DTYP = 'IP'
     C+   or DTYP = 'TI'
     C+   or DTYP = 'CL'
     C+   or DTYP = 'CN'
     C+   or DTYP = 'DL'
     C/end-exec
      *
     C/exec SQL
     C+ update MMDELDPP
     C+   set HKAPRC = 'N'
     C+ where HKMTYP = 'IP'
     C+   or HKMTYP = 'TI'
     C+   or HKMTYP = 'CL'
     C+   or HKMTYP = 'CN'
     C+   or HKMTYP = 'DL'
     C/end-exec
      *
     C/exec SQL
     C+ update DLCHISPD
     C+   set APRC = 'N'
     C+ where DTYP = 'IP'
     C+   or DTYP = 'TI'
     C+   or DTYP = 'CL'
     C+   or DTYP = 'CN'
     C+   or DTYP = 'DL'
     C/end-exec
     C                   Endif
      *
     C                   If        WKMMDP = 'N'
     C/exec SQL
     C+ update DEALSDC
     C+   set APRC = 'N'
     C+ where DTYP = 'IT'
     C+   or DTYP = 'TD'
     C+   or DTYP = 'CD'
     C+   or DTYP = 'CI'
     C/end-exec
      *
     C/exec SQL
     C+ update MMDELDPP
     C+   set HKAPRC = 'N'
     C+ where HKMTYP = 'IT'
     C+   or HKMTYP = 'TD'
     C+   or HKMTYP = 'CD'
     C+   or HKMTYP = 'CI'
     C/end-exec
      *
     C/exec SQL
     C+ update DLCHISPD
     C+   set APRC = 'N'
     C+ where DTYP = 'IT'
     C+   or DTYP = 'TD'
     C+   or DTYP = 'CD'
     C+   or DTYP = 'CI'
     C/end-exec
     C                   Endif
      *
      ** Processing for MM Loans
      *
     C                   Eval      @Cnum = *Blanks
     C                   Eval      @Aprc = *Blanks
      *
     C                   If        WKMMLN = 'Y'
      *
      ** DEALSDC
      *
     C/exec SQL
     C+ declare LoanDC cursor for
     C+ Select * from DEALSDC
     C+ where DTYP = 'IP'
     C+   or DTYP = 'TI'
     C+   or DTYP = 'CL'
     C+   or DTYP = 'CN'
     C+   or DTYP = 'DL'
     C+ order by CNUM
     C/end-exec

     C/exec SQL
     C+ open LoanDC
     C/end-exec

      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 1
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

     C/exec SQL
     C+ fetch next
     C+ from LoanDC
     C+ into :DEALDC
     C/end-exec

     C                   Dow       SQLCode <> 100
     C                   If        LCNUM <> @Cnum
     C                   eval      @Cnum = LCNUM

     C/exec SQL
     C+ select *
     C+ into :SDACUS
     C+ from SDACUSPD
     C+ where E5CUST =:@Cnum
     C/end-exec

     C     SQLCOD        Ifne      *Zeros
     C     SQLCOD        oreq      *Zeros
     C     E5APRC        andeq     *Blank
     C                   Eval      @APRC = 'Y'
     C                   else
     C                   Eval      @APRC = E5APRC
     C                   Endif

     C                   Endif

     C/exec SQL
     C+ update DEALSDC
     C+   set APRC =:@Aprc
     C+ where DLNO =:LDLNO
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from LoanDC
     C+ into :DEALDC
     C/end-exec
     C                   Enddo

     C/exec SQL
     C+ close LoanDC
     C/end-exec
      *
      ** MMDELDPP
      *
     C/exec SQL
     C+ declare LoanMM cursor for
     C+ Select * from MMDELDPP
     C+ where HKMTYP = 'IP'
     C+   or HKMTYP = 'TI'
     C+   or HKMTYP = 'CL'
     C+   or HKMTYP = 'CN'
     C+   or HKMTYP = 'DL'
     C+ order by HKCNUM
     C/end-exec

     C/exec SQL
     C+ open LoanMM
     C/end-exec

      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 2
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

     C/exec SQL
     C+ fetch next
     C+ from LoanMM
     C+ into :MMDELD
     C/end-exec

     C                   Dow       SQLCode <> 100
     C                   If        LHKCNUM <> @Cnum
     C                   eval      @Cnum = LHKCNUM
     C/exec SQL
     C+ select *
     C+ into :SDACUS
     C+ from SDACUSPD
     C+ where E5CUST =:@Cnum
     C/end-exec

     C     SQLCOD        Ifne      *Zeros
     C     SQLCOD        oreq      *Zeros
     C     E5APRC        andeq     *Blank
     C                   Eval      @APRC = 'Y'
     C                   else
     C                   Eval      @APRC = E5APRC
     C                   Endif

     C                   Endif

     C/exec SQL
     C+ update MMDELDPP
     C+   set HKAPRC =:@Aprc
     C+ where HKDN38 =:LHKDN38
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from LoanMM
     C+ into :MMDELD
     C/end-exec
     C                   Enddo

     C/exec SQL
     C+ close LoanMM
     C/end-exec
      *
      ** DLCHISPD
      *
     C/exec SQL
     C+ declare LoanCH cursor for
     C+ Select * from DLCHISPD
     C+ where DTYP = 'IP'
     C+   or DTYP = 'TI'
     C+   or DTYP = 'CL'
     C+   or DTYP = 'CN'
     C+   or DTYP = 'DL'
     C+ order by CNUM
     C/end-exec

     C/exec SQL
     C+ open LoanCH
     C/end-exec

      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 3
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

     C/exec SQL
     C+ fetch next
     C+ from LoanCH
     C+ into :DLCHIS
     C/end-exec

     C                   Dow       SQLCode <> 100
     C                   If        HCNUM <> @Cnum
     C                   eval      @Cnum = HCNUM
     C/exec SQL
     C+ select *
     C+ into :SDACUS
     C+ from SDACUSPD
     C+ where E5CUST =:@Cnum
     C/end-exec

     C     SQLCOD        Ifne      *Zeros
     C     SQLCOD        oreq      *Zeros
     C     E5APRC        andeq     *Blank
     C                   Eval      @APRC = 'Y'
     C                   else
     C                   Eval      @APRC = E5APRC
     C                   Endif

     C                   Endif

     C/exec SQL
     C+ update DLCHISPD
     C+   set APRC =:@Aprc
     C+ where DLNO =:HDLNO
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from LoanCH
     C+ into :DLCHIS
     C/end-exec
     C                   Enddo

     C/exec SQL
     C+ close LoanCH
     C/end-exec
      *
     C                   Endif
      *
      ** Processing for MM Deposits
      *
     C                   Eval      @Cnum = *Blanks
     C                   Eval      @Aprc = *Blanks
      *
     C                   If        WKMMDP = 'Y'
      *
      ** DEALSDC
      *
     C/exec SQL
     C+ declare DepDC cursor for
     C+ Select * from DEALSDC
     C+ where DTYP = 'IT'
     C+   or DTYP = 'TD'
     C+   or DTYP = 'CD'
     C+   or DTYP = 'CI'
     C+ order by CNUM
     C/end-exec

     C/exec SQL
     C+ open DepDC
     C/end-exec

      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 4
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

     C/exec SQL
     C+ fetch next
     C+ from DepDC
     C+ into :DEALDC
     C/end-exec

     C                   Dow       SQLCode <> 100
     C                   If        LCNUM <> @Cnum
     C                   move      LCNUM         @Cnum
     C/exec SQL
     C+ select *
     C+ into :SDACUS
     C+ from SDACUSPD
     C+ where E5CUST =:@Cnum
     C/end-exec

     C     SQLCOD        Ifne      *Zeros
     C     SQLCOD        oreq      *Zeros
     C     E5APRC        andeq     *Blank
     C                   Eval      @APRC = 'Y'
     C                   else
     C                   Eval      @APRC = E5APRC
     C                   Endif

     C                   Endif

     C/exec SQL
     C+ update DEALSDC
     C+   set APRC =:@Aprc
     C+ where DLNO =:LDLNO
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from DepDC
     C+ into :DEALDC
     C/end-exec
     C                   Enddo

     C/exec SQL
     C+ close DepDC
     C/end-exec
      *
      ** MMDELDPP
      *
     C/exec SQL
     C+ declare DepMM cursor for
     C+ Select * from MMDELDPP
     C+ where HKMTYP = 'IT'
     C+   or HKMTYP = 'TD'
     C+   or HKMTYP = 'CD'
     C+   or HKMTYP = 'CI'
     C+ order by HKCNUM
     C/end-exec

     C/exec SQL
     C+ open DepMM
     C/end-exec

      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 5
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

     C/exec SQL
     C+ fetch next
     C+ from DepMM
     C+ into :MMDELD
     C/end-exec

     C                   Dow       SQLCode <> 100
     C                   If        LHKCNUM <> @Cnum
     C                   eval      @Cnum = LHKCNUM
     C/exec SQL
     C+ select *
     C+ into :SDACUS
     C+ from SDACUSPD
     C+ where E5CUST =:@Cnum
     C/end-exec

     C     SQLCOD        Ifne      *Zeros
     C     SQLCOD        oreq      *Zeros
     C     E5APRC        andeq     *Blank
     C                   Eval      @APRC = 'Y'
     C                   else
     C                   Eval      @APRC = E5APRC
     C                   Endif

     C                   Endif

     C/exec SQL
     C+ update MMDELDPP
     C+   set HKAPRC =:@Aprc
     C+ where HKDN38 =:LHKDN38
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from DepMM
     C+ into :MMDELD
     C/end-exec
     C                   Enddo

     C/exec SQL
     C+ close DepMM
     C/end-exec
      *
      ** DLCHISPD
      *
     C/exec SQL
     C+ declare DepCH cursor for
     C+ Select * from DLCHISPD
     C+ where DTYP = 'IT'
     C+   or DTYP = 'TD'
     C+   or DTYP = 'CD'
     C+   or DTYP = 'CI'
     C+ order by CNUM
     C/end-exec

     C/exec SQL
     C+ open DepCH
     C/end-exec

      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 6
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

     C/exec SQL
     C+ fetch next
     C+ from DepCH
     C+ into :DLCHIS
     C/end-exec

     C                   Dow       SQLCode <> 100
     C                   If        HCNUM <> @Cnum
     C                   eval      @Cnum = HCNUM
     C/exec SQL
     C+ select *
     C+ into :SDACUS
     C+ from SDACUSPD
     C+ where E5CUST =:@Cnum
     C/end-exec

     C     SQLCOD        Ifne      *Zeros
     C     SQLCOD        oreq      *Zeros
     C     E5APRC        andeq     *Blank
     C                   Eval      @APRC = 'Y'
     C                   else
     C                   Eval      @APRC = E5APRC
     C                   Endif

     C                   Endif

     C/exec SQL
     C+ update DLCHISPD
     C+   set APRC =:@Aprc
     C+ where DLNO =:HDLNO
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from DepCH
     C+ into :DLCHIS
     C/end-exec
     C                   Enddo

     C/exec SQL
     C+ close DepCH
     C/end-exec
      *
     C                   Endif
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSYSV - Retrieve system value                                *
      *                                                               *
      *****************************************************************
      *
     C     SRSYSV        BEGSR
      *
      * Retrieve APR system value
     C                   CALL      'AOSVALR0'
     C                   PARM                    P@RTCD            7
     C                   PARM      SVALKK        P@OP01           20
     C                   PARM                    P@VL01          200
     C                   PARM      *BLANKS       P@OP02           20
     C                   PARM                    P@VL02          200
     C                   PARM      *BLANKS       P@OP03           20
     C                   PARM                    P@VL03          200
     C                   PARM      *BLANKS       P@OP04           20
     C                   PARM                    P@VL04          200
     C                   PARM      *BLANKS       P@OP05           20
     C                   PARM                    P@VL05          200
     C                   PARM      *BLANKS       P@OP06           20
     C                   PARM                    P@VL06          200
     C                   PARM      *BLANKS       P@OP07           20
     C                   PARM                    P@VL07          200
     C                   PARM      *BLANKS       P@OP08           20
     C                   PARM                    P@VL08          200
     C                   PARM      *BLANKS       P@OP09           20
     C                   PARM                    P@VL09          200
     C                   PARM      *BLANKS       P@OP10           20
     C                   PARM                    P@VL10          200
      *
      * APR system value not found
     C     P@RTCD        IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDSVALPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     SVALKK        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      * Set up copyright parameter
     C                   MOVEA     ARRCPY        WCPY             80
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     'DL6003'      DBPGM
      *
      * Retrieve system values for 'APRMMLoans'
     C                   MOVEL     SVALK1        SVALKK           20
     C                   EXSR      SRSYSV
     C                   MOVE      SVAL11        WKMMLN            1
      *
      * Retrieve system values for 'APRMMDeposits'
     C                   MOVEL     SVALK2        SVALKK
     C                   EXSR      SRSYSV
     C                   MOVE      SVAL11        WKMMDP            1
      *
     C                   ENDSR
      *
     C*****************************************************************
     C/EJECT
     C*****************************************************************
      *                                                               *
      * *PSSR - Error handling subroutine                             *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
     C                   ENDSR
     C*****************************************************************
** ARRCPY
(c) Finastra International Limited 2016
