     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGSQLBND
/*EXI *  TEXT('Midas SC Cache switchable features')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC000300 - Midas SC Cache switchable features                *
      *                                                               *
      *  ((c) Finastra International Limited 2014                     *
      *                                                               *
      *  Last Amend No. MD055681           Date 31Jul20               *
      *  Prev Amend No. MD024398*CREATE    Date 14Feb14               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD024398 - API Performance Optimisation                      *
      *                                                               *
      *****************************************************************
      /EJECT

      ** Core switchable features
     F*SCSARDL0* IF   E           K DISK    INFSR(*PSSR)                                    MD055681

     D Ix              S              5S 0
     D Buffer          S          32000A
     D RunBefore       S              1A

     D PRetRn          S              7A
     D PassOn          S              1A
     D SCSARD        E DS                  EXTNAME(SCSRDJW0)                                MD055681

      ** Check all features on SCSARDPD have valid passwords.

     C                   CALL      'SC0432'
     C                   PARM      'Check'       PRetRn
     C                   PARM      'N'           PassOn

      ** If any invalid features, end in error

     C                   IF        PRetRn = 'Errors'
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Read through core features and add to buffer

     C******LOVAL        SETLL     @SARDL0                                99                MD055681
     C**********         READ      @SARDL0                                99                MD055681
     C/EXEC SQL                                                                             MD055681
     C+ declare ACursor insensitive scroll cursor for                                       MD055681
     C+ select * from SCSRDJW0                                                              MD055681
     C+ order by SARN                                                                       MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C/EXEC SQL                                                                             MD055681
     C+ open ACursor                                                                        MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C/EXEC SQL                                                                             MD055681
     C+ fetch next from ACursor into :SCSARD                                                MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681

     C                   EVAL      Ix = 1
     C**********         DOU       %EoF                                                     MD055681
     C                   DOW       SQLCODE = 0                                              MD055681
     C**********         EVAL      %Subst(Buffer:Ix:6) = ABSARN                             MD055681
     C                   EVAL      %Subst(Buffer:Ix:6) = SARN                               MD055681
     C                   EVAL      Ix =Ix +6
     C**********         READ      @SARDL0                                99                MD055681
     C
     C/EXEC SQL                                                                             MD055681
     C+ fetch next from ACursor into :SCSARD                                                MD055681
     C/END-EXEC                                                                             MD055681
     C                   ENDDO

     C/EXEC SQL                                                                             MD055681
     C+ close ACursor                                                                       MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
      ** Store buffer for later use by AOSARDR0.  This code will always create
      ** a single record in SCSARHTD, whether or not it exists already.

     C/EXEC SQL
     C+ update SCSARHTD
     C+ set SCCACH = :BUFFER
     C/END-EXEC

      ** SQL code 100 = record not found
      ** SQL code 0   = normal completion
      ** Anything else = error, so leave program

     C                   IF        SQLCOD <> 100 and
     C                             SQLCOD <> 0
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Update failed because no record exists, so insert instead.

     C                   IF        SQLCOD = 100
     C/EXEC SQL
     C+ insert into SCSARHTD
     C+  values(:BUFFER)
     C/END-EXEC
     C                   EndIf

      ** Error - leave program

     C                   IF        SQLCOD <> 00
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Return to caller

     C                   SETON                                        LR
     C                   RETURN
      *
      *****************************************************************
      * *PSSR - Program status subroutine                             *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   EVAL      *INLR = *ON
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   IF        RunBefore  = ' '
     C                   EVAL      RunBefore  = 'Y'
     C                   DUMP
     C                   ENDIF
     C                   RETURN

     C                   ENDSR
