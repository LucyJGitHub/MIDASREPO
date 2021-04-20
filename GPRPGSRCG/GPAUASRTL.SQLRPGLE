     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/**** *  RPGBASEMOD                                                   *          MD056611
/*STD *  RPGSQLMOD                                                    *          MD056611
/*EXI *  CLOSQLCSR(*ENDMOD)                                           *          MD056611
/*EXI *  TEXT('Midas GP Audit Field Action Selection - Retrieval')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAUASRTL - Audit Field Action Selection - Retrieval         *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD056611           Date 20Sep20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGP004  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056611 - Deliverable Data Split for Audit Reporting        *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP004 - Audit Reporting                                     *
      *                                                               *
      *****************************************************************

     F*GPAUASL0* IF   E           K DISK    INFSR(*PSSR)                                    MD056611


      * Field Action Selection
     D*COPY*GPCPYSRCG,GPAUFDASL                                                             MD056611
     D/COPY GPCPYSRCG,GPAUFDASL1                                                            MD056611

     D GPAUAS        E DS                  EXTNAME(GPAUAJW0)                                MD056611

      * Number of files whose field action selections are stored
     D NoofFiles       C                   CONST(20)
      * File/Record ID
     D #_FILRID        S             25    DIM(NoofFiles)
      * File Field Action Selection
     D #_FILFDASL      S          13350    DIM(NoofFiles)


      * Clear outputs

     C                   MOVE      *BLANK        #_FDACSL


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
     C                   MOVEA     #_FILFDASL(#X)#_FDACSL
     C                   ELSE

      ** Get the File Field Action Selection

     C                   EXSR      GET_FILFDASL

      * Save the file's details

     C                   Z-ADD     1             #X
     C     *BLANK        LOOKUP    #_FILRID(#X)                           99    *
     C     *in99         IFEQ      *ON
     C                   MOVEL     File_RecordID #_FILRID(#X)
     C                   MOVEA     #_FDACSL      #_FILFDASL(#X)
     C                   ELSE
     C                   ADD       1             #C
     C                   MOVEL     File_RecordID #_FILRID(#C)
     C                   MOVEA     #_FDACSL      #_FILFDASL(#C)
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
     C     GET_FILFDASL  BEGSR
     C                   Z-ADD     1             #FD               5 0
     C*****GPAUASK       SETLL     GPAUASD0                                                 MD056611
     C*****GPAUASK       READE     GPAUASD0                               90                MD056611
     C/EXEC SQL                                                                             MD056611
     C+ declare ACursor insensitive scroll cursor for                                       MD056611
     C+ select * from GPAUAJW0                                                              MD056611
     C+ where AFFILE = :InFile and AFRCID = :InRecordID                                     MD056611
     C+ order by AFFILE, AFRCID                                                             MD056611
     C/END-EXEC                                                                             MD056611
                                                                                            MD056611
     C/EXEC SQL                                                                             MD056611
     C+ open ACursor                                                                        MD056611
     C/END-EXEC                                                                             MD056611
                                                                                            MD056611
     C/EXEC SQL                                                                             MD056611
     C+ fetch next from ACursor into :GPAUAS                                                MD056611
     C/END-EXEC                                                                             MD056611
     C******IN90         DOWEQ     '0'                                                      MD056611
     C     SQLCODE       DOWEQ     0                                                        MD056611
     C                   eval      xFACTN = AFACTN                                          MD056611
     C                   eval      xFSELN = AFSELN                                          MD056611
     C                   eval      xFSIAO = AFSIAO                                          MD056611
     C                   eval      xFBFAF = AFBFAF                                          MD056611
     C                   eval      xFSFLD = AFSFLD                                          MD056611
     C                   eval      xFSCMP = AFSCMP                                          MD056611
     C                   eval      xFSCPV = AFSCPV                                          MD056611
     C                   MOVEL     #FDACSL       #_FDACSL(#FD)
     C                   ADD       1             #FD
     C*****GPAUASK       READE     GPAUASD0                               90                MD056611
     C/EXEC SQL                                                                             MD056611
     C+ fetch next from ACursor into :GPAUAS                                                MD056611
     C/END-EXEC                                                                             MD056611
     C                   ENDDO

     C/EXEC SQL                                                                             MD056611
     C+ close ACursor                                                                       MD056611
     C/END-EXEC                                                                             MD056611
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
     C                   PARM                    InFile           10
     C                   PARM                    InRecordID       15
      * OUTPUT
      * Field Action Selection
     C                   PARM                    #_FDACSL

     C                   Z-ADD     *ZERO         #C                6 0

      * Key lists

     C     GPAUASK       KLIST
     C                   KFLD                    InFile
     C                   KFLD                    InRecordID

     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GPCPYSRCG,GPPSSR
      *****************************************************************
