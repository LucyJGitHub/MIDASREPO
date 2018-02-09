     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas TI COB Events generation for TI postings MOD')
     F*****************************************************************
     F*                                                               *
     F*  Midas/TI Interface                                           *
     F*                                                               *
     F*  TI0360M - COB Events Generation for TI Postings with value   *
     F*           date after the next business day                    *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CGL029             Date 01Sep03               *
      *                 212558             Date 30Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 193207             Date 14Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 164782             Date 14Dec99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CTI001    Create   Date 26Aug97               *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  212558 - Recompile over changed file TIPOSTL6.               *
      *  193207 - Credit events should be Outgoing and Debit events   *
      *           should be Incoming. Also move the transaction       *
      *           reference to LCNO.                                  *
     F*  164782 - Create events with Incoming/Outgoing indicator      *
     F*           set correctly.                                      *
     F*  CTI001 - Midas/TI Interface (Phase 1)                        *
     F*                                                               *
     F*****************************************************************
     F*
     FTIPOSTL6  IF   E           K DISK
     F                                     RENAME(TIPOSTD0:@TIPSTL6)
     FBVNTXEA   O  A E             DISK
     FBVNTXED   O  A E             DISK
     FBVNTXEZ   O  A E             DISK
     F*
     D********************************************************************
     D*  DATA STRUCTURE FOR COMPILATION  - COPYRIGHT INSERTION
     D CPYR@#          DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              COPYRIGHT STATEME
     D*
     D TIREF@          DS
     D  TIDLTP                 1      3
     D  TIDLRF                 4     16
     D  ##TISQ                17     19
     D  TIEVRF                20     36                                                       193207
     D  W#EVRF                25     30                                                       193207
     D*
     D LDA           E DS                  EXTNAME(LDA)
     D* Local Data Area to identify database errors
     D*
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D* Bank Details
     D*
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D* Branch Details
     D*
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D* Long data structure
     D*
     D ##ACOD          S             10A                                                      CGL029
     D ##CH06          S             12A                                                      CGL029
                                                                                              CGL029
      /EJECT
     D********************************************************************
     C*
     C*     Program initialisation
     C*
     C     FSTCAL        IFEQ      ' '
     C                   EXSR      INITSR
     C                   ENDIF
     C*
     C*     Transaction processing
     C*
     C     *LOVAL        SETLL     @TIPSTL6
     C                   READ      @TIPSTL6                               10
     C*
     C     *IN10         DOWEQ     '0'
     C*
     C     MTIVD         IFGE      BJDNWD
     C                   EXSR      DETEVT
     C                   ADD       1             COUNT
     C                   ADD       TIAMNT        W0AMNT
     C                   CLEAR                   TIREF@
     C                   ENDIF
     C*
     C                   READ      @TIPSTL6                               10
     C                   ENDDO
     C*
     C                   EXSR      HDREVT
     C                   EXSR      TRLEVT
     C*
     C                   SETON                                        LR
     C                   RETURN
     C********************************************************************
     C*
     C********************************************************************
     C*     Subroutine:   DETEVT                                         *
     C******Map*the*fields*from*TIPOSTL0*to*BVNTXED                      *                    212558
     C*     Map the fields from TIPOSTL6 to BVNTXED                      *                    212558
     C*                                                                  *
     C********************************************************************
     C*
     C     DETEVT        BEGSR
     C*
     C* Access SDBRCHPD for the Company Code
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       W0RTCD
     C                   PARM      '*KEY    '    W0OPTN
     C                   PARM      BRCA          W0BRCH            3
     C     SDBRCH        PARM      SDBRCH        DSSDY
     C*
     C** Database error
     C     W0RTCD        IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVE      'TI0360'      DBPGM
     C                   MOVEL(P)  'AOBRCHR0'    DBFILE
     C                   MOVEL(P)  BRCA          DBKEY                          ************
     C                   Z-ADD     02            DBASE                          *DB ERROR 02
     C                   EXSR      ERRSR                                        ************
     C                   END
     C*
     C                   MOVE      'B'           RECI
     C                   MOVE      W#EVRF        LCNO                                         193207
     C                   MOVE      '84V1'        ETYP
     C                   Z-ADD     MTIVD         EDAT
     C                   Z-ADD     TIAMNT        EAMT
     C                   MOVE      CCY           ECCY
     C*
     C     NONB          IFNE      0
     C                   Z-ADD     1             SETP
     C                   MOVE      NONB          OSAC1
     C                   MOVE      *BLANK        OSAC2
     C                   ELSE
     C                   Z-ADD     5             SETP
     C                   MOVEL     CNUM          OSAC1
     C                   MOVE      CNUM          ##CNUM            6
     C**********         MOVE      ACOD          ##ACOD            4                          CGL029
     C                   MOVE      ACOD          ##ACOD                                       CGL029
     C                   MOVE      ACSQ          ##ACSQ            2
     C                   SUBST     ##CNUM:3      OSAC2
     C*****##ACOD        CAT       ##ACSQ        ##CH06            6                          CGL029
     C     ##ACOD        CAT       ##ACSQ        ##CH06                                       CGL029
     C                   MOVE      ##CH06        OSAC2
     C                   ENDIF
     C*
     C*****TIPRIN        IFEQ      'R'                                                       164782
     C*****TIDCIN        IFEQ      'C'                                                 164782 193207
     C     TIDCIN        IFEQ      'D'                                                        193207
     C                   MOVE      'I'           INOI
     C                   ELSE
     C                   MOVE      'O'           INOI
     C                   ENDIF
     C                   MOVE      BRCA          OSBR
     C*
     C                   MOVE      TISEQN        ##TISQ
     C                   MOVEL     TIREF@        TIRF
     C*
     C                   MOVE      A8CMCD        TICM
     C*
     C                   WRITE     BVNTXEDF
     C*
     C                   ENDSR
     C********************************************************************
     C*
     C********************************************************************
     C*     Subroutine:   TRLEVT                                         *
     C*     Update trailer file BVNTXEZ                                  *
     C*                                                                  *
     C********************************************************************
     C     TRLEVT        BEGSR
     C*
     C                   MOVE      'T'           RECI
     C                   Z-ADD     COUNT         NORE
     C*
     C     W0AMNT        DIV       1000          Amount           15 3
     C*
     C                   CALLB     'ZZADD'
     C                   PARM                    Amount
     C                   PARM      *ZERO         IntPart          15 0
     C                   PARM      *ZERO         DecPart           3 0
     C*
     C                   Z-ADD     IntPart       HRWN
     C                   Z-ADD     DecPart       HRDC
     C*
     C                   WRITE     BVNTXEZF
     C*
     C                   ENDSR
     C********************************************************************
     C*
     C********************************************************************
     C*     Subroutine:   HDREVT                                         *
     C*     Update header file BVNTXEA                                   *
     C*                                                                  *
     C********************************************************************
     C     HDREVT        BEGSR
     C*
     C                   MOVE      'A'           RECI
     C                   Z-ADD     BJRDNB        EVCD
     C*
     C                   WRITE     BVNTXEAF
     C*
     C                   ENDSR
     C********************************************************************
     C*
     C********************************************************************
     C*     INITSR SR     SUB-ROUTINE                                    *
     C*     Program initialisation                                       *
     C*                                                                  *
     C********************************************************************
     C*
     C     INITSR        BEGSR
     C*
     C                   MOVE      'N'           FSTCAL            1
     C*
     C                   MOVEA     CPY@          BIS@             80
     C*
     C* Set the work fields
     C                   Z-ADD     0             COUNT             5 0
     C                   Z-ADD     0             W0AMNT           15 0
     C*
     C* Define LDA
     C     *DTAARA       DEFINE                  LDA
     C*
     C* Access bank details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       W0RTCD            7
     C                   PARM      '*FIRST  '    W0OPTN            7
     C     SDBANK        PARM      SDBANK        DSSDY
     C*
     C** Database error
     C     W0RTCD        IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVE      'TI0360'      DBPGM
     C                   MOVEL(P)  'AOBANKR0'    DBFILE
     C                   MOVEL(P)  '*CALL'       DBKEY                          ************
     C                   Z-ADD     01            DBASE                          *DB ERROR 01
     C                   EXSR      ERRSR                                        ************
     C                   END
     C*
     C                   ENDSR
     C********************************************************************
     C*
     C********************************************************************
     C*     ERRSR  SR     SUB-ROUTINE                                    *
     C*     Error routine                                                *
     C*                                                                  *
     C********************************************************************
     C*
     C     ERRSR         BEGSR
     C*
     C                   OUT       LDA
     C                   ROLBK
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   RETURN
     C*
     C                   ENDSR
     C*
     C********************************************************************
**CTDATA CPY@
(c) Finastra International Limited 2001
