     H DEBUG
     H OPTION(*NOUNREF)
     H COPYRIGHT('(c) Finastra International Limited 2023')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Background Update of GL Files-MEMOS')         *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger                                       *
      *                                                               *
      *  GL007003 - Background Update of General Ledger Files (MEMOS) *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. MD060909  *CREATE  Date 14Feb23               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD060909 - After COB job FTC0630 go in MSGW.                 *
      *                                                               *
      *****************************************************************

     FGLMEJSTD  UF A E             DISK    COMMIT
     FGLOLPST2  UF A E           K DISK    COMMIT RENAME(GLOLPST2:GLOLPST )
     FGLPRONT2  UF A E           K DISK    COMMIT RENAME(GLPRONT2:GLPRONT )

      *****************************************************************

      ** Entry Parameters
      **=================

      ** Storage for data returned from RCVJRNE with RJNE0200 format

     D*** pRcvVar         DS                  LIKEDS( tpRcvVar )
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
     D  EntAvl                        1A
     D  EntPas                        1A

      ** Main Procedure Declarations
      ** ===========================

      ** Program Error Info
     D LDA           E DS                  EXTNAME( LDA )

      ** Standard Variables
     D True            C                   CONST( *ON )
     D False           C                   CONST( *OFF )
     D PSSRDone        S               N   INZ( False )

      ** Variables for update programs

     D pRtnCode        S              7A   INZ
     D FileUpdated     S               N   INZ
     D CommitCtr       S             10U 0 INZ
     D TransCounter    S                   INZ LIKE( CommitCtr )

     D WRETCD          S              7A
     D SVALK           S             20A   INZ DIM( 10 )
     D SVAL            S            200A   INZ DIM( 10 )

     D OLPOSDS         DS                  INZ LIKEREC( GLOLPST  )
     D PRONODS         DS                  INZ LIKEREC( GLPRONT  )

      ** Receiver Info Storage
     D RcvInf          DS                  INZ LIKEDS( t_RcvInf )

      ** Journal Code Types
     D JrnRcvOp        C                   CONST( 'J' )
     D UserGenerated   C                   CONST( 'U' )
     D RecordEvent     C                   CONST( 'R' )

      ** Journal Entry Types
     D JrnRcvChanged   C                   CONST( 'NR' )
     D OLFlag          C                   CONST( 'OL' )
     D DeleteRollBack  C                   CONST( 'DR' )
     D PTInsert        C                   CONST( 'PT' )
     D PXInsert        C                   CONST( 'PX' )

      ** RCVJRNE passed information values
     D NoEnt           C                   CONST( '0' )
     D SngEnt          C                   CONST( '1' )
     D BlkEnt          C                   CONST( '2' )
     D RcvChgEnd       C                   CONST( '3' )
     D BegBlkMod       C                   CONST( '8' )
     D EndRcvJrnE      C                   CONST( '9' )

      *---------------------------------------------------------------*

      ** Templates (declaration references)
      ** prefixed with 'tp'
      ** ==================================

      ** For RCVJRNE
      /COPY UTCPYSRC,UTRJNE0200

      *---------------------------------------------------------------*

      ** Procedures and Functions
      ** ========================

      ** UpdOLPOS Procedure

     D UpdOLPOS        PR                  EXTPGM('AOOLPSU1')
     D  pRtnCode                           LIKE( pRtnCode )
     D  pOLPOSDS                           LIKEDS( OLPOSDS )

      ** UpdPRONO Procedure

     D UpdPRONO        PR                  EXTPGM('AOPRONU1')
     D  pRtnCode                           LIKE( pRtnCode )
     D  pPRONODS                           LIKEDS( PRONODS )

      ** UpdMEJSTD Procedure

     D UpdMEJSTD       PR
     D  pMEJRCV                            CONST LIKE( MEJRCV )
     D  pMEJSEQ                            CONST LIKE( MEJSEQ )

      ** System Values Procedure

     D GetSysVal       PR                  EXTPGM('AOSVALR0')
     D  pRtnCode                           LIKE( WRETCD )
     D  pSvalK1                            LIKE( SVALK )
     D  pSval1                             LIKE( SVAL )
     D  pSvalK2                            LIKE( SVALK )
     D  pSval2                             LIKE( SVAL )
     D  pSvalK3                            LIKE( SVALK )
     D  pSval3                             LIKE( SVAL )
     D  pSvalK4                            LIKE( SVALK )
     D  pSval4                             LIKE( SVAL )
     D  pSvalK5                            LIKE( SVALK )
     D  pSval5                             LIKE( SVAL )
     D  pSvalK6                            LIKE( SVALK )
     D  pSval6                             LIKE( SVAL )
     D  pSvalK7                            LIKE( SVALK )
     D  pSval7                             LIKE( SVAL )
     D  pSvalK8                            LIKE( SVALK )
     D  pSval8                             LIKE( SVAL )
     D  pSvalK9                            LIKE( SVALK )
     D  pSval9                             LIKE( SVAL )
     D  pSvalK10                           LIKE( SVALK )
     D  pSval10                            LIKE( SVAL )

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
     C                   IF        EntDtaHdr.JOENTT = OLFlag
     C                             AND %SUBST( EntDta.JOESD : 1 : 3 ) = 'END'
     C                   EXSR      EndBgUpd
     C                   ENDIF

      ** 'PT', 'PX' or 'DR' event is received

     C                   WHEN      EntDtaHdr.JOCODE = RecordEvent
     C                   IF           EntDtaHdr.JOENTT = PTInsert
     C                             OR EntDtaHdr.JOENTT = PXInsert
     C                             OR EntDtaHdr.JOENTT = DeleteRollBack
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

     C     KOLPS         KLIST
     C                   KFLD                    OLPOSDS.OLKEY
     C                   KFLD                    OLPOSDS.OLVDAT
     C                   KFLD                    OLPOSDS.OLAMT
     C                   KFLD                    OLPOSDS.OLIO

     C     KPRON         KLIST
     C                   KFLD                    PRONODS.PRKEY
     C                   KFLD                    PRONODS.PRVDAT
     C                   KFLD                    PRONODS.PRAMT

     C                   EVAL      TransCounter = 0


      ** Check System Value: MaxTranstoCommit to get the maximum
      ** number of transactions when the program issues a
      ** COMMIT statement

     C                   EVAL      SVALK( 1 ) = 'MaxTranstoCommit'

      ** Call Access object

     C                   CALLP     GetSysVal( WRETCD
     C                                      : SVALK( 1 )
     C                                      : SVAL( 1 )
     C                                      : SVALK( 2 )
     C                                      : SVAL( 2 )
     C                                      : SVALK( 3 )
     C                                      : SVAL( 3 )
     C                                      : SVALK( 4 )
     C                                      : SVAL( 4 )
     C                                      : SVALK( 5 )
     C                                      : SVAL( 5 )
     C                                      : SVALK( 6 )
     C                                      : SVAL( 6 )
     C                                      : SVALK( 7 )
     C                                      : SVAL( 7 )
     C                                      : SVALK( 8 )
     C                                      : SVAL( 8 )
     C                                      : SVALK( 9 )
     C                                      : SVAL( 9 )
     C                                      : SVALK( 10 )
     C                                      : SVAL( 10 ) )


     C                   IF        WRETCD <> *BLANKS
     C                   EVAL      DBASE = 1
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBKEY =  SVALK( 1 )
     C                   EVAL      DBPGM = 'GL007001'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      CommitCtr = %DEC( SVAL( 1 ) : 10 : 0 )
     C

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
     C                   EVAL      DBPGM = 'GL007001'
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

     C                   WHEN      EntDtaHdr.JOOBJ = 'GLMEMOTD'
     C                   EVAL      OLPOSDS = %SUBST( EntDta.JOESD
     C                                             : 1 : EntDta.JOENTL )
     C                   EXSR      OLPSPGM

     C                   WHEN      EntDtaHdr.JOOBJ = 'GLPRONTD'
     C                   EVAL      PRONODS = %SUBST( EntDta.JOESD
     C                                             : 1 : EntDta.JOENTL )
     C                   EXSR      PRONPGM

     C                   ENDSL

     C                   IF        FileUpdated

     C                   EVAL      TransCounter += 1

     C                   IF        TransCounter >= CommitCtr
     C                   CALLP(E)  UpdMEJSTD( RcvInf.JORCV
     C                                      : %CHAR( EntDtaHdr.JOSEQ )       )
     C                   IF        %ERROR
     C                   EVAL      DBASE = 3
     C                   EVAL      DBFILE = '*CALL'
     C                   EVAL      DBKEY = 'UpdMEJSTD'
     C                   EVAL      DBPGM = 'GL007003'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   COMMIT
     C                   EVAL      TransCounter = 0
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *************************************************************
      /EJECT
      *************************************************************
      * OLPSPGM - Prepare call to OLPOS update program            *
      *************************************************************
     C     OLPSPGM       BEGSR

     C                   IF        EntDtaHdr.JOENTT = DeleteRollBack
     C                   EVAL      OLPOSDS.OLAMT = -( OLPOSDS.OLAMT )
     C                   ENDIF

     C                   CALLP     UpdOLPOS( pRtnCode : OLPOSDS )

     C                   IF        pRtnCode = *BLANKS
     C                   EVAL      OLKEY  = OLPOSDS.OLKEY                                   MD031500
     C                   EVAL      OLVDAT = OLPOSDS.OLVDAT                                  MD031500
     C                   EVAL      OLAMT  = OLPOSDS.OLAMT                                   MD031500
     C                   EVAL      OLIO   = OLPOSDS.OLIO                                    MD031500
     C                   TIME                    OLTMST                                     MD031500
     C                   EVAL      OLPROC = 'Y'
     C                   WRITE     GLOLPST                                                  MD031500
     C                   EVAL      FileUpdated = True

     C                   ELSE
     C                   EVAL      DBASE = 4
     C                   EVAL      DBFILE = '*CALL'
     C                   EVAL      DBKEY = 'AOMEMSU1'
     C                   EVAL      DBPGM = 'GL007003'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *************************************************************
      /EJECT
      *************************************************************
      * PRONPGM - Prepare call to PRONO update program            *
      *************************************************************
     C     PRONPGM       BEGSR

     C                   IF        EntDtaHdr.JOENTT = DeleteRollBack
     C                   EVAL      PRONODS.PRAMT = -( PRONODS.PRAMT )
     C                   ENDIF

     C                   CALLP     UpdPRONO( pRtnCode : PRONODS )

     C                   IF        pRtnCode = *BLANKS
     C                   EVAL      PRKEY  = PRONODS.PRKEY                                   MD031500
     C                   EVAL      PRVDAT = PRONODS.PRVDAT                                  MD031500
     C                   EVAL      PRAMT  = PRONODS.PRAMT                                   MD031500
     C                   TIME                    PRTMST                                     MD031500
     C                   EVAL      PRPROC = 'Y'
     C                   WRITE     GLPRONT                                                  MD031500
     C                   EVAL      FileUpdated = True

     C                   ELSE
     C                   EVAL      DBASE = 5
     C                   EVAL      DBFILE = '*CALL'
     C                   EVAL      DBKEY = 'AOPRONU1'
     C                   EVAL      DBPGM = 'GL007001'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *************************************************************
      /EJECT
      *************************************************************
      * RcvChg - Next receiver change checkpoint                  *
      *************************************************************
     C     RcvChg        BEGSR

     C                   CALLP(E)  UpdMEJSTD( %SUBST( EntDta.JOESD : 1 : 10 )
     C                                      : %CHAR( EntDtaHdr.JOSEQ + 1 )   )
     C                   IF        %ERROR
     C                   EVAL      DBASE = 6
     C                   EVAL      DBFILE = '*CALL'
     C                   EVAL      DBKEY = 'UpdMEJSTD'
     C                   EVAL      DBPGM = 'GL007003'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      pInfo.Control = EndRcvJrne
     C                   EVAL      *INU6 = *ON
     C                   EVAL      *INLR = *ON

     C                   COMMIT
     C                   EVAL      TransCounter = 0

     C                   ENDSR
      *************************************************************
      /EJECT
      *************************************************************
      * EndBgUpd - Ends background updates                        *
      *************************************************************
     C     EndBgUpd      BEGSR

     C                   EVAL      pInfo.Control = EndRcvJrne

     C                   CALLP(E)  UpdMEJSTD( RcvInf.JORCV
     C                                      : %CHAR( EntDtaHdr.JOSEQ ))
     C                   IF        %ERROR
     C                   EVAL      DBASE = 7
     C                   EVAL      DBFILE = '*CALL'
     C                   EVAL      DBKEY = 'UpdMEJSTD'
     C                   EVAL      DBPGM = 'GL007003'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   COMMIT
     C                   EVAL      TransCounter = 0

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
      * UpdMEJSTD - Update OLJSPD with the values passed and from     *
      *             the update flag                                   *
      *---------------------------------------------------------------*
      *   pMEJRCV - inp; value of MEJRCV                              *
      *   pMEJSEQ - inp; value of MEJSEQ                              *
      *   pUpdate - inp; flag if OLJSPD is to be updated              *
      *                                                               *
      *****************************************************************

     P UpdMEJSTD       B
     D                 PI
     D  pMEJRCV                            CONST LIKE( MEJRCV )
     D  pMEJSEQ                            CONST LIKE( MEJSEQ )

     C     1             CHAIN     GLMEJSTD

     C                   EVAL      MEJRCV = pMEJRCV
     C                   EVAL      MEJSEQ = pMEJSEQ

     C                   IF        %FOUND( GLMEJSTD )
     C                   UPDATE    GLMEJST0
     C                   ELSE
     C                   WRITE     GLMEJST0
     C                   ENDIF

     P UpdMEJSTD       E
      *************************************************************
