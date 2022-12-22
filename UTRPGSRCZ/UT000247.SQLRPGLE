     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UT to Housekeep 24x7 DZ Objects - Report')       *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities Module                                     *
      *                                                               *
      *  UT000247 - Midas UT to Housekeep 24x7 DZ Objects Report      *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. MD058904 *CREATE    Date 19Dec22              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058904 - 24x7 Housekeeping and Clearout of the zzDZLIB     *
      *                                                               *
      *****************************************************************

     FUT000247P1O    E             PRINTER OFLIND(*IN25)

      ** D-Specs
     D/COPY ZACPYSRC,STD_D_SPEC

      ** DS for the object list
     D ObjDS           DS
     D  DDDAT                         6A
     D  DLBNM                        10A
     D  DOBNM                        10A
     D  DOBTP                         8A
     D  DOBTX                        50A

      ** DS for the bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Declared variables
     D PRTCD           S              7A
     D POPTN           S              7A
     D PMODE           S              1A
     D PRFIX           S              2A
     D PNODT           S              1A
     D PNERR           S              1A

      *****************************************************************
      /EJECT
      *****************************************************************

      ** Initialize counters and indicators

     C                   EVAL      P1CNT1 = 0
     C                   EVAL      P1CNT2 = 0
     C                   EVAL      *IN10 = *OFF
     C                   EVAL      *IN11 = *OFF

      ** Update / Housekeep mode

     C                   IF        PMODE = 'U'
     C                   EVAL      *IN10 = *ON
     C                   ENDIF

      ** Write headers

     C                   WRITE     HEADER01
     C                   WRITE     HEADER02

      ** Populate report details when No Details flag is 'N'

     C                   IF        PNODT = 'N'
     C                   EXSR      SRDetails
     C                   ENDIF

      ** Write footer

     C                   IF        P1CNT1 = 0 AND P1CNT2 = 0
     C                   WRITE     NODETL
     C                   ELSE
     C                   WRITE     ENDREP
     C                   ENDIF


     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDetails - Subroutine to Retrieve Report Details            *
      *                                                               *
      *****************************************************************

     C     SRDetails     BEGSR

      ** Get report details from DZOBJDVPD driving file

      ** DECLARE file and necessary fields
     C/exec SQL
     C+ declare OBJDV cursor for
     C+ select
     C+   ODDDAT
     C+ , ODLBNM
     C+ , ODOBNM
     C+ , ODOBTP
     C+ , ODOBTX
     C+ from DZOBJDVPD
     C/end-exec

      ** OPEN file
     C/exec SQL
     C+ open OBJDV
     C/end-exec

      ** READ FIRST record
     C/exec SQL
     C+ fetch next
     C+ from OBJDV
     C+ into :ObjDS
     C/end-exec

     C                   DOW       SQLCOD <> 100

     C                   EXSR      SROverflow
      ** Object libraries
     C                   EVAL      P1LBNM = DLBNM
     C                   EVAL      P1OLDL = PRFIX + 'DZLIB'

     C                   IF        PMODE = 'U'
     C                   IF        DDDAT = 'FAILED'
     C                   EVAL      P1NEWL = '**FAILED**'
     C                   ELSE
     C                   EVAL      P1NEWL = PRFIX + 'DPLIB'
     C                   EVAL      P1CNT1 +=1
     C                   ENDIF

     C                   ELSE
     C                   EVAL      P1NEWL = '*******   '
     C                   EVAL      P1CNT1 +=1
     C                   ENDIF
      ** Object name
     C                   EVAL      P1OBNM = DOBNM
      ** Object type
     C                   EVAL      P1OBTP = DOBTP
      ** Object description
     C                   EVAL      P1OBTX = DOBTX

     C                   WRITE     DETAIL

      ** READ NEXT record
     C/exec SQL
     C+ fetch next
     C+ from OBJDV
     C+ into :ObjDS
     C/end-exec

     C                   ENDDO

      ** CLOSE the file
     C/exec SQL
     C+ close OBJDV
     C/end-exec

     C                   EXSR      SROverflow
      ** Housekept count
     C                   WRITE     AUDIT01
     C                   EXSR      SROverflow

      ** Check object move failure
     C                   IF        PMODE = 'U'

     C                   IF        PNERR = 'Y'
      ** No error, count is 0
     C                   EVAL      P1CNT2 = 0
     C                   ELSE
      ** Final check of DZ library
     C                   EVAL      *IN11 = *ON
     C                   EXSR      SRFinalCHk
     C                   ENDIF

      ** Remaining objects count
     C                   WRITE     AUDIT02
     C                   EXSR      SROverflow
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SROverflow - Subroutine to Check for Page Overflow           *
      *                                                               *
      *****************************************************************

     C     SROverflow    BEGSR

     C                   IF        *IN25 = *ON
     C                   WRITE     HEADER01
     C                   WRITE     HEADER02
     C                   EVAL      *IN25 = *OFF
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFinalCHk - Subroutine to Check Remaining Objects in DZ Lib *
      *                                                               *
      *****************************************************************

     C     SRFinalCHk    BEGSR

      ** DECLARE file and necessary fields
     C/exec SQL
     C+ declare ERRMV cursor for
     C+ select
     C+   ODDDAT
     C+ , ODLBNM
     C+ , ODOBNM
     C+ , ODOBTP
     C+ , ODOBTX
     C+ from DZERRMVPD
     C/end-exec

      ** OPEN file
     C/exec SQL
     C+ open ERRMV
     C/end-exec

      ** READ FIRST record
     C/exec SQL
     C+ fetch next
     C+ from ERRMV
     C+ into :ObjDS
     C/end-exec

     C                   DOW       SQLCOD <> 100
     C                   EVAL      P1CNT2 +=1
      ** READ NEXT record
     C/exec SQL
     C+ fetch next
     C+ from ERRMV
     C+ into :ObjDS
     C/end-exec
     C                   ENDDO
      ** CLOSE the file
     C/exec SQL
     C+ close ERRMV
     C/end-exec
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation Routine                      *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      ** Report Mode: A = Audit or U = Update/Housekeep
     C                   PARM                    PMODE
      ** Zone system prefix
     C                   PARM                    PRFIX
      ** Y - if no details to report
     C                   PARM                    PNODT
      ** Y - if no objects remaining in zzDZLIB
     C                   PARM                    PNERR

      ** Read bank details via access program

     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRTCD
     C                   PARM      '*KEY   '     POPTN
     C     SDBANK        PARM                    SDBANK

     C                   IF        PRTCD <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'UT000247'
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = POPTN
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

     C                   DUMP

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   RETURN

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
