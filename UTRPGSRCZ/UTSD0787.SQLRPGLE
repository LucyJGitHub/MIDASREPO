     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SD MD-53116 Utility program for T_GZCUSTEX')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  UTSD0784 - Midas SD MD-53116 Utility program for T_GZCUSTEX  *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. MD053116  *CREATE  Date 08Oct19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD053116 - Customer Deactivated but not displayed as         *
      *             inactive.                                         *
      *                                                               *
      *****************************************************************

     FSDCUSTL5  IF   E           K DISK    INFSR(*PSSR)

     FUTSD0787P1O    E             PRINTER OFLIND(*IN25)

      ** =======
      ** D-specs
      ** =======

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Data Structure for Customer Master File
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D PMODE           S              7
     D WSTAT           S              1A

      ** Variables for GOGETZONE

     D PZRTCD          S              7
     D PZERMS          S             50
     D PZFCHK          S              1
     D PZZONE          S             10
     D PZSHTC          S              4
     D PZRDNB          S              5  0
     D PZDNWD          S              5  0
     D PZBCCY          S              3
     D PZNJOB          S              1  0
     D WZONE           S             10

      *****************************************************************
      /EJECT
      *****************************************************************

     C                   EVAL      *IN10 = *OFF
     C                   IF        PMODE = 'A'
     C                             OR PMODE = 'a'
     C                   EVAL      *IN10 = *ON
     C                   ENDIF

     C                   EXSR      SRCUSTSTAT

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRCUSTSTAT - Patch Customer Status Routine            *
      *****************************************************************

     C     SRCUSTSTAT    BEGSR

     C     *LOVAL        SETLL     SDCUSTL5
     C                   READ      SDCUSTL5

     C                   WRITE     UTSD0787H
     C                   WRITE     UTSD0787H2

     C                   EVAL      WCTR  = 0
     C                   DOW       NOT %EOF(SDCUSTL5)

     C                   EVAL      *IN11 = *OFF
     C                   IF        *IN25 = *ON
     C                   WRITE     UTSD0787H
     C                   WRITE     UTSD0787H2
     C                   EVAL      *IN25 = *OFF
     C                   ENDIF

     C                   EVAL      WCUST = BBCUST
     C                   EVAL      WDEAC = BBDEAC
     C                   IF        BBDEAC = 'Y'

     C/EXEC SQL
     C+ SELECT DDSTAT INTO :WSTAT FROM T_GZCUSTEX
     C+ WHERE DDCUSN = :WCUST
     C+ AND ZONE = :WZONE
     C/END-EXEC

     C                   IF        WSTAT = 'A'
     C                   EVAL      *IN11 = *ON
     C                   EVAL      WCTR +=1
     C                   ENDIF

     C                   IF        *IN10 = *OFF
     C                             AND *IN11 = *ON
     C/EXEC SQL
     C+  UPDATE T_GZCUSTEX
     C+  SET DDSTAT = 'I'
     C+  WHERE DDCUSN = :WCUST
     C+  AND ZONE = :WZONE
     C/END-EXEC
     C                   EVAL      WSTAT = 'I'
     C                   ENDIF

     C                   WRITE     UTSD0787D
     C                   ENDIF
     C                   READ      SDCUSTL5
     C                   ENDDO

     C                   IF        *IN25 = *ON
     C                   WRITE     UTSD0787H
     C                   WRITE     UTSD0787H2
     C                   EVAL      *IN25 = *OFF
     C                   ENDIF
     C                   WRITE     UTSD0787T

     C                   IF        *IN25 = *ON
     C                   WRITE     UTSD0787H
     C                   WRITE     UTSD0787H2
     C                   EVAL      *IN25 = *OFF
     C                   ENDIF
     C                   WRITE     UTSD0787E

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    PMODE
      *
      ** Get Zone details
      *
     C                   CALL      'GOGETZONE'
     C                   PARM      *BLANKS       PZRTCD
     C                   PARM      *BLANKS       PZERMS
     C                   PARM      'N'           PZFCHK
     C                   PARM      *BLANKS       PZZONE
     C                   PARM      *BLANKS       PZSHTC
     C                   PARM      *ZERO         PZRDNB
     C                   PARM      *ZERO         PZDNWD
     C                   PARM      *BLANKS       PZBCCY
     C                   PARM      *ZERO         PZNJOB
      *
     C     PZRTCD        IFEQ      *BLANKS
     C                   MOVE      PZZONE        WZONE
     C                   ELSE
      *
     C     PZRTCD        IFEQ      '*ERROR'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
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
