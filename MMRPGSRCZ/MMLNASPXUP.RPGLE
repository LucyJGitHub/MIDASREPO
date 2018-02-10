     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 1988, 1996')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM NA''s Purchased BoE Extra Data Update')       *
      *****************************************************************
      *                                                               *
      *  Midas - MM Dealer Module                                     *
      *                                                               *
      *  MMLNASPXUP - NAS PURCHASED MM EXTRA DATA UPDATE              *
      *                                                               *
      *  (c) Finastra International Limited 2000                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. LLN022             Date 24Jan05               *
      *                 LLN016             Date 09May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  LLN022 - BOE Upgrade to MidasPlus                            *
      *  LLN016 - Upgrade BoE to DBAR3                                *
      *                                                               *
      *****************************************************************
     FMMDEAULL  UF A E           K DISK
     F                                     COMMIT
     FBYNASPX0  UF A E             DISK
     FMMVNPEXPD IF   E             DISK
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
 
      ** DEFINE FIELDS FOR ZDATE9
     D @DAYN           S              5P 0
     D @YMD            S              8S 0
     D @RETN           S              1A
 
 
      * DATA STRUCTURES FOR USE WITH ACCESS PROGRAMS
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * DATA STRUCTURE FOR BANK DETAILS
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      * DATA STRUCTURE FOR DEAL DATA CODES
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      * DATA STRUCTURE FOR MODULE DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
      * RUN DATE & MULTI-BRANCHING INDICATOR
 
     D RUNDAT          DS
     D  @DLUP                  1      2  0
     D  @MLUP                  3      5
     D  @YLUP                  6      7  0
     D  @MBIN                 13     13
 
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
 
      ** Key for chain to BYNASPX0
     D ULBYKEY         S              6S 0
 
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************
      *
      ** INITIALIZE WORK FIELDS
      *
      * DO INSERT, AMEND, AUTHORIZE OR DELETE PROCESSING
      *
     C     ULACTN        CASEQ     'I'           INSERT
     C     ULACTN        CASEQ     'A'           AMEND
     C                   END
      *
      * EXIT FROM PROGRAM
     C     EXIT          TAG
      *
     C                   RETURN
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* INSERT - Negotiable Assets Purchased Inserts                  *
     C*                                                               *
     C*****************************************************************
     C     INSERT        BEGSR
     C*
     C**  SET DEAL FIELDS ON INSERT
     C*
     C* Retrieve Extra data from the valid file and move into extension
     C* file fields.
     C
     C                   MOVE      ULDLNO        ULBYKEY
     C     ULBYKEY       CHAIN     MMVNPEXPD                          89
     C*                  MOVE      LDLNOEXV      LDLNO
     C*                  MOVE      LGTEEEXV      LGTEE
     C*                  MOVE      LQUALEXV      LQUAL
     C*                  MOVE      LFMATEXV      LFMAT
     C                   WRITE     BYNASPD0
     C*
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* AMEND - Negotiable Assets Purchased Amends                    *
     C*                                                               *
     C*****************************************************************
     C     AMEND         BEGSR
     C     ULBYKEY       CHAIN     BYNASPX0                           90                      LLN022
     C*
     C**  SET DEAL FIELDS ON AMEND
     C*
     C* Retrieve Extra data from the valid file and move into extension
     C* file fields.
     C*
     C     ULBYKEY       CHAIN     MMVNPEXPD                          89
     C*                  MOVE      LDLNOEXV      LDLNO
     C*                  MOVE      LGTEEEXV      LGTEE
     C*                  MOVE      LQUALEXV      LQUAL
     C*                  MOVE      LFMATEXV      LFMAT
     C*
     C**  UPDATE RECORD
     C*
     C                   IF        *IN90 = *OFF                                               LLN022
     C                   UPDATE    BYNASPD0
     C                   ENDIF                                                                LLN022
     C*
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** PARAMETERS
      *
     C     *ENTRY        PLIST
     C                   PARM                    ULDLNO            6
     C                   PARM                    ULACTN            1
     C                   PARM                    @@RTCD            7
     C*
     C* Key List for MMVNPEXPD
     C*
     C*
     C** ACCESS BANK DETAILS
     C*
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C*
     C* DATABASE ERROR
     C*
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '900'         DBASE                          * DBERR 900 *
     C                   EXSR      SRERR                                        *************
     C                   END
     C*
     C*  ACCESS DEAL DATA
     C*
     C                   CALLB     'AODEALR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDDEAL        PARM      SDDEAL        DSFDY
     C*
     C* DATABASE ERROR
     C*
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDDEALPD'    DBFILE                         *************
     C                   MOVEL     '901'         DBASE                          * DBERR 901 *
     C                   EXSR      SRERR                                        *************
     C                   END
     C*
     C** ACCESS MIDAS MODULE DETAILS
     C*
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
     C*
     C* DATABASE ERROR
     C*
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   MOVEL     '902'         DBASE                          * DBERR 902 *
     C                   EXSR      SRERR                                        *************
     C                   END
     C*
     C**  READ DTAARA/RUNDAT to access MULTI-BRANCHING flag.
     C*
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C*
     C                   ENDSR
      *****************************************************************
      /EJECT
     C*****************************************************
     C*                                                   *
     C* SRERR - EXCEPTION ERRORS                          *
     C*                                                   *
     C*****************************************************
     C     SRERR         BEGSR
     C*
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   MOVEL     'MMNASPUPM'   DBPGM            10
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
     C*
     C**  TERMINATE THE PROGRAM
     C*
     C                   RETURN
     C*
     C                   ENDSR
     C*****************************************************
     C/EJECT
**  CPY@
(c) Finastra International Limited 2000
