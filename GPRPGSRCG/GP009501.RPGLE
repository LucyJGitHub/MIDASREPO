     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Global system values maintenance/enquiry')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GP009501 - Midas GP global System Values Maintenance/Enquiry *
      *                                                               *
      *  Function:  This program allows user to enquire/maintain      *
      *             the current setting of a System Value.            *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CPK025             Date 11Oct06               *
      *                 BUG5613            Date 16Dec05               *
      *                 CPK022             Date 29Jul05               *
      *                 CPK019R            Date 17Dec04               *
      *                 CPK019             Date 28May04               *
      *                 CGP001 *CREATE     Date 19Mar04               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CPK025 - Name of /COPY still incorrect.                      *
      *  BUG5613 - Cannot amend ExcptRptRetention system value.       *
      *            Applied BUG7330.                                   *
      *  CPK022 - Should not use zone /COPYs.                         *
      *  CPK019R- Remove date and time from the screen as webfacing   *
      *           is not able to process the fields. Recompile.       *
      *  CPK019 - Can not use RUNDAT in global layer.                 *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *       03         F3 has been pressed (Exit program).          *
      *       05         F5 has been pressed (Reset to default).      *
      *       12         F12 has been pressed (Previous screen).      *
      *       35         Invalidate Current Setting entry.            *
      *       61         ON, Last amend type is Insert.               *
      *                  OFF, Last amend type is Amend.               *
      *       86         Enable PUTOVR for Insert/Amend.              *
      *       87         Amend mode, ON to enable CA05 and allow      *
      *                  Current Setting entry.                       *
      *       90         Record not found, OR                         *
      *                  Error when calling program.                  *
      *       92         End of file.                                 *
      *       99         Global error flag.                           *
      *                                                               *
     F*****************************************************************
     FGP009501DFCF   E             WORKSTN
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas GP System Values maintenance/enquiry
      *
     FGPSVALL0  UF   E           K DISK
     F                                     INFDS(INFDS1)
     F                                     INFSR(*PSSR)
      * RTV/UPD : Midas GP All Midas System Value by System Value
      *
     FGPSVRFL0  IF   E           K DISK
     F                                     INFSR(*PSSR)
      * RTV : Midas GP System Value Header Reference
      *
     FGPSVRFL1  IF   E           K DISK
     F                                     INFSR(*PSSR)
      * RTV : Midas GP System Value Detail Reference (3 keys)
      *
     FGPSVRFL2  IF   E           K DISK
     F                                     INFSR(*PSSR)
      * RTV : Midas GP System Value Detail Reference (2 keys)
      *
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
     D A@CPY           DS
      * Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright
      *
     D WKV             S              1    DIM(200)                             Cur Setting Array
     D TMP             S              1    DIM(200)                             Temp Cur Setting Arr
     D P2A             S              7    DIM(99)                              PARM: Err Msg List
     D WKN             S              1    DIM(200)                                          BUG5613
     D WKNT            S              1    DIM(200)                                          BUG5613
      *
     D PGM@            S             10    DIM(1) CTDATA PERRCD(1)              Programs to call
      *
      * Data structures:
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      * Program data structure
      *
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file information data structure
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure
      *
     D @1DBRC        E DS                  EXTNAME(GPSVALL0)
      * Midas SD System Values
      * Current/previous master file format fields for change control
      *
     D #1DBRC          DS           554
      * Stored master file format fields
     D  #1DB1                  1      1
      *
     D #1VAL           DS
     D  #1SVL1                 1     50
     D  #1SVL2                51    100
     D  #1SVL3               101    150
     D  #1SVL4               151    200
      *
     D #1DFT           DS
     D  #1DFT1                 1     50
     D  #1DFT2                51    100
     D  #1DFT3               101    150
     D  #1DFT4               151    200
      *
     D GJVDT2          DS
     D  WUPGMN                 1     10
     D  WUPMDE                11    200
      *
     D*RUNDAT**        DS                                                                     CPK019
     D**MRDT***                1      7                                                       CPK019
     D**RDNB***                8     10P 0                                                    CPK019
     D**SUC****               11     11                                                       CPK019
     D**DFF****               12     12                                                       CPK019
     D**MBIN***               13     13                                                       CPK019
      *
     D                 DS
     D  ZAMSDA                 1    132
                                                                                             BUG5613
      ** Declare variables for field range validations                                       BUG5613
                                                                                             BUG5613
     D #1VLD           S            200                                                      BUG5613
     D WRNGU1          S            200                                                      BUG5613
     D WRNGU2          S            200                                                      BUG5613
      *
      * Programs to call
      *
      /EJECT
      *
      * Rename fields with the same name.
     I@SVRFL1
     I              GJRECI                      GJREC1
     I              GJSVAL                      GJSVA1
     I              GJSEQ                       GJSEQ1
     I              GJVDTA                      GJVDT1
     I              GJDESC                      GJDES1
     I@SVRFL2
     I              GJRECI                      GJREC2
     I              GJSVAL                      GJSVA2
     I              GJSEQ                       GJSEQ2
     I              GJVDTA                      GJVDT2
     I              GJDESC                      GJDES2
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C                   PARM                    P1SVAL           20            System value
     C                   PARM                    P1SEL             1            Action Code
      *****************************************************************
      * Initialise
     C                   EXSR      ZZINIT
      *
      * Main process
     C                   EXSR      BEPRKY
      *
      * Terminate program
     C                   EXSR      ZXEXPG
      *****************************************************************
      /EJECT
     CSR   BEPRKY        BEGSR
      *================================================================
      * Main process
      *================================================================
      * Check for existing record
     C     KRTV          KLIST
     C                   KFLD                    P1SVAL                         System Value
      *
     C     KRTV          CHAIN     GPSVALL0                           90        *
      *
      * If record does not exist, error
     C     *IN90         IFEQ      '1'
     C                   SETON                                        99        *
      * Send message 'System value record not found'
     C                   MOVEL     'GPM0036'     ZAMSID
     C                   EXSR      ZASNMS
      *
     C                   ELSE
      *
      * Else no error,  load details screen.
     C                   EXSR      MBFL#1
      * Display and process details
     C                   EXSR      CADSDA
     C                   END
      *
      *================================================================
     CSR   BEEXIT        ENDSR
      /EJECT
     CSR   CADSDA        BEGSR
      *================================================================
      * Display and process detail screen
      *================================================================
     C                   MOVEL     'Y'           W0TRN             1
      * Conduct detail screen conversation
      * - repeat until screen control flag is reset:
     C     W0TRN         DOWEQ     'Y'
      * Display detail screen
     C                   EXSR      CBEXFM
      * Process response to detail screen
      * Cancel & exit program
     C   03              CAS                     ZXEXPG
      * Display help
     C   11              CAS                     CCHELP
      * Redisplay previous screen
     C   12              CAS                     CCDSPV
      * HOME: Reset screen fields
     C   05              CAS                     CDDSPV
      * Process detail screen input when amend.
     C   87              CAS                     EBPR##
      * Exit program if 'Enter' for enquiry.
     C                   CAS                     ZXEXPG
     C                   END
      *
     C                   END
      *================================================================
     CSR   CAEXIT        ENDSR
      /EJECT
     CSR   CBEXFM        BEGSR
      *================================================================
      * Display screen
      *================================================================
     C     W0HLP         DOUEQ     'N'
     C                   MOVEL     'N'           W0HLP             1
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
      *
      * Update screen time
     C                   TIME                    ##TME
      *
      * PUTOVR unless conditioned fields change
     C                   SETON                                            86    *
     C     *IN61         IFNE      CBIN61
     C                   SETOFF                                           86    *
     C                   END
     C                   MOVEL     *IN61         CBIN61            1
      *
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT2
     C                   EXFMT     #RCDDTL1
      * Test cursor
     C                   EXSR      Y8TST
      * Clear set cursor DDS indicator
     C     WCSRLC        IFEQ      'OFF'
     C                   SETOFF                                       94        *
     C                   END
     C                   MOVE      *BLANK        WCSRLC
     C                   END
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag
     C                   MOVEL     'Y'           ZAFSMS            1
      * Reset global error indicator
     C                   SETOFF                                           99    *
      *================================================================
     CSR   CBEXIT        ENDSR
      /EJECT
     CSR   CCDSPV        BEGSR
      *================================================================
      * Exit to previous screen
      *================================================================
      *
     C                   MOVEL     *BLANK        P0RTN                          *Return code
     C                   EXSR      ZYEXPG
      *
      *================================================================
     CSR   CCEXIT        ENDSR
      /EJECT
     CSR   CDDSPV        BEGSR
      *================================================================
      * Reset value to default
      *================================================================
      *
      * IF CF5, copy #1DFT to current setting
     C                   MOVEL     #1DFT         #1VAL
      *================================================================
     CSR   CDEXIT        ENDSR
      /EJECT
     CSR   CCHELP        BEGSR
      *================================================================
      * Display the associated help
      *================================================================
      *
      * IF CF11, display the second level text from the associated
      * error message
     C                   MOVEA     PGM@(1)       CALPGM           10
     C                   CALL      CALPGM                               90      Display help
     C                   PARM      GIEMSG        WQ0006            7            Error message
     C                   PARM      ZAMSGF        WQ0007           10            Message file
     C                   PARM      '2'           WQ0008            1            Second level text
     C                   PARM      'GP009501'    WQ0009           10            Calling Pgm
      *================================================================
     CSR                 ENDSR
      /EJECT
     CSR   DAADJU        BEGSR
      *================================================================
      * Position the Current Setting according to #1JUST.
      *================================================================
      *
      * If #1JUST is 'L',
     C     #1JUST        IFEQ      'L'
      *
      *    Get the start position of the Current Setting entry
     C                   Z-ADD     1             SX                3 0          Start Position
     C     WKV(SX)       DOWEQ     *BLANK
     C                   ADD       1             SX
     C                   ENDDO
      *    If Start positon is greater than 1, shift the data string
      *       to the first position.
     C     SX            IFGT      1
     C                   MOVEA(P)  WKV(SX)       TMP
     C                   MOVEA     TMP           WKV
     C                   Z-ADD     1             SX
     C                   ENDIF
      *
     C                   ENDIF
      *
      * If #1JUST is 'N', no data to be shifted.
      *
      * If #1JUST is 'R',
     C     #1JUST        IFEQ      'R'
      *    get the end position.
     C                   Z-ADD     WNDLEN        EX                3 0          End Position
     C     WKV(EX)       DOWEQ     *BLANK
     C                   SUB       1             EX
     C                   ENDDO
      *    only shift data to the rightmost of #1DLEN if ending at position
      *    less than #1DLEN.
     C     EX            IFLT      WNDLEN
     C                   Z-ADD     EX            WX                             WKV Array Index
     C                   Z-ADD     WNDLEN        TX                3 0          TMP Array Index
     C                   MOVEA(P)  *BLANK        TMP
      *
     C     WX            DOWGE     1
     C                   MOVEA     WKV(WX)       TMP(TX)
     C                   SUB       1             TX
     C                   SUB       1             WX
     C                   ENDDO
      *
     C                   Z-ADD     WNDLEN        EX
     C                   MOVEA     TMP           WKV
     C                   ENDIF
      *
     C                   ENDIF
      *
     CSR   DAEXIT        ENDSR
      /EJECT
     CSR   DCVLCS        BEGSR
      *================================================================
      * Validate Current Setting:
      *   - Check if blank entry
      *   - Check if any data entered at position greater than #1DLEN
      *   - Call subroutines according to validation types in
      *     in the Header Reference file.
      *================================================================
      *
      *
      * If Current Setting is blank,
     C     #1VAL         IFEQ      *BLANK
      *
      *    and if blank entry is not allowed, send error message.
     C     #1ALWB        IFNE      'Y'
     C                   SETON                                        3599
     C                   MOVEL     'GPM0037'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   GOTO      DCEXIT
     C                   ENDIF
      *
      * Validate for non-blank entry....
      *
      * Move Current Setting to the Work Current Setting Array.
     C                   MOVEA(P)  #1VAL         WKV
      * Convert #1DLEN to numeric field
     C                   MOVE      #1DLEN        WNDLEN            3 0
      *
      * Check if there are any data after position #1DLEN
     C     WNDLEN        IFLT      200
     C     1             ADD       WNDLEN        WX                3 0
     C     WKV(WX)       DOWEQ     ' '
     C                   ADD       1             WX
      *
     C     WX            IFEQ      201
     C                   GOTO      ADJTAG
     C                   ENDIF
      *
     C                   ENDDO
      * Give error message and exit if there is any data after #1DLEN
     C                   SETON                                        3599
     C                   MOVEL     'GPM0038'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      DCEXIT
     C                   ENDIF
      *
     C     ADJTAG        TAG
      *
      * Adjust the data in array WKV according to the field #1JUST (L, R, N).
     C                   EXSR      DAADJU
      *
      * Copy data back to #1VAL
     C                   MOVEA     WKV           #1VAL
      *
      * Chain to GPSVRFL0 for type of validation for the system value.
     C     #1SVAL        CHAIN     GPSVRFL0                           90
      *
      * If record does not exist, error
     C     *IN90         IFEQ      '1'
     C                   SETON                                        99
      * Send message 'System Value Header Reference record not found'
     C                   MOVEL     'GPM0039'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      DCEXIT
     C                   ENDIF
      *
     C                   SETOFF                                       92
      *
      * Validate according to the type.
     C     #1SVAL        DOWEQ     GJSVAL
     C     *IN92         ANDNE     '1'                                          not EOF
      *
     C     GJVDTA        CASEQ     '*VALUES'     D1VVAL
     C     GJVDTA        CASEQ     '*RANGE'      D2VRNG
     C     GJVDTA        CASEQ     '*PROGRAM'    D3VPGM
     C     GJVDTA        CASEQ     '*EXISTS'     D4VEXS
     C                   ENDCS
      *
     C   99
     CANN35              GOTO      DCEXIT
      * Get next Header Reference record
     C                   READ      GPSVRFL0                               92
     C                   ENDDO
      *
     CSR   DCEXIT        ENDSR
      /EJECT
     CSR   D1VVAL        BEGSR
      *================================================================
      * Validate when GJVDTA is *VALUES in Header Reference file
      *================================================================
      *
      ** Key chaining to GPSVRFL1 .
     C     KLRFL1        KLIST
     C                   KFLD                    GJSVAL
     C                   KFLD                    GJSEQ
     C                   KFLD                    #1VAL
      *
     C     KLRFL1        CHAIN     GPSVRFL1                           90
      *
      * If record does not exist, error
     C     *IN90         IFEQ      '1'
     C                   SETON                                        3599
      *
      * Send message 'Value not found in the System Value Detail Reference file'
     C                   MOVEL     'GPM0040'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     GIEMSG        ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     CSR   D1EXIT        ENDSR
      /EJECT
     CSR   D2VRNG        BEGSR
      *================================================================
      * Validate when GJVDTA is *RANGE in Header Reference file
      *================================================================
      *
      * Define range fields as GJVDTA.
     C     *LIKE         DEFINE    GJVDT2        WURNG1
     C     *LIKE         DEFINE    GJVDT2        WURNG2
      *
      * Key chaining to GPSVRFL2 .
     C     KLRFL2        KLIST
     C                   KFLD                    GJSVAL
     C                   KFLD                    GJSEQ
      *
     C     KLRFL2        CHAIN     GPSVRFL2                           90
      *
      * If record does not exist, error
     C     *IN90         IFEQ      '1'
     C                   SETON                                        9935
      *    Send message 'System Value Detail Reference record not found'
     C                   MOVEL     'GPM0041'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      D2EXIT
     C                   ELSE
      *
      * Else Save GJVDTA1 as range limit 1
     C                   MOVEL     GJVDT2        WURNG1
     C                   ENDIF
      *
      * Read next record in GPSVRFL2 with the same key values.
     C     KLRFL2        READE     GPSVRFL2                               92
      *
      * If record does not exist, error
     C     *IN92         IFEQ      '1'
     C                   SETON                                        99
      *    Send message 'System Value Detail Reference record not found'
     C                   MOVEL     'GPM0041'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      D2EXIT
     C                   ELSE
      *
      * Else Save GJVDTA1 as range limit 2
     C                   MOVEL     GJVDT2        WURNG2
     C                   ENDIF
      *                                                                                      BUG5613
      ** Right justify the input field for validation purposes                               BUG5613
      *                                                                                      BUG5613
     C                   MOVEA(P)  #1VAL         WKV                                         BUG5613
     C                   MOVEL     #1VAL         #1VLD                                       BUG5613
     C                   EXSR      D2VPGM                                                    BUG5613
     C                   IF        TMP(200) <> *BLANKS                                       BUG5613
     C                   MOVEA(P)  TMP           #1VLD                                       BUG5613
     C                   ENDIF                                                               BUG5613
                                                                                             BUG5613
      ** Right justify range fld 1 for validation purposes                                   BUG5613
                                                                                             BUG5613
     C                   MOVEA(P)  WURNG1        WKV                                         BUG5613
     C                   EXSR      D2VPGM                                                    BUG5613
     C                   MOVEA(P)  TMP           WRNGU1                                      BUG5613
                                                                                             BUG5613
      ** Right justify range fld 2 for validation purposes                                   BUG5613
                                                                                             BUG5613
     C                   MOVEA(P)  WURNG2        WKV                                         BUG5613
     C                   EXSR      D2VPGM                                                    BUG5613
     C                   MOVEA(P)  TMP           WRNGU2                                      BUG5613
      ** Check if value input, minimun and maximum range are numeric                         BUG5613
      *                                                                                      BUG5613
     C                   Move      *Blanks       WKNumVal          1                         BUG5613
     C                   Move      *Blanks       WKNumMin          1                         BUG5613
     C                   Move      *Blanks       WKNumMax          1                         BUG5613
      ** New system value                                                                    BUG5613
     C                   Move      'Y'           WKNumF            1                         BUG5613
     C                   MOVEA(P)  #1VAL         WKN                                         BUG5613
     C                   EXSR      D2VNUM                                                    BUG5613
     C                   Eval      WKNumVal = WKNumF                                         BUG5613
      **                                                                                     BUG5613
     C                   If        WKNumF = 'Y'                                              BUG5613
     C                   Exsr      D2CNUM                                                    BUG5613
     C                   MoveA     WKNT          #1VLD                                       BUG5613
     C                   EndIf                                                               BUG5613
      ** Minimum range                                                                       BUG5613
     C                   Move      'Y'           WKNumF                                      BUG5613
     C                   MOVEA(P)  WURNG1        WKN                                         BUG5613
     C                   EXSR      D2VNUM                                                    BUG5613
     C                   Eval      WKNumMin = WKNumF                                         BUG5613
      **                                                                                     BUG5613
     C                   If        WKNumF = 'Y'                                              BUG5613
     C                   Exsr      D2CNUM                                                    BUG5613
     C                   MoveA     WKNT          WRNGU1                                      BUG5613
     C                   EndIf                                                               BUG5613
      ** Maximum range                                                                       BUG5613
     C                   Move      'Y'           WKNumF                                      BUG5613
     C                   MOVEA(P)  WURNG2        WKN                                         BUG5613
     C                   EXSR      D2VNUM                                                    BUG5613
     C                   Eval      WKNumMax = WKNumF                                         BUG5613
      **                                                                                     BUG5613
     C                   If        WKNumF = 'Y'                                              BUG5613
     C                   Exsr      D2CNUM                                                    BUG5613
     C                   MoveA     WKNT          WRNGU2                                      BUG5613
     C                   EndIf                                                               BUG5613
      **                                                                                     BUG5613
     C                   If        WKNumMin = 'Y'                                            BUG5613
     C                             And WKNumMax = 'Y'                                        BUG5613
     C                   If        WKNumVal = 'N'                                            BUG5613
     C                   SETON                                        3599                   BUG5613
      ** Send message 'Value entered must be numeric'.                                       BUG5613
     C                   MOVEL     'USR0822'     ZAMSID                                      BUG5613
     C                   EXSR      ZASNMS                                                    BUG5613
     C                   Else                                                                BUG5613
     C                   Eval      #1VAL = #1VLD                                             BUG5613
     C                   EndIf                                                               BUG5613
     C                   EndIf                                                               BUG5613
      *
      * Check if #1VAL is within the range WURNG1 to WURNG2.
     C*****#1VAL         IFGE      WURNG1
     C*****#1VAL         ANDLE     WURNG2
     C     #1VLD         IFGE      WRNGU1                                                    BUG5613
     C     #1VLD         ANDLE     WRNGU2                                                    BUG5613
      *
     C                   ELSE
      * Else error
     C                   SETON                                        3599
      * Send message 'Value not within the range.' id to Error array.
     C                   MOVEL     'GPM0042'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     GIEMSG        ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     CSR   D2EXIT        ENDSR
      /EJECT
      *****************************************************************                      BUG5613
      *                                                               *                      BUG5613
      *  D2VPGM - Set the field to right justify for proper validation*                      BUG5613
      *                                                               *                      BUG5613
      *****************************************************************                      BUG5613
                                                                                             BUG5613
     C     D2VPGM        BEGSR                                                               BUG5613
                                                                                             BUG5613
      ** Get the end position.                                                               BUG5613
                                                                                             BUG5613
     C                   Z-ADD     WNDLEN        EX                                          BUG5613
     C     WKV(EX)       DOWEQ     *BLANK                                                    BUG5613
     C                   SUB       1             EX                                          BUG5613
     C                   ENDDO                                                               BUG5613
                                                                                             BUG5613
      ** Only shift data to the rightmost of #1DLEN if ending at position                    BUG5613
      ** less than #1DLEN.                                                                   BUG5613
                                                                                             BUG5613
     C                   MOVEA(P)  WKV           TMP                                         BUG5613
     C     EX            IFLT      WNDLEN                                                    BUG5613
     C                   Z-ADD     EX            WX                                          BUG5613
     C                   Z-ADD     WNDLEN        TX                                          BUG5613
     C                   MOVEA(P)  *BLANK        TMP                                         BUG5613
                                                                                             BUG5613
     C     WX            DOWGE     1                                                         BUG5613
     C                   MOVEA     WKV(WX)       TMP(TX)                                     BUG5613
     C                   SUB       1             TX                                          BUG5613
     C                   SUB       1             WX                                          BUG5613
     C                   ENDDO                                                               BUG5613
                                                                                             BUG5613
     C                   Z-ADD     WNDLEN        EX                                          BUG5613
     C                   ENDIF                                                               BUG5613
                                                                                             BUG5613
     C                   ENDSR                                                               BUG5613
                                                                                             BUG5613
      *****************************************************************                      BUG5613
      /EJECT                                                                                 BUG5613
      *****************************************************************                      BUG5613
      *                                                                                      BUG5613
      *****************************************************************                      BUG5613
      *                                                               *                      BUG5613
      *  D2VNUM - Check if numeric field                              *                      BUG5613
      *                                                               *                      BUG5613
      *****************************************************************                      BUG5613
                                                                                             BUG5613
     C     D2VNUM        BegSR                                                               BUG5613
     C                   Move      'N'           WKNumS            1                         BUG5613
     C                   Move      'N'           WKNumN            1                         BUG5613
     C                   Z-Add     0             EN                3 0                       BUG5613
     C     1             Do        WNDLEN        EN                                          BUG5613
      ** Select1                                                                             BUG5613
     C                   Select                                                              BUG5613
      ** Check spaces                                                                        BUG5613
     C                   When      WKN(EN) = ' '                                             BUG5613
      **                                                                                     BUG5613
     C                   If        WKNumS = 'N'                                              BUG5613
     C                             And WKNumN = 'Y'                                          BUG5613
     C                   Eval      WKNumS = 'Y'                                              BUG5613
     C                   EndIf                                                               BUG5613
      ** Check Numeric                                                                       BUG5613
     C                   When      WKN(EN) >= '0'                                            BUG5613
     C                             And WKN(EN) <= '9'                                        BUG5613
      ** Select2                                                                             BUG5613
     C                   Select                                                              BUG5613
      ** Check numeric and space then reset space flag                                       BUG5613
     C                   When      WKNumS = 'N'                                              BUG5613
     C                             And WKNumN = 'N'                                          BUG5613
     C                   Eval      WKNumS = 'N'                                              BUG5613
     C                   Eval      WKNumN = 'Y'                                              BUG5613
      ** Check numeric, space and numeric                                                    BUG5613
     C                   When      WKNumS = 'Y'                                              BUG5613
     C                             And WKNumN = 'Y'                                          BUG5613
     C                   Eval      WKNumF = 'N'                                              BUG5613
     C                   Leave                                                               BUG5613
     C                   EndSL                                                               BUG5613
      ** EndSL2                                                                              BUG5613
     C                   Other                                                               BUG5613
      ** Other1                                                                              BUG5613
      ** Check Non-numeric                                                                   BUG5613
     C                   Eval      WKNumF = 'N'                                              BUG5613
     C                   Leave                                                               BUG5613
     C                   EndSL                                                               BUG5613
      ** EndSL1                                                                              BUG5613
     C                   EndDo                                                               BUG5613
     C                   EndSR                                                               BUG5613
      *                                                                                      BUG5613
      *****************************************************************                      BUG5613
      *                                                               *                      BUG5613
      *  D2CNUM - Convert with leading zeroes to the left             *                      BUG5613
      *                                                               *                      BUG5613
      *****************************************************************                      BUG5613
     C     D2CNUM        BegSR                                                               BUG5613
     C                   Eval      WKNT = *Blanks                                            BUG5613
      **                                                                                     BUG5613
     C                   Z-Add     0             EN                                          BUG5613
     C     1             Do        WNDLEN        EN                                          BUG5613
     C                   Eval      WKNT(EN) = '0'                                            BUG5613
     C                   EndDo                                                               BUG5613
      **                                                                                     BUG5613
     C                   Z-Add     WNDLEN        EN1               3 0                       BUG5613
     C                   Z-Add     WNDLEN        EN2               3 0                       BUG5613
     C     1             Do        WNDLEN                                                    BUG5613
      **                                                                                     BUG5613
     C                   If        WKN(EN2) <> ' '                                           BUG5613
     C                   Eval      WKNT(EN1) = WKN(EN2)                                      BUG5613
     C                   Eval      EN1 = EN1 - 1                                             BUG5613
     C                   EndIf                                                               BUG5613
     C                   Eval      EN2 = EN2 - 1                                             BUG5613
      **                                                                                     BUG5613
     C                   EndDo                                                               BUG5613
     C                   EndSR                                                               BUG5613
     CSR   D3VPGM        BEGSR
      *================================================================
      * Validate when GJVDTA is *PROGRAM in Header Reference file
      *================================================================
      *
      * Define parameter fileds.
     C     *LIKE         DEFINE    GJSVAL        P2SVAL                         System Value
     C     *LIKE         DEFINE    #1VAL         P2VAL                          Cur. Setting
     C     *LIKE         DEFINE    WUPMDE        P2PMDE                         Program Mode
      *
     C     KLRFL2        CHAIN     GPSVRFL2                           90
      *
      * If record does not exist, error
     C     *IN90         IFEQ      '1'
     C                   SETON                                        99
      *    Send message 'System Value Detail Reference record not found'
     C                   MOVEL     'GPM0041'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      D3EXIT
     C                   ENDIF
      *
     C                   SETOFF                                       U7U8
      *
     C                   CALL      WUPGMN
     C                   PARM      GJSVAL        P2SVAL                         System Value
     C                   PARM      #1VAL         P2VAL                          Cur. Setting
     C                   PARM      WUPMDE        P2PMDE                         Program Mode
     C                   PARM      *BLANKS       P2EIND            1            Error Ind.
     C                   PARM      0             P2NUME            2 0          No. of Err. Msg.
     C                   PARM      *BLANKS       P2A                            Error Msg Array
      *
     C     P2EIND        IFEQ      'Y'
     C     P2NUME        ANDGT     0
     C* Send all the messages specified in the Error Array.
     C                   Z-ADD     1             PX                3 0          P2A index
     C     PX            DOWLE     P2NUME
     C                   MOVEA     P2A(PX)       ZAMSID
     C                   EXSR      ZASNMS
     C                   ADD       1             PX
     C                   ENDDO
      *
     C                   ENDIF
      *
     C     *INU7         IFEQ      '1'
     C     *INU8         ANDEQ     '1'
     C     P2EIND        OREQ      'Y'
     C                   SETON                                        3599
      * Send the message specified in filed #1EMSG
     C                   MOVEL     #1EMSG        ZAMSID
     C                   EXSR      ZASNMS
      *
     C                   ENDIF
      *
     CSR   D3EXIT        ENDSR
      /EJECT
     CSR   D4VEXS        BEGSR
      *================================================================
      * Validate when GJVDTA is *EXISTS in Header Reference file
      *================================================================
      *
     C     KLRFL2        CHAIN     GPSVRFL2                           90
      *
      * If record does not exist, error
     C     *IN90         IFEQ      '1'
     C                   SETON                                        99
      *    Send message 'System Value Detail Reference record not found'
     C                   MOVEL     'GPM0041'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      D4EXIT
     C                   ENDIF
      *
      * Check whether object does actually exist in '*LIBL'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD           10
     C                   PARM      #1VAL         P2OBNM           10
     C                   PARM      '*LIBL'       P2TLIB           10
     C                   PARM      GJVDT2        P2OBTP            8
     C                   PARM                    CHKMBR           10
      *
      * If object does not exist in the library list, send message
      *    Object not exists in *LIBL.
     C     RTNCOD        IFNE      'Exist'
     C                   SETON                                        3599
     C                   MOVEL     'GPM0043'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     GIEMSG        ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     CSR   D4EXIT        ENDSR
      /EJECT
     CSR   EBPR##        BEGSR
      *================================================================
      * Process details screen:
      *   - Validate input
      *   - Update System Value file if no validation error.
      *================================================================
      *
      * Validate input
     C                   EXSR      DCVLCS
      * QUIT if error:
     C   99              GOTO      EBEXIT
      *
      * No error: update record
      * Change System Value  - System Values  *
     C                   EXSR      SYCHRC
     C     W0RTN         IFNE      *BLANK
      * Data update error
      * Reset screen fields if changed record
     C     W0RTN         CASEQ     'GPM0045'     MBFL#1
     C                   END
     C                   ELSE
     C                   EXSR      ZXEXPG
     C                   END
      *
      *================================================================
     CSR   EBEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @1VALL0 fields to screen
      *================================================================
     C                   MOVEL     GISVAL        #1SVAL                         System Value
     C                   MOVEL     GIMMOD        #1MMOD                         Midas Module
     C                   MOVEL     GIMMSN        #1MMSN                         Midas Module Shortna
     C                   MOVEL     GIDESC        #1DESC                         Description
     C                   MOVEL     GIVAL         #1VAL                          Current setting
     C                   MOVEL     GIDFT         #1DFT                          Default Setting
     C                   MOVEL     GIHELP        #1HELP                         User Help Info
     C                   MOVEL     GIATTR        #1ATTR                         Attributes
     C**********         MOVEL     GIDLEN        #1DLEN                         Data String LBUG5613
     C                   Eval      #1DLEN = %INT(GIDLEN)                                     BUG5613
     C                   MOVEL     GISUPP        #1SUPP                         Suppress Update
     C                   MOVEL     GISWCH        #1SWCH                         Switchable Feature
     C                   MOVEL     GIJUST        #1JUST                         Justification
     C                   MOVEL     GIALWB        #1ALWB                         Allow Blanks
     C                   MOVEL     GIEMSG        #1EMSG                         General Error Messag
      *
      **Convert*Last*Change*Date*from*Midas*day*number*format*to*date*                        CPK019
     C*****              Z-ADD     GILCD         ZDAYNO                                       CPK019
     C*****              CALLB     'ZDATE2'                                                   CPK019
     C*****              PARM                    ZDAYNO            5 0                        CPK019
     C*****              PARM                    DFF                                          CPK019
     C*****              PARM                    ZDATE             6 0                        CPK019
     C*****              PARM                    ZADATE            7                          CPK019
     C*****              MOVE      ZADATE        #1LCD                          Last Change DaCPK019
      *
      * Set On/Off indicators to display right text depending on the value of
      * the field GILCT.
     C     GILCT         IFEQ      'I'
     C                   SETON                                        61        Insert
     C                   END
     C     GILCT         IFEQ      'A'
     C                   SETOFF                                       61        Amend
     C                   END
      *
      * Hold existing record image
     C                   MOVEL     @1DBRC        #1DBRC
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   SYCHRC        BEGSR
      *================================================================
      * Change System Values record *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Chain to system value file
     C     KRTV          CHAIN     GPSVALL0                           90        *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'GPM0044'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'GPM0044'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      SYEXIT
     C                   END
      *
      * Check for changed record
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'GPM0045'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'GPM0045'     ZAMSID
     C                   EXSR      ZASNMS
      * Release record lock
     C                   UNLOCK    GPSVALL0                                     *
     C                   GOTO      SYEXIT
     C                   END                                                    FI #1DBRC
      *
      * Move amendable field to @SVALL0
     C                   MOVEL     #1VAL         GIVAL
     C                   MOVEL     'A'           GILCT                          Last Change Type
      **Move*Midas*run*day*to*Last*Change*Date*                                               CPK019
     C*****              Z-ADD     WURDNB        GILCD                          Last Change DaCPK019
      *
     C                   UPDATE    @SVALL0
      *
      *================================================================
     CSR   SYEXIT        ENDSR
      /EJECT
     CSR   Y8TST         BEGSR
      *================================================================
      * Test cursor
      *================================================================
     C                   Z-ADD     @#RWCL        ZINPOS            5 0
     C     ZINPOS        DIV       256           W0CRW
     C                   MVR                     W0CCL
      *================================================================
     CSR   Y8EXIT        ENDSR
      /EJECT
     CSR   ZASNMS        BEGSR
      *================================================================
      * Send message to program's message queue
      *================================================================
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   END
      * If no message file specified, use default
     C                   MOVEL     'GPUSRMSG'    ZAMSGF
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C                   PARM                    ZAMSTP            7            Message type
      * Clear all fields for default mechanism next time
     C                   MOVEL     *BLANK        ZAPGMQ
     C                   MOVEL     *BLANK        ZAPGRL
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSTP
      *================================================================
     CSR   ZAEXIT        ENDSR
      /EJECT
     CSR   ZXEXPG        BEGSR
      *================================================================
      * Cancel and exit from key screen
      *================================================================
      * USER: Exit program processing
      *
      * CASE: KEY.*CMD key is *Exit
     C     *IN03         IFEQ      '1'                                          *IF
     C                   MOVEL     'GPM0046'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE                                                   *FI
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
     C                   END
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct
      *================================================================
      * Terminate program
     C                   SETON                                        LR
      *
      * Exit program
     C                   RETURN
      *
      *================================================================
     CSR   ZYEXIT        ENDSR
      /EJECT
     CSR   ZZINIT        BEGSR
      *================================================================
      * Initialisation
      *================================================================
     C     W0ICL         IFEQ      *BLANK
     C                   MOVEL     'Y'           W0ICL             1            *Initial call
     C                   ELSE
     C                   MOVEL     'N'           W0ICL
     C                   END
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
     C                   MOVEL     *ZEROS        W0RTW             9 0
      *
      * Update screen time
     C                   TIME                    ##TME             6 0
      *
      **Define*work*field*Run*day*number*                                                     CPK019
     C*****              Z-ADD     *ZERO         WURDNB            5 0                        CPK019
      *
      * Flag no *SET CURSOR in the program
     C                   MOVE      *BLANK        WCSRLC            3
      *
      * Define *Synon program work fields
     C                   MOVEL     *BLANKS       W0CFL            10            *Cursor field
     C                   Z-ADD     *ZEROS        W0CRW             5 0          *Cursor row
     C                   Z-ADD     *ZEROS        W0CCL             5 0          *Cursor column
      * Move main file information to JOB context
     C                   MOVE      @1FFL         ZZFFL            10            Main file name
     C                   MOVE      @1FLB         ZZFLB            10            Main file lib
     C                   MOVE      @1FMB         ZZFMB            10            Main file mbr
     C                   MOVE      ZZFFL         @1FFL            10
     C                   MOVE      ZZFLB         @1FLB            10
     C                   MOVE      ZZFMB         @1FMB            10
     C                   CALL      'Y2QLVNR'
     C                   PARM                    ZZFFL            10
     C                   PARM                    ZZFLB            10
     C                   PARM                    ZZFQL            21            LIBRARY/FILE
     C                   MOVEL     *BLANK        W0GRP             1
      *
      **Get*Rundate***Rundate***                                                              CPK019
     C******DTAARA       DEFINE                  RUNDAT                                       CPK019
     C*****              IN        RUNDAT                                                     CPK019
     C*****              MOVE      MRDT          ##MRDT            7            RUN DATE      CPK019
     C*****              MOVE      RDNB          WURDNB                         RUNDAY NO.    CPK019
      *
      * Set-up DTL Screen Footer - Standard Functions  *
      *
      *  DETAIL LINE COMMAND KEY TEXT
      *
     C                   MOVEL     'GPUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
      *
      *  If Action Code is Amend :
      *
     C     P1SEL         IFEQ      'A'
      *
      *  Set on indicator for enabling CA5 and current setting input capable.
     C                   SETON                                        87
      * Setup footer text:
      * F3=Main Menu   F12=Previous    F5=Reset to Default
     C                   MOVEL     'GPM0047'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'GPM0031'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'GPM0031'     ZAMSID
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
      *
      *  If Action Code is Enquiry.
      *
     C     P1SEL         IFEQ      'E'
      *
      *  Set off indicator for enabling CA5 and current setting input capable.
     C                   SETOFF                                       87
      *
      * Setup footer text:
      * F3=Main Menu   F12=Previous    F5=Reset to Default
     C                   MOVEL     'GPM0048'     WUMSID                         Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'GPM0031'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'GPM0031'     ZAMSID
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
      *
     CSR   ZZEXIT        ENDSR
      /EJECT
     CSR   *PSSR         BEGSR
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
      * Standard Midas PSSR processing.
      *
     C***/COPY*SDCPYSRC,SDPSSRINTI*                                                           CPK022
     C*COPY*SDCPYSRC,SDPSSRINTI*                                                       CPK022 CPK025
     C/COPY GPCPYSRCG,SDPSSRINTI                                                              CPK025
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
     O*
** CPY@     : Copyright notice for inclusion in all programs
(c) Finastra International Limited 2004
** PGM@     : Programs to call
GPC009520
