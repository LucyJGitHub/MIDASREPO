     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SD ARR Calc Batch Job Exception Rpt Pgm')        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD001112 - ARR Calculator Batch Job Exception Report Program *
      *                                                               *
      *  Function:  This program will generate exception report to    *
      *             list the Loan Transaction for which the call to   *
      *             the calculator has failed.                        *
      *                                                               *
      *  Called By: SDC000114 - Midas SD ARR Calculator Batch Job     *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. CSD103  *CREATE    Date 10Aug20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  USE OF INDICATORS                                            *
      *                                                               *
      *    U7         Database error                                  *
      *    U8         Database error                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *                                                               *
      *****************************************************************

      ** Report File
     FSD001112P1O    E             PRINTER USROPN
     F                                     INFDS(SPOOL1)

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

      ** File Information Data Structure for SD001112P1
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0

      ** Data Sructure for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Short Data Structure for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Work Data Structures
     D ERRDetails      DS
     D  SJMODI                        2A
     D  SJTREF                        6A
     D  SJEXMS                      150A

      ** Work variables
     D @RUN            S              1A
     D WErrMsg         S                   LIKE(SJEXMS)

      ** Access Object Variables
     D PRTCD           S              7A
     D POPTN           S              7A

      ** Report Variables
     D RQDLN1          S              3S 0
     D DIFLN1          S              3S 0
     D WOPNP1          S              1A

      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCESSING                                               *
      *****************************************************************

      ** Initialize Report Work Variables
     C                   EVAL      WOPNP1 = 'N'

      ** Create a list of all loan transactions that failed in
      ** ARR Calculator Batch Job
     C/EXEC SQL
     C+ declare ERRCursor insensitive scroll cursor for
     C+ select SJMODI, SJTREF, SJEXMS
     C+ from SDARRLOGTD
     C+ where SJMODI = 'LE'
     C+   and SJSTAT = 'F'
     C+   and SJMDAY = :BJRDNB
     C+ order by SJTREF
     C/END-EXEC

     C/EXEC SQL
     C+ open ERRCursor
     C/END-EXEC

     C/EXEC SQL
     C+ fetch next from ERRCursor INTO :ERRDetails
     C/END-EXEC

     C                   DOW       SQLCODE <> 100

     C                   IF        SQLCODE <> 0 and
     C                             SQLCODE <> 100
     C                   EVAL      DBFILE = 'SDARRLOGTD'
     C                   EVAL      DBKEY  = 'SQL ERROR'
     C                   EVAL      DBASE  = 005
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EXSR      SRReportP1

     C/EXEC SQL
     C+ fetch next from ERRCursor INTO :ERRDetails
     C/END-EXEC

     C                   ENDDO

     C/EXEC SQL
     C+ close ERRCursor
     C/END-EXEC

      ** Write Report Trailer and then close the file
     C                   EXSR      SREndRPT

      ** End Program
     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRReportP1 - Detail Report Subroutine                         *
      *                                                               *
      *****************************************************************
     C     SRReportP1    BEGSR

      ** Populate Report Details
     C                   EVAL      RMODI = SJMODI
     C                   EVAL      RTREF = SJTREF
     C                   EVAL      REMSG = *BLANKS
     C                   EVAL      WErrMsg = %trim(SJEXMS)
     C                   MOVEL     WErrMsg       REMSG

      ** Report fields have value at this point, open report file
     C                   IF        WOPNP1 <> 'Y'
     C                   OPEN      SD001112P1
     C                   EVAL      WOPNP1 = 'Y'
     C                   ENDIF

      ** Check that sufficient lines remain for the format
     C                   EVAL      RQDLN1 = 2
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF

      ** Write out Detail Record
     C                   WRITE     DETLP1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREndRPT - Write End of Report Line and Close the File        *
      *                                                               *
      *****************************************************************
     C     SREndRPT      BEGSR

      ** If report file is opened, write the End of Report line
     C                   IF        WOPNP1 = 'Y'

      ** Check that sufficient lines remain for the Format
     C                   EVAL      RQDLN1 = 3
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF

      ** Write out Trailer Format
     C                   WRITE     TRAILP1
     C                   CLOSE     SD001112P1

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Initialize Work fields
     C                   EVAL      DBPGM = 'SD001112'

      ** Access Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database error
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 001
     C                   EVAL      DBKEY  = POPTN
     C                   EXSR      *PSSR
     C                   ENDIF

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
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************

