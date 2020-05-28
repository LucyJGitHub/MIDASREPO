     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas LE Create Retail Int. Capitalisation Extract')   *
      *****************************************************************
      *                                                               *
      *  Midas - Lending Module                                       *
      *                                                               *
      *  LE000028 - Create Retail Interest Capitalisation Extract     *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. MD052994  *CREATE  Date 25Nov19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD052994 - CL Facility Event not Generated for Retail        *
      *             Account Debit Capitalised Interests               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7         Database error                                  *
      *    U8         Database error                                  *
      *                                                               *
      *****************************************************************

     FREGEICPD  O    E             DISK    INFSR(*PSSR)
      ** Summary of Generated Entries from GEICPD

      *****************************************************************
      /EJECT
      *****************************************************************

     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure

     D IntCapDtls      DS
     D  InCNUM                        6A
     D  InCCY                         3A
     D  InACOD                       10S 0
     D  InACSQ                        2S 0
     D  InBRCA                        3A
     D  InACNO                       10S 0
     D  InPSTD                        5S 0
     D  InVALD                        5S 0
     D  InTotAmt                     13S 0

     D WRUN            S              1

      *****************************************************************
      /EJECT
      *****************************************************************

      ** MAIN PROCESSING
      ** Select all retail account from GEICPD
      ** Then, sum up the posting amount per account per posting date

     C/EXEC SQL
     C+ declare IntCapCursor insensitive scroll cursor for
     C+ select CNUM, CCY, ACOD, ACSQ, BRCA, ACNO, PSTD, VALD,
     C+        SUM(case when DRCR=1 then PSTA*(-1) ELSE PSTA END)
     C+ from GEICPD
     C+ where ATYP = 'R'
     C+ group by CNUM, CCY, ACOD, ACSQ, BRCA, ACNO, PSTD, VALD
     C+ order by CNUM, CCY, ACOD, ACSQ, BRCA, ACNO, PSTD, VALD
     C/END-EXEC

     C/EXEC SQL
     C+ open IntCapCursor
     C/END-EXEC

     C/EXEC SQL
     C+ fetch next from IntCapCursor into :IntCapDtls
     C/END-EXEC

     C                   DOW       SQLCOD <> 100

     C                   IF        SQLCODE <> 0 and
     C                             SQLCODE <> 100
     C                   EVAL      DBFILE = 'GEICPD'
     C                   EVAL      DBKEY  = 'SQL ERROR'
     C                   EVAL      DBASE  = 001
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Output records to work file

     C                   CLEAR                   REGEICD0
     C                   EVAL      GECNUM = InCNUM
     C                   EVAL      GECCY  = InCCY
     C                   EVAL      GEACOD = InACOD
     C                   EVAL      GEACSQ = InACSQ
     C                   EVAL      GEBRCA = InBRCA
     C                   EVAL      GEACNO = InACNO
     C                   EVAL      GEPSTD = InPSTD
     C                   EVAL      GEVALD = InVALD
     C                   IF        InTotAmt > 0
     C                   EVAL      GEPSTA = InTotAmt
     C                   EVAL      GEDRCR = 0
     C                   ELSE
     C                   EVAL      GEPSTA = 0 - InTotAmt
     C                   EVAL      GEDRCR = 1
     C                   ENDIF
     C                   WRITE     REGEICD0

     C/EXEC SQL
     C+ fetch next from IntCapCursor INTO :IntCapDtls
     C/END-EXEC

     C                   ENDDO

     C/EXEC SQL
     C+ close IntCapCursor
     C/END-EXEC

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Initialize Work fields

     C                   EVAL      DBPGM = 'LE000028'
     C                   EVAL      InTotAmt = *ZEROS

     C                   ENDSR
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

     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
