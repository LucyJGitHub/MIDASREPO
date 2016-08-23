     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Copy GLACBTPD to REACBMPP')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE003860 - Copy GLACBTPD to REACBMPP                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. CRE083BH *CREATE   Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE083BH - COB Restructure - RE COB Optimisation Phase 1     *
      *                                                               *
      *****************************************************************
      /EJECT
     FGLACBTPD  IP   E             DISK    INFSR( *PSSR )
     FREACBMPP  O    F   41        DISK    INFSR( *PSSR )
      *
      ** Constants and Variables
      *
     D True            C                   Const( *ON )
     D PSSRDone        S              1N   Inz
     D Error           S              1A
      *
      ** Local Data Area for Error Log
      *
     D LDA             DS           256    Inz DTAARA( LDA )
     D  DBFILE               134    141A
     D  DBKEY                142    170A
     D  DBPGM                171    180A
     D  DBASE                181    183S 0
      *
     D WLDA            DS                  Inz LIKEDS( LDA )
      *
      ** Primary File
      *
     IGLACBLF       01
      /EJECT
      *****************************************************************
      *                                                               *
      *  Initial Subroutine                                           *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    ERROR
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR Error Subprocedure                                     *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        NOT PSSRDone
     C                   EVAL      Error = 'Y'
     C                   EVAL      *INU7 = True
     C                   EVAL      *INU8 = True
     C                   EVAL      *INLR = True
      *
     C     *LOCK         IN        LDA
      *
     C                   EVAL      DBASE = 1
     C                   EVAL      DBFILE = 'QRNXMSG'
     C                   EVAL      DBKEY = %CHAR(%STATUS)
     C                   EVAL      DBPGM = 'RE003860'
      *
     C                   OUT       LDA
     C                   DUMP(A)
     C                   EVAL      PSSRDone = True
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  MAIN PROCESSING                                              *
      *                                                               *
      *****************************************************************
      *
     OREACBMPP  D    01
     O                       RECI                 1
     O                       CNUM                 7
     O                       CCY                 10
     O                       ACOD                20
     O                       ACSQ                22
     O                       BRCA                25
     O                       LDBL                33P
     O                       CLBL                41P
      /EJECT
      *****************************************************************
