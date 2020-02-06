     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Audit Field Attributes - Retrieval')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAUFDRTL - Audit Field Attributes - Retrieval               *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGP004  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP004 - Audit Reporting                                     *
      *                                                               *
      *****************************************************************
 
     FGPAUFDL4  IF   E           K DISK    INFSR(*PSSR)
 
 
      * Field Attributes
      * Field Shortnames
      * Field Descriptions
     D/COPY GPCPYSRCG,GPAUFDATB
     D/COPY GPCPYSRCG,GPAUFDSNM
     D/COPY GPCPYSRCG,GPAUFDDES
 
 
      * Number of files whose field attributes are stored
     D NoofFiles       C                   CONST(20)
      * File/Record ID
     D #_FILRID        S             25    DIM(NoofFiles)
      * File Field Attributes
     D #_FILFDATB      S          16250    DIM(NoofFiles)
      * File Field Shortnames
     D #_FILFDSNM      S           2500    DIM(NoofFiles)
      * File Field Descriptions
     D #_FILFDDES      S           7500    DIM(NoofFiles)
 
 
      * Clear outputs
 
     C                   MOVE      *BLANK        #_FDATRB
     C                   MOVE      *BLANK        #_FDSNAM
     C                   MOVE      *BLANK        #_FDFDES
 
 
      * Error if the file is not supplied
 
     C     InFile        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'NO FILE'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     InFile        File_RecordID    25
     C                   MOVE      InRecordID    File_RecordID
 
      * If the file field attributes were previously accessed,
      * use those file field attibutes
 
     C                   Z-ADD     1             #X                6 0
     C     File_RecordID LOOKUP    #_FILRID(#X)                           99    *
     C     *in99         IFEQ      *ON
     C                   MOVEA     #_FILFDATB(#X)#_FDATRB
     C                   MOVEA     #_FILFDSNM(#X)#_FDSNAM
     C                   MOVEA     #_FILFDDES(#X)#_FDFDES
     C                   ELSE
 
      ** Get the File Field Attributes
 
     C                   EXSR      GET_FILFDATB
 
      * Save the file's details
 
     C                   Z-ADD     1             #X
     C     *BLANK        LOOKUP    #_FILRID(#X)                           99    *
     C     *in99         IFEQ      *ON
     C                   MOVEL     File_RecordID #_FILRID(#X)
     C                   MOVEA     #_FDATRB      #_FILFDATB(#X)
     C                   MOVEA     #_FDSNAM      #_FILFDSNM(#X)
     C                   MOVEA     #_FDFDES      #_FILFDDES(#X)
     C                   ELSE
     C                   ADD       1             #C
     C                   MOVEL     File_RecordID #_FILRID(#C)
     C                   MOVEA     #_FDATRB      #_FILFDATB(#C)
     C                   MOVEA     #_FDSNAM      #_FILFDSNM(#C)
     C                   MOVEA     #_FDFDES      #_FILFDDES(#C)
     C     #C            IFEQ      NoofFiles
     C                   Z-ADD     *ZERO         #C
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * Return
 
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * Get File Field Attributes
      ********************************************************************
     C     GET_FILFDATB  BEGSR
     C                   Z-ADD     1             #FD               5 0
     C     GPAUFDK       SETLL     GPAUFDD0
     C     GPAUFDK       READE     GPAUFDD0                               90
     C     *IN90         DOWEQ     '0'
     C     InCategory    IFEQ      'R'
     C     AFRSEQ        ANDNE     99999
     C     InCategory    ORNE      'R'
     C     AFWSEQ        ANDNE     99999
     C                   MOVEL     #FDATRB       #_FDATRB(#FD)
     C                   MOVEL     AFSNAM        #_FDSNAM(#FD)
     C                   MOVEL     AFFDES        #_FDFDES(#FD)
     C                   ADD       1             #FD
     C                   ENDIF
     C     GPAUFDK       READE     GPAUFDD0                               90
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * INPUT
      * File
      * Record ID
      * Category (R=report)
     C                   PARM                    InFile           10
     C                   PARM                    InRecordID       15
     C                   PARM                    InCategory        1
      * OUTPUT
      * Field Attributes
      * Field Shortnames
      * Field Descriptions
     C                   PARM                    #_FDATRB
     C                   PARM                    #_FDSNAM
     C                   PARM                    #_FDFDES
 
     C                   Z-ADD     *ZERO         #C                6 0
 
      * Key lists
 
     C     GPAUFDK       KLIST
     C                   KFLD                    InFile
     C                   KFLD                    InRecordID
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GPCPYSRCG,GPPSSR
      *****************************************************************
