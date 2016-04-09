     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Midas system values maintenance/enquiry')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD9501 - System Values Maintenance/Enquiry                   *
      *                                                               *
      *  Function:  This program allows user to enquire/maintain      *
      *             the current setting of a System Value.            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. AR994044           Date 26Jun12               *
      *  Prev Amend No. AR796650           Date 27Jun11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205             Date 23Mar10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 254333             Date 15Apr08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSC027             Date 27Feb06               *
      *                 CDL045             Date 27Feb06               *
      *                 BUG10064           Date 26Jan06               *
      *                 BUG7330            Date 03Jun05               *
      *                 BUG6781            Date 13May05               *
      *                 CRE019             Date 15Mar04               *
      *                 CSC018             Date 25Jun03               *
      *                 216378             Date 17Mar03               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  AR994044 - Field tag 72 Seq C is missing in MT300 if deal    *
      *             type is AT and CSW212 and CSW005 is on            *
      *  AR796650 - Use of data area Y2MGFLA is redundant             *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *           (Recompile)                                         *
      *  254333 - Error on Sysval maint - if General Error Message    *
      *           is blank                                            *
      *  CSC027  - Head Office Extracts                               *
      *           - Add a new built in function to test that a        *
      *             specified object exists in a specified library.   *
      *  CDL045  - Capture Account Keys                               *
      *           - Add a new built in function to test that a        *
      *             specified library exists in the system.           *
      *  BUG10064 - Applied BUG7330 Reopen and BUG8077.               *
      *  BUG7330 - Cannot amend RolloverDays system value             *
      *  BUG6781 - Error message appeared, although valid current     *
      *            setting was entered                                *
      *  CRE019 - Cheque Processing and Maintenance                   *
      *  CSC018 - High Availability Enhangements.                     *
      *           - Extend program mode from 10 to 190 long.          *
      *  216378 - Convert to RPGLE type                               *
      *         - Amend to send GIEMSG after specific validation error*
      *           messages.                                           *
      *         - Add program id as parameter when calling SDC009520. *
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
     FSD009501DFCF   E             WORKSTN
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas SD System Values maintenance/enquiry
      *
     FSDSVALL0  UF   E           K DISK
     F                                     INFDS(INFDS1)
     F                                     INFSR(*PSSR)
      * RTV/UPD : Midas SD All Midas System Value by System Value
      *
     FSDSVRFL0  IF   E           K DISK
     F                                     INFSR(*PSSR)
      * RTV : Midas SD System Value Header Reference
      *
     FSDSVRFL1  IF   E           K DISK
     F                                     INFSR(*PSSR)
      * RTV : Midas SD System Value Detail Reference (3 keys)
      *
     FSDSVRFL2  IF   E           K DISK
     F                                     INFSR(*PSSR)
      * RTV : Midas SD System Value Detail Reference (2 keys)
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
     D WKN             S              1    DIM(200)                                         BUG10064
     D WKNT            S              1    DIM(200)                                         BUG10064
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
     D @1DBRC        E DS                  EXTNAME(SDSVALL0)
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
     D**WUPMDE*****           11     20                                                       CSC018
     D  WUPMDE                11    200                                                       CSC018
      *
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
      *
     D                 DS
     D  ZAMSDA                 1    132
                                                                                             BUG7330
      ** Declare variables for field range validations                                       BUG7330
                                                                                             BUG7330
     D #1VLD           S            200                                                      BUG7330
     D WRNGU1          S            200                                                      BUG7330
     D WRNGU2          S            200                                                      BUG7330
     D WUMSGF          S             10    INZ('GBSDUSRMSG')                                 BUG7330
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
     C     KRTV          CHAIN     SDSVALL0                           90        *
      *
      * If record does not exist, error
     C     *IN90         IFEQ      '1'
     C                   SETON                                        99        *
      * Send message 'System value record not found'
     C                   MOVEL     'USR4616'     ZAMSID
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
     C                   PARM      'SD009501'    WQ0009           10            Calling Pgm
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
     C                   MOVEL     'USR4617'     ZAMSID
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
     C                   MOVEL     'USR4619'     ZAMSID
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
      * Chain to SDSVRFL0 for type of validation for the system value.
     C     #1SVAL        CHAIN     SDSVRFL0                           90
      *
      * If record does not exist, error
     C     *IN90         IFEQ      '1'
     C                   SETON                                        99
      * Send message 'System Value Header Reference record not found'
     C                   MOVEL     'USR4618'     ZAMSID
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
     C     GJVDTA        CASEQ     '*EXISTLIB'   D5VEXS                                       CDL045
     C     GJVDTA        CASEQ     '*EXSTOLIB'   D6VEXS                                       CSC027
     C                   ENDCS
      *
     C   99
     CANN35              GOTO      DCEXIT
      * Get next Header Reference record
     C                   READ      SDSVRFL0                               92
     C                   ENDDO
      *
     CSR   DCEXIT        ENDSR
      /EJECT
     CSR   D1VVAL        BEGSR
      *================================================================
      * Validate when GJVDTA is *VALUES in Header Reference file
      *================================================================
      *
      ** Key chaining to SDSVRFL1 .
     C     KLRFL1        KLIST
     C                   KFLD                    GJSVAL
     C                   KFLD                    GJSEQ
     C                   KFLD                    #1VAL
      *
     C     KLRFL1        CHAIN     SDSVRFL1                           90
      *
      * If record does not exist, error
     C     *IN90         IFEQ      '1'
     C                   SETON                                        3599
      *
      * Send message 'Value not found in the System Value Detail Reference file'
     C**********         MOVEL     'USR4620'     ZAMSID                                     AR994044
     C**********         EXSR      ZASNMS                                                   AR994044
     C*****GIEMSG        IFNE      '       '                                         254333 AR994044
     C**********         MOVEL     GIEMSG        ZAMSID                                     AR994044
     C**********         EXSR      ZASNMS                                                   AR994044
     C**********         ENDIF                                                       254333 AR994044
     C                   MOVEL     GIEMSG        ZAMSID                                     AR994044
     C     GIEMSG        IFEQ      '       '                                                AR994044
     C                   MOVEL     'USR4620'     ZAMSID                                     AR994044
     C                   ENDIF                                                              AR994044
     C                   EXSR      ZASNMS                                                   AR994044
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
      * Key chaining to SDSVRFL2 .
     C     KLRFL2        KLIST
     C                   KFLD                    GJSVAL
     C                   KFLD                    GJSEQ
      *
     C     KLRFL2        CHAIN     SDSVRFL2                           90
      *
      * If record does not exist, error
     C     *IN90         IFEQ      '1'
     C                   SETON                                        9935
      *    Send message 'System Value Detail Reference record not found'
     C                   MOVEL     'USR4621'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      D2EXIT
     C                   ELSE
      *
      * Else Save GJVDTA1 as range limit 1
     C                   MOVEL     GJVDT2        WURNG1
     C                   ENDIF
      *
      * Read next record in SDSVRFL2 with the same key values.
     C     KLRFL2        READE     SDSVRFL2                               92
      *
      * If record does not exist, error
     C     *IN92         IFEQ      '1'
     C                   SETON                                        99
      *    Send message 'System Value Detail Reference record not found'
     C                   MOVEL     'USR4621'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      D2EXIT
     C                   ELSE
      *
      * Else Save GJVDTA1 as range limit 2
     C                   MOVEL     GJVDT2        WURNG2
     C                   ENDIF
                                                                                             BUG7330
      ** Right justify the input field for validation purposes                               BUG7330
                                                                                             BUG7330
     C                   MOVEA(P)  #1VAL         WKV                                         BUG7330
     C                   MOVEL     #1VAL         #1VLD                                       BUG7330
     C                   EXSR      D2VPGM                                                    BUG7330
     C                   IF        TMP(200) <> *BLANKS                                       BUG7330
     C                   MOVEA(P)  TMP           #1VLD                                       BUG7330
     C                   ENDIF                                                               BUG7330
                                                                                             BUG7330
      ** Right justify range fld 1 for validation purposes                                   BUG7330
                                                                                             BUG7330
     C                   MOVEA(P)  WURNG1        WKV                                         BUG7330
     C                   EXSR      D2VPGM                                                    BUG7330
     C                   MOVEA(P)  TMP           WRNGU1                                      BUG7330
                                                                                             BUG7330
      ** Right justify range fld 2 for validation purposes                                   BUG7330
                                                                                             BUG7330
     C                   MOVEA(P)  WURNG2        WKV                                         BUG7330
     C                   EXSR      D2VPGM                                                    BUG7330
     C                   MOVEA(P)  TMP           WRNGU2                                      BUG7330
      *
      ** Check if value input, minimun and maximum range are numeric                        BUG10064
      *                                                                                     BUG10064
     C                   Move      *Blanks       WKNumVal          1                        BUG10064
     C                   Move      *Blanks       WKNumMin          1                        BUG10064
     C                   Move      *Blanks       WKNumMax          1                        BUG10064
      ** New system value                                                                   BUG10064
     C                   Move      'Y'           WKNumF            1                        BUG10064
     C                   MOVEA(P)  #1VAL         WKN                                        BUG10064
     C                   EXSR      D2VNUM                                                   BUG10064
     C                   Eval      WKNumVal = WKNumF                                        BUG10064
      **                                                                                    BUG10064
     C                   If        WKNumF = 'Y'                                             BUG10064
     C                   Exsr      D2CNUM                                                   BUG10064
     C                   MoveA     WKNT          #1VLD                                      BUG10064
     C                   EndIf                                                              BUG10064
      ** Minimum range                                                                      BUG10064
     C                   Move      'Y'           WKNumF                                     BUG10064
     C                   MOVEA(P)  WURNG1        WKN                                        BUG10064
     C                   EXSR      D2VNUM                                                   BUG10064
     C                   Eval      WKNumMin = WKNumF                                        BUG10064
      **                                                                                    BUG10064
     C                   If        WKNumF = 'Y'                                             BUG10064
     C                   Exsr      D2CNUM                                                   BUG10064
     C                   MoveA     WKNT          WRNGU1                                     BUG10064
     C                   EndIf                                                              BUG10064
      ** Maximum range                                                                      BUG10064
     C                   Move      'Y'           WKNumF                                     BUG10064
     C                   MOVEA(P)  WURNG2        WKN                                        BUG10064
     C                   EXSR      D2VNUM                                                   BUG10064
     C                   Eval      WKNumMax = WKNumF                                        BUG10064
      **                                                                                    BUG10064
     C                   If        WKNumF = 'Y'                                             BUG10064
     C                   Exsr      D2CNUM                                                   BUG10064
     C                   MoveA     WKNT          WRNGU2                                     BUG10064
     C                   EndIf                                                              BUG10064
      **                                                                                    BUG10064
     C                   If        WKNumMin = 'Y'                                           BUG10064
     C                             And WKNumMax = 'Y'                                       BUG10064
     C                   If        WKNumVal = 'N'                                           BUG10064
     C                   SETON                                        3599                  BUG10064
      ** Send message 'Value entered must be numeric'.                                      BUG10064
     C                   MOVEL     'USR0822'     ZAMSID                                     BUG10064
     C                   EXSR      ZASNMS                                                   BUG10064
     C                   Else                                                               BUG10064
     C                   Eval      #1VAL = #1VLD                                            BUG10064
     C                   EndIf                                                              BUG10064
     C                   EndIf                                                              BUG10064
      **                                                                                    BUG10064
      **Check*if*#1VAL*is*within*the*range*WURNG1*to*WURNG2.***********                      BUG7330
     C*****#1VAL         IFGE      WURNG1                                                    BUG7330
     C*****#1VAL         ANDLE     WURNG2                                                    BUG7330
                                                                                             BUG7330
      ** Check if #1VLD is within the range WRNGU1 to WRNGU2.                                BUG7330
                                                                                             BUG7330
     C     #1VLD         IFGE      WRNGU1                                                    BUG7330
     C     #1VLD         ANDLE     WRNGU2                                                    BUG7330
      *
     C                   ELSE
      * Else error
     C                   SETON                                        3599
      * Send message 'Value not within the range.' id to Error array.
     C                   MOVEL     'USR4622'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     GIEMSG        ZAMSID
      *                                                                                       254333
      ** Check if General Error Message is blank, then move value before executing ZASNMS     254333
      *                                                                                       254333
     C     GIEMSG        IFEQ      '       '                                                  254333
     C                   MOVEL     'USR4620'     ZAMSID                                       254333
     C                   ENDIF                                                                254333
      *                                                                                       254333
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     CSR   D2EXIT        ENDSR
      /EJECT
      *****************************************************************                      BUG7330
      *                                                               *                      BUG7330
      *  D2VPGM - Set the field to right justify for proper validation*                      BUG7330
      *                                                               *                      BUG7330
      *****************************************************************                      BUG7330
                                                                                             BUG7330
     C     D2VPGM        BEGSR                                                               BUG7330
                                                                                             BUG7330
      ** Get the end position.                                                               BUG7330
                                                                                             BUG7330
     C                   Z-ADD     WNDLEN        EX                                          BUG7330
     C     WKV(EX)       DOWEQ     *BLANK                                                    BUG7330
     C                   SUB       1             EX                                          BUG7330
     C                   ENDDO                                                               BUG7330
                                                                                             BUG7330
      ** Only shift data to the rightmost of #1DLEN if ending at position                    BUG7330
      ** less than #1DLEN.                                                                   BUG7330
                                                                                             BUG7330
     C                   MOVEA(P)  WKV           TMP                                        BUG10064
     C     EX            IFLT      WNDLEN                                                    BUG7330
     C                   Z-ADD     EX            WX                                          BUG7330
     C                   Z-ADD     WNDLEN        TX                                          BUG7330
     C                   MOVEA(P)  *BLANK        TMP                                         BUG7330
                                                                                             BUG7330
     C     WX            DOWGE     1                                                         BUG7330
     C                   MOVEA     WKV(WX)       TMP(TX)                                     BUG7330
     C                   SUB       1             TX                                          BUG7330
     C                   SUB       1             WX                                          BUG7330
     C                   ENDDO                                                               BUG7330
                                                                                             BUG7330
     C                   Z-ADD     WNDLEN        EX                                          BUG7330
     C                   ENDIF                                                               BUG7330
                                                                                             BUG7330
     C                   ENDSR                                                               BUG7330
                                                                                             BUG7330
      *****************************************************************                      BUG7330
      /EJECT                                                                                 BUG7330
      *****************************************************************                      BUG7330
      *                                                                                     BUG10064
      *****************************************************************                     BUG10064
      *                                                               *                     BUG10064
      *  D2VNUM - Check if numeric field                              *                     BUG10064
      *                                                               *                     BUG10064
      *****************************************************************                     BUG10064
                                                                                            BUG10064
     C     D2VNUM        BegSR                                                              BUG10064
     C                   Move      'N'           WKNumS            1                        BUG10064
     C                   Move      'N'           WKNumN            1                        BUG10064
     C                   Z-Add     0             EN                3 0                      BUG10064
     C     1             Do        WNDLEN        EN                                         BUG10064
      ** Select1                                                                            BUG10064
     C                   Select                                                             BUG10064
      ** Check spaces                                                                       BUG10064
     C                   When      WKN(EN) = ' '                                            BUG10064
      **                                                                                    BUG10064
     C                   If        WKNumS = 'N'                                             BUG10064
     C                             And WKNumN = 'Y'                                         BUG10064
     C                   Eval      WKNumS = 'Y'                                             BUG10064
     C                   EndIf                                                              BUG10064
      ** Check Numeric                                                                      BUG10064
     C                   When      WKN(EN) >= '0'                                           BUG10064
     C                             And WKN(EN) <= '9'                                       BUG10064
      ** Select2                                                                            BUG10064
     C                   Select                                                             BUG10064
      ** Check numeric and space then reset space flag                                      BUG10064
     C                   When      WKNumS = 'N'                                             BUG10064
     C                             And WKNumN = 'N'                                         BUG10064
     C                   Eval      WKNumS = 'N'                                             BUG10064
     C                   Eval      WKNumN = 'Y'                                             BUG10064
      ** Check numeric, space and numeric                                                   BUG10064
     C                   When      WKNumS = 'Y'                                             BUG10064
     C                             And WKNumN = 'Y'                                         BUG10064
     C                   Eval      WKNumF = 'N'                                             BUG10064
     C                   Leave                                                              BUG10064
     C                   EndSL                                                              BUG10064
      ** EndSL2                                                                             BUG10064
     C                   Other                                                              BUG10064
      ** Other1                                                                             BUG10064
      ** Check Non-numeric                                                                  BUG10064
     C                   Eval      WKNumF = 'N'                                             BUG10064
     C                   Leave                                                              BUG10064
     C                   EndSL                                                              BUG10064
      ** EndSL1                                                                             BUG10064
     C                   EndDo                                                              BUG10064
     C                   EndSR                                                              BUG10064
      *                                                                                     BUG10064
      *****************************************************************                     BUG10064
      *                                                               *                     BUG10064
      *  D2CNUM - Convert with leading zeroes to the left             *                     BUG10064
      *                                                               *                     BUG10064
      *****************************************************************                     BUG10064
     C     D2CNUM        BegSR                                                              BUG10064
     C                   Eval      WKNT = *Blanks                                           BUG10064
      **                                                                                    BUG10064
     C                   Z-Add     0             EN                                         BUG10064
     C     1             Do        WNDLEN        EN                                         BUG10064
     C                   Eval      WKNT(EN) = '0'                                           BUG10064
     C                   EndDo                                                              BUG10064
      **                                                                                    BUG10064
     C                   Z-Add     WNDLEN        EN1               3 0                      BUG10064
     C                   Z-Add     WNDLEN        EN2               3 0                      BUG10064
     C     1             Do        WNDLEN                                                   BUG10064
      **                                                                                    BUG10064
     C                   If        WKN(EN2) <> ' '                                          BUG10064
     C                   Eval      WKNT(EN1) = WKN(EN2)                                     BUG10064
     C                   Eval      EN1 = EN1 - 1                                            BUG10064
     C                   EndIf                                                              BUG10064
     C                   Eval      EN2 = EN2 - 1                                            BUG10064
      **                                                                                    BUG10064
     C                   EndDo                                                              BUG10064
     C                   EndSR                                                              BUG10064
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
     C     KLRFL2        CHAIN     SDSVRFL2                           90
      *
      * If record does not exist, error
     C     *IN90         IFEQ      '1'
     C                   SETON                                        99
      *    Send message 'System Value Detail Reference record not found'
     C                   MOVEL     'USR4621'     ZAMSID
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
     C                   MOVE      P2VAL         #1VAL                                        CRE019
      *                                                                                       CRE019
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
     C     KLRFL2        CHAIN     SDSVRFL2                           90
      *
      * If record does not exist, error
     C     *IN90         IFEQ      '1'
     C                   SETON                                        99
      *    Send message 'System Value Detail Reference record not found'
     C                   MOVEL     'USR4621'     ZAMSID
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
     C                   MOVEL     'USR4623'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     GIEMSG        ZAMSID
      *                                                                                       254333
      ** Check if General Error Message is blank, then move value before executing ZASNMS     254333
      *                                                                                       254333
     C     GIEMSG        IFEQ      '       '                                                  254333
     C                   MOVEL     'USR4620'     ZAMSID                                       254333
     C                   ENDIF                                                                254333
      *                                                                                       254333
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     CSR   D4EXIT        ENDSR
      /EJECT                                                                                  CDL045
     CSR   D5VEXS        BEGSR                                                                CDL045
      *================================================================                       CDL045
      * Validate when GJVDTA is *EXISTLIB in Header Reference file                            CDL045
      *================================================================                       CDL045
      *                                                                                       CDL045
     C     KLRFL2        CHAIN     SDSVRFL2                           90                      CDL045
      *                                                                                       CDL045
      * If record does not exist, error                                                       CDL045
     C     *IN90         IFEQ      '1'                                                        CDL045
     C                   SETON                                        99                      CDL045
      *    Send message 'System Value Detail Reference record not found'                      CDL045
     C                   MOVEL     'USR4621'     ZAMSID                                       CDL045
     C                   EXSR      ZASNMS                                                     CDL045
     C                   GOTO      D5EXIT                                                     CDL045
     C                   ENDIF                                                                CDL045
      *                                                                                       CDL045
      * Check whether object does actually exist in 'QSYS'                                    CDL045
     C                   CALL      'UTCHKOBJ'                                                 CDL045
     C                   PARM      *BLANK        RTNCOD           10                          CDL045
     C                   PARM      #1VAL         P2OBNM           10                          CDL045
     C                   PARM      'QSYS '       P2TLIB           10                          CDL045
     C                   PARM      GJVDT2        P2OBTP            8                          CDL045
     C                   PARM                    CHKMBR           10                          CDL045
      *                                                                                       CDL045
      * If object does not exist in the library list, send message                            CDL045
      *    Object not exists in *LIBL.                                                        CDL045
     C     RTNCOD        IFNE      'Exist'                                                    CDL045
     C                   SETON                                        3599                    CDL045
     C                   MOVEL     GIEMSG        ZAMSID                                       CDL045
     C                   EXSR      ZASNMS                                                     CDL045
     C                   ENDIF                                                                CDL045
      *                                                                                       CDL045
     CSR   D5EXIT        ENDSR                                                                CDL045
      /EJECT                                                                                  CSC027
     CSR   D6VEXS        BEGSR                                                                CSC027
      *================================================================                       CSC027
      * Validate when GJVDTA is *EXISTLIB in Header Reference file                            CSC027
      *================================================================                       CSC027
      *                                                                                       CSC027
     C     KLRFL2        CHAIN     SDSVRFL2                           90                      CSC027
      *                                                                                       CSC027
      * If record does not exist, error                                                       CSC027
      *                                                                                       CSC027
     C     *IN90         IFEQ      '1'                                                        CSC027
     C                   SETON                                        99                      CSC027
      **    Send message 'System Value Detail Reference record not found'                     CSC027
     C                   MOVEL     'USR4621'     ZAMSID                                       CSC027
     C                   EXSR      ZASNMS                                                     CSC027
     C                   GOTO      D6EXIT                                                     CSC027
     C                   ENDIF                                                                CSC027
      *                                                                                       CSC027
      ** The first 10 character represents the LIBRARY and the next 10 position contains the  CSC027
      ** object being checked in the library.                                                 CSC027
      *                                                                                       CSC027
     C                   EVAL      P2OBNM = %SUBST(#1VAL:11:10)                               CSC027
     C                   EVAL      P2TLIB = %SUBST(#1VAL:1:10)                                CSC027
      *                                                                                       CSC027
      ** If the library or the object is blank, dont do check object anymore, issue           CSC027
      ** an error message                                                                     CSC027
     C                   IF        P2OBNM = *blanks or P2TLIB = *blanks                       CSC027
     C                   SETON                                        99                      CSC027
      **    Send message 'Object does not exist'                                              CSC027
     C                   MOVEL     GIEMSG        ZAMSID                                       CSC027
     C                   EXSR      ZASNMS                                                     CSC027
     C                   GOTO      D6EXIT                                                     CSC027
     C                   ENDIF                                                                CSC027
      *                                                                                       CSC027
      ** Check whether object does actually exist in specified library.                       CSC027
      *                                                                                       CSC027
     C                   CALL      'UTCHKOBJ'                                                 CSC027
     C                   PARM      *BLANK        RTNCOD           10                          CSC027
     C                   PARM                    P2OBNM           10                          CSC027
     C                   PARM                    P2TLIB           10                          CSC027
     C                   PARM      GJVDT2        P2OBTP            8                          CSC027
     C                   PARM                    CHKMBR           10                          CSC027
      *                                                                                       CSC027
      ** If object does not exist in the library list, send message                           CSC027
      **  Object not exists in specified library                                              CSC027
      *                                                                                       CSC027
     C     RTNCOD        IFNE      'Exist'                                                    CSC027
     C                   SETON                                        3599                    CSC027
     C                   MOVEL     GIEMSG        ZAMSID                                       CSC027
     C                   EXSR      ZASNMS                                                     CSC027
     C                   ENDIF                                                                CSC027
      *                                                                                       CSC027
     CSR   D6EXIT        ENDSR                                                                CSC027
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
     C     W0RTN         CASEQ     'Y2U0007'     MBFL#1
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
     C*                  MOVEL     GIDLEN        #1DLEN                                      BUG6781
     C                   EVAL      #1DLEN = %INT(GIDLEN)                                     BUG6781
     C                   MOVEL     GISUPP        #1SUPP                         Suppress Update
     C                   MOVEL     GISWCH        #1SWCH                         Switchable Feature
     C                   MOVEL     GIJUST        #1JUST                         Justification
     C                   MOVEL     GIALWB        #1ALWB                         Allow Blanks
     C                   MOVEL     GIEMSG        #1EMSG                         General Error Messag
      *
      * Convert Last Change Date from Midas day number format to date
     C                   Z-ADD     GILCD         ZDAYNO
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    DFF
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   MOVE      ZADATE        #1LCD                          Last Change Date
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
     C     KRTV          CHAIN     SDSVALL0                           90        *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SYEXIT
     C                   END
      *
      * Check for changed record
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Release record lock
     C                   UNLOCK    SDSVALL0                                     *
     C                   GOTO      SYEXIT
     C                   END                                                    FI #1DBRC
      *
      * Move amendable field to @SVALL0
     C                   MOVEL     #1VAL         GIVAL
     C                   MOVEL     'A'           GILCT                          Last Change Type
      * Move Midas run day to Last Change Date
     C                   Z-ADD     WURDNB        GILCD                          Last Change Date
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
     C     ZAMSGF        IFEQ      *BLANK
     C**********         MOVEL     ZADFMF        ZAMSGF                                      BUG7330
     C                   MOVEL     WUMSGF        ZAMSGF                                      BUG7330
     C                   END
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
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code
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
      **Obtain*default*message*file*                                                        AR796650
     C******DTAARA       DEFINE    Y2MGFLA       ZADFMF           10                        AR796650
     C**********         IN        ZADFMF                                                   AR796650
      *
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
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
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT            7            RUN DATE
     C                   MOVE      RDNB          WURDNB                         RUNDAY NO.
      *
      * Set-up DTL Screen Footer - Standard Functions  *
      *
      *  DETAIL LINE COMMAND KEY TEXT
      *
     C**********         MOVEL     'SDUSRMSG'    WUMSGF           10                         BUG7330
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
     C                   MOVEL     'USR4614'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
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
     C                   MOVEL     'USR4615'     WUMSID                         Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
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
     C/COPY SDCPYSRC,SDPSSRINTI
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
     O*
** CPY@     : Copyright notice for inclusion in all programs
(c) Misys International Banking Systems Ltd. 2003
** PGM@     : Programs to call
SDC009520
