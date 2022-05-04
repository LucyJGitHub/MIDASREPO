      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Update for GPUTXTPD')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing                                    *
      *                                                               *
      *  SMU90008 - Midas SM Update for duplicate ID in GPUTXTPD      *
      *                                                               *
      *  Function:  This program will update the duplicate ID in      *
      *             GPUTXTPD file.                                    *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. MD059767 *CREATE     Date 29Apr22             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059767-  Some GOC0040 task-split jobs fail during COB      *
      *             with error message unable to allocate a record    *
      *             on file GPTRAPPD.                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Subroutine index                                             *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FGPUTNIPD  UF   E             DISK    INFSR(*PSSR)
     FSMU90008P1O    E             PRINTER OFLIND(*IN25)

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     DPSDS            SDS
      * Job name.
     D PSJobName             244    253
      * User name.
     D PSUser                254    263

     D/COPY ZACPYSRC,STD_D_SPEC


      ** Data Structure for Global Branch
     D GZSDBRCH      E DS                  EXTNAME(GZSDBRCHPD)
      ** Data Structure for Global Zone
     D GPZONE        E DS                  EXTNAME(GPZONEPD)

     D GPUTXT        E DS                  EXTNAME(GPUTXTPD)

     D GPTRAP        E DS                  EXTNAME(GPTRAPPD)
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D                 DS
     D  ZONE_DS                      10
     D  TMOD_DS                       2
     D  TSMOD_DS                      4
     D  TID_DS                       15S 0
     D  GPUTXT_DS              1     31

     D  GPUTXT_DS2     DS
     D   ZONE_DS2                    10
     D   TMOD_DS2                     2
     D   TSMOD_DS2                    4
     D   TID_DS2                     15S 0

     D A_TREF          S             20    DIM(5)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D PMODE           S              1A
     D PRTCD           S              7A
     D POPTN           S              7A
     D PERR            S             50A
     D PBRCA           S              3A
     D EntID           S             30A
     D EntType         S              6A
     D EntValue        S              3A
     D SQLStmt         S           1500A   VARYING INZ
     D WCTR            S              5S 0
     D WCTR1           S              5S 0
     D WGPUTXT         S             31A
     D WTIDA           S             15A
     D WTREF           S             20A
     D WIDNTID         S             15S 0

      /EJECT
     D
      ** Read all records from GPUTXTPD
     C/exec SQL
     C+ declare GPUTXT_C cursor for
     C+ select XTZONE, XTMOD, XTSMOD, XTTREF, XTID
     C+ from GPUTXTPD
     C+ order by XTZONE, XTMOD, XTSMOD, XTID
     C/end-exec

     C/exec SQL
     C+ open GPUTXT_C
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from GPUTXT_C
     C+ into :GPUTXT
     C/end-exec

      *
      ** Print Header
      *
     C                   EVAL      *IN25 = *ON
     C                   EXSR      PrintHeader1
     C                   EVAL      *IN25 = *ON
     C                   EXSR      PrintHeader2

     C                   CLEAR                   A_TREF
     C                   EVAL      WCTR = 0
     C                   EVAL      PCTR = 0
     C                   DOW       SQLCOD <> 100

     C                   IF        SQLCOD <> 0 and SQLCOD <> 100
     C                   EVAL      DBFILE = 'GPUTXT'
     C                   EVAL      DBKEY  = 'WTREF'
     C                   EVAL      DBASE  = 001
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      ZONE_DS = XTZONE
     C                   EVAL      TMOD_DS = XTMOD
     C                   EVAL      TSMOD_DS = XTSMOD
     C                   EVAL      TID_DS = XTID

     C                   IF        GPUTXT_DS <> WGPUTXT

     C                   IF        WCTR > 1
     C                   EXSR      CHK_GPTRAP
     C                   ENDIF

     C                   CLEAR                   A_TREF
     C                   EVAL      WCTR = 1

     C                   EVAL      WGPUTXT = GPUTXT_DS
     C                   ELSE
     C                   EVAL      WCTR += 1
     C                   ENDIF

     C                   EVAL      A_TREF(WCTR) = XTTREF

     C/exec SQL
     C+ fetch next
     C+ from GPUTXT_C
     C+ into :GPUTXT
     C/end-exec
     C                   ENDDO

     C                   IF        WCTR > 1
     C                   EXSR      CHK_GPTRAP
     C                   ENDIF
      *
      ** Print Total
      *
     C                   EXSR      PrintHeader1
     C                   EXSR      PrintHeader2
     C                   WRITE     SMU90008T
      *
      ** Print End of Report
      *
     C                   EXSR      PrintHeader1
     C                   EXSR      PrintHeader2
     C                   WRITE     SMU90008E

     C/exec SQL
     C+ close GPUTXT_C
     C/end-exec

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *  CHK_GPTRAP - Check GPTRAPPD             1                    *
      *****************************************************************

     C     CHK_GPTRAP    BEGSR
      *
     C                   EVAL      WCTR1 = 1
     C                   EVAL      GPUTXT_DS2 = WGPUTXT
     C                   DOW       WCTR1 <= WCTR

     C*                  EVAL      SQLStmt  TREF(WCTR1)
     C                   EVAL      WTREF = A_TREF(WCTR1)
      *
      ** Check if GPTRAPPD is existing
      *
     C/exec SQL
     C+ declare GPTRAP_C cursor for
     C+ select *
     C+ from GPTRAPPD
     C+ where T_ZONE = :ZONE_DS2
     C+ and T_MOD = :TMOD_DS2
     C+ and T_SMOD = :TSMOD_DS2
     C+ and T_ID = :TID_DS2
     C+ and T_TREF = :WTREF
     C/end-exec

     C/exec SQL
     C+ open GPTRAP_C
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from GPTRAP_C
     C+ into :GPTRAP
     C/end-exec

     C                   IF        SQLCOD <> 0
     C                   EXSR      GETNEXT_ID
     C*                  EXSR      UPD_GPUTXTL0
     C                   EXSR      PrintDetail1
     C                   EVAL      PCTR += 1
     C                   ENDIF

     C                   EVAL      WCTR1 += 1
     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *  GETNEXT_ID - Get next ID from GPUTNIPD plus 1 (GOGETNTID)    *
      *****************************************************************

     C     GETNEXT_ID    BEGSR

      *
      ** Access the single record in GPUTNIPD
      *

     C     1             CHAIN     GPUTNID0                           99
     C     *IN99         IFEQ      *ON
     C                   EVAL      DBFILE = 'GPUTNIPD'
     C                   EVAL      DBKEY  = 'IDNTID'
     C                   EVAL      DBASE  = 002
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Update
      *
     C                   ADD       1             IDNTID
     C                   EVAL      WIDNTID +=1
     C*                  UPDATE    GPUTNID0

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *  UPD_GPUTXTL0 - Update GPTRAPL0                               *
      *****************************************************************

     C     UPD_GPUTXTL0  BEGSR

     C/Exec SQL
     C+ UPDATE GPUTXTL0 SET XTID = IDNTID
     C+ where XTZONE = :ZONE_DS2
     C+ and XTMOD = :TMOD_DS2
     C+ and XTSMOD = :TSMOD_DS2
     C+ and XTID = :TID_DS2
     C+ and XTTREF = :WTREF
     C/End-Exec

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *  PrintHeader1 - Print header 1                                *
      *****************************************************************

     C     PrintHeader1  BEGSR

     C                   IF        *IN25 = *ON
     C                   WRITE     SMU90008H1
     C                   EVAL      *IN25 = *OFF
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *  PrintHeader2 - Print header 2                                *
      *****************************************************************

     C     PrintHeader2  BEGSR

     C                   IF        *IN25 = *ON
     C                   WRITE     SMU90008H2
     C                   EVAL      *IN25 = *OFF
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *  PrintDetail1  - Print Detail record                          *
      *****************************************************************

     C     PrintDetail1  BEGSR

     C                   EXSR      PrintHeader1
     C                   EXSR      PrintHeader2
     C                   EVAL      PLNRF = WTREF
     C                   EVAL      POTID = TID_DS2
     C                   EVAL      PNTID = WIDNTID
     C                   WRITE     SMU90008D1

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************

     C     *INZSR        BEGSR

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
