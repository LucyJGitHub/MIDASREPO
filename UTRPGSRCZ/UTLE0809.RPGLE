     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Patch for Facilities Interest Calc. Basis')   *
      *****************************************************************
      *                                                               *
      *  Midas - Lending Module                                       *
      *                                                               *
      *  PRTF/UTLE0809P1 - Midas UT Patch for Facility Interest       *
      *                    Calculation Basis                          *
      *                                                               *
      *  (c) Finastra International Limited 2018                      *
      *                                                               *
      *  Last Amend No. MD042752 *Create   Date 15Jan18               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD042752 - Facility currency being picked up to calculate    *
      *             interest rather than loan currency                *
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      ** LE Facilities Detail A Record
     FFCLTYL1   UF   E           K DISK    INFSR(*PSSR)

      ** SD Currency Codes File
     FSDCURRL1  IF   E           K DISK    INFSR(*PSSR)

      ** UT Patch for Facilities Interest Calc, Basis
     FUTLE0809P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
     F                                     USROPN

      *****************************************************************
      /EJECT
      *****************************************************************

      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)

      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

      ** File Information Data Structure for UTLE0809P1
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0

      ** File Information Data Structure for UTLE0809P1
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0

     D DDTMST          DS            26
     D  DDTIME                12     19A

     D RUNDT           DS
      *
      ** RUNDAT data structure to pick up system rundate.
      *
     D RUNA                    1      7
     D RUND                    8     10P 0
     D SSF                    11     11
     D DATF                   12     12
     D MBIN                   13     13
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D ODICB           S              1  0
     D WDICB           S              1  0
     D RRCNT           S              6  0
     D WRUN            S              1
     D WRQDLN          S              3  0
     D WDIFLN          S              3  0

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================

      ** Perform Detail Processing.

     C     *LOVAL        SETLL     FCLTYL1
     C                   READ      FCLTYL1

      ** Do While not End of File

     C                   DOW       NOT %EOF(FCLTYL1 )                           B1

      ** Select only a Multi-Currency Facilities

     C                   IF        MCCY = 'Y'

      ** Retrieve the Currency Calculation Basis from Currency File

     C     FCCY          CHAIN     SDCURRL1                           98

     C                   IF        *IN98 = *OFF
      *
      ** When Calculation basis is similar with calculation basis in SDCURRPD set it to zero.
      *
     C                   MOVE      A6DICB        WDICB
     C                   IF        DICB = WDICB
      *
     C                   EVAL      ODICB = DICB
     C                   EVAL      DICB = 0

     C                   IF        *IN10 = *On
     C                   UPDATE    FCLTYFMF
     C                   ENDIF

     C                   EXSR      SRDETAIL

     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   READ      FCLTYL1

     C                   ENDDO                                                  E1

      ** Write End of Report.

     ** Check that sufficient lines remain for the Format. If not,
     ** write out the Main Headings on a new page

     C                   EVAL      WRQDLN = 4
     C                   EVAL      WDIFLN = OFLLN1 - PRTLN1
     C                   IF        WDIFLN < WRQDLN
     C                   WRITE     HEADP1
     C                   ENDIF

      ** If no records read, Output "No Details" message

     C                   IF        RRCNT = *ZEROS
     C                   WRITE     NODETP1
     C                   ENDIF

     C                   WRITE     ENDRPT

      ** End Program and Return

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      *                                                               *
      *  SRWRTP1DET-Subroutine to Write a Detail record to the Report *
      *                                                               *
      *****************************************************************

     C     SRDETAIL      BEGSR

      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page

     C                   EVAL      WRQDLN = 2
     C                   EVAL      WDIFLN = OFLLN1 - PRTLN1
     C                   IF        WDIFLN < WRQDLN
     C                   WRITE     HEADP1
     C                   ENDIF

      ** Write out Detail Record

     C                   EVAL      RRCNT = RRCNT + 1
     C                   WRITE     DETAILP1

     C                   ENDSR

      *****************************************************************
      *                                                               *
      *  *INZSR - Subroutine to do Program Initialisation.            *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    MODE              1
      *
      ** Check mode is AUDIT or UPDATE.
      *
     C                   IF        MODE = 'U'
     C                             OR MODE = 'u'
     C                   EVAL      *IN10 = '1'
     C                   ELSE
     C                   EVAL      *IN10 = '0'
     C                   ENDIF

      ** Initialise LDA field

     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = *ZEROS
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY  = *BLANKS
     C                   EVAL      DBMOD  = *BLANKS
     C                   EVAL      DBPGM  = PSPROCNAME
     C                   EVAL      DBPROC = *BLANKS
     C                   OUT       LDA

      ** Report Work fields

     C                   EVAL      OFLLN1 = *ZEROS
     C                   EVAL      WDIFLN = *ZEROS

      **   Get RUND from DTAARA/RUNDAT.
      *
     C     *DTAARA       DEFINE    RUNDAT        RUNDT
     C                   IN        RUNDT

      ** Initialise variables

     C                   EVAL      RRCNT    =    0

     C                   OPEN      UTLE0809P1

     C                   WRITE     HEADP1

     C                   ENDSR

      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      *  *PSSR - Error control subroutine                             *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

      ** Check to see that *PSSR has not already been called

     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   DUMP
     C                   WRITE     HEADP1
     C                   WRITE     DBERROR
     C                   ENDIF

     C                   RETURN

     C                   ENDSR

      *****************************************************************
