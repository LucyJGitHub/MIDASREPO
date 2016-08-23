     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Notify Management Limits in CoB')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing                                    *
      *                                                               *
      *  GO000120  - Notify Management Limits in CoB                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CLE040             Date 13Oct04               *
      *  Prev Amend No. BG1673             Date 30Mar04               *
      *                 CGP003  *CREATE    Date 28Jan04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE040 - Change of Management Limit COB                      *
      *  BG1673 - EOD process not working properly                    *
      *  Changed array elements from:
      *  <mlimitsEODEvent xmlns="http://www.misys.com/midas/midasplus/mlimitsendofday/xml"
      *  <paramValue>ABCDEFGHIJ</paramValue></eventParam></mlimitsEODEvent>
      *  to  (capitalisation of MLimitsEODEvent)
      *  <MLimitsEODEvent xmlns="http://www.misys.com/midas/midasplus/mlimitsendofday/xml"
      *  <paramValue>ABCDEFGHIJ</paramValue></eventParam></MLimitsEODEvent>
      *  CGP003 - Management Limits                                   *
      *                                                               *
      *****************************************************************
 
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
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
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
      **------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      * Message to send to Management Limits
     D ML_MSG          S              1    DIM(800) CTDATA PERRCD(86)
 
     D DBerrUpd        C                   CONST('DB error in MLIM global updat+
     D                                     e')
 
      ** Access Object Parameters
     D PRetCode        S              7A
     D PSysValK1       S             20A
     D PSysVal1        S            200A
     D PSysValK2       S             20A
     D PSysVal2        S            200A
     D PSysValK3       S             20A
     D PSysVal3        S            200A
     D PSysValK4       S             20A
     D PSysVal4        S            200A
     D PSysValK5       S             20A
     D PSysVal5        S            200A
     D PSysValK6       S             20A
     D PSysVal6        S            200A
     D PSysValK7       S             20A
     D PSysVal7        S            200A
     D PSysValK8       S             20A
     D PSysVal8        S            200A
     D PSysValK9       S             20A
     D PSysVal9        S            200A
     D PSysValK10      S             20A
     D PSysVal10       S            200A
 
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
      *
      ** Data Area giving Installation Control Details
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving System prefix
     D SDSTAT        E DS                  EXTNAME(SDSTAT)
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D WConst          C                   'ManagementLimitsCoBWait'
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - Main body                                              *
      *                                                               *
      *****************************************************************
 
      ** Get the rundate
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
      ** Get the system prefix
     C     *DTAARA       DEFINE                  SDSTAT
     C                   IN        SDSTAT
 
      *  Get wait time
     C                   EVAL      PSysValK1 = WConst
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM                    PSysValK1
     C                   PARM                    PSysVal1
     C                   PARM                    PSysValK2
     C                   PARM                    PSysVal2
     C                   PARM                    PSysValK3
     C                   PARM                    PSysVal3
     C                   PARM                    PSysValK4
     C                   PARM                    PSysVal4
     C                   PARM                    PSysValK5
     C                   PARM                    PSysVal5
     C                   PARM                    PSysValK6
     C                   PARM                    PSysVal6
     C                   PARM                    PSysValK7
     C                   PARM                    PSysVal7
     C                   PARM                    PSysValK8
     C                   PARM                    PSysVal8
     C                   PARM                    PSysValK9
     C                   PARM                    PSysVal9
     C                   PARM                    PSysValK10
     C                   PARM                    PSysVal10
      *
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDSVALJ0'
     C                   EVAL      DBKEY  =  PSysValK1
     C                   EVAL      DBASE  =  6
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      *  Initialise Data queue parms
     C*******************EVAL      DtqNam = 'GPMLCOBNFY'                                      CLE040
     C                   EVAL      DtqNam = 'EODMONITOR'                                      CLE040
     C                   EVAL      DtqLib = '*LIBL'
     C                   EVAL      DtqLen = 1000
 
      *  Convert Midas run day number to SQL date number
     C                   Z-Add     0             TempRDNB         10 0
     C                   EVAL      TempRDNB = AGRDNB + 719892
 
      * Add system prefix
     C                   Move      TempRDNB      WorkF            10
     C                   Eval      %SubSt(WorkF:1:2) = LIBR
 
      * Set up message
     C                   MOVEA     WorkF         ML_MSG(529)
     C                   MOVEA     ML_MSG        DtqDta
 
     C                   CALL      'QSNDDTAQ'
     C                   PARM                    DtqNam           10
     C                   PARM                    DtqLib           10
     C                   PARM                    DtqLen            5 0
     C                   PARM                    DtqDta         1000
 
      *  Re-initialise Data queue parms
     C                   EVAL      DtqNam = 'GOMLCOBRSP'
     C                   MoveL     PSysVal1      DtqWait
 
      ** Wait for data queue return prompt
     C                   CALL      'QRCVDTAQ'
     C                   PARM                    DtqNam
     C                   PARM                    DtqLib
     C                   PARM                    DtqLen
     C                   PARM                    DtqRsp           10
     C                   PARM                    DtqWait           5 0
 
      ** Check for error
     C     DtqRsp        IFNE      'RECEIVED'
     C                   ExSr      *Pssr
     C                   EndIf
 
      * Exit from program
     C                   RETURN
 
      *****************************************************************
      /EJECT
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   EndSr
      *****************************************************************
      /EJECT
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
** ML_MSG
<?xml version="1.0" encoding="UTF-8"?>
<MLimitsEODEvent xmlns="http://www.misys.com/midas/midasplus/mlimitsendofday/xml"
 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xsi:schemaLocation="http://www.misys.com/midas/midasplus/mlimitsendofday/xml
  ../../../../../../frwkdtd/dtd/mlimits-eod-monitor-event.xsd">
<eventType>MLIMITS_EOD_BEGIN</eventType><eventParam><paramName>ZONE</paramName>
<paramValue>ABCDEFGHIJ</paramValue></eventParam></MLimitsEODEvent>
