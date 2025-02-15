     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
/*EXI *  TEXT('Gen Code amended for TS Deletions for GLACNTQD')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GO011102 - Bulk Update of Global File GZGLACNTQD             *
      *             Process deletions arising from GL3320 only.       *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE095             Date 25Apr14               *
      *                 CRE090             Date 14Feb14               *
      *                 MD023783           Date 25Nov13               *
      *                 CGP017  *CREATE    Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE095 - Rate Fixing for RE Accounts (Recompile)             *
      *  CRE090 - Delay Capitalisation of Interest (Recompile)        *
      *  MD023783 - GOC011101 01022 Decimal data error occurred       *
      *             (Recompile)                                       *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *                                                               *
      *****************************************************************
     FACNTDLPD  IF   E           K DISK    INFSR(*PSSR)
     FGLACNTL3  IF   E           K DISK
     F                                     INFSR(*PSSR)

      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

     D Z_GLACNTL3    E DS                  EXTNAME(GLACNTQD)
     D G_GLACNTL3    E DS                  EXTNAME(GLACNTQD)
     D                                     PREFIX(G_)
     D GPSBLOGPD     E DS                  EXTNAME(GOSBLOGPD)

B    D BR              S              3    DIM(999)
B    D SL              S             27    DIM(999)
     D WRun            S              1
     D WkRrn           S              9  0
     D I               S              3  0
     D Tot_hh          S              6  0
     D Tot_mm          S              6  0
     D Tot_ss          S              6  0
     D Num_Time        S              6  0
     D T_Bscntw        S              9  0
     D T_Bscntd        S              9  0
     D T_Bscntu        S              9  0
     D PSjobnoa        S              6
     D PSrundatea      S              6
     D I#Erms          S             50
     D I_Zone          S             10
     D TotRow          S             13  0
B
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

      ** Read through the file of deleted accounts. Where zonal
      ** record not found and global record exists, then
      ** perform the update.

     C                   READ      ACNTDLPD
     C                   DOW       NOT %EOF(ACNTDLPD)

     C     ACCNTK        SETLL     GLACNTL3
     C                   IF        NOT %EQUAL(GLACNTL3)

     C/EXEC SQL
     C+ select * into :G_GLACNTL3 from GZGLACNTL0 where
     C+ F1CNUM = :CNUM and F1CCY = :CCY and F1ACOD = :ACOD
     C+ and F1ACSQ = :ACSQ and F1BRCA = :BRCA
     C/END-EXEC

     C/EXEC SQL
     C+ get diagnostics :TotRow = db2_number_rows
     C/END-EXEC

     C                   IF        TotRow <> 0
     C                   EVAL      I#BFAF = 'B'
     C                   EXSR      UPDGBF
     C                   EXSR      UPSYNT
     C                   ENDIF
     C                   ENDIF

     C                   READ      ACNTDLPD
     C                   ENDDO

     C                   EXSR      WRSYNL

     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDGBF - Update Global File                                   *
      *                                                               *
      *****************************************************************
     C     UPDGBF        BEGSR
     C                   EVAL      I#ZONE = I_Zone
     C                   EVAL      I#TRAP = 'N'
     C                   EVAL      I#BIMG = G_GLACNTL3
     C                   EVAL      I#AIMG = G_GLACNTL3
     C/COPY GPCPYSRCG,GPGLACNTQD
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPSYNT - Update Synchronization Totals                        *
      *                                                               *
      *****************************************************************
     C     UPSYNT        BEGSR

B    C                   Z-ADD     1             I
B    C     G_F1BRCA      LOOKUP    BR(I)                                  99
B    C                   IF        *IN99 = *OFF
B    C     '***'         LOOKUP    BR(I)                                  99
B    C                   MOVEL     G_F1BRCA      BR(I)
B    C                   CLEAR                   SYNLOGREC
B    C                   MOVEL     SYNLOGREC     SL(I)
B    C                   ELSE
B    C                   MOVEL     SL(I)         SYNLOGREC
B    C                   ENDIF
B
B    C                   ADD       1             WBSCNTW
     C                   EVAL      BSCNTW = WBSCNTW
     C                   ADD       1             T_Bscntd

B    C                   MOVEL     SYNLOGREC     SL(I)

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * WRSYNL - Write to Synchronization Log                         *
      *                                                               *
      *****************************************************************
     C     WRSYNL        BEGSR

      ** Write overall totals

     C                   MOVEL     '***'         BSBRCA
     C                   Z-ADD     T_Bscntw      WBSCNTW
     C                   Z-ADD     T_Bscntd      WBSCNTD
     C                   Z-ADD     T_Bscntu      WBSCNTU
     C                   EVAL      BSCNTW = WBSCNTW
     C                   EVAL      BSCNTD = WBSCNTD
     C                   EVAL      BSCNTU = WBSCNTU

     C                   EVAL      BSDATE = PSrundatea
     C                   EVAL      BSJOB  = PSJobName
     C                   EVAL      BSUSER = PSUser
     C                   EVAL      BSJOBN = PSjobnoa

     C                   EXSR      RECTME
     C                   EVAL      TIME_END = Num_Time
     C                   EVAL      BSETIM = BUF_TIME

      ** Calculate total number of seconds

     C                   EXSR      CALTOS

     C/EXEC SQL
     C+ insert into GPSBLOGPD
     C+ values
     C+ :GPSBLOGPD
     C/END-EXEC

B     ** Write branch totals

B    C                   Z-ADD     1             I
B    C     BR(I)         DOWNE     '***'
B    C                   MOVEL     BR(I)         BSBRCA
B    C                   MOVEL     SL(I)         SYNLOGREC

     C/EXEC SQL
     C+ insert into GPSBLOGPD
     C+ values
     C+ :GPSBLOGPD
     C/END-EXEC

B    C                   ADD       1             I
B    C                   ENDDO
B
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CALTOS - Calculate total number of seconds                    *
      *                                                               *
      *****************************************************************
     C     CALTOS        BEGSR

     C     TIME_END      IFLT      TIME_STR
     C                   ADD       240000        TIME_END
     C                   ENDIF

     C     END_HH        SUB       STR_HH        Tot_hh
     C     END_MM        SUB       STR_MM        Tot_mm
     C     END_SS        SUB       STR_SS        Tot_ss

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
      *  RECTME - Record the time                                     *
      *                                                               *
      *****************************************************************
     C     RECTME        BEGSR
     C                   TIME                    Num_Time
     C                   MOVEL     Num_Time      ALP_TIME
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
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    I_Zone

     C                   EVAL      I#Erms = *BLANK
     C                   CLEAR                   Z_GLACNTL3
     C                   CLEAR                   G_GLACNTL3

      ** Delete existing log records

     C                   EVAL      BSFILE = 'GZGLACNTQD'
     C                   EVAL      BSZONE = I_Zone

     C/EXEC SQL
     C+ delete from GPSBLOGPD where
     C+ BSFILE = :BSFILE and BSZONE = :BSZONE
     C/END-EXEC

     C                   MOVEL     PSRunDate     PSrundatea
     C                   MOVEL     PSJobNo       PSjobnoa
     C                   EXSR      RECTME
     C                   EVAL      TIME_STR = Num_Time
     C                   EVAL      BSSTIM = BUF_TIME

B     ** Initialize branches

B    C                   MOVE      '***'         BR
B
      ** Initialize overall totals
B
     C                   Z-ADD     *ZERO         T_Bscntw
     C                   Z-ADD     *ZERO         T_Bscntd
     C                   Z-ADD     *ZERO         T_Bscntu

      ** Key lists

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
      *  *PSSR  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
