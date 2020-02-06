     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Global Product Codes')
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects                                       *
      *                                                               *
      *  AOGPRDR0 - Global Product Codes Access Object                *
      *                                                               *
      *  Function:  This module retrieves Global Product Codes.       *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG2072            Date 22Apr04               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG2072 - Don't allow deleted items to be selected.          *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FGPPRODL0  IF   E           K DISK    USROPN
      ** Midas GP Global Products by Global Product Code
 
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
     D GPPROD        E DS                  EXTNAME(GPPRODPD)
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Program Parameters
     D PRtCd           S              7A
     D POptn           S              7A
     D PGPRD           S                   LIKE(PDGPRD)
 
      ** SD000012S Parameters
     D PZRtCd          S              7A
     D PZGPRD          S                   LIKE(PDGPRD)
 
      ** ZASNMG Parameters
     D PZPGNM          S             10A
     D PZDEST          S              5A
     D PZMGID          S              7A
     D PZMSGF          S             10A
     D PZMGKY          S              4A
     D PZMGDA          S             50A
     D PZMGTP          S              7A
 
      ** Key Fields
     D KGPRD           S                   LIKE(PDGPRD)
 
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
 
      ** Initialise the error flags.
 
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
     C                   OPEN(E)   GPPRODL0
 
     C                   IF        %ERROR
     C                   EVAL      WOpen = 'Y'
     C                   EVAL      *INLR = *ON
     C                   LEAVESR
     C                   ENDIF
 
     C                   ENDIF
 
      ** Close the file and return to the calling program if required.
 
     C                   IF        POptn = '*FREE  '
     C                   CLOSE(E)  GPPRODL0
 
     C                   IF        %ERROR
     C                   EVAL      WClose = 'Y'
     C                   EVAL      *INLR = *ON
     C                   LEAVESR
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   ENDIF
 
      ** Get the first record if required.
 
     C                   IF        POptn = '*FIRST '
     C     *LOVAL        SETLL(E)  GPPRODL0
 
     C                   IF        %ERROR
     C                   EVAL      WError = 'Y'
     C                   EVAL      *INLR = *ON
     C                   LEAVESR
     C                   ENDIF
 
     C                   IF        NOT %FOUND
     C                   EVAL      WEmpty = 'Y'
     C                   LEAVESR
     C                   ENDIF
 
     C                   EVAL      POptn = '*NEXT  '
     C                   ENDIF
 
      ** Get the next record if required.
 
     C                   IF        POptn = '*NEXT  '
     C                   READ(E)   GPPRODL0
 
     C                   IF        %ERROR
     C                   EVAL      WError = 'Y'
     C                   EVAL      *INLR = *ON
     C                   LEAVESR
     C                   ENDIF
 
     C                   IF        %EOF
     C                   EVAL      WEOF = 'Y'
     C                   LEAVESR
     C                   ENDIF
 
     C                   ENDIF
 
      ** Get the last record if required.
 
     C                   IF        POptn = '*LAST  '
     C     *HIVAL        SETGT(E)  GPPRODL0
 
     C                   IF        %ERROR
     C                   EVAL      WError = 'Y'
     C                   EVAL      *INLR = *ON
     C                   LEAVESR
     C                   ENDIF
 
     C                   EVAL      POptn = '*PREV  '
     C                   ENDIF
 
      ** Get the previous record if required.
 
     C                   IF        POptn = '*PREV  '
     C                   READP(E)  GPPRODL0
 
     C                   IF        %ERROR
     C                   EVAL      WError = 'Y'
     C                   EVAL      *INLR = *ON
     C                   LEAVESR
     C                   ENDIF
 
     C                   IF        %EOF
     C                   EVAL      WEOF = 'Y'
     C                   LEAVESR
     C                   ENDIF
 
     C                   ENDIF
 
      ** Search for the record if required.
 
     C                   IF        POptn = '*KEY   ' OR
     C                             POptn = '*VERIFY'
 
     C                   IF        %SCAN('?' : PGPRD) <> *ZERO
 
     C                   CALL(E)   'SD000012S'
     C                   PARM      *BLANKS       PZRtCd
     C                   PARM      *BLANKS       PZGPRD
 
     C                   IF        %ERROR
     C                   EVAL      WCall = 'Y'
     C                   LEAVESR
     C                   ENDIF
 
     C                   IF        PZRtCd <> *BLANKS
     C                   EVAL      WNoSel = 'Y'
     C                   LEAVESR
     C                   ENDIF
 
     C                   EVAL      PGPRD = PZGPRD
 
     C                   ENDIF
 
     C                   EVAL      KGPRD = PGPRD
     C     KGPRD         CHAIN(E)  GPPRODL0
 
     C                   IF        %ERROR
     C                   EVAL      WError = 'Y'
     C                   EVAL      *INLR = *ON
     C                   LEAVESR
     C                   ENDIF
 
     C                   IF        NOT %FOUND
     C                             OR (%FOUND AND PDCHTP = 'D')                              BUG2072
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
     C                   MOVEL     GPPROD        DSFDY
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
 
     C                   PARM                    PGPRD
 
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
