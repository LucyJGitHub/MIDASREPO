     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Global User Security')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing                                    *
      *                                                               *
      *  GP100001 - Global User Security                              *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGP001  *CREATE    Date 26May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
     FGP100001DFCF   E             WORKSTN
     FGZMUSERL0 IF   E           K DISK
     FGZSDBANKL1IF   E           K DISK
 
 
     D MSG             S             78    DIM(3) CTDATA PERRCD(1)
     D ERR             S              4    DIM(19)
 
      **    'Initial Screen Details Requested' data structure.
     D                 DS
     D  SXXRQ                  1      2
     D  SBBRQ                  1      1
     D  SACRQ                  2      2
 
      **    'Initial Screen Details Requested' data structure (STORED)
     D                 DS
     D  CXXRQ                  1      2
     D  CBBRQ                  1      1
     D  CACRQ                  2      2
 
      **     Program status data structure.
     D PSDS           SDS
     D  WSID                 244    246
     D  WSID2                245    246
     D  SWSID                244    253
     D  USRID                254    263
 
      **     Local data area.
     D LDA             DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
 
 
     I/EJECT
      **    User maintenance - detail
     IMUSERDDF
     I              RECI                        RECIDD
 
     I/EJECT
     C/SPACE 2
      ********************************************************************
      *                                                                  *
      *    'F I R S T    C Y C L E'    P R O C E S S I N G               *
      *                                                                  *
      ********************************************************************
     C     *IN20         IFEQ      '0'
      *
     C                   MOVE      '1'           *IN20
      *
      **  GET LOCAL DATA AREA
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
      *
     C                   MOVEL     'GP100001'    DBPGM
      *
     C                   MOVE      'N'           UPDATE            1
     C                   MOVE      'Y'           MBRIND            1
     C                   MOVE      'N'           OBRIND            1
     C                   Z-ADD     0             RTCDE             1 0
     C                   TIME                    TIMEP             6 0
      *
      * Get user's zone
     C     USRID         CHAIN     GZMUSERL0                          8889
      *
     C     *IN88         IFEQ      '0'
     C     *IN89         ANDEQ     '0'
     C     SDBANKK       KLIST
     C                   KFLD                    USZONE
     C                   KFLD                    BJBANK
     C                   MOVEL     'BANK   '     BJBANK
     C     SDBANKK       CHAIN     GZSDBANKL1                         8889
     C  N88              MOVEL     BJMRDT        SRUNA
     C  N88              Z-ADD     BJRDNB        RUNDD             5 0
     C                   ENDIF
      *
     C                   ENDIF
     C/SPACE 2
      ********************************************************************
      *                                                                  *
      *    I  N  I  T  I  A  L      S  C  R  E  E  N                     *
      *                                                                  *
     *********************************************************************
     C**
     C     *IN21         DOUEQ     '1'
     C**
     C     RDSPIN        TAG
     C**
     C                   WRITE     GP100001F1
      *
      ** READ WORKSTATION FILE
      *
     C                   READ      GP100001F1                             19
      *
      ** F3
      *
     C     *INKC         IFEQ      '1'
     C                   EXSR      ENDPGM
      *
      ** ENTER
      *
     C                   ELSE
     C                   EXSR      INITSC
     C                   END
     C/SPACE 2
      ********************************************************************
      *                                                                 **
      *    ' O T H E R    D E T A I L S '     S C R E E N S             **
      *                                                                 **
      ********************************************************************
      *
     C     *IN21         DOWEQ     '1'
      *
     C                   MOVE      SUSER         USRPRF           10
     C                   MOVE      SACTN         ACTCDE            1
      *
      **   PROCEED ONLY IF NO ERRORS
      *
     C     *IN80         IFEQ      '0'
      *
      ** WRITE A BLANK SCREEN TO PREVENT SCREEN FLASHING ON
      ** RETURNING FROM CALLED PROGRAMS.
      *
     C                   WRITE     GP100001F3
      *
      ** BOOKING BRANCHES SELECTED
      *
     C     CBBRQ         IFEQ      'Y'
      *
     C                   CALL      'GP100002'
     C                   PARM                    USRPRF
     C                   PARM                    ACTCDE
     C                   PARM                    RTCDE
     C                   PARM                    UPDATE
     C                   PARM                    SRUNA
     C                   PARM                    RUNDD
      *
     C     RTCDE         IFEQ      1
      *
      ** If CMD3 is pressed from called pgm, the system should also check
      ** whether any updating done for booking brchs. If so, execute
      ** SUBR/FLAGS to check any booking brch defined for this user
      *
     C     UPDATE        IFEQ      'Y'
     C                   EXSR      FLAGS
     C                   ENDIF
      *
     C                   EXSR      ENDPGM
     C                   ENDIF
     C     RTCDE         CABEQ     5             BYPASS
      *
     C                   ENDIF
      *
      ** ACTION CODES SELECTED
      *
     C     CACRQ         IFEQ      'Y'
      *
     C                   Z-ADD     SECL          SECLUS            4 0
      *
     C                   CALL      'GPC100003'
     C                   PARM                    USRPRF
     C                   PARM                    ACTCDE
     C                   PARM                    RTCDE
     C                   PARM                    UPDATE
     C                   PARM                    SRUNA
     C                   PARM                    RUNDD
     C                   PARM                    MBRIND
     C                   PARM                    SECLUS
      *
     C     RTCDE         IFEQ      1
      *
      ** If CMD3 is pressed from called pgm, the system should also check
      ** whether any updating done for actions codes. If so, execute
      ** SUBR/FLAGS to check any action codes defined for this user
      *
     C     UPDATE        IFEQ      'Y'
     C                   EXSR      FLAGS
     C                   END
      *
     C                   EXSR      ENDPGM
     C                   END
      *
     C     RTCDE         CABEQ     5             BYPASS
      *
     C                   END
      *
     C     BYPASS        TAG
      *
     C                   EXSR      FLAGS
     C                   EXSR      RTRNSC
      *
     C                   END
      *
     C                   ENDDO                                                   DOW
      *
     C                   ENDDO                                                   DOU
      *
     C/EJECT
      ********************************************************************
      **  ENDPGM SR.  TO END PROGRAM                                    **
      ********************************************************************
     C     ENDPGM        BEGSR
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C                   ENDSR
     C********************************************************************
     C/EJECT
     C********************************************************************
      *   RTRNSC SR. TO RETURN TO THE INITIAL SCREEN                     *
     C********************************************************************
     C     RTRNSC        BEGSR
      *
     C                   MOVE      ' '           SACTN
     C                   MOVE      '  '          SXXRQ
      *
     C                   Z-ADD     0             RTCDE
      *
     C                   MOVEA     '000000'      *IN(11)
     C                   MOVEA     '0000000'     *IN(21)
     C                   MOVEA     '00'          *IN(79)
     C                   MOVEA     '0000'        *IN(30)
     C                   MOVEA     '00000'       *IN(36)
     C                   MOVEA     '000000'      *IN(41)
     C                   MOVEA     '00000000'    *IN(57)
     C                   MOVEA     '000'         *IN(08)
      *
     C                   MOVE      *BLANKS       ERR
     C                   MOVE      *BLANKS       ERCD
     C                   MOVE      *BLANKS       ERMS
     C                   MOVE      '0'           *IN80
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      *   FLAGS SR. TO UPDATE USER FLAGS                                 *
      ********************************************************************
     C     FLAGS         BEGSR
      *
     C     UPDATE        IFEQ      'Y'
      *
     C                   CALL      'GP100004'
     C                   PARM                    USRPRF
     C                   PARM                    BRB               1
     C                   PARM                    ACD               1
      *
     C                   MOVE      BRB           BRBS
     C                   MOVE      ACD           ACDS
      *
     C                   MOVE      'N'           UPDATE
      *
     C                   END
      *
     C                   ENDSR
      ********************************************************************
     C/EJECT
      ********************************************************************
      *   INITSC SR. TO PROCESS THE INITIAL SCREEN                       *
      ********************************************************************
     C     INITSC        BEGSR
      *
     C                   Z-ADD     0             Z                 2 0
     C                   MOVEA     '00'          *IN(21)
     C                   MOVE      '0'           *IN40
     C                   MOVEA     '000'         *IN(79)
     C                   MOVEA     '00000'       *IN(23)
     C                   MOVEA     '0000000'     *IN(30)
     C                   MOVEA     '000000'      *IN(41)
     C                   MOVEA     '000000'      *IN(51)
     C                   MOVEA     '000'         *IN(63)
     C                   MOVEA     '000'         *IN(08)
     C                   MOVEA     '0'           *IN(05)
     C*
     C                   SETON                                        88
     C                   MOVE      *BLANKS       ERR
     C                   MOVE      *BLANKS       ERCD
     C                   MOVE      *BLANKS       ERMS
      *
      ** ACTION CODE  VALIDATION
      ** ~~~~~~~~~~~~~~~~~~~~~~~
      **  001        MANDATORY ENTRY
      **  002        MUST BE A  E
      **
      **
      ** RESET WARNING IND.
      *
     C                   SETOFF                                       50
      *
      ** ACTION CODE IS MANDATORY ENTRY.
      *
     C     SACTN         IFEQ      ' '
     C                   MOVE      '1'           *IN30
     C                   MOVE      '1'           *IN80
     C                   ADD       1             Z
     C                   MOVE      ' 001'        ERR(Z)
     C                   GOTO      INT002
     C                   END
      *
      ** ACTION CODE MUST BE A  OR  E.
      *
     C                   MOVEA     '0000'        *IN(23)
     C     SACTN         CABEQ     'A'           INT002                   23
     C     SACTN         CABEQ     'E'           INT002                   25
     C                   MOVE      '1'           *IN30
     C                   MOVE      '1'           *IN80
     C                   ADD       1             Z
     C                   MOVE      ' 002'        ERR(Z)
      *
     C     INT002        TAG
      *
      ** USER PROFILE VALIDATION
      ** ~~~~~~~~~~~~~~~~~~~~~~~
      ** 003         MANDATORY ENTRY
      *
      ** USER PROFILE IS MANDATORY ENTRY.
      *
     C     SUSER         IFEQ      *BLANKS
     C                   MOVE      '1'           *IN31
     C                   MOVE      '1'           *IN80
     C                   ADD       1             Z
     C                   MOVE      ' 003'        ERR(Z)
     C                   GOTO      INT003
     C                   END
      *
      **   ATTEMPT TO ACCESS AN EXISTING MUSER RECORD :
      **   IF FOUND, CHECK IF THE RECORD IS LOCKED, SET UP SCREEN
      **   FIELDS  AND CHECK IF THE RECORD IS LIVE.
      *
     C     SUSER         CHAIN     GZMUSERL0                          8886
      *
     C     *IN88         IFEQ      '0'
     C     *IN86         IFEQ      '1'
     C                   SETON                                        303180
     C                   MOVEL     MSG(3)        ERMS
     C                   GOTO      INT003
     C                   ENDIF
     C     RECIDD        COMP      'C'                                    65
     C                   ENDIF
      *
      ** FOR AMEND, MUST REFER TO A LIVE RECORD ON FILE
      *
     C     SACTN         IFEQ      'A'
     C     *IN88         IFEQ      '1'
     C                   MOVE      '1'           *IN30
     C                   MOVE      '1'           *IN31
     C                   MOVE      '1'           *IN80
     C                   ADD       1             Z
     C                   MOVE      ' 006'        ERR(Z)
     C                   MOVEL     MSG(1)        ERMS
     C                   GOTO      INT003
     C                   ELSE
     C     *IN65         IFEQ      '1'
     C                   MOVE      '1'           *IN30
     C                   MOVE      '1'           *IN31
     C                   MOVE      '1'           *IN80
     C                   ADD       1             Z
     C                   MOVE      ' 006'        ERR(Z)
     C                   MOVEL     MSG(1)        ERMS
     C                   GOTO      INT003
     C                   END
     C                   END
     C                   END
      *
      ** FOR ENQUIRE, MUST REFER TO A RECORD ON FILE
      *
     C     SACTN         IFEQ      'E'
     C     *IN88         IFEQ      '1'
     C                   MOVE      '1'           *IN30
     C                   MOVE      '1'           *IN31
     C                   MOVE      '1'           *IN80
     C                   ADD       1             Z
     C                   MOVE      ' 007'        ERR(Z)
     C                   MOVEL     MSG(2)        ERMS
     C                   GOTO      INT003
     C                   END
     C                   END
      *
      ** BOOKING BRANCHES
      *  ~~~~~~~~~~~~~~~~
     C     SBBRQ         IFNE      'Y'
     C     SBBRQ         ANDNE     ' '
     C                   SETON                                        4380
     C                   ADD       1             Z
     C                   MOVE      ' 103'        ERR(Z)
     C                   ELSE
     C     SBBRQ         IFEQ      'Y'
     C     BRBS          ANDNE     'Y'
     C     *IN25         IFEQ      '1'
     C                   SETON                                        435381
     C                   END
     C                   END
     C                   END
      *
      ** ACTION CODES
      *  ~~~~~~~~~~~~
     C     SACRQ         IFNE      'Y'
     C     SACRQ         ANDNE     ' '
     C                   SETON                                        4680
     C                   ADD       1             Z
     C                   MOVE      ' 106'        ERR(Z)
     C                   ELSE
     C     SACRQ         IFEQ      'Y'
     C     ACDS          ANDNE     'Y'
     C     *IN25         IFEQ      '1'
     C                   SETON                                        465681
     C                   END
     C                   END
     C                   END
      *
      ** NO DETAILS REQUESTED
      *  ~~~~~~~~~~~~~~~~~~~~
     C     SXXRQ         IFEQ      '  '
     C                   SETON                                        80
     C                   MOVEA     '111111'      *IN(41)
     C                   ADD       1             Z
     C                   MOVE      ' 110'        ERR(Z)
     C                   ENDIF
      *
     C     INT003        TAG
     C/SPACE 2
      *
      ** VALID SCREEN : PROCEED TO DISPLAY DETAIL SCREEN(S)
      ** ELSE INVALID SCREEN : DISPLAY ERRORS
      *
     C     *IN80         IFEQ      '0'
     C     *IN81         ANDEQ     '0'
     C     *IN50         ANDEQ     '0'
     C                   MOVE      '1'           *IN21
     C                   MOVE      SXXRQ         CXXRQ
     C                   ELSE
     C                   MOVEA     ERR           ERCD
     C                   END
      *
     C                   ENDSR
     C********************************************************************
** MSG  - ERROR MESSAGES ARRAY
ENTER A LIVE USER
THIS USER DOES NOT EXIST - ENQUIRE IS NOT ALLOWED
USER BEING MAINTAINED BY ANOTHER WORKSTATION
