     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Allocate transaction reference')              *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEALLO - LE Allocate transaction reference                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. CLE148   *CREATE   Date 23Jul12               *
      *  Prev Amend No. xxxxxx             Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE148 - Alpha Loan Reference                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** | F-specs                              |
      ** | =======                              |
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** | D-specs                              |
      ** | =======                              |
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** | Named constants                      |
      ** | ===============                      |
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** | Arrays and Data Structures           |
      ** | ==========================           |
      ** +--------------------------------------+
 
      ** Array Reference
     D ArRef           S              1    DIM(8)
 
      ** Array Value
     D ArVal           S              1    DIM(36) CTDATA PERRCD(36)
 
      ** Data Area LEALLO
     D LEALLO        E DS                  EXTNAME(LEALLO) DTAARA(LEALLO)
 
      ** +--------------------------------------+
      ** | Declared variables                   |
      ** | ==================                   |
      ** +--------------------------------------+
 
      ** Entry parameter
     D PRtnCde         S              7A
     D PUpdate         S              1A
     D PLstRef         S                   LIKE(PCLAST)
     D PNxtRef         S                   LIKE(PCLAST)
 
      ** Working variables
     D @RUN            S              1
     D Ix              S              2P 0
     D Jx              S              2P 0
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** |                                                                |
      ** | Initial processing is performed automatically: the *INZSR is   |
      ** | executed at program activation.                                |
      ** |                                                                |
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C     *LOCK         IN        LEALLO
 
     C                   IF        PLstRef <> *BLANK
     C                   MOVEA     PLstRef       ArRef
 
     C                   ELSE
     C                   MOVEA     PCLAST        ArRef
     C                   ENDIF
 
     C                   FOR       Jx = 8 DOWNTO 1
 
     C                   IF        ArRef(Jx) <> '9'
     C                   EVAL      Ix = 1
     C     ArRef(Jx)     LOOKUP    ArVal(Ix)                              20
     C                   IF        *IN20 = *ON
     C                   EVAL      ArRef(Jx) = ArVal(Ix + 1)
     C                   LEAVE
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      ArRef(Jx) = 'A'
     C                   ENDIF
 
     C                   ENDFOR
 
     C                   MOVEA     ArRef         PNxtRef
 
     C                   IF        Jx < 1 and PNxtRef = 'AAAAAAAA'
     C                   EVAL      PRtnCde = '*MAX'
     C                   ENDIF
 
     C                   IF        PUpdate = 'Y'
     C                   MOVE      PNxtRef       PCLAST
     C                   OUT       LEALLO
     C                   ENDIF
 
     C                   MOVE      *ON           *INLR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PRtnCde
     C                   PARM                    PUpdate
     C                   PARM                    PLstRef
     C                   PARM                    PNxtRef
 
     C                   EVAL      PRtnCde = *BLANKS
     C                   EVAL      PNxtRef = *BLANKS
 
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
**  Array ArVal
ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
