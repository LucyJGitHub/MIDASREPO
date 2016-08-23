     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Stamp Tax Control Data Screen')               *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data                                        *
      *                                                               *
      *  SD008101 - Stamp Tax Control Data Maintenance                *
      *                                                               *
      *  (c) Copyright Misys International Banking Systems Ltd 2010   *
      *                                                               *
      *  Last Amend No. AR834543           Date 26Sep11               *
      *  Prev Amend No. CER049  *CREATE    Date 06Dec10               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  AR834543 - Error in the effective date                       *
      *  CER049 - Stamp Tax                                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *       03      F3 PRESSED EXIT PROGRAM                         *
      *       20      PROTECT FIELDS                                  *
      *       41      NEW SECURITY CHARGE CODE IS NUMERIC             *
      *       42      NEW EFFECTIVE DATE IS NUMERIC                   *
      *       40      REDISPLAY THE SCREEN                            *
      *       5O      GENERAL ERROR INDICATOR                         *
      *       51      STAMP TAX CURRENCY FIELD IN ERROR               *
      *       52      DEFAULT STAMP TAX RATE FIELD IN ERROR           *
      *       53      SECURITY CHARGE CODE FIELD IN ERROR             *
      *       54      SECURITY STAMP TAX RATE FIELD IN ERROR          *
      *       55      EFFECTIVE DATE FIELD IN ERROR                   *
      *                                                               *
      *****************************************************************
 
     FSDSTPTL1  IF   E           K DISK
     FSDSTPTL0  UF A E           K DISK
      ** Stamp Tax Tax Installation control
 
     FSD008101DFCF   E             WORKSTN
      ** Display file
 
     FSECGT     IF   E           K DISK
      ** Security Charge Code file
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Array containing Copyright statement
 
     D/COPY ZSRSRC,ZALIGNZ1LE
      **  ZALIGN Subroutine Array
 
     D/COPY ZSRSRC,ZDATE9Z1LE
      **  ZDATE9 Subroutine Array
 
      *****************************************************************
      /SPACE 3
      *****************************************************************
     D A@CPY           DS
      ** Copyright array
 
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  ErrorMsg                     60    DIM(6) CTDATA PERRCD(1)
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, Long Data Structure
 
     D LDA           E DS           256    EXTNAME(LDA)
     D  W24          E                     EXTFLD(SPARE)
      ** Local data area for database error details
 
     D PSDS           SDS
      ** Program Status Data Structure - gives Job/Workstation name and
      ** User ID
 
     D  ##PGM            *PROC
     D  JOB                  244    253
     D  WSID                 244    246
     D  USER                 254    263
 
     D                 DS                  INZ
     D  U#EDTE                 1      6
     D  U#EMM                  1      2
     D  U#ECC                  3      4
     D  U#EYY                  5      6
     D                 DS                  INZ
     D  U#6DTE                 1      6  0
     D  U#6ECC                 1      2  0
     D  U#6EYY                 3      4  0
     D  U#6EMM                 5      6  0
     D                 DS                  INZ
     D  U#6DTN                 1      6  0
     D  U#6NCC                 1      2  0
     D  U#6NYY                 3      4  0
     D  U#6NMM                 5      6  0
     D                 DS                  INZ
     D  U#EDTN                 1      6
     D  U#EMMN                 1      2
     D  U#ECCN                 3      4
     D  U#EYYN                 5      6
     D                 DS                  INZ
     D  U#SECN                 1      2
     D  U#SEC1                 1      1
     D  U#SEC2                 2      2
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency Details
 
     I/COPY ZSRSRC,ZDATE9Z2LE
      ** ZDATE9 Subroutine Array
 
     I/COPY ZSRSRC,ZDAT10Z1LE
      ** ZDAT10 Subroutine Array
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *
      *                M A I N  P R O C E S S I N G
      *
      *****************************************************************
 
     C     *ENTRY        PLIST
     C                   PARM                    MODE              1
 
      ** Initialise data
 
     C                   EXSR      INIT
 
      ** Continue to redisplay the screen if *IN40 remains off
 
     C     *IN40         DOUEQ     '1'
 
      **   If error write messages
 
     C     *IN50         IFEQ      '1'
     C                   WRITE     #MSGCTL
     C                   ENDIF
 
      ** If MODE is Enquire then protect fields.
 
     C     MODE          IFEQ      'E'
     C                   SETON                                        20
     C                   ENDIF
 
     C                   EXFMT     FORMAT1
 
      ** Clear message subfile
 
     C                   EXSR      CLEAR
 
     C     *IN03         CASEQ     '1'           END
     C     *IN05         CASEQ     '1'           RESET
     C     *IN13         CASEQ     '1'           RETAIL
     C     *IN14         CASEQ     '1'           DEAL
     C     *IN15         CASEQ     '1'           LOAN
     C     *IN16         CASEQ     '1'           FCLTY
     C     *IN17         CASEQ     '1'           FEES
     C                   CAS                     VALID
     C                   ENDCS
     C                   ENDDO
 
      **   Exit from program
 
     C                   EXSR      END
      *****************************************************************
      * Initial Processing
      *****************************************************************
 
     C     INIT          BEGSR
 
      ** Define the LDA for error handling
 
     C     *DTAARA       DEFINE                  LDA
 
      ** Call Access Program to obtain Banks details from PF/SDBANKPD
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '       '     ULRTCD            7
     C                   PARM      '*FIRST '     ULOPTN            7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Handle Database Error.
 
     C     ULRTCD        IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SD008101'    DBPGM
     C                   MOVE      'SDBANKPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Obtain Midas Run Date
 
     C                   MOVEL     BJMRDT        U#MRDT
 
     C                   MOVEL     'CONTROL'     U#KEY            10
     C     U#KEY         CHAIN     SDSTPTL1                           80
     C     *IN80         IFEQ      *OFF
 
      ** Move fields on file into display fields
 
     C                   MOVE      A1STCY        U#STCY
     C                   MOVE      A1SECC        U#SECC
     C                   MOVE      A1STCN        U#STCN
     C                   MOVE      A1SECN        U#SECN
 
      ** Set up correct output for Tax Rate fields
 
     C     A1STRT        IFEQ      *ZEROS
     C                   MOVE      *BLANKS       U#STRT
     C                   ELSE
     C                   MOVE      A1STRT        ZFIELD
     C                   MOVE      '6'           ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        U#STRT
     C                   ENDIF
 
     C     A1SERT        IFEQ      *ZEROS
     C                   MOVE      *BLANKS       U#SERT
     C                   ELSE
     C                   MOVE      A1SERT        ZFIELD
     C                   MOVE      '6'           ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        U#SERT
     C                   ENDIF
 
     C     A1STRN        IFEQ      *ZEROS
     C                   MOVE      *BLANKS       U#STRN
     C                   ELSE
     C                   MOVE      A1STRN        ZFIELD
     C                   MOVE      '6'           ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        U#STRN
     C                   ENDIF
 
     C     A1SERN        IFEQ      *ZEROS
     C                   MOVE      *BLANKS       U#SERN
     C                   ELSE
     C                   MOVE      A1SERN        ZFIELD
     C                   MOVE      '6'           ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        U#SERN
     C                   ENDIF
 
      ** Convert Midas Day number of Current and New Effective Dates to
      ** MMCCYY format on screen.
 
     C     A1EDTE        IFEQ      *ZEROS
     C                   MOVE      *BLANKS       U#EDTE
     C                   ELSE
     C                   MOVE      A1EDTE        @@DAYN            5 0
     C                   EXSR      ZDATE9
     C                   MOVE      @@VDT         U#8DTE            8 0
     C                   MOVEL     U#8DTE        U#6DTE            6 0
     C                   MOVE      U#6ECC        U#ECC
     C                   MOVE      U#6EYY        U#EYY
     C                   MOVE      U#6EMM        U#EMM
     C                   ENDIF
 
     C     A1EDTN        IFEQ      *ZEROS
     C                   MOVE      *BLANKS       U#EDTN
     C                   ELSE
     C                   MOVE      A1EDTN        @@DAYN
     C                   EXSR      ZDATE9
     C                   MOVE      @@VDT         U#8DTN            8 0
     C                   MOVEL     U#8DTN        U#6DTN            6 0
     C                   MOVE      U#6NCC        U#ECCN
     C                   MOVE      U#6NYY        U#EYYN
     C                   MOVE      U#6NMM        U#EMMN
     C                   ENDIF
 
     C                   ELSE
 
      ** Move BLANKS into display fields
 
     C                   MOVE      *BLANKS       U#STCY
     C                   MOVE      *BLANKS       U#STRT
     C                   MOVE      *BLANKS       U#SECC
     C                   MOVE      *BLANKS       U#SERT
     C                   MOVE      *BLANKS       U#STCN
     C                   MOVE      *BLANKS       U#STRN
     C                   MOVE      *BLANKS       U#SECN
     C                   MOVE      *BLANKS       U#SERN
     C                   ENDIF
     C                   ENDSR
 
      *****************************************************************
      * Validation subroutine
      *****************************************************************
 
     C     VALID         BEGSR
 
      ** If in Enquire mode then exit program
 
     C     MODE          IFEQ      'E'
     C                   EXSR      END
     C                   ENDIF
 
      ** Initialise error indicators
 
     C                   SETOFF                                       505152
     C                   SETOFF                                       535455
 
      ** Validate NEW fields, only if New Effective Date entered
      ** Validate New Stamp Tax Currency
 
     C     U#EDTN        IFNE      *BLANKS
     C     U#STCN        ORNE      *BLANKS
 
     C     U#STCN        IFNE      *BLANKS
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       ULRTCD
     C                   PARM      '*KEY   '     ULOPTN
     C                   PARM      U#STCN        @CCYD             3
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Handle Database Error.
 
     C     ULRTCD        IFNE      *BLANKS
     C     ULRTCD        IFEQ      '*NRF'
 
      ** Send message 'Currency not a valid Currency'
 
     C                   SETON                                        5051
     C                   MOVEL     'USR9986'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ELSE
 
     C     *LOCK         IN        LDA
     C                   MOVEL     'SD008101'    DBPGM
     C                   Z-ADD     2             DBASE
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     U#STCN        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
 
     C                   SETON                                        5051
     C                   MOVEL     'USR9987'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EVAL      ZAMSDA = ErrorMsg(1)
     C                   EXSR      ZASNMS
     C                   ENDIF
 
     C                   ENDIF
 
      ** Validate Default Stamp Tax Rate
 
     C     U#EDTN        IFNE      *BLANKS
     C     U#STRN        ORNE      *BLANKS
     C     U#STRN        IFEQ      *BLANKS
     C                   SETON                                        5052
     C                   MOVEL     'USR9987'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EVAL      ZAMSDA = ErrorMsg(2)
     C                   EXSR      ZASNMS
     C                   ELSE
 
      ** Call ZALIGN
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      U#STRN        ZFIELD
     C                   MOVE      6             ZADEC
     C                   MOVE      7             ZADIG
     C                   EXSR      ZALIGN
 
      ** If error Send message 'Default Stamp Tax Rate not valid'
 
     C     *IN99         IFEQ      *ON
     C                   SETON                                        5052
     C                   MOVEL     'USR9988'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EVAL      ZAMSDA = ErrorMsg(2)
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   MOVE      ZFIELD        ##STRN           13 8
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Security Charge Code
 
     C     U#SECN        IFEQ      *BLANKS
     C                   SETON                                        5053
     C                   MOVEL     'USR9987'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EVAL      ZAMSDA = ErrorMsg(3)
     C                   EXSR      ZASNMS
     C                   ELSE
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      U#SECN        ZFIELD
     C                   MOVE      0             ZADEC
     C                   MOVE      2             ZADIG
     C                   EXSR      ZALIGN
 
     C     *IN99         IFEQ      *ON
     C                   SETON                                        5053
     C                   MOVEL     'USR9946'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
 
     C                   ELSE
 
     C                   IF        *IN51 = *OFF
     C     KEYST         KLIST
     C                   KFLD                    U#STCN
     C                   KFLD                    U#SECN
 
     C     KEYST         SETLL     SECGT
     C     KEYST         CHAIN     SECGT
     C                   IF        NOT %FOUND(SECGT)
     C                   SETON                                        5053
     C                   MOVEL     'USR9947'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Security Stamp Tax Rate
 
     C     U#EDTN        IFNE      *BLANKS
     C     U#SERN        ORNE      *BLANKS
     C     U#SERN        IFEQ      *BLANKS
     C                   SETON                                        5054
     C                   MOVEL     'USR9987'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EVAL      ZAMSDA = ErrorMsg(4)
     C                   EXSR      ZASNMS
     C                   ELSE
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      U#SERN        ZFIELD
     C                   MOVE      6             ZADEC
     C                   MOVE      7             ZADIG
     C                   EXSR      ZALIGN
     C     *IN99         IFEQ      *ON
 
      ** If error Send message 'Security Stamp Tax Rate not valid'
 
     C                   SETON                                        5054
     C                   MOVEL     'USR9988'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EVAL      ZAMSDA = ErrorMsg(4)
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   MOVE      ZFIELD        ##SERN           13 8
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Effective Date
 
     C     U#EDTN        IFNE      *BLANKS
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      U#EDTN        ZFIELD
     C                   MOVE      0             ZADEC
     C                   MOVE      6             ZADIG
     C                   EXSR      ZALIGN
     C     *IN99         IFEQ      *ON
     C                   SETON                                        5055
     C                   ELSE
     C                   MOVE      U#EMMN        ##EMMN            2 0
     C                   MOVE      U#ECCN        ##ECCN            2 0
     C     ##EMMN        IFLT      01
     C     ##EMMN        ORGT      12
     C     ##ECCN        ORGT      20
     C     ##ECCN        ORLT      19
 
     C                   SETON                                        5055
     C                   MOVEL     'USR9948'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
 
      ** If Date is valid, convert New Effective Date to CCYYMM format
      ** from MMCCYY fromat.
 
     C     *IN55         IFEQ      *OFF
     C                   MOVE      U#ECCN        U#6NCC
     C                   MOVE      U#EYYN        U#6NYY
     C                   MOVE      U#EMMN        U#6NMM
 
      ** If New Effective Date is not a future month to Current
      ** Effective Date.
 
     C     U#6DTN        IFLE      U#6DTE
 
      ** Send message The new effective date must be later than
      ** the current effective date
 
     C                   SETON                                        5055
     C                   MOVEL     'USR9949'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        5055
     C                   MOVEL     'USR9948'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        5055
     C                   MOVEL     'USR9950'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
 
      ** If there are any errors *IN40 must be set off, otherwise
      ** set *IN40 on.
 
     C     *IN50         IFEQ      *ON
     C                   SETOFF                                       40
     C                   ELSE
     C                   SETON                                        40
     C                   ENDIF
 
      ** If there is and error in any of the screen fields then need to
      ** redisplay the screen and send all error messages.
 
     C     *IN40         IFEQ      '1'
 
      ** If no errors update file
 
     C                   EXSR      UPDAT
 
      ** Switch off IN40 as hitting Enter should only update the file,
      ** not take the user out of the screen. Need F3 to do this.
      ** Comit changes
 
     C                   COMMIT
     C                   EXSR      RESET
     C                   SETOFF                                       40
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      * Update subroutine
      *****************************************************************
 
     C     UPDAT         BEGSR
 
      ** Chain to SDSTPTPD
 
     C                   MOVEL     'CONTROL'     U#KEY
     C     U#KEY         CHAIN     SDSTPTL0                           80
 
      ** If record found then update otherwise insert
 
     C     *IN80         IFEQ      *OFF
 
      ** Set up type of last change and last change date
 
     C                   MOVE      BJRDNB        A1LCD
     C                   MOVE      'A'           A1TYLC
 
      ** Move display file fields to file fields
 
     C                   MOVE      U#STCN        A1STCN
     C                   MOVE      ##STRN        A1STRN
     C                   MOVE      U#SECN        A1SECN
     C                   MOVE      ##SERN        A1SERN
 
      ** Convert New Effective Date in CCYYMM format to Midas Day No.
 
     C     U#EDTN        IFEQ      *BLANKS
     C                   Z-ADD     *ZERO         A1EDTN
     C                   ELSE
     C                   MOVEL     U#6DTN        ##6DTN            8
     C                   MOVE      '01'          ##6DTN
     C                   MOVE      ##6DTN        ZZDTIN
     C                   EXSR      ZDAT10
     C                   MOVE      ZZMDNO        A1EDTN
     C                   ENDIF
 
     C                   UPDATE    @STPTV0
 
     C                   ELSE
 
      ** Set up type of last change and last change date
 
     C                   MOVE      BJRDNB        A1LCD
     C                   MOVE      'I'           A1TYLC
 
      ** Move display file fields to file fields
 
     C                   MOVEL     'CONTROL'     A1KEY
     C                   MOVE      U#STCN        A1STCN
     C                   MOVE      ##STRN        A1STRN
     C                   MOVE      U#SECN        A1SECN
     C                   MOVE      ##SERN        A1SERN
     C**********         MOVE      U#EDTN        A1EDTN                                     AR834543
     C                   MOVEL     U#6DTN        ##6DTN                                     AR834543
     C                   MOVE      '01'          ##6DTN                                     AR834543
     C                   MOVE      ##6DTN        ZZDTIN                                     AR834543
     C                   EXSR      ZDAT10                                                   AR834543
     C                   MOVE      ZZMDNO        A1EDTN                                     AR834543
     C                   WRITE     @STPTV0
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      * RESET/REFRESH THE SCREEN IF F5 IS PRESSED
      *****************************************************************
     C     RESET         BEGSR
 
      ** Clear the program message queue and call SR/INIT to retrieve
      ** the last committed data from the extension file.
 
     C                   EXSR      CLEAR
     C                   WRITE     #MSGCTL
     C                   EXSR      INIT
 
      ** Reset all error indicators
 
     C                   SETOFF                                       505152
     C                   SETOFF                                       535455
 
     C                   ENDSR
      *****************************************************************
      * Error message subroutine
      *****************************************************************
     C     ZASNMS        BEGSR
 
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   ENDIF
 
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10
     C                   PARM                    ZAPGRL            5
     C                   PARM                    ZAMSID            7
     C                   PARM                    ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM                    ZAMSTP            7
 
     C     ZAEXIT        ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * CLEAR MESSAGE FILE
      *****************************************************************
     C     CLEAR         BEGSR
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * GOTO RETAIL SCREEN
      *****************************************************************
     C     RETAIL        BEGSR
     C                   CALL      'SD008110'
     C                   PARM                    #RTCD             7
     C                   PARM                    MODE
 
     C     #RTCD         IFNE      *BLANKS
 
      ** If F3 pressed from the Retail screen
 
     C     #RTCD         IFEQ      'Y2U9999'
     C                   EXSR      END
     C                   ENDIF
 
      ** If F12 pressed from the Retail screen
 
     C     #RTCD         IFEQ      'USR0790'
 
      ** Clear the program message queue and call SR/INIT to retrieve
      ** the last committed data from the extension file.
 
     C                   EXSR      CLEAR
     C                   WRITE     #MSGCTL
     C                   EXSR      INIT
 
      ** Reset all error indicators
 
     C                   SETOFF                                       505152
     C                   SETOFF                                       535455
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * GOTO DEALING SCREEN
      *****************************************************************
     C     DEAL          BEGSR
     C                   CALL      'SD008112'
     C                   PARM                    #RTCD             7
     C                   PARM                    MODE
 
     C     #RTCD         IFNE      *BLANKS
 
      ** If F3 pressed from the Retail screen
 
     C     #RTCD         IFEQ      'Y2U9999'
     C                   EXSR      END
     C                   ENDIF
 
      ** If F12 pressed from the Retail screen
 
     C     #RTCD         IFEQ      'USR0790'
 
      ** Clear the program message queue and call SR/INIT to retrieve
      ** the last committed data from the extension file.
 
     C                   EXSR      CLEAR
     C                   WRITE     #MSGCTL
     C                   EXSR      INIT
 
      ** Reset all error indicators
 
     C                   SETOFF                                       505152
     C                   SETOFF                                       535455
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * GOTO LOAN SCREEN
      *****************************************************************
     C     LOAN          BEGSR
     C                   CALL      'SD008114'
     C                   PARM                    #RTCD             7
     C                   PARM                    MODE
 
     C     #RTCD         IFNE      *BLANKS
 
      ** If F3 pressed from the Retail screen
 
     C     #RTCD         IFEQ      'Y2U9999'
     C                   EXSR      END
     C                   ENDIF
 
      ** If F12 pressed from the Retail screen
 
     C     #RTCD         IFEQ      'USR0790'
 
      ** Clear the program message queue and call SR/INIT to retrieve
      ** the last committed data from the extension file.
 
     C                   EXSR      CLEAR
     C                   WRITE     #MSGCTL
     C                   EXSR      INIT
 
      ** Reset all error indicators
 
     C                   SETOFF                                       505152
     C                   SETOFF                                       535455
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * GOTO FACILITY SCREEN
      *****************************************************************
     C     FCLTY         BEGSR
     C                   CALL      'SD008116'
     C                   PARM                    #RTCD             7
     C                   PARM                    MODE
 
     C     #RTCD         IFNE      *BLANKS
 
      ** If F3 pressed from the Retail screen
 
     C     #RTCD         IFEQ      'Y2U9999'
     C                   EXSR      END
     C                   ENDIF
 
      ** If F12 pressed from the Retail screen
 
     C     #RTCD         IFEQ      'USR0790'
 
      ** Clear the program message queue and call SR/INIT to retrieve
      ** the last committed data from the extension file.
 
     C                   EXSR      CLEAR
     C                   WRITE     #MSGCTL
     C                   EXSR      INIT
 
      ** Reset all error indicators
 
     C                   SETOFF                                       505152
     C                   SETOFF                                       535455
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * GOTO FEES SCREEN
      *****************************************************************
     C     FEES          BEGSR
     C                   CALL      'SD008118'
     C                   PARM                    #RTCD             7
     C                   PARM                    MODE
 
     C     #RTCD         IFNE      *BLANKS
 
      ** If F3 pressed from the Retail screen
 
     C     #RTCD         IFEQ      'Y2U9999'
     C                   EXSR      END
     C                   ENDIF
 
      ** If F12 pressed from the Retail screen
 
     C     #RTCD         IFEQ      'USR0790'
 
      ** Clear the program message queue and call SR/INIT to retrieve
      ** the last committed data from the extension file.
 
     C                   EXSR      CLEAR
     C                   WRITE     #MSGCTL
     C                   EXSR      INIT
 
      ** Reset all error indicators
 
     C                   SETOFF                                       505152
     C                   SETOFF                                       535455
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT FROM PROGRAM
      *****************************************************************
     C     END           BEGSR
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   SETON                                        U7U8LR
     C                   DUMP
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   ENDSR
 
     C/COPY ZSRSRC,ZALIGNZ2LE
     C/COPY ZSRSRC,ZEDITZ2LE
     C/COPY ZSRSRC,ZDATE9Z3LE
     C/COPY ZSRSRC,ZDAT10Z2LE
      ********************************************************************
      /EJECT
** @YD  USED BY SR. ZDATE9 - YEARS, IN DAYS, CUMULATIVE IN 4 YEAR SPAN
00366007310109601461
** @MD  USED BY SR. ZDATE9 - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
00000000310005900090001200015100181002120024300273003040033400365
** CPY@
(c) Copyright Misys International Banking Systems Ltd. 2010
** ErrorMsg
The New Stamp Tax Currency code
The New Default Stamp Tax Rate
The New Security Charge Code
The New Security Stamp Tax Rate
