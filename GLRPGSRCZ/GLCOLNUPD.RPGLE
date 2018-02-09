     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Update Function Module')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLCOLNUPD - GL Collateral Narrative Update Function Module   *
      *                                                               *
      *  Function:  This API module will serve as the Update module   *
      *             of the complete API program and will be made      *
      *             switchable under enhancement number CGL011.       *
      *                                                               *
      *  Called By: GLCOLNSIN                                         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *  Prev Amend No. CGL011  *CREATE    Date 20Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL011 - Collateral Processing for Midas                     *
      *                                                               *
      *****************************************************************
 
     FGLCOLNL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
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
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Include the standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      ** Collateral Narrative File Format
     D ValidRec      E DS                  EXTNAME(GLCOLNPD)
 
      ** CN Record format
     D RecToAmend    E DS                  EXTNAME(GLCOLNPD)
     D                                     PREFIX(@)
 
      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** DS for Access Object Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Timestamp field
     D PtimeStamp      S               Z
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Return if action code is not 'I'or 'A'
 
     C                   If        (CNCHTP <> 'I') And
     C                             (CNCHTP <> 'A')
     C                   Return
     C                   EndIf
 
      ** Insert
 
     C     CNCHTP        CasEq     'I'           SRINS
 
      ** Amend
 
     C     CNCHTP        CasEq     'A'           SRAMD
 
     C                   EndCs
 
     C                   Return
 
      *****************************************************************
      *                                                               *
      * SR/*InzSr: Initialisation Routine                             *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      * AOBANKR0   Access Object                                      *
      *                                                               *
      *****************************************************************
 
     C     *InzSr        BegSr
 
      ** Entry Parameters
 
     C     *Entry        PList
     C                   Parm                    PRetCode          7
     C                   Parm                    ValidRec
     C                   Parm                    PNarRlrn          3 0
 
      ** Program Name
 
     C                   Eval      DbPgm = 'GLCOLNUPD'
 
      ** Access Bank Details via Access Object AOBANKR0
 
     C                   Call      'AOBANKR0'
     C                   Parm      '*DBERR '     @RtCd
     C                   Parm      '*FIRST '     @Optn
     C     SDBANK        Parm      SDBANK        DSFDY
 
     C     @RtCd         IfNe      *BLANKS
     C     *LOCK         In        LDA
     C                   Move      *On           *INU7
     C                   Move      *On           *INU8                          ************
     C                   MoveL     'SDBANKPD'    DbFile                         * DBERR 01 *
     C                   Z-Add     001           Dbase                          ************
     C                   MoveL     @Optn         DbKey
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
 
      ** Key list for GLCOLNL0
 
     C     WKeyColnL0    Klist
     C                   Kfld                    @CNCREF
     C                   Kfld                    @CNNRRN
 
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SrIns: Insert processing                                   *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      * ZAGENTMSTM- Generate a timestamp                              *
      *                                                               *
      *****************************************************************
 
     C     SrIns         BegSr
 
      ** Write record
 
     C                   If        (CNNRRN - PNarRlrn) >= 1
     C                   Eval      RecToAmend = ValidRec
 
     C     PNarRlrn      DoWlt     @CNNRRN
 
     C                   Eval      CNNARR = *Blank
     C                   Eval      CNNRRN = PNarRlrn
 
      ** Generate timestamp
 
     C                   CallB     'ZAGENTMSTM'
     C                   Parm                    PtimeStamp
 
     C                   Movel     PtimeStamp    CNTMST
 
      ** Write record to GLCOLNPD
 
     C                   Write     GLCOLND0                             30
 
     C                   Add       1             PNarRlrn
 
      ** Error writing record
 
     C                   If        *IN30 = *On
     C                   ExSr      SrError
     C                   EndIf
 
     C                   EndDo
 
     C                   Eval      ValidRec = RecToAmend
     C                   EndIf
 
     C                   Eval      PNarRlrn = CNNRRN
 
      ** Generate timestamp
 
     C                   CallB     'ZAGENTMSTM'
     C                   Parm                    PtimeStamp
 
     C                   Movel     PtimeStamp    CNTMST
 
      ** Write record to GLCOLNPD
 
     C                   Write     GLCOLND0                             30
     C                   Add       1             PNarRlrn
 
      ** Error writing record
 
     C                   If        *IN30 = *On                                  ************
     C                   Z-Add     002           Dbase                          * DBERR 02 *
     C                   ExSr      SrError                                      ************
     C                   EndIf
 
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SrAmd: Amend processing                                    *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      * ZAGENTMSTM- Generate a timestamp                              *
      *                                                               *
      *****************************************************************
 
     C     SrAmd         BegSr
 
      ** Copy records from ValidRec to RecToAmend
 
     C                   Eval      RecToAmend = ValidRec
 
     C     WKeyColnl0    Chain     GLCOLNL0                           3132
 
      ** Chaining Error
 
     C                   If        *IN32 = *On
     C                   Z-Add     003           Dbase                          ************
     C                   MoveL     'GLCOLNL0'    DbFile                         * DBERR 03 *
     C                   MoveL     RecToAmend    DbKey                          ************
     C                   Dump
     C                   Movel     'Y2U0032'     PRetCode
     C                   Return
     C                   EndIf
 
      ** Record not found, call CNINS to add narrative to an already
      ** existing narrative
 
     C                   If        *IN31 = *On
     C     CNCREF        SetGt     GLCOLNL0
     C     CNCREF        ReadPe    GLCOLNL0                               33
     C                   Eval      PNarRlrn = CNNRRN + 1
     C                   Eval      ValidRec = RecToAmend
     C                   Exsr      SrIns
     C                   Else
     C                   Eval      ValidRec = RectoAmend
 
      ** Generate timestamp
 
     C                   CallB     'ZAGENTMSTM'
     C                   Parm                    PtimeStamp
 
     C                   Movel     PtimeStamp    CNTMST
 
      ** Update Record
 
     C                   Eval      *IN30 = *Off
 
     C                   Update    GLCOLND0                             30
 
      ** Error updating record
 
     C                   If        *IN30 = *On
     C                   Z-Add     004           Dbase                          ************
     C                   ExSr      SrError                                      * DBERR 04 *
     C                   EndIf                                                  ************
     C                   EndIf
 
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SrError: Write/Update Error                                *
      *                                                               *
      * Called By: SrIns and SrAmd subroutines                        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrError       BegSr
 
     C                   MoveL     'GLCOLNL0'    DbFile
     C                   MoveL     ValidRec      DbKey
     C                   Dump
     C                   Movel     'Y2U0032'     PRetCode
     C                   Return
 
     C                   EndSr
 
      ****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
