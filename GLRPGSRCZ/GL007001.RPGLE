     H DEBUG
     H OPTION(*NOUNREF)
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Background Update of GL Files')               *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger                                       *
      *                                                               *
      *  GL007001 - Background Update of General Ledger Files         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. MD026169B          Date 19Jun14               *
      *  Prev Amend No. MD026169A          Date 24Apr14               *
      *                 MD026169  *REWRITE Date 04Apr14               *
      *                 MD025679B          Date 26Mar14               *
      *                 MD025679A          Date 21Mar14               *
      *                 MD025679  *CREATE  Date 18Mar14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD026169B - Wrong value for receiver in GLOLJSTD             *
      *  MD026169A - Error in Journal Receiver change event           *
      *  MD026169 - GO_ONL_OLP background job is processing           *
      *             full receiver chain                               *
      *  MD025679B - API - PRONO Locking Issue                        *
      *  MD025679A - API - OLPOSOA Locking Issue Performance Update   *
      *  MD025679 - API: OLPOS Locking issue.                         *
      *                                                               *
      *****************************************************************
 
     FGLOLJSTD  UF A E             DISK    COMMIT
     FGLOLPSL0  UF   E           K DISK    COMMIT
     FGLPRONL0  UF   E           K DISK    COMMIT
 
      *****************************************************************
 
      ** Entry Parameters
      **=================
 
      ** Storage for data returned from RCVJRNE with RJNE0200 format
 
     D pRcvVar         DS                  LIKEDS( tpRcvVar )
 
     D EntDtaHdr       DS                  BASED( ptrEntDtaHdr )
     D                                     LIKEDS( tpEntDtaHdr )
 
     D EntDta          DS                  BASED( ptrEntDta )
     D                                     LIKEDS( tpEntDta )
 
      ** Receiver information
 
     D FRcvInf         DS                  BASED( ptrRcvInf )
     D                                     LIKEDS( tpRcvInf )
 
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
     D***TransCounter    S              6S 0 INZ                                           MD026169B
     D***MAX_TR_TO_CMT   S              6S 0 INZ                                           MD026169B
     D CommitCtr       S             10U 0 INZ                                             MD026169B
     D TransCounter    S                   INZ LIKE( CommitCtr )                           MD026169B
 
      ** SDSVALPD Parameters
     D***WRETCD*         S              7                                                  MD026169B
     D***P@OP01*         S             20                                                  MD026169B
     D***P@VL01*         S            200                                                  MD026169B
     D***P@OP02*         S             20                                                  MD026169B
     D***P@VL02*         S            200                                                  MD026169B
     D***P@OP03*         S             20                                                  MD026169B
     D***P@VL03*         S            200                                                  MD026169B
     D***P@OP04*         S             20                                                  MD026169B
     D***P@VL04*         S            200                                                  MD026169B
     D***P@OP05*         S             20                                                  MD026169B
     D***P@VL05*         S            200                                                  MD026169B
     D***P@OP06*         S             20                                                  MD026169B
     D***P@VL06*         S            200                                                  MD026169B
     D***P@OP07*         S             20                                                  MD026169B
     D***P@VL07*         S            200                                                  MD026169B
     D***P@OP08*         S             20                                                  MD026169B
     D***P@VL08*         S            200                                                  MD026169B
     D***P@OP09*         S             20                                                  MD026169B
     D***P@VL09*         S            200                                                  MD026169B
     D***P@OP10*         S             20                                                  MD026169B
     D***P@VL10*         S            200                                                  MD026169B
     D***SET09**         S              1                                                  MD026169B
     D***SVALK1*         S             20                                                  MD026169B
     D***SVAL1**         S            200                                                  MD026169B
     D***SVALK2*         S             20                                                  MD026169B
     D***SVAL2**         S            200                                                  MD026169B
     D***SVALK3*         S             20                                                  MD026169B
     D***SVAL3**         S            200                                                  MD026169B
     D***SVALK4*         S             20                                                  MD026169B
     D***SVAL4**         S            200                                                  MD026169B
     D***SVALK5*         S             20                                                  MD026169B
     D***SVAL5**         S            200                                                  MD026169B
     D***SVALK6*         S             20                                                  MD026169B
     D***SVAL6**         S            200                                                  MD026169B
     D***SVALK7*         S             20                                                  MD026169B
     D***SVAL7**         S            200                                                  MD026169B
     D***SVALK8*         S             20                                                  MD026169B
     D***SVAL8**         S            200                                                  MD026169B
     D***SVALK9*         S             20                                                  MD026169B
     D***SVAL9**         S            200                                                  MD026169B
     D***SVALK0*         S             20                                                  MD026169B
     D***SVAL10*         S            200                                                  MD026169B
     D WRETCD          S              7A                                                   MD026169B
     D SVALK           S             20A   INZ DIM( 10 )                                   MD026169B
     D SVAL            S            200A   INZ DIM( 10 )                                   MD026169B
 
     D OLPOSDS         DS                  INZ LIKEREC( GLOLPST0 )
     D PRONODS         DS                  INZ LIKEREC( GLPRONT0 )
 
      ** Receiver Info Storage
     D RcvInf          DS                  INZ LIKEDS( tpRcvInf )
 
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
 
      ** UpdOLJSTD Procedure
 
     D UpdOLJSTD       PR
     D  pOLJRCV                            CONST LIKE( OLJRCV )
     D  pOLJSEQ                            CONST LIKE( OLJSEQ )
                                                                                           MD026169B
      ** System Values Procedure                                                           MD026169B
                                                                                           MD026169B
     D GetSysVal       PR                  EXTPGM('AOSVALR0')                              MD026169B
     D  pRtnCode                           LIKE( WRETCD )                                  MD026169B
     D  pSvalK1                            LIKE( SVALK )                                   MD026169B
     D  pSval1                             LIKE( SVAL )                                    MD026169B
     D  pSvalK2                            LIKE( SVALK )                                   MD026169B
     D  pSval2                             LIKE( SVAL )                                    MD026169B
     D  pSvalK3                            LIKE( SVALK )                                   MD026169B
     D  pSval3                             LIKE( SVAL )                                    MD026169B
     D  pSvalK4                            LIKE( SVALK )                                   MD026169B
     D  pSval4                             LIKE( SVAL )                                    MD026169B
     D  pSvalK5                            LIKE( SVALK )                                   MD026169B
     D  pSval5                             LIKE( SVAL )                                    MD026169B
     D  pSvalK6                            LIKE( SVALK )                                   MD026169B
     D  pSval6                             LIKE( SVAL )                                    MD026169B
     D  pSvalK7                            LIKE( SVALK )                                   MD026169B
     D  pSval7                             LIKE( SVAL )                                    MD026169B
     D  pSvalK8                            LIKE( SVALK )                                   MD026169B
     D  pSval8                             LIKE( SVAL )                                    MD026169B
     D  pSvalK9                            LIKE( SVALK )                                   MD026169B
     D  pSval9                             LIKE( SVAL )                                    MD026169B
     D  pSvalK10                           LIKE( SVALK )                                   MD026169B
     D  pSval10                            LIKE( SVAL )                                    MD026169B
 
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
 
     C**********         EVAL      SVALK1 = 'MaxTranstoCommit'                             MD026169B
     C                   EVAL      SVALK( 1 ) = 'MaxTranstoCommit'                         MD026169B
 
      ** Call Access object
 
     C**********         CALL      'AOSVALR0'                                              MD026169B
     C**********         PARM                    WRETCD                                    MD026169B
     C**********         PARM                    SVALK1                                    MD026169B
     C**********         PARM                    SVAL1                                     MD026169B
     C**********         PARM                    SVALK2                                    MD026169B
     C**********         PARM                    SVAL2                                     MD026169B
     C**********         PARM                    SVALK3                                    MD026169B
     C**********         PARM                    SVAL3                                     MD026169B
     C**********         PARM                    SVALK4                                    MD026169B
     C**********         PARM                    SVAL4                                     MD026169B
     C**********         PARM                    SVALK5                                    MD026169B
     C**********         PARM                    SVAL5                                     MD026169B
     C**********         PARM                    SVALK6                                    MD026169B
     C**********         PARM                    SVAL6                                     MD026169B
     C**********         PARM                    SVALK7                                    MD026169B
     C**********         PARM                    SVAL7                                     MD026169B
     C**********         PARM                    SVALK8                                    MD026169B
     C**********         PARM                    SVAL8                                     MD026169B
     C**********         PARM                    SVALK9                                    MD026169B
     C**********         PARM                    SVAL9                                     MD026169B
     C**********         PARM                    SVALK0                                    MD026169B
     C**********         PARM                    SVAL10                                    MD026169B
                                                                                           MD026169B
     C                   CALLP     GetSysVal( WRETCD                                       MD026169B
     C                                      : SVALK( 1 )                                   MD026169B
     C                                      : SVAL( 1 )                                    MD026169B
     C                                      : SVALK( 2 )                                   MD026169B
     C                                      : SVAL( 2 )                                    MD026169B
     C                                      : SVALK( 3 )                                   MD026169B
     C                                      : SVAL( 3 )                                    MD026169B
     C                                      : SVALK( 4 )                                   MD026169B
     C                                      : SVAL( 4 )                                    MD026169B
     C                                      : SVALK( 5 )                                   MD026169B
     C                                      : SVAL( 5 )                                    MD026169B
     C                                      : SVALK( 6 )                                   MD026169B
     C                                      : SVAL( 6 )                                    MD026169B
     C                                      : SVALK( 7 )                                   MD026169B
     C                                      : SVAL( 7 )                                    MD026169B
     C                                      : SVALK( 8 )                                   MD026169B
     C                                      : SVAL( 8 )                                    MD026169B
     C                                      : SVALK( 9 )                                   MD026169B
     C                                      : SVAL( 9 )                                    MD026169B
     C                                      : SVALK( 10 )                                  MD026169B
     C                                      : SVAL( 10 ) )                                 MD026169B
 
 
     C     WRETCD        IFNE      *BLANKS
     C                   EVAL      DBASE = 1
     C                   EVAL      DBFILE = 'SDSVALPD'
     C**********         EVAL      DBKEY =  SVALK1                                         MD026169B
     C                   EVAL      DBKEY =  SVALK( 1 )                                     MD026169B
     C                   EVAL      DBPGM = 'GL007001'
     C                   EXSR      *PSSR
     C                   ENDIF
     C**********         MOVEL     SVAL1         MAX_TR_TO_CMT                             MD026169B
     C                   EVAL      CommitCtr = %DEC( SVAL( 1 ) : 10 : 0 )                  MD026169B
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
 
     C                   WHEN      EntDtaHdr.JOOBJ = 'GLOLPSTD'
     C                   EVAL      OLPOSDS = %SUBST( EntDta.JOESD
     C                                             : 1 : EntDta.JOENTL )
     C     KOLPS         SETLL     GLOLPSL0
     C                   IF        %EQUAL( GLOLPSL0 )
     C                   EXSR      OLPSPGM
     C                   ENDIF
 
     C                   WHEN      EntDtaHdr.JOOBJ = 'GLPRONTD'
     C                   EVAL      PRONODS = %SUBST( EntDta.JOESD
     C                                             : 1 : EntDta.JOENTL )
     C     KPRON         SETLL     GLPRONL0
     C                   IF        %EQUAL( GLPRONL0 )
     C                   EXSR      PRONPGM
     C                   ENDIF
 
     C                   ENDSL
 
     C                   IF        FileUpdated
 
     C                   EVAL      TransCounter += 1
 
     C**********         IF        TransCounter > MAX_TR_TO_CMT                            MD026169B
     C**********         CALLP(E)  UpdOLJSTD( %SUBST( EntDta.JOESD : 1 : 10 )              MD026169B
     C                   IF        TransCounter >= CommitCtr                               MD026169B
     C                   CALLP(E)  UpdOLJSTD( RcvInf.JORCV                                 MD026169B
     C                                      : %CHAR( EntDtaHdr.JOSEQ )       )
     C                   IF        %ERROR
     C                   EVAL      DBASE = 3
     C                   EVAL      DBFILE = '*CALL'
     C                   EVAL      DBKEY = 'UpdOLJSTD'
     C                   EVAL      DBPGM = 'GL007001'
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
     C     KOLPS         SETLL     GLOLPSL0
     C                   IF        %EQUAL( GLOLPSL0 )
     C                   READ      GLOLPSL0
     C                   EVAL      OLPROC = 'Y'
     C                   UPDATE    GLOLPST0
     C                   EVAL      FileUpdated = True
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      DBASE = 4
     C                   EVAL      DBFILE = '*CALL'
     C                   EVAL      DBKEY = 'AOOLPSU1'
     C                   EVAL      DBPGM = 'GL007001'
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
     C     KPRON         SETLL     GLPRONL0
     C                   IF        %EQUAL( GLPRONL0 )
     C                   READ      GLPRONL0
     C                   EVAL      PRPROC = 'Y'
     C                   UPDATE    GLPRONT0
     C                   EVAL      FileUpdated = True
     C                   ENDIF
 
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
 
     C                   CALLP(E)  UpdOLJSTD( %SUBST( EntDta.JOESD : 1 : 10 )
     C                                      : %CHAR( EntDtaHdr.JOSEQ + 1 )   )
     C                   IF        %ERROR
     C                   EVAL      DBASE = 6
     C                   EVAL      DBFILE = '*CALL'
     C                   EVAL      DBKEY = 'UpdOLJSTD'
     C                   EVAL      DBPGM = 'GL007001'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      pInfo.Control = EndRcvJrne                              MD026169A
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
 
     C                   CALLP(E)  UpdOLJSTD( RcvInf.JORCV
     C                                      : %CHAR( EntDtaHdr.JOSEQ ))
     C                   IF        %ERROR
     C                   EVAL      DBASE = 7
     C                   EVAL      DBFILE = '*CALL'
     C                   EVAL      DBKEY = 'UpdOLJSTD'
     C                   EVAL      DBPGM = 'GL007001'
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
      * UpdOLJSTD - Update OLJSPD with the values passed and from     *
      *             the update flag                                   *
      *---------------------------------------------------------------*
      *   pOLJRCV - inp; value of OLJRCV                              *
      *   pOLJSEQ - inp; value of OLJSEQ                              *
      *   pUpdate - inp; flag if OLJSPD is to be updated              *
      *                                                               *
      *****************************************************************
 
     P UpdOLJSTD       B
     D                 PI
     D  pOLJRCV                            CONST LIKE( OLJRCV )
     D  pOLJSEQ                            CONST LIKE( OLJSEQ )
 
     C     1             CHAIN     GLOLJSTD
 
     C                   EVAL      OLJRCV = pOLJRCV
     C                   EVAL      OLJSEQ = pOLJSEQ
 
     C                   IF        %FOUND( GLOLJSTD )
     C                   UPDATE    GLOLJST0
     C                   ELSE
     C                   WRITE     GLOLJST0
     C                   ENDIF
 
     P UpdOLJSTD       E
      *************************************************************
