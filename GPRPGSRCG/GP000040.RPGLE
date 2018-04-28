     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Selected Accnt Temp File Update')             *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GP000040 - Selected Account Temporary File Update and        *
      *             Housekeeping                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. AR719317*CREATE  Date 19Jul11                 *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR719317 - Include T_GZAMADEX in ATU processing              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRInit - Program Initialisation                              *
      *  SRProcess - Detail Processing                                *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *                                                               *
      *****************************************************************
 
      ** Midas GP Selected Account Temporary File
 
     FGPSATPL0  UF A E           K DISK    INFSR(*PSSR)
 
     D LDA           E DS           256    EXTNAME(LDA)
     D                                     DTAARA(LDA)
 
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'
 
     D/COPY GPCPYSRCG,PSDS
      ** Program Status Data Structure
 
      ** Entry Parameters
 
     D PRtcd           S              7A
     D PZone           S             10A
     D PRefn           S             10A
     D PAction         S              1A
     D PFRAC           S             24A
     D PTOAC           S             24A
 
      ** Work fields
 
     D WRun            S              1A   INZ(' ')
 
     C/TITLE Main Processing
      *****************************************************************
      *  P R O G R A M   S T A R T                                    *
      *****************************************************************
 
     C                   IF        PAction = 'D'
 
      ** Read first record from File
 
     C     KSATP         SETLL     GPSATPL0
     C     KSATP         READE     GPSATPL0
 
     C                   DOW       NOT %EOF(GPSATPL0)
 
     C                   DELETE    GPSATPD0
     C     KSATP         READE     GPSATPL0
     C                   ENDDO
 
     C                   ELSE
 
     C                   EVAL      GPZONE = PZONE
     C                   EVAL      GPRFNO = PREFN
     C                   EVAL      GPFRAC = PFRAC
     C                   EVAL      GPTOAC = PTOAC
     C                   WRITE     GPSATPD0
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Receive Parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    PRTCD
     C                   PARM                    PZONE
     C                   PARM                    PREFN
     C                   PARM                    PFRAC
     C                   PARM                    PTOAC
     C                   PARM                    PAction
 
      ** Initialise LDA field
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBASE = 0
     C                   EVAL      DBPGM = 'GP000040'
     C                   OUT       LDA
 
      ** Key lists
 
     C     KSATP         KLIST
     C                   KFLD                    PZONE
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
      ** Check to see that *PSSR has not already been called
 
     C                   EVAL      PRtcd = 'ERROR'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   RETURN
 
     C                   ENDSR
 
