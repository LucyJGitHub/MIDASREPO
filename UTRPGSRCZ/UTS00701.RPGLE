     H NOMAIN
     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas UT QJORJRNE API Interface')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities                                            *
      *                                                               *
      *  UTS00701 - QJORJRNE API Interface                            *
      *                                                               *
      *  (c) Finastra International Limited 2018                      *
      *                                                               *
      *  Last Amend No. MD022132 *CREATE   DATE 09Mar18               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD022132 - Triggers don't pick up Rollback deletes of ABC    *
      *             files.                                            *
      *           - Applied for MD-35969.                             *
      *                                                               *
      *****************************************************************

      ** Templates and format for UTS00701
      ** prefixed with 't_'
      ** =================================

      /COPY UTCPYSRC,UTRJNE0200
      /COPY UTCPYSRC,UTERRC0100
      /COPY UTCPYSRC,UTS00701TP

      ** Procedure Prototypes
      ** ====================

     D bldCritParm     PR             5U 0
     D  pJrnEFilter                        CONST LIKEDS( t_EntSelCriteria )
     D  pEntCrit                   1300A   VARYING
      *---------------------------------------------------------------*
     D GetJrnE         PR                  EXTPROC('QjoRetrieveJournalEntries')
     D  pRcvVar                   32767A
     D  pRcvVarLen                   10I 0 CONST
     D  pQualJrn                     20A   CONST
     D  pRcvInfFmt                    8A   CONST
     D  pEntCrit                   1300A   CONST OPTIONS( *OMIT : *VARSIZE )
     D  pError                             LIKEDS( t_APIError )
     D                                     OPTIONS( *OMIT : *VARSIZE )
      *---------------------------------------------------------------*
     D dltPtrHdl       PR                  EXTPROC( 'QjoDeletePointerHandle' )
     D  pPtrHdl                      10U 0 CONST
     D  pErorr                    32767a   OPTIONS( *NOPASS: *VARSIZE )
      *---------------------------------------------------------------*
     D UTS00701        PR
      /COPY UTCPYSRC,UTS00701PR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UTS00701 - Wrapper procedure for QJORJRNE API                 *
      *          - Returns journal header information and entry data  *
      *---------------------------------------------------------------*
      *  pQualJrn - inp; Journal information <jrnname><jrnlib>        *
      *  pJrnEFilter - inp; entry selection criteria parameter        *
      *              - outp; returns continuation information if more *
      *                      data are yet to be retrieved             *
      *  pJrnHdr - outp; Journal header (JOSEQ, JOJOB, etc)           *
      *  pJrnEntDta - outp; Enty data (JOESD)                         *
      *  pEntCnt - outp; no of entries placed in the arrays           *
      *  pNoMoreData - outp; flag if more data are yet to be retrvd   *
      *  pErrorDS - outp; standard API error information data struct  *
      *                                                               *
      *****************************************************************

     P UTS00701        B                   EXPORT
     D                 PI
      /COPY UTCPYSRC,UTS00701PR

      *---------------------------------------------------------------*

      ** Storage for data returned from GetJrnE with RJNE0200 format

     D RcvVar          DS                  STATIC
     D                                     LIKEDS( t_RcvVar )

      ** Breakdown of stored/received data from GetJrnE
      ** Header part + data part

     D EntDtaHdr       DS                  BASED( ptrEntHdr )
     D                                     LIKEDS( t_EntDtaHdr )

     D EntDta          DS                  BASED( ptrEntDta )
     D                                     LIKEDS( t_EntDta )

      ** Receiver information

     D RcvInf          DS                  BASED( ptrRcvInf )
     D                                     LIKEDS( t_RcvInf )

      ** Work Variables

     D EntSelCriteria  S           1300A   STATIC VARYING
     D EntLen          S             10I 0 STATIC
     D RecJrnRcv       DS                  STATIC LIKEDS( RcvInf )
     D IdxA            DS                  STATIC INZ
     D  Idx                          10I 0

      *---------------------------------------------------------------*

     C                   MONITOR
     C                   CLEAR                   pJrnHdr
     C                   CLEAR                   pJrnEntDta
     C                   CLEAR                   pErrorDS
     C                   EVAL      pErrorDS.BytPrv = %SIZE( pErrorDS )

     C                   EVAL      pEntCnt = 0

      ** Check and build any passed criterias that would be used in GetJrnE

     C                   DOU       RcvVar.ContInd = '0' OR pErrorDS.BytAvl > 0

     C                   EVAL      Idx = bldCritParm( pJrnEFilter
     C                                              : EntSelCriteria )
     C                   IF        Idx > 0
     C                   CALLP(E)  GetJrnE( RcvVar
     C                                    : %Size( RcvVar )
     C                                    : pQualJrn
     C                                    : 'RJNE0200'
     C                                    : IdxA + EntSelCriteria
     C                                    : pErrorDS       )
     C                   ELSE
     C                   CALLP(E)  GetJrnE( RcvVar
     C                                    : %Size( RcvVar )
     C                                    : pQualJrn
     C                                    : 'RJNE0200'
     C                                    : *OMIT
     C                                    : pErrorDS       )
     C                   ENDIF

      ** Begin separating data retrieved if there were no errors

     C                   IF        pErrorDS.BytAvl > 0
     C                   LEAVE
     C                   ENDIF

     C                   EVAL      ptrEntHdr = %ADDR( RcvVar )
     C                                       + RcvVar.HdrOffset

     C                   FOR       Idx = 1 to RcvVar.NbrEntRtv

      ** Header part

     C                   EVAL      pEntCnt = pEntCnt + 1
     C                   EVAL-CORR pJrnHdr(pEntCnt) = EntDtaHdr
     C                   EVAL      pJrnHdr(pEntCnt).JOTSTP =
     C                                %CHAR( EntDtaHdr.UnfTmst )

      ** Data part

     C                   EVAL      ptrEntDta = ptrEntHdr
     C                                       + EntDtaHdr.EntDtaOffset

     C                   EVAL      EntLen = 2000
     C                   IF        EntDta.JOENTL < EntLen
     C                   EVAL      EntLen = EntDta.JOENTL
     C                   ENDIF

     C                   EVAL      pJrnEntDta(pEntCnt) =
     C                                         %SUBST( EntDta.JOESD
     C                                               : 1 : EntLen   )

      ** Store journal receiver information if available

     C                   IF        EntDtaHdr.JRcvOffset > 0
     C                   EVAL      ptrRcvInf = ptrEntHdr + EntDtaHdr.JRcvOffset
     C                   EVAL      RecJrnRcv = RcvInf
     C                   ENDIF

     C                   EVAL-CORR pJrnHdr(pEntCnt) = RcvInf

      ** Free up handle and its allocation

     C                   IF        EntDtaHdr.PtrHdl > 0
     C                   CALLP(E)  dltPtrHdl( EntDtaHdr.PtrHdl )
     C                   ENDIF

      ** Return to caller if array full, set values for resuming retrieval

     C                   IF        pEntCnt = %ELEM( t_EntDtaArr )
     C                   EVAL      pNoMoreData = 'N'
     C                   EVAL      pJrnEFilter.StrtRcv = RecJrnRcv.JORCV
     C                   EVAL      pJrnEFilter.StrtRcvLib = RecJrnRcv.JORCVLIB
     C                   EVAL      pJrnEFilter.EndRcv = '*CURRENT'
     C                   EVAL      pJrnEFilter.FROMENTLRG =
     C                              %CHAR( pJrnHdr(pEntCnt).JOSEQ + 1 )
     C                   EVAL      pJrnEFilter.TOENTLRG = '*LAST'
     C                   RETURN
     C                   ENDIF

     C                   IF        Idx < RcvVar.NbrEntRtv
     C                   EVAL      ptrEntHdr = ptrEntHdr + EntDtaHdr.HdrOffset
     C                   ENDIF

     C                   ENDFOR

      ** Set values to continue retrieving data if there are more

     C                   EVAL      pNoMoreData = 'Y'
     C                   IF        RcvVar.ContInd = '1'
     C                   EVAL      pNoMoreData = 'N'
     C                   EVAL      pJrnEFilter.StrtRcv = RcvVar.ContStrRcv
     C                   EVAL      pJrnEFilter.StrtRcvLib = RcvVar.ContStrRcvLib
     C                   EVAL      pJrnEFilter.EndRcv = '*CURRENT'
     C                   EVAL      pJrnEFilter.FROMENTLRG = RcvVar.ContSeqNbr
     C                   EVAL      pJrnEFilter.TOENTLRG = '*LAST'
     C                   ENDIF

     C                   ENDDO

     C                   ON-ERROR
     C                   EVAL      pErrorDS.BytAvl = 99
     C                   EVAL      pErrorDS.MsgID = 'PROCERR'
     C                   EVAL      pErrorDS.MsgDta = 'Check Dump and Joblog'
     C                   ENDMON

     P UTS00701        E

      *****************************************************************
      *                                                               *
      * bldCritParm - Build entry selection criteria parameter for    *
      *               the GETJRNE API                                 *
      *---------------------------------------------------------------*
      *   pCriteria - inp; value of selection criteria                *
      *   pEntCrit  - outp; criteria parameter built                  *
      *   NbrCrit   - outp; number of criterias in pEntCrit           *
      *                                                               *
      *****************************************************************

     P bldCritParm     B
     D                 PI             5U 0
     D  pCriteria                          CONST LIKEDS( t_EntSelCriteria )
     D  pEntCrit                   1300A   VARYING

      *---------------------------------------------------------------*

     D FmtSz           C                   CONST(%SIZE( CritFmt ))
     D FmtArrSz        C                   CONST(%SIZE( CritFmtArr ))

     D CritFmt         DS                  STATIC QUALIFIED
     D  Len                          10I 0
     D  Key                          10I 0
     D  ValLen                       10I 0

     D CritFmtArr      DS                  STATIC QUALIFIED
     D  Len                          10I 0
     D  Key                          10I 0
     D  ValLen                       10I 0
     D  NbrVal                       10I 0

     D DSNbrEnt        DS                  STATIC QUALIFIED
     D  NBRENT                             LIKE( pCriteria.NBRENT )

     D DSJrnCde        DS                  STATIC QUALIFIED
     D  JRNCDE                             LIKE( pCriteria.JRNCDE )
     D                                     DIM(%ELEM( t_KeyArr ))

     D DSEntTyp        DS                  STATIC QUALIFIED
     D  ENTTYP                             LIKE( pCriteria.ENTTYP )
     D                                     DIM(%ELEM( t_KeyArr ))

     D DSFile          DS                  STATIC QUALIFIED
     D  FILE                               LIKE( pCriteria.FILE )
     D                                     DIM(%ELEM( t_KeyArr ))

     D NbrCrit         S              5U 0 INZ

      *---------------------------------------------------------------*

     C                   EVAL      pEntCrit = ''

     C                   IF        pCriteria.RCVRNG <> *BLANKS
     C                   EVAL      NbrCrit = NbrCrit + 1
     C                   EVAL      CritFmt.Key = 1
     C                   EVAL      CritFmt.ValLen = %SIZE( pCriteria.RCVRNG )
     C                   EVAL      CritFmt.Len = CritFmt.ValLen + FmtSz
     C                   EVAL      pEntCrit = pEntCrit + CritFmt
     C                               + pCriteria.RCVRNG
     C                   ENDIF

     C                   IF        pCriteria.FROMENTLRG <> *BLANKS
     C                   EVAL      NbrCrit = NbrCrit + 1
     C                   EVAL      CritFmt.Key = 2
     C                   EVAL      CritFmt.ValLen =
     C                                        %SIZE( pCriteria.FROMENTLRG )
     C                   EVAL      CritFmt.Len = CritFmt.ValLen + FmtSz
     C                   EVAL      pEntCrit = pEntCrit + CritFmt
     C                               + pCriteria.FROMENTLRG
     C                   ENDIF

     C                   IF        pCriteria.FROMTIME <> *BLANKS
     C                   EVAL      NbrCrit = NbrCrit + 1
     C                   EVAL      CritFmt.Key = 3
     C                   EVAL      CritFmt.ValLen = %SIZE( pCriteria.FROMTIME )
     C                   EVAL      CritFmt.Len = CritFmt.ValLen + FmtSz
     C                   EVAL      pEntCrit = pEntCrit + CritFmt
     C                               + pCriteria.FROMTIME
     C                   ENDIF

     C                   IF        pCriteria.TOENTLRG <> *BLANKS
     C                   EVAL      NbrCrit = NbrCrit + 1
     C                   EVAL      CritFmt.Key = 4
     C                   EVAL      CritFmt.ValLen = %SIZE( pCriteria.TOENTLRG )
     C                   EVAL      CritFmt.Len = CritFmt.ValLen + FmtSz
     C                   EVAL      pEntCrit = pEntCrit + CritFmt
     C                               + pCriteria.TOENTLRG
     C                   ENDIF

     C                   IF        pCriteria.TOTIME <> *BLANKS
     C                   EVAL      NbrCrit = NbrCrit + 1
     C                   EVAL      CritFmt.Key = 5
     C                   EVAL      CritFmt.ValLen = %SIZE( pCriteria.TOTIME )
     C                   EVAL      CritFmt.Len = CritFmt.ValLen + FmtSz
     C                   EVAL      pEntCrit = pEntCrit + CritFmt
     C                               + pCriteria.TOTIME
     C                   ENDIF

     C                   IF        pCriteria.NBRENT > 0
     C                   EVAL      NbrCrit = NbrCrit + 1
     C                   EVAL      CritFmt.Key = 6
     C                   EVAL      CritFmt.ValLen = %SIZE( DSNbrEnt )
     C                   EVAL      CritFmt.Len = CritFmt.ValLen + FmtSz
     C                   EVAL      DSNbrEnt.NBRENT = pCriteria.NBRENT
     C                   EVAL      pEntCrit = pEntCrit + CritFmt
     C                               + DSNbrEnt
     C                   ENDIF

     C                   IF        pCriteria.JRNCDE(1) <> *BLANKS
     C                   EVAL      NbrCrit = NbrCrit + 1
     C                   EVAL      CritFmtArr.Key = 7
     C                   EVAL      CritFmtArr.NbrVal = pCriteria.CDECNT
     C                   EVAL      CritFmtArr.ValLen = %SIZE( DSJrnCde )
     C                   EVAL      CritFmtArr.Len = CritFmtArr.ValLen + FmtArrSz
     C                   EVAL      DSJrnCde.JRNCDE = pCriteria.JRNCDE
     C                   EVAL      pEntCrit = pEntCrit + CritFmtArr
     C                               + DSJrnCde
     C                   ENDIF

     C                   IF        pCriteria.ENTTYP(1) <> *BLANKS
     C                   EVAL      NbrCrit = NbrCrit + 1
     C                   EVAL      CritFmtArr.Key = 8
     C                   EVAL      CritFmtArr.NbrVal = pCriteria.TYPCNT
     C                   EVAL      CritFmtArr.ValLen = %SIZE( DSEntTyp )
     C                   EVAL      CritFmtArr.Len = CritFmtArr.ValLen + FmtArrSz
     C                   EVAL      DSEntTyp.ENTTYP = pCriteria.ENTTYP
     C                   EVAL      pEntCrit = pEntCrit + CritFmtArr
     C                               + DSEntTyp
     C                   ENDIF

     C                   IF        pCriteria.JOB <> *BLANKS
     C                   EVAL      NbrCrit = NbrCrit + 1
     C                   EVAL      CritFmt.Key = 9
     C                   EVAL      CritFmt.ValLen = %SIZE( pCriteria.JOB )
     C                   EVAL      CritFmt.Len = CritFmt.ValLen + FmtSz
     C                   EVAL      pEntCrit = pEntCrit + CritFmt
     C                               + pCriteria.JOB
     C                   ENDIF

     C                   IF        pCriteria.PGM <> *BLANKS
     C                   EVAL      NbrCrit = NbrCrit + 1
     C                   EVAL      CritFmt.Key = 10
     C                   EVAL      CritFmt.ValLen = %SIZE( pCriteria.PGM )
     C                   EVAL      CritFmt.Len = CritFmt.ValLen + FmtSz
     C                   EVAL      pEntCrit = pEntCrit + CritFmt
     C                               + pCriteria.PGM
     C                   ENDIF

     C                   IF        pCriteria.USRPRF <> *BLANKS
     C                   EVAL      NbrCrit = NbrCrit + 1
     C                   EVAL      CritFmt.Key = 11
     C                   EVAL      CritFmt.ValLen = %SIZE( pCriteria.USRPRF )
     C                   EVAL      CritFmt.Len = CritFmt.ValLen + FmtSz
     C                   EVAL      pEntCrit = pEntCrit + CritFmt
     C                               + pCriteria.USRPRF
     C                   ENDIF

     C                   IF        pCriteria.CMTCYCID <> *BLANKS
     C                   EVAL      NbrCrit = NbrCrit + 1
     C                   EVAL      CritFmt.Key = 12
     C                   EVAL      CritFmt.ValLen = %SIZE( pCriteria.CMTCYCID )
     C                   EVAL      CritFmt.Len = CritFmt.ValLen + FmtSz
     C                   EVAL      pEntCrit = pEntCrit + CritFmt
     C                               + pCriteria.CMTCYCID
     C                   ENDIF

     C                   IF        pCriteria.DEPENT <> *BLANKS
     C                   EVAL      NbrCrit = NbrCrit + 1
     C                   EVAL      CritFmt.Key = 13
     C                   EVAL      CritFmt.ValLen = %SIZE( pCriteria.DEPENT )
     C                   EVAL      CritFmt.Len = CritFmt.ValLen + FmtSz
     C                   EVAL      pEntCrit = pEntCrit + CritFmt
     C                               + pCriteria.DEPENT
     C                   ENDIF

     C                   IF        pCriteria.INCENT <> *BLANKS
     C                   EVAL      NbrCrit = NbrCrit + 1
     C                   EVAL      CritFmt.Key = 14
     C                   EVAL      CritFmt.ValLen = %SIZE( pCriteria.INCENT )
     C                   EVAL      CritFmt.Len = CritFmt.ValLen + FmtSz
     C                   EVAL      pEntCrit = pEntCrit + CritFmt
     C                               + pCriteria.INCENT
     C                   ENDIF

     C                   IF        pCriteria.NULLINDLEN <> *BLANKS
     C                   EVAL      NbrCrit = NbrCrit + 1
     C                   EVAL      CritFmt.Key = 15
     C                   EVAL      CritFmt.ValLen =
     C                                  %SIZE( pCriteria.NULLINDLEN )
     C                   EVAL      CritFmt.Len = CritFmt.ValLen + FmtSz
     C                   EVAL      pEntCrit = pEntCrit + CritFmt
     C                               + pCriteria.NULLINDLEN
     C                   ENDIF

     C                   IF        pCriteria.FILE(1) <> *BLANKS
     C                   EVAL      NbrCrit = NbrCrit + 1
     C                   EVAL      CritFmtArr.Key = 16
     C                   EVAL      CritFmtArr.NbrVal = pCriteria.FILCNT
     C                   EVAL      CritFmtArr.ValLen = %SIZE( DSFile )
     C                   EVAL      CritFmtArr.Len = CritFmtArr.ValLen + FmtArrSz
     C                   EVAL      DSFile.FILE = pCriteria.FILE
     C                   EVAL      pEntCrit = pEntCrit + CritFmtArr
     C                               + DSFile
     C                   ENDIF

     C                   RETURN    NbrCrit

     P bldCritParm     E
      *****************************************************************
