     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *************************************************************************
/*STD *  RPGBASEMOD                                                           *
/*EXI *  TEXT('Midas GL Background Update of ABC Files')              *
      *************************************************************************
      *                                                                       *
      *  Midas - General Ledger Module                                        *
      *                                                                       *
      *  GL007011 - Background update of ABC Files                            *
      *                                                                       *
      *  (c) Finastra International Limited 2018                              *
      *                                                                       *
      *  Last Amend No. MD022132 *CREATE   Date 09Mar18                       *
      *                                                                       *
      *-----------------------------------------------------------------------*
      *                                                                       *
      *  MD022132 - Triggers don't pick up Rollback deletes of ABC files.     *
      *           - Applied for MD-35969.                                     *
      *                                                                       *
      *************************************************************************

     FGLABJSTD  UF A E             DISK    COMMIT
      ** Midas GL ABC Last Journal Entry Processed

     FGLACNTL4  IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Account Master Extension

     FHELDIHB   IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Account Movements

     FACCNTAB   IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Account Movements

     FGLCOLLPD  IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Account Movements

     FRSACMTPD  IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Shadow Postings

      *****************************************************************

      ** Entry Parameters
      **=================

      ** Storage for data returned from RCVJRNE with RJNE0200 format

     D pRcvVar         DS                  LIKEDS( t_RcvVar )

     D EntDtaHdr       DS                  BASED( ptrEntDtaHdr )
     D                                     LIKEDS( t_EntDtaHdr )

     D EntDta          DS                  BASED( ptrEntDta )
     D                                     LIKEDS( t_EntDta )

      ** Receiver information

     D FRcvInf         DS                  BASED( ptrRcvInf )
     D                                     LIKEDS( t_RcvInf )

     D PInfo           DS                  QUALIFIED
     D  Control                       1A

      ** Main Procedure Declarations
      ** ===========================

      ** Program Error Info
     D LDA           E DS                  EXTNAME( LDA )

      ** Standard Variables
     D True            C                   CONST( *ON )
     D False           C                   CONST( *OFF )
     D PSSRDone        S               N   INZ( False )

      ** Variables for update programs

     D FileUpdated     S               N   INZ

      ** Parameters for access object programs

     D PRtcd           S              7A
     D POptn           S              7A
     D PErrMsg         S             50A
     D PFullChk        S              1A
     D PZone           S             10A
     D PShtc           S              4A
     D PRdnb           S              5P 0
     D PDnwd           S              5P 0
     D PBCcy           S              3A
     D PNJob           S              1P 0

     D ABCData         DS
     D  WEventType             1     20
     D  WTrigEvent            21     21
     D  WDetail               22   4021

     D HELDIDS         DS                  INZ LIKEREC( HELDIHBF )
     D ACCNTDS         DS                  INZ LIKEREC( ACCNTABF )
     D GLCOLDS         DS                  INZ LIKEREC( GLCOLLD0 )
     D RSACMDS         DS                  INZ LIKEREC( RSACMTPO )

      ** Receiver Info Storage
     D RcvInf          DS                  INZ LIKEDS( t_RcvInf )

     D GLACNT        E DS                  EXTNAME(ACCNTAB) PREFIX(AA)
      ** Account details

     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      **  External DS for Branch Details

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS for access programs, long data structure

      ** Journal Code Types
     D JrnRcvOp        C                   CONST( 'J' )
     D UserGenerated   C                   CONST( 'U' )
     D RecordEvent     C                   CONST( 'R' )

      ** Journal Entry Types
     D JrnRcvChanged   C                   CONST( 'NR' )
     D ABFlag          C                   CONST( 'AB' )
     D DeleteRollBack  C                   CONST( 'DR' )
     D BRRollback      C                   CONST( 'BR' )
     D URRollback      C                   CONST( 'UR' )

      ** RCVJRNE passed information values
     D NoEnt           C                   CONST( '0' )
     D EndRcvJrnE      C                   CONST( '9' )

      *---------------------------------------------------------------*

      ** Templates (declaration references)
      ** prefixed with 't_'
      ** ==================================

      *---------------------------------------------------------------*

      ** For RCVJRNE
      /COPY UTCPYSRC,UTRJNE0200

      ** Procedures and Functions
      ** ========================

      ** UpdABJSTD Procedure

     D UpdABJSTD       PR
     D  pABJRCV                            CONST LIKE( ABJRCV )
     D  pABJSEQ                            CONST LIKE( ABJSEQ )

      *---------------------------------------------------------------*

      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCESSING                                               *
      *****************************************************************

     C                   IF        PInfo.Control = NoEnt
     C                   RETURN
     C                   ENDIF

     C                   EXSR      FmtRcvVar

     C                   SELECT

      ** Journal receiver has changed?

     C                   WHEN      EntDtaHdr.JOCODE = JrnRcvOp
     C                   IF        EntDtaHdr.JOENTT = JrnRcvChanged
     C                   EXSR      RcvChg
     C                   ENDIF

      ** User requested a background job end?

     C                   WHEN      EntDtaHdr.JOCODE = UserGenerated
     C                   IF        EntDtaHdr.JOENTT = ABFlag
     C                             AND %SUBST( EntDta.JOESD : 1 : 3 ) = 'END'
     C                   EXSR      EndBgUpd
     C                   ENDIF

      ** 'DR', 'UR' or 'BR' event is received

     C                   WHEN      EntDtaHdr.JOCODE = RecordEvent
     C                   IF           EntDtaHdr.JOENTT = DeleteRollBack
     C                             OR EntDtaHdr.JOENTT = URRollback
     C                             OR EntDtaHdr.JOENTT = BRRollBack
     C                   EXSR      CalUpdPrg
     C                   ENDIF

     C                   ENDSL

     C                   RETURN
      *************************************************************
      /EJECT
      *************************************************************
      *                                                           *
      * *INZSR - Initialisation Routine                           *
      *                                                           *
      *************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    pRcvVar
     C                   PARM                    pInfo

     C     KGLAC         KLIST
     C                   KFLD                    KCNUM             6
     C                   KFLD                    KCCY              3
     C                   KFLD                    KACOD            10 0
     C                   KFLD                    KACSQ             2 0
     C                   KFLD                    KBRCA             3
     C
      ** Read in data area

     C     *DTAARA       DEFINE                  LDA

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  = 'GL007011'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY  = *BLANKS
     C                   EVAL      DBASE  = 0
     C                   OUT       LDA

      **  Access Zone details.

     C                   CALL      'GOGETZONE'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      *BLANKS       PErrMsg
     C                   PARM      'N'           PFullChk
     C                   PARM                    PZone
     C                   PARM                    PShtc
     C                   PARM                    PRdnb
     C                   PARM                    PDnwd
     C                   PARM                    PBCcy
     C                   PARM                    PNJob

     C                   IF        PRtcd <> *BLANK
     C                   MOVEL     'GPZONEPD'    DBFILE
     C                   MOVEL     '004'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *************************************************************
      /EJECT
      *************************************************************
      *                                                           *
      * FmtRcvVar - Format received data from RCVJRNE             *
      *                                                           *
      *************************************************************
     C     FmtRcvVar     BEGSR

     C                   MONITOR

     C                   EVAL      ptrEntDtaHdr = %ADDR( pRcvVar )
     C                                       + pRcvVar.HdrOffset
     C                   EVAL      ptrEntDta = ptrEntDtaHdr
     C                                       + EntDtaHdr.EntDtaOffset

     C                   IF        EntDtaHdr.JRcvOffset > 0
     C                   EVAL      ptrRcvInf = ptrEntDtaHdr
     C                                       + EntDtaHdr.JRcvOffset
     C                   EVAL-CORR RcvInf = FRcvInf
     C                   ENDIF

     C                   ON-ERROR
     C                   EVAL      DBASE = 2
     C                   EVAL      DBFILE = 'EXSR'
     C                   EVAL      DBKEY = 'FMTRcvVar'
     C                   EVAL      DBPGM = 'GL007011'
     C                   EXSR      *PSSR
     C                   ENDMON

     C                   ENDSR
      *************************************************************
      /EJECT
      *************************************************************
      *                                                           *
      * CalUpdPrg - Call Update Program                           *
      *                                                           *
      *************************************************************
     C     CalUpdPrg     BEGSR

     C                   EVAL      FileUpdated = False

     C                   SELECT

     C                   WHEN      EntDtaHdr.JOOBJ = 'HELDIHB'
     C                   EXSR      HELDUPD

     C                   WHEN      EntDtaHdr.JOOBJ = 'ACCNTAB'
     C                   EXSR      ACCTUPD

     C                   WHEN      EntDtaHdr.JOOBJ = 'GLCOLLPD'
     C                   EXSR      COLLUPD

     C                   WHEN      EntDtaHdr.JOOBJ = 'RSACMTPD'
     C                   EXSR      RSACUPD
     C                   ENDSL

     C                   IF        FileUpdated

     C                   CALLP(E)  UpdABJSTD( RcvInf.JORCV
     C                                      : %EDITC( EntDtaHdr.JOSEQ: 'X' ))
     C                   IF        %ERROR
     C                   EVAL      DBASE = 3
     C                   EVAL      DBFILE = '*CALL'
     C                   EVAL      DBKEY = 'UpdABJSTD'
     C                   EVAL      DBPGM = 'GL007011'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   COMMIT

     C                   ENDIF

     C                   ENDSR
      *************************************************************
      /EJECT
      *************************************************************
      * HELDUPD - Update GLACNTL4 for HELDIHB update              *
      *************************************************************
     C     HELDUPD       BEGSR

     C                   EVAL      HELDIDS = %SUBST( EntDta.JOESD
     C                                             : 1 : EntDta.JOENTL )
     C                   EVAL      KCNUM = HELDIDS.CNUM
     C                   EVAL      KCCY = HELDIDS.CCY
     C                   EVAL      KACOD = HELDIDS.ACOD
     C                   EVAL      KACSQ = HELDIDS.ACSQ
     C                   EVAL      KBRCA = HELDIDS.BRCA

     C     KGLAC         CHAIN     GLACNTL4
     C                   IF        %FOUND( GLACNTL4 )

     C                   IF        EntDtaHdr.JOENTT = DeleteRollBack
     C                             OR EntDtaHdr.JOENTT = BRRollBack
     C                   EVAL      WTrigEvent = '3'
     C                   ELSE
     C                   EVAL      WTrigEvent = '1'
     C                   ENDIF

     C                   EVAL      WEventType = 'MNT_HELDIHB'
     C                   EVAL      WDetail = HELDIDS
     C                   CALL      'RE001502'
     C                   PARM                    ABCDATA
     C                   IF        WTrigEvent = '9'
     C                   EVAL      FileUpdated = True
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *************************************************************
      /EJECT
      *************************************************************
      * ACCTUPD - Update GLACNTL4 for ACCNTAB update              *
      *************************************************************
     C     ACCTUPD       BEGSR

     C                   EVAL      ACCNTDS = %SUBST( EntDta.JOESD
     C                                             : 1 : EntDta.JOENTL )
     C                   EVAL      KCNUM = ACCNTDS.CNUM
     C                   EVAL      KCCY = ACCNTDS.CCY
     C                   EVAL      KACOD = ACCNTDS.ACOD
     C                   EVAL      KACSQ = ACCNTDS.ACSQ
     C                   EVAL      KBRCA = ACCNTDS.BRCA

     C     KGLAC         CHAIN     GLACNTL4
     C                   IF        %FOUND( GLACNTL4 )

     C                   IF        EntDtaHdr.JOENTT = DeleteRollBack
     C                             OR EntDtaHdr.JOENTT = BRRollBack
     C                   EVAL      WTrigEvent = '3'
     C                   ELSE
     C                   EVAL      WTrigEvent = '1'
     C                   ENDIF

     C                   EVAL      WEventType = 'MNT_ACCNTAB'
     C                   EVAL      WDetail = ACCNTDS
     C                   CALL      'RE001502'
     C                   PARM                    ABCDATA
     C                   IF        WTrigEvent = '9'
     C                   EVAL      FileUpdated = True
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *************************************************************
      /EJECT
      *************************************************************
      * COLLUPD - Update GLACNTL4 for GLCOLLPD update             *
      *************************************************************
     C     COLLUPD       BEGSR

     C                   EVAL      GLCOLDS = %SUBST( EntDta.JOESD
     C                                             : 1 : EntDta.JOENTL )

     C                   IF        GLCOLDS.CDCCNM = *BLANKS
     C                             AND GLCOLDS.CDCACN <> 0
     C                   MOVEL     GLCOLDS.CDCACNPAcno
     C     PAccntab      PLIST
     C                   PARM      '*BLANKS'     PRtCd             7
     C                   PARM      '*KEY   '     POptn             7
     C                   PARM                    PAcno            10
     C                   PARM      *BLANKS       PCusn             6
     C                   PARM      *BLANKS       PCurr             3
     C                   PARM      *BLANKS       PACod            10
     C                   PARM      *BLANKS       PASeq             2
     C                   PARM      *BLANKS       PBrch             3
     C     GLACNT        PARM      '*BLANKS'     DSSDY
     C                   CALL      'AOACCTR0'    PAccntab
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'AOACCTR0'
     C                   EVAL      DBFILE = 'ACCNTAB'
     C                   EVAL      DBKEY = PAcno
     C                   EVAL      DBASE = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      GLCOLDS.CDCCNM = AACNUM
     C                   EVAL      GLCOLDS.CDCCCY = AACCY
     C                   EVAL      GLCOLDS.CDCACD = AAACOD
     C                   EVAL      GLCOLDS.CDCSEQ = AAACSQ
     C                   EVAL      GLCOLDS.CDCBRC = AABRCA
     C                   ENDIF
     C                   EVAL      KCNUM = GLCOLDS.CDCCNM
     C                   EVAL      KCCY = GLCOLDS.CDCCCY
     C                   EVAL      KACOD = GLCOLDS.CDCACD
     C                   EVAL      KACSQ = GLCOLDS.CDCSEQ
     C                   EVAL      KBRCA = GLCOLDS.CDCBRC

     C     KGLAC         CHAIN     GLACNTL4
     C                   IF        %FOUND( GLACNTL4 )

     C                   IF        EntDtaHdr.JOENTT = DeleteRollBack
     C                             OR EntDtaHdr.JOENTT = BRRollBack
     C                   EVAL      WTrigEvent = '3'
     C                   ELSE
     C                   EVAL      WTrigEvent = '1'
     C                   ENDIF

     C                   EVAL      WEventType = 'MNT_GLCOLLPD'
     C                   EVAL      WDetail = GLCOLDS
     C                   CALL      'RE001502'
     C                   PARM                    ABCDATA
     C                   IF        WTrigEvent = '9'
     C                   EVAL      FileUpdated = True
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *************************************************************
      /EJECT
      *************************************************************
      * RSACUPD - Update GLACNTL4 for RSACMTPD update             *
      *************************************************************
     C     RSACUPD       BEGSR

     C                   EVAL      RSACMDS = %SUBST( EntDta.JOESD
     C                                             : 1 : EntDta.JOENTL )
     C                   EVAL      KCNUM = RSACMDS.CUSN
     C                   EVAL      KCCY = RSACMDS.CCYD
     C                   EVAL      KACOD = RSACMDS.ACDE
     C                   EVAL      KACSQ = RSACMDS.ASNC
     C                   EVAL      KBRCA = RSACMDS.BRCA
      *
     C                   Call      'AOBRCHR1'
     C                   parm      *BLANKS       PRTCD
     C                   parm      '*KEY   '     POPTN
     C                   parm                    KBRCA
     C     SDBRCH        parm      SDBRCH        DSSDY
      *
     C     PRTCD         Ifne      *BLANKS
     C     A8ZONE        Orne      PZone
     C                   Return
     C                   Endif

      ** Update Available Balance in GLACNTQD

     C     KGLAC         CHAIN     GLACNTL4
     C                   IF        %FOUND( GLACNTL4 )

     C                   IF        EntDtaHdr.JOENTT = DeleteRollBack
     C                             OR EntDtaHdr.JOENTT = BRRollBack
     C                   EVAL      WTrigEvent = '3'
     C                   ELSE
     C                   EVAL      WTrigEvent = '1'
     C                   ENDIF

     C                   EVAL      WEventType = 'TRAN_RSACMTPD'
     C                   EVAL      WDetail = RSACMDS
     C                   CALL      'RE001502'
     C                   PARM                    ABCDATA
     C                   IF        WTrigEvent = '9'
     C                   EVAL      FileUpdated = True
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *************************************************************
      /EJECT
      *************************************************************
      * RcvChg - Next receiver change checkpoint                  *
      *************************************************************
     C     RcvChg        BEGSR

     C                   CALLP(E)  UpdABJSTD( %SUBST( EntDta.JOESD : 1 : 10 )
     C                                    : %EDITC( EntDtaHdr.JOSEQ + 1: 'X' ))
     C                   IF        %ERROR
     C                   EVAL      DBASE = 5
     C                   EVAL      DBFILE = '*CALL'
     C                   EVAL      DBKEY = 'UpdABJSTD'
     C                   EVAL      DBPGM = 'GL007011'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      pInfo.Control = EndRcvJrne
     C                   EVAL      *INU6 = *ON
     C                   EVAL      *INLR = *ON

     C                   COMMIT

     C                   ENDSR
      *************************************************************
      /EJECT
      *************************************************************
      * EndBgUpd - Ends background updates                        *
      *************************************************************
     C     EndBgUpd      BEGSR

     C                   EVAL      pInfo.Control = EndRcvJrne

     C                   CALLP(E)  UpdABJSTD( RcvInf.JORCV
     C                                      : %EDITC( EntDtaHdr.JOSEQ: 'X' ))
     C                   IF        %ERROR
     C                   EVAL      DBASE = 6
     C                   EVAL      DBFILE = '*CALL'
     C                   EVAL      DBKEY = 'UpdABJSTD'
     C                   EVAL      DBPGM = 'GL007011'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   COMMIT

     C                   ENDSR
      *************************************************************
      /EJECT
      *************************************************************
      *                                                           *
      * *PSSR - Unhandled exception error routine                 *
      *                                                           *
      *************************************************************
     C     *PSSR         BEGSR

     C                   IF        NOT PSSRDone
     C                   EVAL      PSSRDone = True
     C                   DUMP
     C                   ENDIF

     C                   EVAL      pInfo.Control = EndRcvJrnE
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   RETURN

     C                   ENDSR     '*CANCL'
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UpdABJSTD - Update GLABJSTD with the values passed and from   *
      *             the update flag                                   *
      *---------------------------------------------------------------*
      *   pABJRCV - inp; value of ABJRCV                              *
      *   pABJSEQ - inp; value of ABJSEQ                              *
      *   pUpdate - inp; flag if GLABJSTD is to be updated            *
      *                                                               *
      *****************************************************************

     P UpdABJSTD       B
     D                 PI
     D  pABJRCV                            CONST LIKE( ABJRCV )
     D  pABJSEQ                            CONST LIKE( ABJSEQ )

     C     1             CHAIN     GLABJSTD

     C                   EVAL      ABJRCV = pABJRCV
     C                   EVAL      ABJSEQ = pABJSEQ

     C                   IF        %FOUND( GLABJSTD )
     C                   UPDATE    GLABJST0
     C                   ELSE
     C                   WRITE     GLABJST0
     C                   ENDIF

     P UpdABJSTD       E
      *************************************************************
