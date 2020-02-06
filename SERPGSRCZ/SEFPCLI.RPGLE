     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SE BSC: Automated Telekurs (send- receive)')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading                                   *
      *                                                               *
      *  SEFPCLI - SE BSC: Automated Telekurs (send- receive)         *
      *            (Previously ICFPCLI in Midas lower release)        *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSE067  *CREATE    Date 25Apr05               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
/*    *  CSE067 - Telekurs Interface Changes                          *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      ** Fichier BSCF du client
     FICFFCLI   CF   E             WORKSTN
     F                                     INFDS(FEEDBK)
 
      ** Selection TDF
     FTDFF63    IF   E             DISK
 
      ** Fichier informations client
     FTDFFCLI1  IF   E             DISK
 
      ** Fichier TRAITE
     FTDFF64    O    E             DISK
 
      ** Fichier TRAITE bulletins
     FTDFF65    O    E             DISK
 
      ** Fichier TRAITE title bulletins
     FTDFF66    O    E             DISK
 
      ** Print error
     FQPRINT    O    F  132        PRINTER
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D/EJECT
 
     D FEEDBK          DS
     D  FMTNM                 38     45
     D  PGMDEV               273    282
     D  MAJMIN               401    404
     D  MAJCOD               401    402
     D  MINCOD               403    404
     D                 DS
     D  JOUR                   1      2  0
     D  MOIS                   3      4  0
     D  AN                     5      6  0
     D  DAT                    1      6  0
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
     C/EJECT
 
      ** Send identification record
 
     C                   Z-ADD     UDAY          JOUR
     C                   Z-ADD     UMONTH        MOIS
     C                   Z-ADD     UYEAR         AN
     C                   Z-ADD     DAT           TPDATT
     C                   TIME                    TPTIME
     C                   READ      TDFFCLI1                               99
     C                   MOVE      TPRES         TPRESI
     C                   MOVEL     CLPASW        TPPAS
     C                   MOVEL     CLABRV        TPIDEN
     C                   MOVEL     CLPASN        TPPASN
     C                   Z-ADD     *ZEROS        TPRC
     C                   Z-ADD     1             ZRCD              5 0
 
      ** Send identification
 
     C                   WRITE     SENDI                                50
     C     MAJCOD        CABGT     '03'          ERROR
 
      ** Receive ACK/NAK on identification record
 
     C     TPRES         IFEQ      *BLANKS
     C     TPRES         OREQ      'CRS'
     C     TPRES         OREQ      'CRSTD'
     C     TPRES         OREQ      'CRSTP'
     C                   MOVE      *ON           *IN01
     C                   ENDIF
 
     C     TPRES         IFEQ      'TD'
     C     TPRES         OREQ      'CRSTD'
     C     TPRES         OREQ      'TDTP'
     C                   MOVE      *ON           *IN02
     C                   ENDIF
 
     C     TPRES         IFEQ      'TP'
     C     TPRES         OREQ      'CRSTP'
     C     TPRES         OREQ      'TDTP'
     C                   MOVE      *ON           *IN03
     C                   ENDIF
 
      ** Receive response
 
     C                   READ      RECEIVEI                             5099
     C     MAJCOD        CABGT     '03'          ERROR
 
      ** Read until turnaround occurs
 
     C     *IN66         DOUEQ     '1'
     C                   READ      TRNRND                               5099
     C     MAJCOD        CABGT     '03'          ERROR
     C                   ENDDO
 
      ** Deconnexion si error
 
     C     TPRC          IFNE      900
     C                   GOTO      ERROR
     C                   ENDIF
 
      ** Send en-tete file selection
 
     C                   Z-ADD     001           TPRC
     C                   MOVE      CLCDVL        TPTYCV
     C                   Z-ADD     6             NBRR
     C                   WRITE     SEND1S
     C     MAJCOD        CABGT     '03'          ERROR
 
      ** Send FICHIER selection
 
     C     *IN98         DOUEQ     '1'
     C                   READ      TDFF63                                 98
     C     *IN98         IFEQ      '0'
     C                   ADD       1             ZRCD              5 0
     C                   MOVE      TPRCX         TPRC
     C                   WRITE     SENDS                                50
     C     MAJCOD        CABGT     '03'          ERROR
     C                   ENDIF
     C                   ENDDO
     C                   ADD       1             ZRCD              5 0
     C                   Z-ADD     ZRCD          NBRR              5 0
 
      ** Send end record FICHIER selection
 
     C                   Z-ADD     009           TPRC
     C                   MOVE      *BLANKS       TPRES6
     C                   WRITE     SENDE                                50
     C     MAJCOD        CABGT     '03'          ERROR
 
      ** Reception FICHIER traite
 
     C                   Z-ADD     *ZEROS        TPRC
     C     READC         TAG
     C     TPRC          IFEQ      909
     C   11              SETOFF                                       0111
     C   12              SETOFF                                       0212
     C   13              SETOFF                                       0313
     C  N01
     CANN02
     CANN03              EXCEPT    #FIN
     C  N01
     CANN02
     CANN03              SETON                                        LR
     C  N01
     CANN02
     CANN03              RETURN
     C                   ENDIF
 
     C     TPRC          IFEQ      *ZEROS
     C     TPRC          OREQ      909
     C                   READ      RECEIVE                              5099
     C     MAJCOD        CABGT     '03'          ERROR
     C                   MOVEL     ZONE45        TPRC
     C   01TPRC          COMP      901                                    11
     C   02TPRC          COMP      902                                    12
     C   03TPRC          COMP      903                                    13
     C   11              MOVEL(P)  ZONE45        TOU64
     C   11              WRITE     RTDF64
     C   12              MOVEL(P)  ZONE45        TOU65
     C   12              WRITE     RTDF65
     C   13              MOVEL(P)  ZONE45        TOU66
     C   13              WRITE     RTDF66
     C                   ENDIF
 
     C   11              READ      RECEIVE                              5099
     C   12              READ      RECEIVB                              5099
     C   13              READ      RECEIVT                              5099
     C     MAJCOD        CABGT     '03'          ERROR
 
     C                   MOVEL     ZONE45        TPRC
     C   11              MOVEL(P)  ZONE45        TOU64
     C   11              WRITE     RTDF64
     C   12              MOVEL(P)  ZON210        TOU65
     C   12              WRITE     RTDF65
     C   13              MOVEL(P)  ZON198        TOU66
     C   13              WRITE     RTDF66
     C                   GOTO      READC
 
     C     ERROR         TAG
     C                   EXCEPT    #ERR
     C                   SETON                                        LR
 
      ** +--------------------------------------+
      ** ¦ O-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     O/EJECT
 
     OQPRINT    E            #ERR
     O                                           20 'MAJOR/MINOR: '
     O                       MAJCOD              24
     O                                           25 '/'
     O                       MINCOD              28
     O                                           38 'FORMAT : '
     O                       FMTNM               50
     O                                           60 'TYPE REC.'
     O                       TPRC                70
     O          E            #FIN
     O                                           30 'FIN TRANSMISSION'
