     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/**** *  RPGBASEMOD                                                   *                     MD058188
/*STD *  RPGSQLMOD                                                    *                     MD058188
/*EXI *  CLOSQLCSR(*ENDMOD)                                           *                     MD058188
/*EXI *  TEXT('Midas AO Global Instrument Codes')
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects                                       *
      *                                                               *
      *  AOGINSR0 - Global Instrument Codes Access Object             *
      *                                                               *
      *  Function:  This module retrieves Global Instrument Codes.    *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD058188           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG2072            Date 22Apr04               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058188 - Deliverable Data Split for Global files           *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG2072 - Don't allow deleted items to be selected.          *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     F*GPINSTL0* IF   E           K DISK    USROPN                                          MD058188
      ** Midas GP Global Instruments by Global Instrument Code

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Copyright Array
     D CPY@            S             80A   DIM(1) CTDATA

      ** Program Status Data Structure
     D PGMDS          SDS
     D  PGNAME                 1     10
     D  PGLIBR                81     90
     D  PGJBNM               244    253
     D  PGUSER               254    263
     D  PGJBNO               264    269  0

      ** Global Products Details Data Structure
     D*GPINST***     E DS                  EXTNAME(GPINSTPD)                                MD058188
     D GPINST        E DS                  EXTNAME(GPINSJW0)                                MD058188

      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Program Parameters
     D PRtCd           S              7A
     D POptn           S              7A
     D PGINS           S                   LIKE(INGINS)

      ** SD000013S Parameters
     D PZRtCd          S              7A
     D PZGINS          S                   LIKE(INGINS)

      ** ZASNMG Parameters
     D PZPGNM          S             10A
     D PZDEST          S              5A
     D PZMGID          S              7A
     D PZMSGF          S             10A
     D PZMGKY          S              4A
     D PZMGDA          S             50A
     D PZMGTP          S              7A

      ** Key Fields
     D KGINS           S                   LIKE(INGINS)

      ** Working Variables
     D WRtCd           S              7A
     D WRun            S              1A
     D WError          S              1A
     D WOpen           S              1A
     D WClose          S              1A
     D WEmpty          S              1A
     D WEOF            S              1A
     D WNRF            S              1A
     D WOption         S              1A
     D WNoSel          S              1A
     D WCall           S              1A

      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

     C                   EXSR      SRMain

     C                   EXSR      SRCheck

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMain - Handles main processing.                            *
      *                                                               *
      *****************************************************************
     C     SRMain        BEGSR

     C                   IF        POptn = '*SAME  '
     C                   IF        WRun <> 'Y'
     C                   EVAL      WOpen = 'Y'
     C                   ENDIF
     C                   LEAVESR
     C                   ENDIF

      ** Initialise the Error Flags.

     C                   EVAL      WError = 'N'
     C                   EVAL      WOpen = 'N'
     C                   EVAL      WClose = 'N'
     C                   EVAL      WEmpty = 'N'
     C                   EVAL      WEOF = 'N'
     C                   EVAL      WNRF = 'N'
     C                   EVAL      WOption = 'N'
     C                   EVAL      WNoSel = 'N'
     C                   EVAL      WCall = 'N'

      ** Open the file on the first call.

     C                   IF        WRun <> 'Y'
     C                   EVAL      WRun = 'Y'
     C**********         OPEN(E)   GPINSTL0                                                 MD058188

     C**********         IF        %ERROR                                                   MD058188
     C**********         EVAL      WOpen = 'Y'                                              MD058188
     C**********         EVAL      *INLR = *ON                                              MD058188
     C**********         LEAVESR                                                            MD058188
     C**********         ENDIF                                                              MD058188

     C                   ENDIF

      ** Close the file and return to the calling program if required.

     C                   IF        POptn = '*FREE  '
     C**********         CLOSE(E)  GPINSTL0                                                 MD058188

     C**********         IF        %ERROR                                                   MD058188
     C**********         EVAL      WClose = 'Y'                                             MD058188
     C**********         EVAL      *INLR = *ON                                              MD058188
     C**********         LEAVESR                                                            MD058188
     C**********         ENDIF                                                              MD058188

     C                   EVAL      *INLR = *ON
     C                   ENDIF

      ** Get the first record if required.

     C                   IF        POptn = '*FIRST '
     C**********L        SETLL(E)  GPINSTL0                                                 MD058188

     C**********         IF        %ERROR                                                   MD058188
     C**********         EVAL      WError = 'Y'                                             MD058188
     C**********         EVAL      *INLR = *ON                                              MD058188
     C**********         LEAVESR                                                            MD058188
     C**********         ENDIF                                                              MD058188

     C**********         IF        NOT %FOUND                                               MD058188
     C**********         EVAL      WEmpty = 'Y'                                             MD058188
     C**********         LEAVESR                                                            MD058188
     C**********         ENDIF                                                              MD058188

     C                   EVAL      POptn = '*NEXT  '
     C                   ENDIF

      ** Get the next record if required.

     C                   IF        POptn = '*NEXT  '
     C**********         READ(E)   GPINSTL0                                                 MD058188

     C**********         IF        %ERROR                                                   MD058188
     C**********         EVAL      WError = 'Y'                                             MD058188
     C**********         EVAL      *INLR = *ON                                              MD058188
     C**********         LEAVESR                                                            MD058188
     C**********         ENDIF                                                              MD058188

     C**********         IF        %EOF                                                     MD058188
     C**********         EVAL      WEOF = 'Y'                                               MD058188
     C**********         LEAVESR                                                            MD058188
     C**********         ENDIF

     C                   ENDIF

      ** Get the last record if required.

     C                   IF        POptn = '*LAST  '
     C******HIVAL        SETGT(E)  GPINSTL0                                                 MD058188

     C**********         IF        %ERROR                                                   MD058188
     C**********         EVAL      WError = 'Y'                                             MD058188
     C**********         EVAL      *INLR = *ON                                              MD058188
     C**********         LEAVESR                                                            MD058188
     C**********         ENDIF                                                              MD058188

     C**********         EVAL      POptn = '*PREV  '                                        MD058188
     C                   ENDIF

      ** Get the previous record if required.

     C                   IF        POptn = '*PREV  '
     C**********         READP(E)  GPINSTL0                                                 MD058188

     C**********         IF        %ERROR                                                   MD058188
     C**********         EVAL      WError = 'Y'                                             MD058188
     C**********         EVAL      *INLR = *ON                                              MD058188
     C**********         LEAVESR                                                            MD058188
     C**********         ENDIF                                                              MD058188

     C**********         IF        %EOF                                                     MD058188
     C**********         EVAL      WEOF = 'Y'                                               MD058188
     C**********         LEAVESR                                                            MD058188
     C**********         ENDIF                                                              MD058188

     C                   ENDIF

      ** Search for the record if required.

     C                   IF        POptn = '*KEY   ' OR
     C                             POptn = '*VERIFY'

     C                   IF        %SCAN('?' : PGINS) <> *ZERO

     C                   CALL(E)   'SD000013S'
     C                   PARM      *BLANKS       PZRtCd
     C                   PARM      *BLANKS       PZGINS

     C                   IF        %ERROR
     C                   EVAL      WCall = 'Y'
     C                   LEAVESR
     C                   ENDIF

     C                   IF        PZRtCd <> *BLANKS
     C                   EVAL      WNoSel = 'Y'
     C                   LEAVESR
     C                   ENDIF

     C                   EVAL      PGINS = PZGINS

     C                   ENDIF

     C                   EVAL      KGINS = PGINS
     C*****KGINS         CHAIN(E)  GPINSTL0                                                 MD058188
     C/EXEC SQL                                                                             MD058188
     C+ SELECT *                                                                            MD058188
     C+ into :GPINST                                                                        MD058188
     C+ from GPINSJW0                                                                       MD058188
     C+ where INGINS = :PGINS                                                               MD058188
     C/END-EXEC                                                                             MD058188

     C**********         IF        %ERROR                                                   MD058188
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058188
     C                   EVAL      WError = 'Y'
     C                   EVAL      *INLR = *ON
     C                   LEAVESR
     C                   ENDIF

     C**********         IF        NOT %FOUND                                               MD058188
     C**********                   OR (%FOUND AND INCHTP = 'D')                     BUG2072 MD058188
     C                   If        SQLCODE = 100                                            MD058188
     C                             OR (SQLCODE = 100 AND INCHTP = 'D')                      MD058188
     C                   EVAL      WNRF = 'Y'
     C                   LEAVESR
     C                   ENDIF

     C                   ENDIF

     C                   IF        POptn <> '*KEY   '  AND
     C                             POptn <> '*NEXT  '  AND
     C                             POptn <> '*PREV  '  AND
     C                             POptn <> '*VERIFY'  AND
     C                             POptn <> '*FREE  '
     C                   EVAL      WOption = 'Y'
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCheck - Handles error processing.                          *
      *                                                               *
      *****************************************************************
     C     SRCheck       BEGSR

     C                   EVAL      PRtCd = *BLANKS

     C                   SELECT
     C                   WHEN      WError = 'Y'
     C                   EVAL      PRtCd = '*ERROR '
     C                   WHEN      WOpen = 'Y'
     C                   EVAL      PRtCd = '*OPEN  '
     C                   WHEN      WClose = 'Y'
     C                   EVAL      PRtCd = '*CLOSE '
     C                   WHEN      WEmpty = 'Y'
     C                   EVAL      PRtCd = '*EMPTY '
     C                   WHEN      WEOF = 'Y'
     C                   EVAL      PRtCd = '*EOF   '
     C                   WHEN      WNRF = 'Y'
     C                   EVAL      PRtCd = '*NRF   '
     C                   WHEN      WOption = 'Y'
     C                   EVAL      PRtCd = '*OPTION'
     C                   WHEN      WNoSel = 'Y'
     C                   EVAL      PRtCd = '*NOSEL '
     C                   WHEN      WCall = 'Y'
     C                   EVAL      PRtCd = '*CALL  '
     C                   ENDSL

      ** Send the message to the program queue if required.

     C                   IF        PRtCd <> *BLANKS AND
     C                             WRtCd = '*MSG   '
     C                   SELECT
     C                   WHEN      WError = 'Y'
     C                   EVAL      PZMGID = 'ACO1001'
     C                   WHEN      WOpen = 'Y'
     C                   EVAL      PZMGID = 'ACO1002'
     C                   WHEN      WClose = 'Y'
     C                   EVAL      PZMGID = 'ACO1003'
     C                   WHEN      WEmpty = 'Y'
     C                   EVAL      PZMGID = 'ACO1004'
     C                   WHEN      WEOF = 'Y'
     C                   EVAL      PZMGID = 'ACO1005'
     C                   WHEN      WNRF = 'Y'
     C                   EVAL      PZMGID = 'ACO1006'
     C                   WHEN      WOption = 'Y'
     C                   EVAL      PZMGID = 'ACO1007'
     C                   WHEN      WNoSel = 'Y'
     C                   EVAL      PZMGID = 'ACO1009'
     C                   WHEN      WCall = 'Y'
     C                   EVAL      PZMGID = 'ACO1010'
     C                   ENDSL

     C                   CALLB     'ZASNMG'
     C                   PARM      *BLANKS       PZRtCd
     C                   PARM      PGNAME        PZPGNM
     C                   PARM      '*PRV'        PZDEST
     C                   PARM                    PZMGID
     C                   PARM      *BLANKS       PZMSGF
     C                   PARM      *BLANKS       PZMGKY
     C                   PARM                    PZMGDA
     C                   PARM      '*DIAG'       PZMGTP

     C                   ENDIF

      ** Execute database error-handling if required.

     C                   IF        PRtCd <> *BLANKS AND
     C                             WRtCd = '*DBERR '
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   ENDIF

     C                   IF        POptn <> '*VERIFY' AND
     C                             POptn <> '*FREE'   AND
     C                             PRtCd <> '*OPTION'
     C                   MOVEL     GPINST        DSFDY
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Subroutine.                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Begin Parameter List
      ** ====================

     C     *ENTRY        PLIST

      ** Return Code

     C                   PARM                    PRtCd

      ** Option

     C                   PARM                    POptn

      ** Global Product Code

     C                   PARM                    PGINS

      ** Short Access Object Data Structure

     C                   PARM                    DSFDY

      ** End Parameter List
      ** ==================

     C                   EVAL      WRtCd = PRtCd

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2003
