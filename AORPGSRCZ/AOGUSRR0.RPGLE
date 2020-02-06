     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Global User Profiles')
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects                                       *
      *                                                               *
      *  AOGUSRR0 - Midas AO Global User Profiles Access Object       *
      *                                                               *
      *  Function:  This module retrieves Global User Profiles. If    *
      *             no zone is given, the module goes into global     *
      *             mode and takes into account every user profile    *
      *             available. On the other hand, if a zone is given  *
      *             as one of the entry parameters, the module goes   *
      *             into zonal mode and restricts processing only to  *
      *             those user profiles available in the given zone.  *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG2975  *CREATE   Date 28May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  BUG2975 - Security Profile Facility changes for MidasPlus    *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FGZMUSERL0 IF   E           K DISK    RENAME(MUSERDDF:GZMUSERD0)
     F                                     USROPN
      ** Midas GZ Midas Users by User Profile
 
     FGZMUSERL1 IF   E           K DISK    RENAME(MUSERDDF:GZMUSERD1)
     F                                     USROPN
      ** Midas GZ Midas Users by Zone/User Profile
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Copyright Statement Array
     D CPY@            S             80A   DIM(1) CTDATA
 
      ** Program Status Data Structure
     D PGMDS          SDS
     D  PGNAME                 1     10
     D  PGLIBR                81     90
     D  PGJBNM               244    253
     D  PGUSER               254    263
     D  PGJBNO               264    269  0
 
      ** Global User Profiles Data Structure
     D GZMUSER       E DS                  EXTNAME(GZMUSERDD)
 
      ** Long Access Object Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Program Parameters
     D PRtCd           S              7A
     D POptn           S              7A
     D PZone           S                   LIKE(USZONE)
     D PGUSR           S                   LIKE(USRP)
 
      ** SD000016S Parameters
     D PZRtCd          S              7A
     D PZZone          S                   LIKE(USZONE)
     D PZGUSR          S                   LIKE(USRP)
 
      ** ZASNMG Parameters
     D PZPGNM          S             10A
     D PZDEST          S              5A
     D PZMGID          S              7A
     D PZMSGF          S             10A
     D PZMGKY          S              4A
     D PZMGDA          S             50A
     D PZMGTP          S              7A
 
      ** Key Fields
     D KZone           S                   LIKE(USZONE)
     D KGUSR           S                   LIKE(USRP)
 
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
      *
      ** Initialise relevant variables
      *
     C                   EVAL      WRtCd = PRtCd
     C                   EVAL      KZone = PZone
      *
      ** Initialise the error flags
      *
     C                   EVAL      WError = 'N'
     C                   EVAL      WOpen = 'N'
     C                   EVAL      WClose = 'N'
     C                   EVAL      WEmpty = 'N'
     C                   EVAL      WEOF = 'N'
     C                   EVAL      WNRF = 'N'
     C                   EVAL      WOption = 'N'
     C                   EVAL      WNoSel = 'N'
     C                   EVAL      WCall = 'N'
      *
      ** Open the file on the first call
      *
     C                   IF        WRun <> 'Y'
     C                   EVAL      WRun = 'Y'
 
     C                   IF        PZone = *BLANKS
     C                   OPEN(E)   GZMUSERL0
     C                   ELSE
     C                   OPEN(E)   GZMUSERL1
     C                   ENDIF
 
     C                   IF        %ERROR
     C                   EVAL      WOpen = 'Y'
     C                   EVAL      *INLR = *ON
     C                   LEAVESR
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Close the file and return to the calling program if required
      *
     C                   IF        POptn = '*FREE  '
 
     C                   IF        PZone = *BLANKS
     C                   CLOSE(E)  GZMUSERL0
     C                   ELSE
     C                   CLOSE(E)  GZMUSERL1
     C                   ENDIF
 
     C                   IF        %ERROR
     C                   EVAL      WClose = 'Y'
     C                   EVAL      *INLR = *ON
     C                   LEAVESR
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   ENDIF
      *
      ** Get the first record if required
      *
     C                   IF        POptn = '*FIRST '
 
     C                   IF        PZone = *BLANKS
     C     *LOVAL        SETLL(E)  GZMUSERL0
     C                   ELSE
     C     KZone         SETLL(E)  GZMUSERL1
     C                   ENDIF
 
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
 
     C                   IF        PZone = *BLANKS
     C                   READ(E)   GZMUSERL0
     C                   ELSE
     C     KZone         READE(E)  GZMUSERL1
     C                   ENDIF
 
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
 
     C                   IF        PZone = *BLANKS
     C     *HIVAL        SETGT(E)  GZMUSERL0
     C                   ELSE
     C                   EVAL      KGUSR = *HIVAL
     C     KMUSR         SETGT(E)  GZMUSERL1
     C                   ENDIF
 
     C                   IF        %ERROR
     C                   EVAL      WError = 'Y'
     C                   EVAL      *INLR = *ON
     C                   LEAVESR
     C                   ENDIF
 
     C                   EVAL      POptn = '*PREV  '
     C                   ENDIF
 
      ** Get the previous record if required.
 
     C                   IF        POptn = '*PREV  '
 
     C                   IF        PZone = *BLANKS
     C                   READP(E)  GZMUSERL0
     C                   ELSE
     C     KZone         READPE(E) GZMUSERL1
     C                   ENDIF
 
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
 
     C                   IF        %SCAN('?' : PGUSR) <> *ZERO
 
     C                   EVAL      PZZone = PZone
 
     C                   CALL(E)   'SD000016S'
     C                   PARM      *BLANKS       PZRtCd
     C                   PARM                    PZZone
     C                   PARM      *BLANKS       PZGUSR
 
     C                   IF        %ERROR
     C                   EVAL      WCall = 'Y'
     C                   LEAVESR
     C                   ENDIF
 
     C                   IF        PZRtCd <> *BLANKS
     C                   EVAL      WNoSel = 'Y'
     C                   LEAVESR
     C                   ENDIF
 
     C                   EVAL      PGUSR = PZGUSR
 
     C                   ENDIF
 
     C                   EVAL      KGUSR = PGUSR
 
     C                   IF        PZone = *BLANKS
     C     KGUSR         CHAIN(E)  GZMUSERL0
     C                   ELSE
     C     KMUSR         CHAIN(E)  GZMUSERL1
     C                   ENDIF
 
     C                   IF        %ERROR
     C                   EVAL      WError = 'Y'
     C                   EVAL      *INLR = *ON
     C                   LEAVESR
     C                   ENDIF
 
     C                   IF        NOT %FOUND
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
     C                   MOVEL     GZMUSER       DSSDY
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
 
      ** Zone
 
     C                   PARM                    PZone
 
      ** Global User Profile
 
     C                   PARM                    PGUSR
 
      ** Long Access Object Data Structure
 
     C                   PARM                    DSSDY
 
      ** End Parameter List
      ** ==================
 
      ** Midas GZ Midas Users Key List
 
     C     KMUSR         KLIST
     C                   KFLD                    KZone
     C                   KFLD                    KGUSR
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2003
