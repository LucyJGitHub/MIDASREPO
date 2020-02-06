     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Audit File Merge')                            *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GP000041 - Midas GP Audit File Merge                         *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR719317 *CREATE   Date 19Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
 
      ** Midas GP Batch Update Audit File
 
     FGPAUTFPD  UF   E           K DISK    INFSR(*PSSR)
 
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
 
     D PZone           S             10A
     D PREFN           S             10A
     D PFILE           S             10A
     D PLFIL           S             10A
     D PFBRC           S              3A
     D PFCNU           S              6A
     D PFACO           S             10A
     D PFACS           S              2A
     D PTBRC           S              3A
     D PTCNU           S              6A
     D PTACO           S             10A
     D PTACS           S              2A
     D PTEXT           S             50A
 
      ** Work fields
 
     D WRun            S              1A   INZ(' ')
 
     C/TITLE Main Processing
      *****************************************************************
      *  P R O G R A M   S T A R T                                    *
      *****************************************************************
 
      ** Read first record from File
 
     C     KSATP         SETLL     GPAUTFPD
     C     KSATP         READE     GPAUTFPD
 
     C                   DOW       NOT %EOF(GPAUTFPD) AND
     C                             PZONE = GPZONE
 
     C                   CALL      'GL003601'
     C                   PARM      GPREFN        PREFN
     C                   PARM      GPFILE        PFILE
     C                   PARM      GPLFIL        PLFIL
     C                   PARM      GPFBRC        PFBRC
     C                   PARM      GPFCNU        PFCNU
     C                   PARM      GPFACO        PFACO
     C                   PARM      GPFACS        PFACS
     C                   PARM      GPTBRC        PTBRC
     C                   PARM      GPTCNU        PTCNU
     C                   PARM      GPTACO        PTACO
     C                   PARM      GPTACS        PTACS
     C                   PARM      GPTEXT        PTEXT
 
     C                   DELETE    GPAUTFD0
 
     C     KSATP         READE     GPAUTFPD
 
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
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
     C                   PARM                    PZone
 
      ** Initialise LDA field
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBASE = 0
     C                   EVAL      DBPGM = 'GP000041'
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
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   RETURN
 
     C                   ENDSR
 
