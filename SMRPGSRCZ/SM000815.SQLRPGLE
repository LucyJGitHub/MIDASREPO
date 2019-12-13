     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Initialise PDDI and PTDI in Fee Ext File')    *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000815 - Initialise PDDI and PTDI in Fee Extension File    *
      *                                                               *
      *  Function:  This program will run during Post Database        *
      *             Upgrade. It will select all existing calculated   *
      *             fees. Then, it will default the PDDI/PTDI to 'M'  *
      *             and set FBDT to Fee Next Payment Date value if    *
      *             these fields do not contain a value.              *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. MD052216  *CREATE  Date 04Apr19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD052216 - Lending Fee's Payment Due and Taken Day           *
      *                                                               *
      *****************************************************************

     FLEFEEQL1  UF   E           K DISK    INFSR(*PSSR)
      ** Midas Fee Extension File

     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
      ** Midas Loan File

      *****************************************************************
      /EJECT
      *****************************************************************

     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *

     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure

     D FeeDetails      DS
     D FEBRCA                  1      3
     D FECNUM                  4      9
     D FEFACL                 10     14S 0
     D FELOAN                 15     20
     D FEFSEQ                 21     22S 0
     D FECALT                 23     24
     D FENPYD                 25     27P 0
     D FESYIN                 28     28

     D @RUN            S              1A
     D WPDDI           S              1A

      *****************************************************************
      /EJECT
      *****************************************************************

      ** Key Fields for Fee Extension File Access
     C     FEEKEY        KLIST
     C                   KFLD                    FECNUM
     C                   KFLD                    FEFACL
     C                   KFLD                    FELOAN
     C                   KFLD                    FEFSEQ

      ** Key Fields for Fee Extension File Access
     C     LOANKY        KLIST
     C                   KFLD                    FELOAN

      ** Select all existing calculated fees or syndicated fees with
      ** Payment Due Day Ind and Payment Taken Ind set to blanks

     C/EXEC SQL
     C+ declare FeeCursor insensitive scroll cursor for
     C+ select FEBRCA, FECNUM, FEFACL, FELOAN, FEFSEQ,
     C+        FECALT, FENPYD, FESYIN
     C+ from LEFEED left join LEFEEDQD
     C+ on   FECNUM = FQCNUM and FEFACL = FQFACL and
     C+      FELOAN = FQLOAN and FEFSEQ = FQFSEQ
     C+ where (FECALT <> ' ' or FESYIN = 'Y') and
     C+        FQPDDI = ' ' and FQPTDI = ' '
     C+ order by FEBRCA, FECNUM, FEFACL, FELOAN, FEFSEQ
     C/END-EXEC
      *
     C/EXEC SQL
     C+ open FeeCursor
     C/END-EXEC
      *
     C/EXEC SQL
     C+ fetch next from FeeCursor into :FeeDetails
     C/END-EXEC

     C                   DOW       SQLCOD <> 100

     C                   IF        SQLCODE <> 0 and
     C                             SQLCODE <> 100
     C                   EVAL      DBFILE = 'LEFEED'
     C                   EVAL      DBKEY  = 'SQL ERROR'
     C                   EVAL      DBPGM  = 'SM000815'
     C                   EVAL      DBASE  = SQLCODE
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      WPDDI = 'M'

      ** If calculated fee is attached to a flat rate personal loan,
      ** set Payment Due Day Ind to 'A'

     C                   IF        FELOAN <> *BLANKS and
     C                             FESYIN <> 'Y' and
     C                             FECALT <> '90'

     C     FELOAN        CHAIN     CLOAN
     C                   IF        %FOUND(CLOAN)
     C                   IF        PTYP = 80
     C                   EVAL      WPDDI = 'A'
     C                   ENDIF
     C                   ELSE
     C                   EVAL      DBFILE = 'CLOANCL'
     C                   EVAL      DBKEY  = 'LOAN NOT FOUND'
     C                   EVAL      DBPGM  = 'SM000815'
     C                   EVAL      DBASE  = 001
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDIF

      ** Initialise new fields in Fee Extension File
      ** Set Payment Due Day Ind and Payment Taken Ind to 'M'
      ** Set Fee Payment Base Date to Fee Next Payment Date

     C     FEEKEY        CHAIN     LEFEEQL1
     C                   IF        %FOUND(LEFEEQL1)
     C                   EVAL      FQFPBD = FENPYD
     C                   EVAL      FQPDDI = WPDDI
     C                   EVAL      FQPTDI = 'M'
     C                   UPDATE    LEFEEQD0
     C                   ELSE
     C                   EVAL      DBFILE = 'LEFEEDQD'
     C                   EVAL      DBKEY  = 'FEE NOT FOUND'
     C                   EVAL      DBPGM  = 'SM000815'
     C                   EVAL      DBASE  = 002
     C                   EXSR      *PSSR
     C                   ENDIF

     C/EXEC SQL
     C+ fetch next from FeeCursor INTO :FeeDetails
     C/END-EXEC

     C                   ENDDO

     C/EXEC SQL
     C+ close FeeCursor
     C/END-EXEC

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
