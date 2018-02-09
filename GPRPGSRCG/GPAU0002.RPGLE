     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Create a New Audit File')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAU0002 - Create a New Audit File                           *
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
 
     FGPAU0002DFCF   E             WORKSTN
     FGPAUFLL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GPAUFLD0:GPAUFLDX)
     FGPAUFLL1  UF A E           K DISK    INFSR(*PSSR)
     FGPAUFDL3  IF   E           K DISK    INFSR(*PSSR)
     FGPAUIPPD  IF   E           K DISK    INFSR(*PSSR)
 
     D WKV             S              1    DIM(10)
     D ERR             S             76    DIM(20) CTDATA PERRCD(1)
     D HLP             S             76    DIM(2) CTDATA PERRCD(1)
     D CHAR            S              1    DIM(39) CTDATA PERRCD(39)
     D CHK             S              1    DIM(47) CTDATA PERRCD(47)
 
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
 
     IGPAUFLDX
     I              AFFILE                      XXFILE
     I              AFRCID                      XXRCID
 
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
 
     C* WRITE OR UPDATE THE AUDIT FILE HEADER
 
     C                   MOVEL     *BLANK        FHDATA
     C     GPAUFLK       CHAIN     GPAUFLD0                           90
     C                   MOVEL     USRID         AFUSRI
     C  N90              UPDATE    GPAUFLD0
     C   90              WRITE     GPAUFLD0
     C                   MOVEL     FHDATA        SHDATA
 
     C* FIELD RETRIEVAL
 
     C                   CALL      'GPAU0008'
     C                   PARM      *BLANK        RETC              6
     C                   PARM                    AFFILE
     C                   PARM                    AFRCID
     C                   PARM                    AFDESC           40
     C                   EXSR      CHKERR
 
     C* DISPLAY THE SECOND SCREEN  (DESCRIPTION ETC)
 
     C                   Z-ADD     99            ER
     C                   MOVEL     HLP(2)        DDHELP
     C                   MOVEA     '1'           *IN(70)                        POSITION CURSOR
     C                   MOVEA     '1'           *IN(71)                        PROT FILE NAME
     C     ER            DOWNE     *ZERO
     C                   EXSR      SECOND
     C                   END
 
     C* IF CK/3 WAS TAKEN ON THE SECOND SCREEN, THEN GO TO END OF PROGRAM
 
     C     *INKC         CABEQ     '1'           ENDPGM
 
     C* IF CK/12 WAS TAKEN ON THE SECOND SCREEN, THEN GO TO END OF PROGRAM
 
     C     *INKL         CABEQ     '1'           ENDPGM
 
     C* WRITE OR UPDATE THE AUDIT FILE HEADER
 
     C     GPAUFLK       CHAIN     GPAUFLD0                           90
     C                   MOVEL     SHDATA        FHDATA
     C     AFRIFD        IFNE      *BLANK
     C                   Z-ADD     AFFOBO        AFRIOB
     C                   Z-ADD     AFLEN         AFRILN
     C                   ENDIF
     C  N90              UPDATE    GPAUFLD0
     C  N90              MOVEL     AFDESC        PPDESC
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
 
     C* FILE NAME MUST BE DEFINED
 
     C     AFFILE        IFEQ      *BLANK
     C     ER            IFEQ      0
     C                   Z-ADD     1             ER
     C                   END
     C                   MOVE      '1'           *IN41
     C                   END
 
     C* FILE NAME MUST CONTAIN VALID CHARACTERS AND NO EMBEDDED BLANKS
 
     C                   MOVEA     AFFILE        WKV
     C                   EXSR      VALCHR
     C* INVALID CHARACTERS
     C     VERR          IFEQ      'V'
     C     ER            IFEQ      0
     C                   Z-ADD     2             ER
     C                   END
     C                   MOVE      '1'           *IN(41)
     C                   END
     C* EMBEDDED BLANKS
     C     VERR          IFEQ      'E'
     C     ER            IFEQ      0
     C                   Z-ADD     3             ER
     C                   END
     C                   MOVE      '1'           *IN(41)
     C                   END
     C* FIRST CHARACTER IS A NUMBER
     C     VERR          IFEQ      'F'
     C     ER            IFEQ      0
     C                   Z-ADD     4             ER
     C                   END
     C                   MOVE      '1'           *IN(41)
     C                   END
 
     C* FILE MUST EXIST
 
     C     AFFILE        IFNE      *BLANK
     C                   Z-ADD     47            MESLEN           15 5
     C                   MOVEA     AFFILE        CHK(12)
     C                   CALL      'QCMDEXC'                            9999
     C                   PARM                    CHK
     C                   PARM                    MESLEN
     C     *IN99         IFEQ      '1'
     C     ER            IFEQ      0
     C                   Z-ADD     5             ER
     C                   END
     C                   MOVE      '1'           *IN41
     C                   END
 
     C* ACCESS FILE TO BE CREATED
 
     C                   MOVEL     *BLANK        FHDATA
     C     GPAUFLK       CHAIN     GPAUFLDX                           90
 
     C* FILE NAME/RECORD ID MUST NOT EXIST
 
     C     *IN90         IFEQ      '0'
     C     ER            IFEQ      0
     C                   Z-ADD     6             ER
     C                   END
     C                   MOVE      '1'           *IN41
     C                   MOVE      '1'           *IN42
     C                   END
     C                   END
 
     C* IF ERROR, OUTPUT MESSAGE
 
     C     ER            IFNE      *ZERO
     C                   MOVEA     ERR(ER)       DDERR
     C                   END
     C                   ENDSR
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
     C* ENTER
     C                   EXSR      VALSEC
     C                   END
     C                   END
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Validate the second screen
      ********************************************************************
     C     VALSEC        BEGSR
 
     C                   Z-ADD     0             ER
     C                   MOVEA     '000000000'   *IN(41)
     C                   MOVE      '0'           *IN70
 
     C* DESCRIPTION MUST BE DEFINED
 
     C     SSDESC        IFEQ      *BLANK
     C     ER            IFEQ      0
     C                   Z-ADD     11            ER
     C                   END
     C                   MOVE      '1'           *IN43
     C                   MOVE      '1'           *IN70
     C                   END
 
     C* INPUT MUST BE VALID
     C     SSINPT        IFEQ      '?'                                          B2
     C                   CALL      'GPAU0017'                           9999    *
     C                   PARM      *BLANK        RETC
     C                   PARM      *BLANK        SSINPT
     C                   EXSR      CHKERR
     C     RETC          IFEQ      'EXIT  '
     C                   MOVE      '1'           *INKC
     C                   Z-ADD     *ZERO         ER
     C                   GOTO      EVALSEC
     C                   END
     C                   END                                                    E2
 
     C     SSINPT        CHAIN     GPAUIPD0                           99        *
     C     *IN99         IFEQ      *ON
     C     ER            IFEQ      0
     C                   Z-ADD     12            ER
     C                   END
     C                   MOVE      '1'           *IN44
     C                   END
 
     C* RECORD ID FIELD MUST BE INPUT IF RECORD ID IS PRESENT
     C* ELSE IT MUST BE BLANK
 
     C     SSRIFD        IFEQ      *BLANK
     C     AFRCID        ANDNE     *BLANK
     C     SSRIFD        ORNE      *BLANK
     C     AFRCID        ANDEQ     *BLANK
     C     ER            IFEQ      0
     C                   Z-ADD     13            ER
     C                   END
     C                   MOVE      '1'           *IN45
     C                   END
 
     C* RECORD ID FIELD IS NOT A FIELD IN THE FILE
 
     C     SSRIFD        IFNE      *BLANK
     C     AFRCID        ANDNE     *BLANK
     C     GPAUFDK       CHAIN     GPAUFDD0                           99        *
     C     *IN99         IFEQ      *ON
     C     ER            IFEQ      0
     C                   Z-ADD     14            ER
     C                   END
     C                   MOVE      '1'           *IN45
     C                   END
     C                   END
 
     C* REPORT LAYOUT MUST BE 'C' OR 'R' OR BLANK
 
     C     SSLAYO        IFNE      'C'
     C     SSLAYO        ANDNE     'R'
     C     SSLAYO        ANDNE     ' '
     C     ER            IFEQ      0
     C                   Z-ADD     15            ER
     C                   END
     C                   MOVE      '1'           *IN46
     C                   END
 
     C* REPORT FIELD SPACING MUST BE BLANK OR '1' TO '9'
 
     C     SSFDSP        IFNE      ' '
     C     SSFDSP        ANDNE     '0'
     C     SSFDSP        ANDNE     '1'
     C     SSFDSP        ANDNE     '2'
     C     SSFDSP        ANDNE     '3'
     C     SSFDSP        ANDNE     '4'
     C     SSFDSP        ANDNE     '5'
     C     SSFDSP        ANDNE     '6'
     C     SSFDSP        ANDNE     '7'
     C     SSFDSP        ANDNE     '8'
     C     SSFDSP        ANDNE     '9'
     C     ER            IFEQ      0
     C                   Z-ADD     16            ER
     C                   END
     C                   MOVE      '1'           *IN47
     C                   END
 
     C* AUTHORITY MUST BE 'A' OR 'U'
 
     C     SSAUTH        IFNE      'A'
     C     SSAUTH        ANDNE     'O'
     C     ER            IFEQ      0
     C                   Z-ADD     17            ER
     C                   END
     C                   MOVE      '1'           *IN48
     C                   END
 
     C* ACTIVE MUST BE 'Y' OR 'N'
 
     C     SSACTV        IFNE      'Y'
     C     SSACTV        ANDNE     'N'
     C     ER            IFEQ      0
     C                   Z-ADD     18            ER
     C                   END
     C                   MOVE      '1'           *IN49
     C                   END
 
     C* IF ERROR, OUTPUT MESSAGE
 
     C     ER            IFNE      *ZERO
     C                   MOVEA     ERR(ER)       DDERR
     C                   END
     C     EVALSEC       ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Validate character field
      ********************************************************************
     C     VALCHR        BEGSR
 
     C* VERR: 'V' RETURNED IF INVALID CHARACTER.
     C*       'E' RETURNED IF EMBEDDED BLANK.
     C*       'F' RETURNED IF FIRST CHARACTER IS A NUMBER
 
     C                   MOVEL     *BLANK        VERR              1
     C                   Z-ADD     1             V1                3 0
     C     V1            DOUGT     10                                           B1
     C* VALID CHAR
     C                   MOVEL     WKV(V1)       VWK               1
     C                   Z-ADD     1             V2                3 0
     C     VWK           LOOKUP    CHAR(V2)                               99    *
     C     *IN99         IFEQ      '0'                                          B2
     C                   MOVEL     'V'           VERR
     C                   Z-ADD     10            V1
     C                   ELSE                                                   X2
     C* EMBEDDED
     C     V1            IFGT      1                                            B3
     C                   SUB       1             V1
     C                   MOVEL     WKV(V1)       VWK
     C                   ADD       1             V1
     C     WKV(V1)       IFNE      *BLANK                                       B4
     C     VWK           ANDEQ     *BLANK
     C                   MOVEL     'E'           VERR
     C                   Z-ADD     10            V1
     C                   END                                                    E4
     C                   ELSE                                                   X3
     C* 1ST CHARACTER CAN'T BE A NUMBER
     C     V2            IFGE      30                                           B4
     C                   MOVEL     'F'           VERR
     C                   Z-ADD     10            V1
     C                   END                                                    E4
     C                   END                                                    E3
     C                   END                                                    E2
     C                   ADD       1             V1
     C                   END                                                    E1
     C                   ENDSR
      ********************************************************************
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
     C                   PARM                    COPY              1
 
     C* KEY LISTS
 
     C     GPAUFLK       KLIST
     C                   KFLD                    AFFILE
     C                   KFLD                    AFRCID
     C     GPAUFDK       KLIST
     C                   KFLD                    AFFILE
     C                   KFLD                    AFRCID
     C                   KFLD                    SSRIFD
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
File Name contains invalid characters
Embedded blanks in File Name
First character of File Name cannot be a number
File does not exist
File Name/Record ID must not exist
 
 
 
 
Description must be defined
Invalid Input
Record ID field must be input if record ID is present, else it must be blank
Record ID field is not a field in the file
Report Layout must be 'C' for columns (then rows), or 'R' for rows, or blank
Report Field Spacing must be 1 to 9, or blank
Authority must be A for 'All' or 'O' for 'Owner Only'
Active must be 'Y' or 'N'
 
 
** HLP
Enter File Name; CK/3=Exit
Enter details; CK/3=Exit, CK/12=Abandon,
** CHAR
 ABCDEFGHIJKLMNOPQRSTUVWXYZ#@0123456789
** CHK
CHKOBJ OBJ(          ) OBJTYPE(*FILE) AUT(*USE)
