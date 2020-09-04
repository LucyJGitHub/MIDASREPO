     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*XBI *  CRTPF FILE(QTEMP/SCTRIGQT) RCDLEN(400)                       *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SC Write cmd and error messages')                *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  SC001005 - Write cmd and error messages for SCSARDPD SCTRIGPD*
      *             SDMMIDPD SCSARTPD                                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. CCB022  *CREATE    Date 06Aug12               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CCB022 - COB Restructure - COB File Manager                  *
      *                                                               *
      *****************************************************************
      *
     FUPERRMQT  IF A E             DISK    INFSR( *PSSR )
     F                                     RENAME( UPERRMQT : ERRM )
     F                                     PREFIX( X )
     FSCTRIGQT  IF A E             DISK    INFSR( *PSSR )
     F                                     RENAME( SCTRIGQT : CMDS )
     F                                     PREFIX( X )
      *
      /EJECT
      *
      ** Variable/Constant Declarations
      *
     D ParmMode        S              7A
     D ParmMessage     S                   LIKE( XSCTRIGQT )
     D PSSRDone        S              1N   Inz
     D CmdLength       S             15P 0 Inz
     D ErrMsg          S            100A   Inz
     D True            C                   Const( *ON )
     D False           C                   Const( *OFF )
      *
      ** Data structure to store record read from SCTRIGQT
      *
     D SCTRIGDS        DS                  LIKEREC( CMDS : *INPUT )
      *
      * Point SCFldDS to SCTRIGDS memory location
      * SCFldDS will now hold same values with SCTRIGDS
      * and subdivide XSCTRIGQT to different fields
      *
     D SCTrigPtr       S               *   Inz( %Addr( SCTRIGDS ) )
     D SCFLDDS         DS                  BASED( SCTRIGPTR )
     D  SCMode                       10A   Overlay( SCFLDDS )
     D  CmdString                          LIKE( ParmMessage )
     D                                     Overlay( SCFLDDS : *NEXT )
     D   TriggerMode                  8A   Overlay( CmdString )
     D   TriggerFile                 10A   Overlay( CmdString : 15 )
      *
      * Local data area for database error details
      * *LOCK IN LDA immediately before and OUT LDA immediately
      * after each database error handling.
      * Fields:
      *  DBFILE
      *  DBPGM
      *  DBKEY
      *  DBASE
      *
     D LDA           E DS           256    Inz EXTNAME( LDA )
      *
      * Program Status Data Structure.
      *
     D PSDS           SDS
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
      ** Prototype for QCMDEXC program
      *
     D QCMDEXC         PR                  EXTPGM('QCMDEXC')
     D  ParmCMD                   32702A   CONST OPTIONS(*VARSIZE)
     D  ParmCMDLen                   15P 5 CONST
     D  ParmIGC                       3A   CONST OPTIONS(*NOPASS)
      ****************************************************************
      *                                                              *
      ** MAIN ROUTINE                                                *
      *                                                              *
      ****************************************************************
 
      ** WRITE mode
 
     C                   IF        ParmMode = '*WRITE'
     C                   EVAL      XSCTRIGQT = ParmMessage
     C                   WRITE     CMDS
     C                   ENDIF
 
      ** PROC mode
 
     C                   IF        ParmMode = '*PROC'
 
     C     1             SETLL     SCTRIGQT
     C                   READ      CMDS          SCTRIGDS
 
     C                   DOW       NOT %EOF( SCTRIGQT )
 
     C                   IF        SCMode = '*SPECIAL'
 
     C                   EVAL      CmdLength = %LEN( CmdString )
     C                   CALLP(E)  QCMDEXC( CmdString : CmdLength )
 
     C                   IF        %ERROR
     C                   EXSR      WriteErrMsg
     C                   ENDIF
 
     C                   ENDIF
 
     C                   READ      CMDS          SCTRIGDS
     C                   ENDDO
 
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program initialisation routine                       *
      *          Called automatically at the start of program call    *
      *                                                               *
      * Called by: None                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    ParmMode
     C                   PARM                    ParmMessage
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * WriteErrMsg - Writes error message depending on trigger mode  *
      *                                                               *
      * Called by: Error handler on QCMDEXC monitor                   *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     WRITEERRMSG   BEGSR
 
     C                   IF        TriggerMode = 'ADDPFTRG'
     C                   EVAL      ErrMsg = 'Trigger(s) not added to '
     C                   ENDIF
 
     C                   IF        TriggerMode = 'RMVPFTRG'
     C                   EVAL      ErrMsg = 'Trigger(s) not removed ' +
     C                                      'from '
     C                   ENDIF
 
     C                   EVAL      ErrMsg = %TRIM( ErrMsg ) +
     C                               ' ' +  %TRIM ( TriggerFile ) + '.'
     C                   EVAL      XUPERRMQT = ErrMsg
     C                   WRITE     ERRM
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: None                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        NOT PSSRDone
     C                   EVAL      PSSRDone = True
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
