     H DEBUG
     F*****************************************************************
/*OVR *  CRTSRCPF FILE(QTEMP/SOURCEF) RCDLEN(112)                     *
/*OVR *  CRTSRCPF FILE(QTEMP/COPYSRC) RCDLEN(112)                     *
/*S*D****RPGBASE*******************************************************                       CUT008
/*STD *  RPGBASEBND                                                   *                       CUT008
/*EXI *  TEXT('Midas UT Expand source program')                       *
      *****************************************************************
      *                                                               *
      *  Midas Utilities Module                                       *
      *                                                               *
      *  UT0015  - Expand source code to include:                     *
      *          - External file record layouts                       *
      *          - /COPY members                                      *
      *                                                               *
      *  Called By: UTC0016 - Expand source main program              *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CUT008             Date 22Feb11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CPK018             Date 26Apr04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 178905             Date 17May00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPK008             DATE 13Feb97               *
      *                 CAAA01             DATE 10JAN96               *
      *                 095167             DATE 27OCT95               *
      *                 092401             DATE 29AUG95               *
      *                 079709             DATE 05DEC94               *
      *                 078080             DATE 28OCT94               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CUT008 - CRTOBJ rewrite.  QUSRTVUS returns extra data at     *
      *           V5R4M0.                                             *
      *           Amend so that UT0015 extands sources for RGPLE      *
      *           CLLE.                                               *
      *           Convert this program to ILE.                        *
      *  CPK018 - MidasPlus packaging.  Move to global layer.         *
      *  178905 - Program cannot identify F-spec continuation line;   *
      *           calls CHKOBJ with blank file name.                  *
      *  CPK008 - DBA R2 packaging:                                   *
      *           - Changes for source being 112 long.                *
      *  CAAA01 - Allow expanded source to be retained for Midas GUI  *
      *           Collector to run and make bold printing optional    *
      *           for EXPSRC (now UT0015)                             *
      *  095167 - Allow /COPY source file to be > 8 chars long        *
      *  092401 - Ensure that the /COPY member is picked up from      *
      *           the library list.                                   *
      *  079709 - QUSRTVUS returns extra data at V2R3M0               *
      *  078080 - Expand layout of external data structures           *
      *                                                               *
      *****************************************************************
     F/EJECT
      *
     FSOURCEF   IF   E             DISK
     F                                     RENAME(SOURCEF:SOURCE)
     FCOPYSRC   IF   E             DISK    USROPN
     F                                     RENAME(COPYSRC:CPYSCF)
     FUT0015P1  O    E             PRINTER
     F                                     INFDS(PRINT)
     F*
     F/EJECT
     F*********************************************************************
     F*                                                                   *
     F*            FUNCTION OF INDICATORS                                 *
     F*                                                                   *
     F*    17      WHEN 'F' SPEC                                          *
     F*    18      WHEN '/COPY' MEMBER                                    *
     F*                                                                   *
     F*    19      SPECIFIES 'HIGHLIGHT' ON REPORT LINE                   *
     F*                                                                   *
     F*    27      SPECIFIES BEGINNING OR END OF 'F' SPEC                 *
     F*    28      SPECIFIES BEGINNING OR END OF '/COPY' MEMBER           *
     F*                                                                   *
     F*    37      SPECIFIES BOLD TYPE (WRITE LINE TWICE) ON 'F' SPEC     *
     F*    38      SPECIFIES BOLD TYPE (WRITE LINE TWICE) ON '/COPY'      *
     F*                                                                   *
     F*    47      MANUAL 'OPEN' FOR 'EXPSRCEX' FILE                      *
     F*                                                                   *
     F*    99      END OF FILE FOR 'SOURCEF'                              *
     F*    98      END OF FILE FOR 'EXPSRCEX'                             *
     F*    97      END OF FILE FOR 'COPYSRC '                             *
     F*                                                                   *
     F*       LR   LAST RECORD INDICATOR                                  *
     F*                                                                   *
     F*********************************************************************
     F/EJECT
     D*
     D**  DATA STRUCTURE TO IDENTIFY 'F' AND 'C' SPECS
     D*
     D                 DS
     D***********                             1  92 SRCLIN                CPK008
     D  SRCLIN                 1    112                                         CPK008
     D  SRCSEQ                 1      6  2
     D***********                            13  92 SRCDTA                CPK008
     D  SRCDTA                13    112                                         CPK008
     D  CLCOPY                13     19
     D  SPEC                  18     18
     D  FCOMM                 19     19
     D**EXTFIL                19     26                                                       CUT008
     D  EXTFL                 19     26                                                       CUT008
     D  EXTFLLE               19     28                                                       CUT008
     D  COPY                  19     23
     D  CLDATA                21     41
     D  CPYDTA                25     45
     D  EXTDS                 29     29                                         078080
     D  FORMAT                31     31
     D  DATAST                31     32                                         078080
     D  EXTDSF                33     42                                         078080
     D  FORMT2                34     34                                                       CUT008
     D  KEYWRD                56     92                                                       CUT008
     D*
     D PRINT           DS
     D  LINE                 367    368B 0
      *
      *    Data structures for QUSLFLD API
      *
     D INPUT           DS
     D  USRSPC                 1     20
     D  SPCNAM                 1     10
     D  SPCLIB                11     20
     D  OUTFMT                21     28
     D  FILLII                29     48
     D  FILNAI                29     38
     D  FILLBI                39     48
     D  RCDFMI                49     58
     D  OVRRID                59     59
      *
     D HEADER          DS
     D  FILLIH                 1     20
     D  FILNAH                 1     10
     D  FILLBH                11     20
     D  FILTYP                21     30
     D  RCDFMH                31     40
     D  RCDLEN                41     44B 0
     D  RCDID                 45     57
     D  TEXT                  58    107
     D  HDRRSV               108    256                                                       CUT008
      *
     D LIST            DS
     D  FLDNAM                 1     10
     D  DTATYP                11     11
     D  USAGE                 12     12
     D  OUTBUF                13     16B 0
     D  INPBUF                17     20B 0
     D  FLDLEN                21     24B 0
     D  DIGITS                25     28B 0
     D  DECPOS                29     32B 0
     D  DESCR                 33     82
     D  EDTCDE                83     84
     D  EDTLEN                85     88B 0
     D  EDTWRD                89    152
     D  COLHD1               153    172
     D  COLHD2               173    192
     D  COLHD3               193    212
     D  RESERV               213    288                                         079709
     D  RESEXX               289    544                                                       CUT008
      *
      *    Variable to hold list/entry size
      *
     D RCVVAR          DS
     D  OFFSET                 1      4B 0
     D  HDRSIZ                 5      8B 0
     D  NBRENT                 9     12B 0
     D  SIZENT                13     16B 0
     D                 DS
     D  LENDTA                 1      4B 0
     D  STRPOS                 5      8B 0
     D  LENSPC                 9     12B 0
     D  LENVAR                13     16B 0
      *
      *    Data structures for QUSLRCD API
      *
     D INPUT2          DS
     D  USSPC                  1     20
     D  SPCNM                  1     10
     D  SPCLB                 11     20
     D  FMTNAI                21     28
     D  FILLI2                29     48
     D  FILNA2                29     38
     D  FILLB2                39     48
     D  OVRID                 49     49
     D HDRFMT          DS
     D  FILLH2                 1     20
     D  FILNH2                 1     10
     D  LIBNH2                11     20
     D  FILTP2                21     30
     D  TEXT2                 31     80
     D  HFTRSV                81     97                                                       CUT008
     D LIST2           DS
     D  FMTNAL                 1     10
      *
     D RCVVR2          DS
     D  OFSET                  1      4B 0
     D  HDRSZ                  5      8B 0
     D  NOENT                  9     12B 0
     D  SZENT                 13     16B 0
     D                 DS
     D  LNDTA                  1      4B 0
     D  STPOS                  5      8B 0
     D  LNSPC                  9     12B 0
     D  LNVAR                 13     16B 0
      *                                                                                       CUT008
     D  EXTFIL         S             10                                                       CUT008
      * Variables to call program UT00027                                                     CUT008
      *                                                                                       CUT008
     D TxtToBeSrched   S            999                                                       CUT008
     D FndTxt          S            999                                                       CUT008
     D LArg            S             50                                                       CUT008
     D RArg            S             50                                                       CUT008
     D FndTxtPos       S              3  0                                                    CUT008
     D FndTxtLen       S              3  0                                                    CUT008
     D                                                                                        CUT008
     I/EJECT
     C     *ENTRY        PLIST
     C                   PARM                    SRCFIL           10
     C                   PARM                    SRCLIB           10
     C     SRCSEQ        PARM      SRCSEQ        SEQNO             6 2
     C                   PARM                    SRCMBR           10
     C*********            PARM           SRCTYP  4                                           CUT008
     C                   PARM                    SRCTYP           10                          CUT008
     C                   PARM                    BOLD              1            CAAA01
     C*
     C** Set up copyright parameter
     C*
     C** READ SOURCE MEMBER CODE FILE
     C*
     C                   READ      SOURCEF                                99
     C*
     C** LOOP UNTIL END OF SOURCE MEMBER CODE FILE
     C*
     C     *IN99         DOWEQ     '0'
     C*
     C** IF 'F' SPEC, NOT COMMENT OR SECONDARY LINE
     C**     DO SUBROUTINE 'FPROC'
     C*
     C     SRCTYP        IFEQ      'RPG'
     C     SPEC          ANDEQ     'F'
     C     FORMAT        ANDEQ     'E'
     C     FCOMM         ANDNE     '*'
     C*****EXTFIL        ANDNE     *BLANK                                                     CUT008
     C     EXTFL         ANDNE     *BLANK                                                     CUT008
     C     FCOMM         IFNE      '/'
     C                   MOVEL     EXTFL         EXTFIL                                       CUT008
     C                   EXSR      FPROC
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CUT008
     C     SRCTYP        IFEQ      'RPGLE'                                                    CUT008
     C     SPEC          ANDEQ     'F'                                                        CUT008
     C     FORMT2        ANDEQ     'E'                                                        CUT008
     C     FCOMM         ANDNE     '*'                                                        CUT008
     C     EXTFLLE       ANDNE     *BLANK                                                     CUT008
     C     FCOMM         IFNE      '/'                                                        CUT008
     C                   MOVEL     EXTFLLE       EXTFIL                                       CUT008
     C                   EXSR      FPROC                                                      CUT008
     C                   ENDIF                                                                CUT008
     C                   ENDIF                                                                CUT008
      *                                                                   078080
      **   Process external data structures as external files             078080
      *                                                                   078080
     C     SRCTYP        IFEQ      'RPG'                                        078080
     C     SPEC          ANDEQ     'I'                                          078080
     C     DATAST        ANDEQ     'DS'                                         078080
     C     FCOMM         ANDNE     '*'                                          092401
     C********** EXTDS     ANDEQ'E'                                 078080092401
     C     EXTDSF        ANDNE     *BLANKS                                      092401
     C                   MOVEL     EXTDSF        EXTFIL                                       CUT008
     C                   EXSR      FPROC                                        078080
     C                   ENDIF                                                  078080
      *                                                                                       CUT008
     C     SRCTYP        IFEQ      'RPGLE'                                                    CUT008
     C     SPEC          ANDEQ     'D'                                                        CUT008
     C     FCOMM         ANDNE     '*'                                                        CUT008
     C     KEYWRD        ANDNE     *BLANKS                                                    CUT008
      *                                                                                       CUT008
      **   Check if KEYWORD has EXTNAME                                                       CUT008
     C                   EXSR      SRCHKW                                                     CUT008
      *                                                                                       CUT008
      **   If external data structure is used, expand the data                                CUT008
      *    structure.                                                                         CUT008
     C                   IF        FndTxtPos > 0                                              CUT008
     C                   EVAL      EXTFIL = %Trim(FNDTXT)                                     CUT008
     C                   EXSR      FPROC                                                      CUT008
     C                   ENDIF                                                                CUT008
      *                                                                                       CUT008
     C                   ENDIF                                                                CUT008
     C*
     C** IF '/COPY' MEMBER DO SUBROUTINE 'CPYPRC'
     C** CALL THE CL PROGRAM THAT COLLECTS THE '/COPY' MEMBER CODE
     C*
     C     COPY          IFEQ      '/COPY'
     C                   EXSR      CPYPRC
     C                   ENDIF
     C*
     C** IF 'CL' SOURCE,
     C** IF '/COPY' MEMBER DO SUBROUTINE 'CPYPRC'
     C*
     C     SRCTYP        IFEQ      'CLP'
     C     CLCOPY        ANDEQ     '/*/COPY'
     C     SRCTYP        OREQ      'CLLE'                                                     CUT008
     C     CLCOPY        ANDEQ     '/*/COPY'                                                  CUT008
     C                   EXSR      CPYPRC
     C                   ENDIF
     C*
     C** SEND SOURCE-CODE LINE TO PRINTER
     C*
     C     *IN17         IFEQ      '0'
     C     *IN18         ANDEQ     '0'
     C                   EXSR      REPORT
     C                   ELSE
     C                   SETOFF                                       17
     C                   SETOFF                                       18
     C                   ENDIF
     C*
     C** READ NEXT SOURCE MEMBER CODE FILE
     C*
     C                   READ      SOURCEF                                99
     C*
     C                   ENDDO
      *
      *    Write end of listing line
      *
     C                   EXSR      ZZEND
     C*
     C                   SETON                                        LR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C**
     C** INDEX OF SUBROUTINES
     C**                                                                                      CUT008
     C** SRCHKW - SEARCH 'EXTNAME' IN KEYWORD                                                 CUT008
     C**
     C** FPROC  - 'F' SPEC PROCESS
     C**
     C** CPYPRC - '/COPY' PROCESS
     C**
     C** REPORT - PRINTING OF EXPANDED RPG SOURCE
     C**
     C** EXREC  - PRINTING OF EXPANDED 'F' SPEC
     C**
     C** FLINE  - PRINTING OF 'F' SPEC COMMENTS
     C**
     C** CLINE  - PRINTING OF '/COPY' HEADINGS AND COMMENTS
     C**
     C********************************************************************
      /EJECT                                                                                  CUT008
      ********************************************************************                    CUT008
      *                                                                  *                    CUT008
      * Subroutine to search if 'EXTNAME' exists in the keyword.         *                    CUT008
      *                                                                  *                    CUT008
      *  Called from main cycle.                                         *                    CUT008
      *                                                                  *                    CUT008
      *  Calls programs : UT000027                                       *                    CUT008
      *                                                                  *                    CUT008
      ********************************************************************                    CUT008
      *
     C     SRCHKW        BEGSR                                                                CUT008
      *
      * Initialise work fields.                                                               CUT008
     C                   EVAL      FndTxt     = '  '                                          CUT008
     C                   EVAL      FndTxtPos  = 0                                             CUT008
     C                   EVAL      FndTxtLen  = 0                                             CUT008
      *
     C                   CALL      'UT000027'                                                 CUT008
     C                   PARM      KEYWRD        TxtToBeSrched                                CUT008
     C                   PARM      'EXTNAME('    LArg                                         CUT008
     C                   PARM      ')'           RArg                                         CUT008
     C                   PARM                    FndTxt                                       CUT008
     C                   PARM                    FndTxtPos                                    CUT008
     C                   PARM                    FndTxtLen                                    CUT008
      *
     C                   ENDSR                                                                CUT008
      *
     C/EJECT
     C********************************************************************
     C*
     C** FPROC SUBROUTINE TO PROCESS 'F' SPEC RECORDS
     C*                   AND EXTERNAL DATA STRUCTURE FILE                                    CUT008
     C*
     C** CALLED FROM MAIN CYCLE
     C*
     C** CALLS SUBROUTINES :-
     C**                    - 'REPORT'
     C**                    - 'FLINE' (twice)
     C**                    - 'EXREC'
     C*
     C********************************************************************
     C*
     C     FPROC         BEGSR
     C*
     C                   EXSR      REPORT
     C*
     C** SWITCH ON 'F SPEC'
     C** SWITCH ON REPORT 'HIGHLIGHT'S
     C*
     C                   SETON                                        18
     C     BOLD          IFEQ      'Y'                                          CAAA01
     C                   SETON                                        19
     C                   ENDIF                                                  CAAA01
      **********                                                                       078080 CUT008
      *****Set*up*file*name*for*external*data*structure*******************             078080 CUT008
      **********                                                                       078080 CUT008
     C********** SPEC      IFEQ 'I'                                                    078080 CUT008
     C********** FCOMM     ANDNE'*'                                                    092401 CUT008
     C********** DATAST    ANDEQ'DS'                                                   078080 CUT008
     C********** EXTDS     ANDEQ'E'                                              078080092401 CUT008
     C********** EXTDSF    ANDNE*BLANKS                                                092401 CUT008
     C**********           MOVELEXTDSF    EXTFIL                                       078080 CUT008
     C**********           ENDIF                                                       078080 CUT008
      *
      *    Set up values for user spaces
      *
     C                   MOVEL     'FLDSPC  '    SPCNAM
     C                   MOVEL     'QTEMP   '    SPCLIB
     C                   MOVEL     EXTFIL        FILNAI
     C                   MOVEL     '*LIBL'       FILLBI
     C                   MOVEL     'RCDSPC  '    SPCNM
     C                   MOVEL     'QTEMP   '    SPCLB
     C                   MOVEL     EXTFIL        FILNA2
     C                   MOVEL     '*LIBL'       FILLB2
      *
      *    Check for external file in library list
      *
     C                   CALL      'UTC0017'
     C                   PARM                    EXTFIL
     C                   PARM                    ERROR             1
      *
     C     ERROR         IFEQ      'N'
      *
      *    Create user space for record format list
      *
     C     USRSP2        IFEQ      ' '
     C                   CALL      'QUSCRTUS'                           99
     C                   PARM                    USSPC
     C                   PARM      *BLANK        ATTRIB           10
     C                   PARM      1024          LENSPC
     C                   PARM      *BLANK        VALUE             1
     C                   PARM      '*CHANGE '    PUBAUT           10
     C                   PARM      *BLANK        TXT              50
     C                   MOVE      'Y'           USRSP2            1
     C                   ENDIF
      *
      *    Generate record format list
      *
     C                   CALL      'QUSLRCD'
     C                   PARM                    USSPC
     C                   PARM      'RCDL0100'    FMTNAI
     C                   PARM                    FILLI2
     C                   PARM      '0'           OVRID
      *
      *    Read generic header and list header
      *
     C                   CALL      'QUSRTVUS'
     C                   PARM                    USSPC
     C                   PARM      117           STPOS
     C                   PARM      16            LNDTA
     C                   PARM                    RCVVR2
     C                   Z-ADD     OFSET         STPOS
     C                   ADD       1             STPOS
     C                   Z-ADD     HDRSZ         LNDTA
     C                   CALL      'QUSRTVUS'
     C                   PARM                    USSPC
     C                   PARM                    STPOS
     C                   PARM                    LNDTA
     C                   PARM                    HDRFMT
      *
      *    Find offset, size and number of entries
      *
     C                   CALL      'QUSRTVUS'
     C                   PARM                    USSPC
     C                   PARM      125           STPOS
     C                   PARM      16            LNDTA
     C                   PARM                    RCVVR2
     C                   Z-ADD     OFSET         STPOS
     C                   ADD       1             STPOS
     C                   Z-ADD     SZENT         LNDTA
     C                   Z-ADD     1             NOFMT            15 0
      *
      *    Read list entries
      *
     C     NOFMT         DOWLE     NOENT
     C                   CALL      'QUSRTVUS'
     C                   PARM                    USSPC
     C                   PARM                    STPOS
     C                   PARM                    LNDTA
     C                   PARM                    LIST2
      *
      *    Find record format name and description
      *
      *
      *    Create user space for field list
      *
     C     USERSP        IFEQ      ' '
     C                   CALL      'QUSCRTUS'                           99
     C                   PARM                    USRSPC
     C                   PARM      *BLANK        ATTRIB           10
     C                   PARM      1024          LENSPC
     C                   PARM      *BLANK        VALUE             1
     C                   PARM      '*CHANGE '    PUBAUT           10
     C                   PARM      *BLANK        TXT              50
     C                   MOVE      'Y'           USERSP            1
     C                   ENDIF
      *
      *    Generate field list
      *
     C                   CALL      'QUSLFLD'
     C                   PARM                    USRSPC
     C                   PARM      'FLDL0100'    OUTFMT
     C                   PARM                    FILLII
     C                   PARM      FMTNAL        RCDFMI
     C                   PARM      '0'           OVRRID
      *
      *    Find record format name and description
      *
     C                   CALL      'QUSRTVUS'
     C                   PARM                    USRSPC
     C                   PARM      117           STRPOS
     C                   PARM      16            LENDTA
     C                   PARM                    RCVVAR
     C                   Z-ADD     OFFSET        STRPOS
     C                   ADD       1             STRPOS
     C                   Z-ADD     HDRSIZ        LENDTA
     C                   CALL      'QUSRTVUS'
     C                   PARM                    USRSPC
     C                   PARM                    STRPOS
     C                   PARM                    LENDTA
     C                   PARM                    HEADER
     C*
     C**   WRITE 'F' SPEC HEADINGS
     C*
     C                   EXSR      FLINE
      *
      *    Find offset, size and number of entries
      *
     C                   CALL      'QUSRTVUS'
     C                   PARM                    USRSPC
     C                   PARM      125           STRPOS
     C                   PARM      16            LENDTA
     C                   PARM                    RCVVAR
     C                   Z-ADD     OFFSET        STRPOS
     C                   ADD       1             STRPOS
     C                   Z-ADD     SIZENT        LENDTA
     C                   Z-ADD     1             COUNT            15 0
      *
      *    Read list entries
      *
     C     COUNT         DOWLE     NBRENT
     C                   CALL      'QUSRTVUS'
     C                   PARM                    USRSPC
     C                   PARM                    STRPOS
     C                   PARM                    LENDTA
     C                   PARM                    LIST
      *
     C                   SETOFF                                       1011
     C     DTATYP        COMP      'P'                                    10    Numeric fields
     C  N10DTATYP        COMP      'S'                                    10
     C   10DTATYP        COMP      'P'                                    11    Packed field
     C                   Z-ADD     OUTBUF        FROM              4 0
     C     OUTBUF        ADD       FLDLEN        END               4 0
     C                   SUB       1             END
     C                   Z-ADD     DECPOS        DECP              1 0
     C                   EXSR      EXREC                                        Print detail
      *
     C                   ADD       1             COUNT
     C                   ADD       SIZENT        STRPOS
     C                   ENDDO
      *
     C                   ADD       1             NOFMT
     C                   ADD       SZENT         STPOS
     C                   ENDDO
     C*
     C** END OF 'F SPEC' PROCESSING
     C*
     C                   SETON                                        28
     C                   EXSR      FLINE
     C                   SETOFF                                       28
     C*
     C** SWITCH OFF REPORT 'HIGHLIGHTS'
     C*
     C                   SETOFF                                       19
     C*
     C** REPORT ERROR
     C*
     C                   ELSE
     C                   SETOFF                                       47
     C                   WRITE     ERRF
     C                   ENDIF
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C** SUBROUTINE TO PROCESS '/COPY' RECORDS
     C*
     C** CALLED FROM MAIN CYCLE
     C*
     C** CALLS SUBROUTINES :-
     C**                    - 'REPORT' (twice)
     C**                    - 'CLINE'  (twice)
     C*
     C********************************************************************
     C*
     C     CPYPRC        BEGSR
     C*
     C                   EXSR      REPORT
     C*
     C** SWITCH ON '/COPY' MEMBER
     C** SWITCH ON REPORT 'HIGHLIGHTS'
     C*
     C                   SETON                                        17
     C     BOLD          IFEQ      'Y'                                          CAAA01
     C                   SETON                                        19
     C                   ENDIF                                                  CAAA01
     C*
     C** SCAN VARIABLE FIELD TO ISOLATE FILE AND MEMBER
     C*
     C                   MOVE      *BLANKS       CPYFIL
     C                   MOVE      *BLANKS       CPYSRC
     C     SRCTYP        IFNE      'CLP'
     C     SRCTYP        ANDNE     'CLLE'                                                     CUT008
     C***********','       SCAN CPYDTA    POSN    10                      095167
     C     ','           SCAN      CPYDTA        POSN              2 0          095167
     C     POSN          SUB       1             FSIZE             2 0
     C     POSN          ADD       1             N                 2 0
     C     FSIZE         SUBST     CPYDTA:1      CPYFIL           10
     C     10            SUBST     CPYDTA:N      CPYSRC           10
     C                   ELSE
     C***********','       SCAN CLDATA    POSN    10                      095167
     C     ','           SCAN      CLDATA        POSN                           095167
     C     POSN          SUB       1             FSIZE             2 0
     C     POSN          ADD       1             N                 2 0
     C     FSIZE         SUBST     CLDATA:1      CPYFIL           10
     C     10            SUBST     CLDATA:N      CPYSRC           10
     C                   ENDIF
     C*
     C**********           CALL 'UTC0018'                                 092401
     C**********           PARM           SRCLIB 10                       092401
     C**********           PARM           CPYFIL                          092401
     C**********           PARM           CPYSRC                          092401
     C**********           PARM 'N'       ERROR   1                       092401
      *                                                                   092401
     C                   CALL      'UTC0012'                                    092401
     C                   PARM                    CPYFIL                         092401
     C                   PARM                    CPYSRC                         092401
     C                   PARM                    SRCTYP                         092401
     C                   PARM      'N'           ERROR                          092401
     C                   PARM                    CPYLIB                         092401
     C*
     C** IF ERROR IN ACCESSING '/COPY' MEMBER
     C**    SKIP PROCESS AND GO TO END OF SUBROUTINE
     C*
     C     ERROR         IFNE      'E'
     C     ERROR         ANDNE     'M'
     C     ERROR         ANDNE     'Y'                                          092401
     C     ERROR         ANDNE     'F'
     C*
     C** START OF '/COPY' REPORT PROCESSING
     C*
     C                   EXSR      CLINE
     C*
     C** OPEN '/COPY SOURCE-MEMBER-CODE' FILE
     C*
     C                   OPEN      COPYSRC
     C*
     C** READ '/COPY SOURCE-MEMBER-CODE' FILE
     C*
     C                   READ      COPYSRC                                97
     C*
     C** LOOP UNTIL END OF SOURCE MEMBER CODE FILE
     C*
     C     *IN97         DOWEQ     '0'
     C*
     C                   EXSR      REPORT
     C*
     C** READ NEXT '/COPY SOURCE-MEMBER-CODE' FILE
     C*
     C                   READ      COPYSRC                                97
     C*
     C                   ENDDO
     C*
     C                   SETOFF                                       97
     C*
     C** CLOSE '/COPY SOURCE-MEMBER-CODE' FILE
     C*
     C                   CLOSE     COPYSRC
     C*
     C** END OF '/COPY' REPORT PROCESSING
     C*
     C                   SETON                                        27
     C                   EXSR      CLINE
     C                   SETOFF                                       27
     C*
     C***SWITCH*OFF*REPORT*'HIGHLIGHT'S                                   CAAA01
     C*
     C*********************SETOF                     19                   CAAA01
     C*
     C** REPORT ERROR
     C*
     C                   ELSE
     C     ERROR         IFEQ      'E'                                          Empty /COPY member
     C                   WRITE     ERRC1
     C                   ENDIF
     C     ERROR         IFEQ      'M'
     C     ERROR         OREQ      'Y'                                          /COPY member  092401
     C                   WRITE     ERRC2                                        not found
     C                   ENDIF
     C     ERROR         IFEQ      'F'                                          /COPY source file
     C                   WRITE     ERRC3                                        not found
     C                   ENDIF
     C                   ENDIF
     C*                                                                   CAAA01
     C** SWITCH OFF REPORT 'HIGHLIGHT'S                                   CAAA01
     C*                                                                   CAAA01
     C                   SETOFF                                       19        CAAA01
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C** SUBROUTINE TO PRINT EXPANDED RPG SOURCE
     C*
     C** CALLED FROM MAIN CYCLE
     C*
     C** CALLS NO OTHER SUBROUTINES
     C*
     C********************************************************************
     C*
     C     REPORT        BEGSR
     C*
     C** IF WRITING ON OR BELOW LINE 56 START NEW PAGE
     C*
     C     LINE          IFGE      56
     C                   WRITE     HEADPR
     C                   ENDIF
     C*
     C** WRITE DETAIL LINE
     C*
     C                   WRITE     DETAIL
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C** SUBROUTINE TO PRINT EXPANDED DSPFFD FILE
     C*
     C** CALLED FROM MAIN CYCLE
     C*
     C** CALLS NO OTHER SUBROUTINES
     C*
     C********************************************************************
     C*
     C     EXREC         BEGSR
     C*
     C** IF WRITING ON OR BELOW LINE 56 START NEW PAGE
     C*
     C     LINE          IFGE      56
     C                   WRITE     HEADPR
     C                   ENDIF
     C*
     C** WRITE EXTREC LINE
     C*
     C                   WRITE     EXTREC
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C** SUBROUTINE TO PRINT 'F' SPEC COMMENTS
     C*
     C** CALLED FROM MAIN CYCLE
     C*
     C** CALLS NO OTHER SUBROUTINES
     C*
     C********************************************************************
     C*
     C     FLINE         BEGSR
     C*
     C** IF WRITING ON OR BELOW LINE 50 START NEW PAGE
     C*
     C     LINE          IFGE      50
     C                   WRITE     HEADPR
     C                   ENDIF
     C*
     C** WRITE 'F' SPEC MAIN HEADER LINE, FIELD HEADINGS LINE
     C** OR WRITE 'ENDING' LINE
     C*
     C     *IN28         IFEQ      '0'
     C                   WRITE     FHDR1
     C     ERROR         IFEQ      'N'
     C*                    WRITEFHDR2
     C                   ENDIF
     C                   ELSE
     C                   WRITE     ENDF
     C                   ENDIF
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C** SUBROUTINE TO PRINT '/COPY' COMMENTS
     C*
     C** CALLED FROM MAIN CYCLE
     C*
     C** CALLS NO OTHER SUBROUTINES
     C*
     C********************************************************************
     C*
     C     CLINE         BEGSR
     C*
     C** IF WRITING ON OR BELOW LINE 50 START NEW PAGE
     C*
     C     LINE          IFGE      50
     C                   WRITE     HEADPR
     C                   ENDIF
     C*
     C** WRITE '/COPY' DETAIL LINE
     C*
     C     *IN27         IFEQ      '0'
     C                   WRITE     CLINED
     C                   ELSE
     C                   WRITE     ENDC
     C                   ENDIF
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C** SUBROUTINE TO PRINT END OF SOURCE LINE
     C*
     C** CALLED FROM MAIN CYCLE
     C*
     C** CALLS NO OTHER SUBROUTINES
     C*
     C********************************************************************
     C*
     C     ZZEND         BEGSR
     C*
     C** IF WRITING ON OR BELOW LINE 59 START NEW PAGE
     C*
     C     LINE          IFGE      59
     C                   WRITE     HEADPR
     C                   ENDIF
     C*
     C** Write End of Source line
     C*
     C                   WRITE     TRAILP1
     C*
     C                   ENDSR
     C*
     C********************************************************************
