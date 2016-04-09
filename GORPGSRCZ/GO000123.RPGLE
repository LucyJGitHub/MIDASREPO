     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Get finished message in CoB')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing                                    *
      *                                                               *
      *  GO000123  - Get Finished Message in COB                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. AR818983           Date 23Aug11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG9647 *CREATE    Date 19Dec05               *
      *                 XXXXXX             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR818983 - GOC0122 taking a long time.  Properly convert     *
      *             system value COBDtaQWait from alpha to numeric    *
      *             (Child: AR818984)                                 *
      *  BUG9647- Syndications Manager Correspondence does not        *
      *           generate any correspondence during COB              *
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
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D WConst          C                   'COBDtaQWait'
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
 
      *  Re-initialise Data queue parms
     C                   EVAL      DtqNam = 'GOMLCOBRSP'
     C                   EVAL      DtqLib = '*LIBL'
     C                   EVAL      DtqLen = 1000
     C**********         MOVEL     PSysVal1      DtqWait                                    AR818983
     C                   EVAL      DtqWait = %DEC(PSysVal1:5:0)                             AR818983
 
      ** Wait for data queue return prompt
     C                   CALL      'QRCVDTAQ'
     C                   PARM                    DtqNam           10
     C                   PARM                    DtqLib           10
     C                   PARM                    DtqLen            5 0
     C                   PARM                    DtqRsp           10
     C                   PARM                    DtqWait           5 0
 
      ** Check for error
     C     DtqRsp        IFNE      'GO'
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
(c) Misys International Banking Systems Ltd. 2005
