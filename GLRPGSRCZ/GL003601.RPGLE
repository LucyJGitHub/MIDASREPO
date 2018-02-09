     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Audit File Merge')                            *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL003601 - Midas GL Audit File Merge                         *
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
 
      ** Midas GP Selected Account Temporary File
 
     FGLAUTFPD  O    E           K DISK    INFSR(*PSSR)
 
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
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program Status Data Structure
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D PRtcd           S              7A
     D PZone           S             10A
     D PAction         S              1A
     D PFRAC           S             24A
     D PTOAC           S             24A
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
     D WKDFMT          S              9A
     D WKYEAR          S              2S 0
     D WKCCYY          S              4S 0
     D @RTCD           S              7A
     D @OPTN           S              7A
 
      ** Work fields
 
     D WRun            S              1A   INZ(' ')
 
     C/TITLE Main Processing
      *****************************************************************
      *  P R O G R A M   S T A R T                                    *
      *****************************************************************
 
     C                   EVAL      AURFNO = PREFN
     C                   EVAL      AUFILE = PFILE
     C                   EVAL      AULFIL = PLFIL
     C                   EVAL      AUFBRC = PFBRC
     C                   EVAL      AUFCNU = PFCNU
     C                   EVAL      AUFACO = PFACO
     C                   EVAL      AUFACS = PFACS
     C                   EVAL      AUTBRC = PTBRC
     C                   EVAL      AUTCNU = PTCNU
     C                   EVAL      AUTACO = PTACO
     C                   EVAL      AUTACS = PTACS
     C                   EVAL      AUTEXT = PTEXT
     C                   EVAL      AUCRTD = WKDFMT
     C                   WRITE     GLAUTFD0
 
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
     C                   PARM                    PREFN
     C                   PARM                    PFILE
     C                   PARM                    PLFIL
     C                   PARM                    PFBRC
     C                   PARM                    PFCNU
     C                   PARM                    PFACO
     C                   PARM                    PFACS
     C                   PARM                    PTBRC
     C                   PARM                    PTCNU
     C                   PARM                    PTACO
     C                   PARM                    PTACS
     C                   PARM                    PTEXT
 
      ** Initialise LDA field
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBASE = 0
     C                   EVAL      DBPGM = 'GL003601'
     C                   OUT       LDA
 
      ** Retrieve Run Date.
 
     C                   CALL      'AOBANKR0'                           9090
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** If return with an error (LR seton in called program) then
      ** process for database error.
 
     C                   IF        *IN90 = '1' OR
     C                             @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'AOBANKR0'
     C                   EVAL      DBKEY = '*FIRST'
     C                   Z-ADD     001           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     BJMRDT        WKDFMT
     C                   MOVE      BJMRDT        WKYEAR
 
     C                   IF        WKYEAR < 72
     C     WKYEAR        ADD       2000          WKCCYY
     C                   ELSE
     C     WKYEAR        ADD       1900          WKCCYY
     C                   ENDIF
 
     C                   MOVE      WKCCYY        WKDFMT
 
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
 
