     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
/*EXI *  TEXT('Gen Code amended for TS Deletions for REIACD')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GO011302 - Bulk Update of Global File GZREIACD               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. CGP017  *CREATE    Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *                                                               *
      *****************************************************************
 
     FACNTDLL0  IF   E           K DISK    INFSR(*PSSR)
     FREIAC     IF   E           K DISK
     F                                     IGNORE(REIACAF    )
     F                                     IGNORE(REIACZF    )
     F                                     INFSR(*PSSR)
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
     D Z_REIAC       E DS                  EXTNAME(REIACD)
     D G_REIAC       E DS                  EXTNAME(REIACD)
     D                                     PREFIX(G_)
     D GPSBLOGPD     E DS                  EXTNAME(GOSBLOGPD)
 
B    D SYNLOGREC       DS
B    D  WBSCNTW                1      9S 0
B    D  WBSCNTD               10     18S 0
B    D  WBSCNTU               19     27S 0
B
     D                 DS
     D  BUF_TIME               1      8
     D  BUF_HH                 1      2
     D  BUF_C1                 3      3
     D  BUF_MM                 4      5
     D  BUF_C2                 6      6
     D  BUF_SS                 7      8
 
     D                 DS
     D  ALP_TIME               1      6
     D  ALP_HH                 1      2
     D  ALP_MM                 3      4
     D  ALP_SS                 5      6
 
     D                 DS
     D  TIME_STR               1      6S 0
     D  STR_HH                 1      2S 0
     D  STR_MM                 3      4S 0
     D  STR_SS                 5      6S 0
 
     D                 DS
     D  TIME_END               1      6S 0
     D  END_HH                 1      2S 0
     D  END_MM                 3      4S 0
     D  END_SS                 5      6S 0
 
B    D BR              S              3    DIM(999)
B    D SL              S             27    DIM(999)
     D RUNBEFORE       S              1A
     D IDX             S              3S 0
     D TOT_HH          S              6S 0
     D TOT_MM          S              6S 0
     D TOT_SS          S              6S 0
     D NUM_TIME        S              6S 0
     D TOTHH           S              6S 0
     D TOTMM           S              6S 0
     D TOTSS           S              6S 0
     D NUMTIME         S              6S 0
     D I_ZONE          S             10A
     D I#ERMS          S             50A
     D PSRUNDATEA      S              6A
     D PSJOBNOA        S              6A
     D TBSCNTW         S              9S 0
     D TBSCNTD         S              9S 0
     D TBSCNTU         S              9S 0
     D TOTROW          S             13  0
 
      ** Read through the file of deleted accounts. Where zonal record
      ** not found and global record exists, then perform the update.
 
     C                   READ      ACNTDLL0
     C                   DOW       NOT %EOF(ACNTDLL0)
 
     C     ACCNTK        SETLL     REIAC
     C                   IF        NOT %EQUAL(REIAC)
     C
     C/EXEC SQL
     C+ select * into :G_REIAC from GZREIACD where
     C+ CNUM = :CNUM and CCY = :CCY and ACOD = :ACOD
     C+ and ACSQ = :ACSQ and BRCA = :BRCA
     C/END-EXEC
 
     C/EXEC SQL
     C+ get diagnostics :TotRow = db2_number_rows
     C/END-EXEC
     C                   IF        TOTROW <> 0
     C                   EVAL      I#BFAF = 'B'
     C                   EXSR      UPDGLFL
     C                   EXSR      UPDSYTO
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      ACNTDLL0
     C                   ENDDO
 
     C                   EXSR      WRTSYLG
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  UPDGLFL - Update global file                                 *
      *                                                               *
      *****************************************************************
     C     UPDGLFL       BEGSR
     C                   EVAL      I#ZONE = I_ZONE
     C                   EVAL      I#TRAP = 'N'
     C                   EVAL      I#BIMG = G_REIAC
     C                   EVAL      I#AIMG = G_REIAC
     C/COPY GPCPYSRCG,GPREIACD
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  UPDSYTO - Update Synchronization Totals                      *
      *                                                               *
      *****************************************************************
     C     UPDSYTO       BEGSR
 
B    C                   Z-ADD     1             IDX
B    C     G_BRCA        LOOKUP    BR(IDX)                                99
B    C                   IF        *IN99 = *OFF
B    C     '***'         LOOKUP    BR(IDX)                                99
B    C                   MOVEL     G_BRCA        BR(IDX)
B    C                   CLEAR                   SYNLOGREC
B    C                   MOVEL     SYNLOGREC     SL(IDX)
B    C                   ELSE
B    C                   MOVEL     SL(IDX)       SYNLOGREC
B    C                   ENDIF
B
B    C                   ADD       1             WBSCNTD
     C                   EVAL      BSCNTW = WBSCNTW
     C                   ADD       1             TBSCNTD
 
B    C                   MOVEL     SYNLOGREC     SL(IDX)
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  WRTSYLG - Write to synchronization log                       *
      *                                                               *
      *****************************************************************
     C     WRTSYLG       BEGSR
 
      ** Write overall totals
 
     C                   MOVEL     '***'         BSBRCA
     C                   Z-ADD     TBSCNTW       WBSCNTW
     C                   Z-ADD     TBSCNTD       WBSCNTD
     C                   Z-ADD     TBSCNTU       WBSCNTU
     C                   EVAL      BSCNTW = WBSCNTW
     C                   EVAL      BSCNTD = WBSCNTD
     C                   EVAL      BSCNTU = WBSCNTU
 
     C                   EVAL      BSDATE = PSRUNDATEA
     C                   EVAL      BSJOB  = PSJobName
     C                   EVAL      BSUSER = PSUser
     C                   EVAL      BSJOBN = PSJOBNOA
 
     C                   EXSR      RECTIME
     C                   EVAL      TIME_END = NUM_TIME
     C                   EVAL      BSETIM   = BUF_TIME
 
      ** Calculate total number of seconds
 
     C                   EXSR      CALTOSC
 
     C/EXEC SQL
     C+ insert into GPSBLOGPD
     C+ values
     C+ :GPSBLOGPD
     C/END-EXEC
 
B     ** Write branch totals
 
B    C                   Z-ADD     1             IDX
B    C     BR(IDX)       DOWNE     '***'
B    C                   MOVEL     BR(IDX)       BSBRCA
B    C                   MOVEL     SL(IDX)       SYNLOGREC
 
     C/EXEC SQL
     C+ insert into GPSBLOGPD
     C+ values
     C+ :GPSBLOGPD
     C/END-EXEC
 
B    C                   ADD       1             IDX
B    C                   ENDDO
B
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CALTOSC - Calculate total number of seconds                  *
      *                                                               *
      *****************************************************************
     C     CALTOSC       BEGSR
 
     C     TIME_END      IFLT      TIME_STR
     C                   ADD       240000        TIME_END
     C                   ENDIF
 
     C     END_HH        SUB       STR_HH        TOT_HH
     C     END_MM        SUB       STR_MM        TOT_MM
     C     END_SS        SUB       STR_SS        TOT_SS
 
     C     STR_MM        IFGT      END_MM
     C                   SUB       1             TOT_HH
     C                   ADD       60            TOT_MM
     C                   ENDIF
 
     C     STR_SS        IFGT      END_SS
     C                   SUB       1             TOT_MM
     C                   ADD       60            TOT_SS
     C                   ENDIF
 
     C                   MULT      3600          TOT_HH
     C                   MULT      60            TOT_MM
 
     C                   Z-ADD     TOT_HH        BSTOS
     C                   ADD       TOT_MM        BSTOS
     C                   ADD       TOT_SS        BSTOS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  RECTIME - Record the time                                    *
      *                                                               *
      *****************************************************************
     C     RECTIME       BEGSR
     C                   TIME                    NUM_TIME
     C                   MOVEL     NUM_TIME      ALP_TIME
     C                   MOVEL     ALP_HH        BUF_HH
     C                   MOVEL     ALP_MM        BUF_MM
     C                   MOVEL     ALP_SS        BUF_SS
     C                   MOVEL     ':'           BUF_C1
     C                   MOVEL     ':'           BUF_C2
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial subroutine called automatically at program  *
      *           start                                               *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I_ZONE
 
     C                   EVAL      I#ERMS = *BLANK
     C                   CLEAR                   Z_REIAC
     C                   CLEAR                   G_REIAC
 
      ** Delete existing log records
 
     C                   EVAL      BSFILE = 'GZREIACD  '
     C                   EVAL      BSZONE = I_ZONE
 
     C/EXEC SQL
     C+ delete from GPSBLOGPD where
     C+ BSFILE = :BSFILE and BSZONE = :BSZONE
     C/END-EXEC
 
     C                   MOVEL     PSRunDate     PSRUNDATEA
     C                   MOVEL     PSJobNo       PSJOBNOA
     C                   EXSR      RECTIME
     C                   EVAL      TIME_STR = NUM_TIME
     C                   EVAL      BSSTIM   = BUF_TIME
 
B     ** Initialize branches
 
B    C                   MOVE      '***'         BR
B
      ** Initialize overall totals
 
     C                   Z-ADD     *ZERO         TBSCNTW
     C                   Z-ADD     *ZERO         TBSCNTD
     C                   Z-ADD     *ZERO         TBSCNTU
 
      * Key lists
 
     C     ACCNTK        KLIST
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C                   KFLD                    BRCA
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Abnormal error conditions                            *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        RUNBEFORE = *BLANKS
     C                   EVAL      RUNBEFORE = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
