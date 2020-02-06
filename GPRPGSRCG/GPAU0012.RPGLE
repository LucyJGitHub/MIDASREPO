     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Report Layout Generation')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAU0012 - Report Layout Generation                          *
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
 
     FGPAU0012DFCF   E             WORKSTN
     FGPAUFLL1  UF   E           K DISK    INFSR(*PSSR)
     FGPAUFDL4  UF   E           K DISK    INFSR(*PSSR)
     FGPAURNL1  UF A E           K DISK    INFSR(*PSSR)
 
     D WKA             S              1    DIM(30)
     D ERR             S             76    DIM(2) CTDATA PERRCD(1)
 
     D PSDS           SDS
     D  ERROR            *STATUS
     D  WKSID                244    253
     D  USRID                254    263
     IGPAUFDD0
     I              AFFLDN                      XXFLDN
     I              AFLN                        XXLN
     I              AFPS                        XXPS
 
     C* INITIAL PROCESSING
 
     C                   EXSR      INIT
 
     C* ACCESS THE AUDIT FILE FOR THE REPORT LAYOUT AND FIELD SPACING
 
     C     GPAUFLK       CHAIN     GPAUFLD0                           90        *
     C  N90              UPDATE    GPAUFLD0                                     * RELEASE
     C                   MOVEL     AFLAYO        SSLAYO
     C                   MOVEL     AFFDSP        SSFDSP
 
     C* DISPLAY THE SCREEN
 
     C                   Z-ADD     99            ER                2 0
     C     ER            DOWNE     *ZERO
     C                   EXSR      DSPLAY
     C                   END
 
     C                   SETON                                        LR
 
      /SPACE 5
      *****************************************************************
      * Display screen
      *****************************************************************
     C     DSPLAY        BEGSR
     C                   WRITE     MESSAG
     C                   WRITE     MAIN
     C                   READ      MAIN                                   99    *
     C                   MOVEL     *BLANK        DDERR            76
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
     C                   EXSR      VALDSP
     C                   END
     C                   END
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Validate display
      *****************************************************************
     C     VALDSP        BEGSR
 
     C                   Z-ADD     0             ER
     C                   MOVEA     '00'          *IN(41)
 
     C** VALIDATE REPORT LAYOUT
 
     C     SSLAYO        IFNE      'C'
     C     SSLAYO        ANDNE     'R'
     C                   Z-ADD     1             ER
     C                   MOVE      '1'           *IN41
     C                   END
 
     C* REPORT FIELD SPACING MUST BE '1' TO '9'
 
     C     SSFDSP        IFNE      '1'
     C     SSFDSP        ANDNE     '2'
     C     SSFDSP        ANDNE     '3'
     C     SSFDSP        ANDNE     '4'
     C     SSFDSP        ANDNE     '5'
     C     SSFDSP        ANDNE     '6'
     C     SSFDSP        ANDNE     '7'
     C     SSFDSP        ANDNE     '8'
     C     SSFDSP        ANDNE     '9'
     C     ER            IFEQ      0
     C                   Z-ADD     2             ER
     C                   END
     C                   MOVE      '1'           *IN42
     C                   END
 
     C* IF ERROR, OUTPUT MESSAGE
 
     C     ER            IFNE      *ZERO
     C                   MOVEA     ERR(ER)       DDERR
     C                   ELSE
     C                   EXSR      REPLAY
     C                   END
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Report layout
      *****************************************************************
     C     REPLAY        BEGSR
 
     C* UPDATE THE AUDIT FILE WITH THE REPORT LAYOUT AND FIELD SPACING
 
     C     GPAUFLK       CHAIN     GPAUFLD0                           90        *
     C                   MOVEL     SSLAYO        AFLAYO
     C                   MOVEL     SSFDSP        AFFDSP
     C  N90              UPDATE    GPAUFLD0
 
     C* DELETE ALL REPORT NARRATIVE
 
     C     GPAUFLK       SETLL     GPAURND0
     C     GPAUFLK       READE     GPAURND0                               90    *
     C     *IN90         DOWEQ     '0'
     C                   DELETE    GPAURND0
     C     GPAUFLK       READE     GPAURND0                               90    *
     C                   END
 
     C                   Z-ADD     *ZERO         AFFLDN
     C                   Z-ADD     1             AFLN              3 0
     C                   Z-ADD     1             AFPS              3 0
 
     C* ACCESS ALL FIELDS SELECTED
 
     C     GPAUFLK       SETLL     GPAUFDD0
     C     GPAUFLK       READE     GPAUFDD0                               90    *
     C  N90AFRSEQ        COMP      99999                                  90    *
 
     C* COLUMNS REQUIRED AND FIRST RECORD READ - SET LINE 1
 
     C     SSLAYO        IFEQ      'C'
     C  N90AFSPCB        ADD       4             LineNo1           3 0
     C  N90              Z-ADD     *ZERO         AFSPCB
     C                   END
 
     C* DO WHILE FIELDS READ FOR REPORTING
 
     C     *IN90         DOWEQ     '0'
 
     C* COLUMNS REQUIRED
 
     C     SSLAYO        IFEQ      'C'
     C                   EXSR      PROCOL
     C                   ELSE
 
     C* ROWS REQUIRED
 
     C                   EXSR      PROROW
     C                   END
 
     C     GPAUFLK       READE     GPAUFDD0                               90    *
     C  N90AFRSEQ        COMP      99999                                  90    *
     C                   END
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Process columns
      *****************************************************************
     C     PROCOL        BEGSR
 
     C* IF SPACE BEFORE, ADVANCE TO ROWS
 
     C     AFSPCB        IFNE      *ZERO
     C                   MOVEL     'R'           SSLAYO
     C                   EXSR      PROROW
     C                   ELSE
 
     C* DETERMINE LARGEST COLUMN HEADING
 
     C* COL1
     C                   MOVE      *BLANK        WKA
     C                   MOVEA     AFCOL1        WKA
     C                   EXSR      DETCSZ
     C                   Z-ADD     EP            LEP               3 0
     C* COL2
     C                   MOVE      *BLANK        WKA
     C                   MOVEA     AFCOL2        WKA
     C                   EXSR      DETCSZ
     C     EP            IFGT      LEP
     C                   Z-ADD     EP            LEP
     C                   END
     C* COL3
     C                   MOVE      *BLANK        WKA
     C                   MOVEA     AFCOL3        WKA
     C                   EXSR      DETCSZ
     C     EP            IFGT      LEP
     C                   Z-ADD     EP            LEP
     C                   END
 
     C* CHECK IF EDITED FIELD SIZE EXCEEDS LARGEST COLUMN HEADING
 
     C     AFEDTS        IFGT      LEP
     C                   Z-ADD     AFEDTS        LEP
     C                   END
 
     C                   ADD       LEP           AFPS
     C                   SUB       1             AFPS
 
     C* IF END OF LINE, GO TO PROCESSING ROWS
 
     C     AFPS          IFGT      132
     C                   MOVEL     'R'           SSLAYO
     C                   EXSR      PROROW
     C                   ELSE
     C                   SUB       LEP           AFPS                           * RESTORE TO
     C                   ADD       1             AFPS                             ORIGINAL VALUE
 
     C* WRITE COLUMN HEADING RECORDS TO GPAURNPD
 
     C     AFCOL1        IFNE      *BLANK
     C                   MOVEL     *BLANK        AFNARR
     C                   MOVEL     AFCOL1        AFNARR
     C                   Z-ADD     LEP           AFDIG
     C                   Z-ADD     1             AFLN
     C                   ADD       1             AFFLDN
     C                   WRITE     GPAURND0
     C                   END
     C     AFCOL2        IFNE      *BLANK
     C                   MOVEL     *BLANK        AFNARR
     C                   MOVEL     AFCOL2        AFNARR
     C                   Z-ADD     LEP           AFDIG
     C                   Z-ADD     2             AFLN
     C                   ADD       1             AFFLDN
     C                   WRITE     GPAURND0
     C                   END
     C     AFCOL3        IFNE      *BLANK
     C                   MOVEL     *BLANK        AFNARR
     C                   MOVEL     AFCOL3        AFNARR
     C                   Z-ADD     LEP           AFDIG
     C                   Z-ADD     3             AFLN
     C                   ADD       1             AFFLDN
     C                   WRITE     GPAURND0
     C                   END
 
     C* SET THE FIELD TO ITS LINE/POSITION
 
     C                   Z-ADD     LineNo1       AFLN
     C                   Z-ADD     LineNo1       XXLN
     C     AFPS          IFNE      1
     C                   Z-ADD     AFPS          XXPS
     C                   ELSE
     C                   Z-ADD     2             XXPS
     C                   Z-ADD     2             AFPS
     C                   END
     C                   EXCEPT    U_GPAUFD
 
     C* ADVANCE TO NEXT POSITION
 
     C                   ADD       LEP           AFPS
     C                   ADD       1             AFPS
     C                   END
     C                   END
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Process rows
      *****************************************************************
     C     PROROW        BEGSR
 
     C* IF SPACE BEFORE
 
     C     AFSPCB        IFNE      *ZERO
     C                   ADD       AFSPCB        AFLN
     C                   Z-ADD     1             AFPS
     C                   END
 
     C* IF NO DESCRIPTION DEFINED, USE SHORTNAME
 
     C     AFFDES        IFEQ      *BLANK
     C                   MOVEL     AFSNAM        AFFDES
     C                   END
 
     C* DETERMINE SIZE OF DESCRIPTION
 
     C                   MOVE      *BLANK        WKA
     C                   MOVEA     AFFDES        WKA
     C                   Z-ADD     30            X
     C     *IN99         DOUEQ     '1'
     C     WKA(X)        IFNE      *BLANK
     C                   MOVE      '1'           *IN99
     C                   ELSE
     C                   SUB       1             X                        99    *
     C                   END
     C                   END
 
     C* STORE SIZE OF DESCRIPTION
 
     C                   Z-ADD     X             SZD               3 0
 
     C* DETERMINE START POSITION OF SHORTNAME
 
     C     AFPS          ADD       SZD           SPS               3 0
     C                   ADD       1             SPS
 
     C* DETERMINE END POSITION OF SHORTNAME
 
     C     SPS           ADD       AFEDTS        EPS               3 0
     C                   SUB       1             EPS
 
     C* IF END OF LINE, GO TO NEXT ROW
 
     C     EPS           IFGT      132
     C                   ADD       1             AFLN
     C                   Z-ADD     1             AFPS
     C     AFPS          ADD       SZD           SPS
     C                   ADD       1             SPS
     C     SPS           ADD       AFEDTS        EPS
     C                   SUB       1             EPS
     C                   END
 
     C* WRITE DESCRIPTION RECORD TO GPAURNPD
 
     C                   MOVEL     *BLANK        AFNARR
     C                   MOVEL     AFFDES        AFNARR
     C                   Z-ADD     SZD           AFDIG
     C     SZD           IFLE      24
     C                   ADD       1             AFFLDN
     C                   WRITE     GPAURND0
     C                   ELSE
     C                   Z-ADD     24            AFDIG
     C                   ADD       1             AFFLDN
     C                   WRITE     GPAURND0
     C                   ADD       24            AFPS
     C                   MOVE      AFFDES        WRK6              6
     C                   MOVEL     *BLANK        AFNARR
     C                   MOVEL     WRK6          AFNARR
     C     SZD           SUB       24            AFDIG
     C                   ADD       1             AFFLDN
     C                   WRITE     GPAURND0
     C                   END
 
     C* SET THE FIELD TO ITS LINE/POSITION
 
     C                   Z-ADD     AFLN          XXLN
     C                   Z-ADD     SPS           XXPS
     C                   EXCEPT    U_GPAUFD
 
     C* ADVANCE TO NEXT POSITION
 
     C     EPS           ADD       1             AFPS
     C                   ADD       AFFDSP        AFPS
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Determine column size
      *****************************************************************
     C     DETCSZ        BEGSR
     C                   Z-ADD     *ZERO         EP                3 0
     C                   Z-ADD     17            X                 3 0
     C     X             DOUEQ     *ZERO
     C     WKA(X)        IFNE      *BLANK
     C                   Z-ADD     X             EP
     C                   Z-ADD     *ZERO         X
     C                   ELSE
     C                   SUB       1             X
     C                   END
     C                   END
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Initial processing
      *****************************************************************
     C     INIT          BEGSR
 
     C*  PARAMETERS PASSED
 
     C     *ENTRY        PLIST
     C                   PARM                    RETC              6
     C                   PARM                    AFFILE
     C                   PARM                    AFRCID
     C                   PARM                    AFDESC
 
     C* KEY LISTS
 
     C     GPAUFLK       KLIST
     C                   KFLD                    AFFILE
     C                   KFLD                    AFRCID
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * *PSSR processing
      *****************************************************************
     C     *PSSR         BEGSR
     C                   DUMP
     C                   MOVEL     '*CANCL'      RETURN            6
     C                   ENDSR     RETURN
      **********************************************************************
     OGPAUFDD0  E            U_GPAUFD
     O                       XXLN
     O                       XXPS
** ERR
Layout code must be 'C' (columns then rows), or 'R' (rows)
Field Spacing must be 1 to 9
