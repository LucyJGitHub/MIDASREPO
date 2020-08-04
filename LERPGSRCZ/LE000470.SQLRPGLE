     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas LE Merge Generated Entries of Trailer')          *
      *****************************************************************
      *                                                               *
      *  Midas - Lending Module                                       *
      *                                                               *
      *  LE000470 - Merge Generated Entries of Trailer                *
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

     D WFile           S             10A
     D WRUN            S              1A
     D WNORE1          S             10S 0
     D FNORE1          S              5S 0

      *****************************************************************
      /EJECT
      *****************************************************************

      ** MAIN PROCESSING
      ** Update Customer Lending Postings Trailer File

     C                   SELECT

      ** Update trailer file GELEZZ

     C                   WHEN      WFile = 'GELEZZ'

     C/EXEC SQL
     C+ select (a.NORE1 + b.NORE1) - 2 into :WNORE1
     C+ from GELEZZ a, GELEICZZ b
     C/END-EXEC

     C                   MOVE      WNORE1        FNORE1

     C/EXEC SQL
     C+ UPDATE GELEZZ SET
     C+ NORE1 = :FNORE1,
     C+ HRWN = ( select cast(
     C+ ( a.HRWN + cast( (a.HRDC /1000) as numeric (3,3) ) ) +
     C+ ( b.HRWN + cast( (b.HRDC /1000) as numeric (3,3) ) )
     C+ as numeric (15,0) )
     C+ FROM GELEZZ a, GELEICZZ b ),
     C+ HRDC = ( select cast( ( mod( cast(
     C+ ( a.HRWN + cast( (a.HRDC /1000) as numeric (3,3) ) ) +
     C+ ( b.HRWN + cast( (b.HRDC /1000) as numeric (3,3) ) )
     C+ as numeric (18,3) )
     C+ , 1 ) * 1000 )
     C+ as numeric(3,0) )
     C+ FROM GELEZZ a, GELEICZZ b )
     C/END-EXEC

      ** Update trailer file GELE2ZZ

     C                   WHEN      WFile = 'GELE2ZZ'

     C/EXEC SQL
     C+ select (a.NORE1 + b.NORE1) - 2 into :WNORE1
     C+ from GELE2ZZ a, GELEICZZ b
     C/END-EXEC

     C                   MOVE      WNORE1        FNORE1

     C/EXEC SQL
     C+ UPDATE GELE2ZZ SET
     C+ NORE1 = :FNORE1,
     C+ HRWN = ( select cast(
     C+ ( a.HRWN + cast( (a.HRDC /1000) as numeric (3,3) ) ) +
     C+ ( b.HRWN + cast( (b.HRDC /1000) as numeric (3,3) ) )
     C+ as numeric (15,0) )
     C+ FROM GELE2ZZ a, GELEICZZ b ),
     C+ HRDC = ( select cast( ( mod( cast(
     C+ ( a.HRWN + cast( (a.HRDC /1000) as numeric (3,3) ) ) +
     C+ ( b.HRWN + cast( (b.HRDC /1000) as numeric (3,3) ) )
     C+ as numeric (18,3) )
     C+ , 1 ) * 1000 )
     C+ as numeric(3,0) )
     C+ FROM GELE2ZZ a, GELEICZZ b )
     C/END-EXEC

     C                   ENDSL

     C                   IF        SQLCODE <> 0
     C                   EVAL      DBFILE = WFile
     C                   EVAL      DBKEY  = 'SQL ERROR'
     C                   EVAL      DBASE  = 001
     C                   EXSR      *PSSR
     C                   ENDIF

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

     C     *ENTRY        PLIST
     C                   PARM                    WFile

      ** Initialize Work fields

     C                   EVAL      DBPGM = 'LE000470'
     C                   EVAL      WNORE1 = *ZEROS
     C                   EVAL      FNORE1 = *ZEROS

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
