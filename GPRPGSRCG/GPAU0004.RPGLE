     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Delete an Audit File')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAU0004 - Delete an Audit File                              *
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
 
     FGPAU0004DFCF   E             WORKSTN
     FGPAUFLL0  UF   E           K DISK    INFSR(*PSSR)
     FGPAUFDL0  UF   E           K DISK    INFSR(*PSSR)
     FGPAURNL0  UF   E           K DISK    INFSR(*PSSR)
     FGPAUASL0  UF   E           K DISK    INFSR(*PSSR)
 
     D ERR             S             76    DIM(4) CTDATA PERRCD(1)
     D HLP             S             76    DIM(2) CTDATA PERRCD(1)
 
     D                 DS
     D  FHDATA                 1     68
     D  AFDESC                 1     40
     D  AFINPT                41     44
     D  AFRIFD                45     54
     D  AFUSRI                55     64
     D  AFLAYO                65     65
     D  AFFDSP                66     66  0
     D  AFAUTH                67     67
     D  AFACTV                68     68
     D                 DS
     D  SHDATA                 1     68
     D  SSDESC                 1     40
     D  SSINPT                41     44
     D  SSRIFD                45     54
     D  SSUSRI                55     64
     D  SSLAYO                65     65
     D  SSFDSP                66     66
     D  SSAUTH                67     67
     D  SSACTV                68     68
 
     D PSDS           SDS
     D  ERROR            *STATUS
     D  WKSID                244    253
     D  USRID                254    263
 
     C* INITIAL PROCESSING
 
     C                   EXSR      INIT
     C     STRPGM        TAG
 
     C* CLEAR THE SCREEN
 
     C                   WRITE     CLEARSCR
 
     C* DISPLAY THE FIRST SCREEN (FILE NAME)
 
     C                   Z-ADD     99            ER                2 0
     C                   MOVEL     HLP(1)        DDHELP
     C                   MOVEA     '0'           *IN(71)                        PROT FILE NAME
     C     ER            DOWNE     *ZERO
     C                   EXSR      FIRST
     C                   END
 
     C* IF CK/3 WAS TAKEN ON THE FIRST SCREEN, THEN GO TO END OF PROGRAM
 
     C     *INKC         CABEQ     '1'           ENDPGM
 
     C* IF CK/12 WAS TAKEN ON THE FIRST SCREEN, THEN GO TO END OF PROGRAM
 
     C     *INKL         CABEQ     '1'           ENDPGM
 
     C* ACCESS (THEN RELEASE) THE AUDIT FILE HEADER
 
     C                   MOVEL     *BLANK        FHDATA
     C     GPAUFLK       CHAIN     GPAUFLD0                           90
     C  N90              UPDATE    GPAUFLD0
     C                   MOVEL     FHDATA        SHDATA
 
     C* DISPLAY THE SECOND SCREEN  (DESCRIPTION ETC)
 
     C                   Z-ADD     99            ER
     C                   MOVEL     HLP(2)        DDHELP
     C                   MOVEA     '1'           *IN(71)                        PROT FILE NAME
     C     ER            DOWNE     *ZERO
     C                   EXSR      SECOND
     C                   END
 
     C* IF CK/3 WAS TAKEN ON THE SECOND SCREEN, THEN GO TO END OF PROGRAM
 
     C     *INKC         CABEQ     '1'           ENDPGM
 
     C* IF CK/12 WAS TAKEN ON THE SECOND SCREEN, THEN GO TO END OF PROGRAM
 
     C     *INKL         CABEQ     '1'           ENDPGM
 
     C* CLEAR THE AUDIT FILES
 
     C                   EXSR      AUFL
     C                   EXSR      AUFD
     C                   EXSR      AURN
     C                   EXSR      AUAS
     C     ENDPGM        TAG
     C                   SETON                                        LR
 
      /SPACE 5
      ********************************************************************
      * Display the first screen
      ********************************************************************
     C     FIRST         BEGSR
     C                   WRITE     HEADINGS
     C                   WRITE     FIRSTSCR
     C                   WRITE     SUBMESS
     C                   READ      FIRSTSCR                               99    *
     C                   MOVEL     *BLANK        DDERR
     C* CK/3
     C     *INKC         IFEQ      '1'
     C                   MOVEL     'EXIT  '      RETC
     C                   Z-ADD     *ZERO         ER
     C                   ELSE
     C* CK/12
     C     *INKL         IFEQ      '1'
     C                   MOVEL     'EXIT  '      RETC
     C                   Z-ADD     *ZERO         ER
     C                   ELSE
     C* ENTER
     C                   EXSR      VALFST
     C                   END
     C                   END
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Validate the first screen
      ********************************************************************
     C     VALFST        BEGSR
 
     C                   Z-ADD     0             ER
     C                   MOVEA     '00000000'    *IN(41)
 
     C* IF FILE TO BE SELECTED
 
     C     AFFILE        IFEQ      '?'
     C                   CALL      'GPAU0005'                           9999    *
     C                   PARM      *BLANK        RETC
     C                   PARM      *BLANK        AFFILE
     C                   PARM      *BLANK        AFRCID
     C                   EXSR      CHKERR
     C     RETC          IFEQ      'EXIT  '
     C                   MOVE      '1'           *INKC
     C                   Z-ADD     *ZERO         ER
     C                   GOTO      EFIRST
     C                   END
     C                   END
 
     C* FILE NAME MUST BE DEFINED
 
     C     AFFILE        IFEQ      *BLANK
     C     ER            IFEQ      0
     C                   Z-ADD     1             ER
     C                   END
     C                   MOVE      '1'           *IN41
     C                   ELSE
 
     C* ACCESS AUDIT FILE HEADER
 
     C     GPAUFLK       CHAIN     GPAUFLD0                           90
 
     C* FILE/RECORD ID MUST EXIST
 
     C     *IN90         IFEQ      '1'
     C     ER            IFEQ      0
     C                   Z-ADD     2             ER
     C                   END
     C                   MOVE      '1'           *IN41
     C                   MOVE      '1'           *IN42
     C                   END
 
     C* IF IT DOES EXIST, USER MUST BE AUTHORIZED TO IT
     C* AND IT MUST BE INACTIVE
 
     C     *IN90         IFEQ      '0'
     C     AFAUTH        ANDEQ     'O'
     C     AFUSRI        ANDNE     USRID
     C     *IN90         OREQ      '0'
     C     AFACTV        ANDEQ     'Y'
     C     ER            IFEQ      0
     C                   Z-ADD     3             ER
     C                   END
     C                   MOVE      '1'           *IN41
     C                   MOVE      '1'           *IN42
     C                   END
 
     C                   END
 
     C* IF ERROR, OUTPUT MESSAGE
 
     C     ER            IFNE      *ZERO
     C                   MOVEA     ERR(ER)       DDERR
     C                   END
     C     EFIRST        ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Display the second screen
      ********************************************************************
     C     SECOND        BEGSR
     C                   WRITE     HEADINGS
     C                   WRITE     FIRSTSCR
     C                   WRITE     SECNDSCR
     C                   WRITE     SUBMESS
     C                   READ      SECNDSCR                               99    *
     C                   MOVEL     *BLANK        DDERR
     C* CK/3
     C     *INKC         IFEQ      '1'
     C                   MOVEL     'EXIT  '      RETC
     C                   Z-ADD     *ZERO         ER
     C                   ELSE
     C* CK/12
     C     *INKL         IFEQ      '1'
     C                   MOVEL     'ABAND '      RETC
     C                   Z-ADD     *ZERO         ER
     C                   ELSE
     C* CK/10
     C     *INKJ         IFEQ      '1'
     C                   MOVEL     'ABAND '      RETC
     C                   Z-ADD     *ZERO         ER
     C                   ELSE
     C                   Z-ADD     4             ER
     C                   MOVEA     ERR(ER)       DDERR
     C                   END
     C                   END
     C                   END
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Clear file
      ********************************************************************
     C     AUFL          BEGSR
 
     C* DELETE EXISTING RECORDS FOR FILE
 
     C     GPAUFLK       SETLL     GPAUFLD0
     C     GPAUFLK       READE     GPAUFLD0                               90    *
     C     *IN90         DOWEQ     '0'
     C                   DELETE    GPAUFLD0
     C     GPAUFLK       READE     GPAUFLD0                               90    *
     C                   END
     C                   ENDSR
      **********************************************************************
      /SPACE 5
      ********************************************************************
      * Clear file
      ********************************************************************
     C     AUFD          BEGSR
 
     C* DELETE EXISTING RECORDS FOR FILE
 
     C     GPAUFLK       SETLL     GPAUFDD0
     C     GPAUFLK       READE     GPAUFDD0                               90    *
     C     *IN90         DOWEQ     '0'
     C                   DELETE    GPAUFDD0
     C     GPAUFLK       READE     GPAUFDD0                               90    *
     C                   END
     C                   ENDSR
      **********************************************************************
      /SPACE 5
      ********************************************************************
      * Clear file
      ********************************************************************
     C     AURN          BEGSR
 
     C* DELETE EXISTING RECORDS FOR FILE
 
     C     GPAUFLK       SETLL     GPAURND0
     C     GPAUFLK       READE     GPAURND0                               90    *
     C     *IN90         DOWEQ     '0'
     C                   DELETE    GPAURND0
     C     GPAUFLK       READE     GPAURND0                               90    *
     C                   END
     C                   ENDSR
      **********************************************************************
      /SPACE 5
      ********************************************************************
      * Clear file
      ********************************************************************
     C     AUAS          BEGSR
 
     C* DELETE EXISTING RECORDS FOR FILE
 
     C     GPAUFLK       SETLL     GPAUASD0
     C     GPAUFLK       READE     GPAUASD0                               90    *
     C     *IN90         DOWEQ     '0'
     C                   DELETE    GPAUASD0
     C     GPAUFLK       READE     GPAUASD0                               90    *
     C                   END
     C                   ENDSR
      **********************************************************************
      /SPACE 5
      ********************************************************************
      * Initial processing
      ********************************************************************
     C     INIT          BEGSR
 
     C*  PARAMETERS PASSED
 
     C     *ENTRY        PLIST
     C                   PARM                    RETC              6
     C                   PARM                    AFFILE
     C                   PARM                    AFRCID
     C                   PARM                    PPDESC           50
 
     C* KEY LISTS
 
     C     GPAUFLK       KLIST
     C                   KFLD                    AFFILE
     C                   KFLD                    AFRCID
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Check for error
      ********************************************************************
     C     CHKERR        BEGSR
 
     C* ERROR ON CALL OF PROGRAM
 
     C     *IN99         IFEQ      '1'
     C     ERROR         ANDNE     1
     C                   EXSR      *PSSR
     C                   END
     C                   ENDSR
      **********************************************************************
      /SPACE 5
      ********************************************************************
      * *PSSR Processing
      ********************************************************************
     C     *PSSR         BEGSR
     C                   DUMP
     C                   MOVEL     '*CANCL'      RETURN            6
     C                   ENDSR     RETURN
      **********************************************************************
** ERR
File Name must be defined
File Name/Record ID does not exist
You are not authorized to this file/record ID or it is active
To delete this file/record ID take CK/10
** HLP
Enter File Name; CK/3=Exit
CK/3=Exit, CK/10=Delete This File, CK/12=Abandon
