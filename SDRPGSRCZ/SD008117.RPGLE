     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Facilities Stamp Tax details')                *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data                                        *
      *                                                               *
      *  SD008117 - Stamp Tax Facility Type Defaults                  *
      *                                                               *
      *  (c) Copyright Misys International Banking Systems Ltd 2010   *
      *                                                               *
      *  Last Amend No. AR837609A          Date 15Nov11               *
      *  Prev Amend No. AR837609           Date 09Nov11               *
      *                 CER049  *CREATE    Date 06Dec10               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  AR837609A - Update current fields during COB only.           *
      *  AR837609 - Update current fields during COB only.            *
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
      *       53      SECURITY CHARGE CODE FIELD IN ERROR             *
      *       54      SECURITY STAMP TAX RATE FIELD IN ERROR          *
      *       55      EFFECTIVE DATE FIELD IN ERROR                   *
      *                                                               *
      *****************************************************************
     FSDFACTL0  IF   E           K DISK
     FSDSTPDL1  IF   E           K DISK
     FSDSTPDL0  UF A E           K DISK
      ** Stamp Tax Tax Installation control
 
     F                                     COMMIT
     FSD008117DFCF   E             WORKSTN
      ** Display file
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     D/COPY ZSRSRC,ZALIGNZ1LE
      ** ZALIGN Subroutine Array
 
     D/COPY ZSRSRC,ZDATE9Z1LE
      ** ZDATE9 Subroutine Array
 
     D/COPY ZSRSRC,ZDATE2Z1LE
      ** ZDATE2 Subroutine Array
 
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
 
     D LDA           E DS           256    EXTNAME(LDA)
     D  W24          E                     EXTFLD(SPARE)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
 
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
     D  U#RDAT                 1      6  0
     D  U#RDD                  1      2  0
     D  U#RMM                  3      4  0
     D  U#RYY                  5      6  0
     D                 DS                  INZ
     D  U#SECN                 1      2
     D  U#SEC1                 1      1
     D  U#SEC2                 2      2
     D I#PARM          DS           100
     D  I#KEY                  1     10
     D  I#BRCA                11     13
     D  I#CUST                14     19
     D  I#CTRY                20     21
     D  I#ACCD                22     31
     D  I#DTYP                32     33
     D  I#DSTP                34     35
     D  I#LTYP                36     37
     D  I#LSTP                38     39
     D  I#FTYP                40     42
     D  I#LFTP                43     44
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details
 
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
     C                   PARM                    #RTRN             7
     C                   PARM                    MODE              1
     C                   PARM                    I#PARM
 
      ** Initialise data
 
     C                   EXSR      INIT
 
      ** Continue to redisplay the screen if *IN40 remains off
 
     C     *IN40         DOUEQ     '1'
 
      ** If error write messages
 
     C     *IN50         IFEQ      '1'
     C                   WRITE     #MSGCTL
     C                   ENDIF
 
      ** If MODE is Enquire then protect fields.
 
     C     MODE          IFEQ      'E'
     C                   SETON                                        202164
     C                   ENDIF
 
      ** If MODE is Amend and not in ADD then protect only current fields
      ** Otherwise allow all to be input capable
 
     C     MODE          IFEQ      'A'
     C                   SETON                                        20
     C                   ENDIF
 
     C                   EXFMT     FORMAT1
 
      ** Clear message subfile
 
     C                   EXSR      CLEAR
 
     C     *IN03         CASEQ     '1'           END
     C     *IN05         CASEQ     '1'           RESET
     C     *IN12         CASEQ     '1'           PREV
     C                   CAS                     VALID
     C                   ENDCS
     C                   ENDDO
 
      ** Exit from program
 
     C                   EXSR      PREV
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
 
     C     ULRTCD        IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SD008117'    DBPGM
     C                   MOVE      'SDBANKPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Obtain Midas Run Date
 
     C                   MOVEL     BJMRDT        U#MRDT
 
     C                   SETOFF                                       202164
 
      ** If in Amend or Enquire mode.
 
     C     MODE          IFEQ      'A'
     C     MODE          OREQ      'E'
 
     C     KLIST1        KLIST
     C                   KFLD                    I#KEY
     C                   KFLD                    I#BRCA
     C                   KFLD                    I#CUST
     C                   KFLD                    I#CTRY
     C                   KFLD                    I#ACCD
     C                   KFLD                    I#DTYP
     C                   KFLD                    I#DSTP
     C                   KFLD                    I#LTYP
     C                   KFLD                    I#LSTP
     C                   KFLD                    I#FTYP
 
     C     KLIST1        CHAIN     SDSTPDL1                           80
     C     *IN80         IFEQ      *OFF
 
     C                   MOVEL     A3FTYP        U#FTYP
 
      ** Convert Midas Day number of Current and New Effective Dates to
      ** MMCCYY format on screen.
 
     C     A3EDTE        IFEQ      *ZEROS
     C                   MOVE      *BLANKS       U#EDTE
     C                   ELSE
     C                   MOVE      A3EDTE        @@DAYN            5 0
     C                   EXSR      ZDATE9
     C                   MOVE      @@VDT         U#8DTE            8 0
     C                   MOVEL     U#8DTE        U#6DTE            6 0
     C                   MOVE      U#6ECC        U#ECC
     C                   MOVE      U#6EYY        U#EYY
     C                   MOVE      U#6EMM        U#EMM
     C                   ENDIF
 
     C     A3EDTN        IFEQ      *ZEROS
     C                   MOVE      *BLANKS       U#EDTN
     C                   ELSE
     C                   MOVE      A3EDTN        @@DAYN
     C                   EXSR      ZDATE9
     C                   MOVE      @@VDT         U#8DTN            8 0
     C                   MOVEL     U#8DTN        U#6DTN            6 0
     C                   MOVE      U#6NCC        U#ECCN
     C                   MOVE      U#6NYY        U#EYYN
     C                   MOVE      U#6NMM        U#EMMN
     C                   ENDIF
 
      ** Format under 1 Year rate
 
     C     A3F01Y        IFEQ      *ZEROS
     C                   MOVE      *BLANKS       U#F01Y
     C                   ELSE
     C                   MOVE      A3F01Y        ZFIELD
     C                   MOVE      '6'           ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        U#F01Y
     C                   ENDIF
 
     C     A3N01Y        IFEQ      *ZEROS
     C                   MOVE      *BLANKS       U#N01Y
     C                   ELSE
     C                   MOVE      A3N01Y        ZFIELD
     C                   MOVE      '6'           ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        U#N01Y
     C                   ENDIF
 
      ** Format over 1 year under 5 years
 
     C     A3F05Y        IFEQ      *ZEROS
     C                   MOVE      *BLANKS       U#F05Y
     C                   ELSE
     C                   MOVE      A3F05Y        ZFIELD
     C                   MOVE      '6'           ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        U#F05Y
     C                   ENDIF
 
     C     A3N05Y        IFEQ      *ZEROS
     C                   MOVE      *BLANKS       U#N05Y
     C                   ELSE
     C                   MOVE      A3N05Y        ZFIELD
     C                   MOVE      '6'           ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        U#N05Y
     C                   ENDIF
 
      ** Format over 5 years
 
     C     A3F99Y        IFEQ      *ZEROS
     C                   MOVE      *BLANKS       U#F99Y
     C                   ELSE
     C                   MOVE      A3F99Y        ZFIELD
     C                   MOVE      '6'           ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        U#F99Y
     C                   ENDIF
 
     C     A3N99Y        IFEQ      *ZEROS
     C                   MOVE      *BLANKS       U#N99Y
     C                   ELSE
     C                   MOVE      A3N99Y        ZFIELD
     C                   MOVE      '6'           ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        U#N99Y
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        MODE = 'I'
     C                   MOVEL     *BLANKS       U#FTYP
     C                   MOVEL     *BLANKS       U#EDTE
     C                   MOVEL     *BLANKS       U#EDTN
     C                   MOVEL     *BLANKS       U#F01Y
     C                   MOVEL     *BLANKS       U#N01Y
     C                   MOVEL     *BLANKS       U#F05Y
     C                   MOVEL     *BLANKS       U#N05Y
     C                   MOVEL     *BLANKS       U#F99Y
     C                   MOVEL     *BLANKS       U#N99Y
     C                   ENDIF
 
     C                   EXSR      RESETERR
     C                   EXSR      CLEAR
     C                   WRITE     #MSGCTL
 
     C                   ENDSR
 
      *****************************************************************
      * Validation subroutine
      *****************************************************************
 
     C     VALID         BEGSR
 
      ** If in Enquire mode then exit program
 
     C     MODE          IFEQ      'E'
     C                   RETURN
     C                   ENDIF
 
      ** Initialise error indicators
 
     C                   EXSR      RESETERR
 
     C     MODE          IFEQ      'A'
 
      ** Validate Effective Date
 
     C                   EXSR      VEDTN
 
      ** Validate Stamp Tax Rate on Principal under 1 year
 
     C                   EXSR      VN01Y
 
      ** Validate Stamp Tax Rate on Principal over 1 year under 5
 
     C                   EXSR      VN05Y
 
      ** Validate Stamp Tax Rate on Principal over 5 years
 
     C                   EXSR      VN99Y
 
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
     C                   ENDIF
 
     C     MODE          IFEQ      'I'
 
      ** Facility Type is new and all details are to be entered.
      **  Facility Type must not already exist on the Stamp Tax
      **  Defaults by business Types file but must exist on Facility
      **  Type file.
 
     C     U#FTYP        IFNE      *BLANKS
 
     C     U#FTYP        CHAIN     SDFACTL0                           81
     C     *IN81         IFEQ      *ON
     C                   SETON                                        5055
     C                   MOVEL     'USR9984'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   MOVEL     'Facility'    ZAMSDA
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVEL     'FACILITY'    I#KEY
     C                   MOVE      U#FTYP        I#FTYP
 
     C     KLIST1        CHAIN     SDSTPDL1                           80
     C     *IN80         IFEQ      *OFF
     C                   SETON                                        5055
     C                   MOVEL     'USR9985'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   MOVEL     'Facility'    ZAMSDA
     C                   EXSR      ZASNMS
     C                   ENDIF
 
      ** Validate CURRENT fields
      ** Validate Effective Date
 
     C**********         IF        U#EDTE = *BLANKS                                         AR837609
     C**********         SETON                                        5053                  AR837609
     C**********         MOVEL     'USR9963'     ZAMSID                                     AR837609
     C**********         MOVEL     'SDUSRMSG'    ZAMSGF                                     AR837609
     C**********         EXSR      ZASNMS                                                   AR837609
      **********                                                                            AR837609
     C**********         ELSE                                                               AR837609
     C**********         MOVE      *BLANKS       ZFIELD                                     AR837609
     C**********         MOVE      U#EDTE        ZFIELD                                     AR837609
     C**********         MOVE      0             ZADEC                                      AR837609
     C**********         MOVE      6             ZADIG                                      AR837609
     C**********         EXSR      ZALIGN                                                   AR837609
     C******IN99         IFEQ      *ON                                                      AR837609
     C**********         SETON                                        5053                  AR837609
     C**********         ELSE                                                               AR837609
     C**********         MOVE      U#EMM         ##EMM             2 0                      AR837609
     C**********         MOVE      U#ECC         ##ECC             2 0                      AR837609
     C*****##EMM         IFLT      01                                                       AR837609
     C*****##EMM         ORGT      12                                                       AR837609
     C*****##ECC         ORGT      20                                                       AR837609
     C*****##ECC         ORLT      19                                                       AR837609
      **********                                                                            AR837609
     C**********         SETON                                        5053                  AR837609
     C**********         ENDIF                                                              AR837609
     C**********         ENDIF                                                              AR837609
      **********                                                                            AR837609
      ** If error send message 'Invalid Date - must be in MMYYYY format'                    AR837609
      **********                                                                            AR837609
     C******IN53         IFEQ      *ON                                                      AR837609
     C**********         MOVEL     'USR9964'     ZAMSID                                     AR837609
     C**********         MOVEL     'SDUSRMSG'    ZAMSGF                                     AR837609
     C**********         EXSR      ZASNMS                                                   AR837609
     C**********         ENDIF                                                              AR837609
      **********                                                                            AR837609
      ** If Date is valid, ensure it is not for a future date                               AR837609
      **********                                                                            AR837609
     C******IN53         IFEQ      *OFF                                                     AR837609
     C**********         MOVE      BJRDNB        ZDAYNO                                     AR837609
     C**********         MOVE      *OFF          *IN98                                      AR837609
     C**********         EXSR      ZDATE2                                                   AR837609
     C**********         MOVE      ZDATE         U#RDAT                                     AR837609
     C**********         MOVE      U#RMM         U#6NMM                                     AR837609
     C**********         Z-ADD     20            U#6NCC                                     AR837609
     C**********         MOVE      U#RYY         U#6NYY                                     AR837609
     C**********         MOVE      U#EMM         U#6EMM                                     AR837609
     C**********         MOVE      U#ECC         U#6ECC                                     AR837609
     C**********         MOVE      U#EYY         U#6EYY                                     AR837609
      **********                                                                            AR837609
      ** If error send message 'Date cannot be in advance of current month'                 AR837609
      **********                                                                            AR837609
     C*****U#6DTE        IFGT      U#6DTN                                                   AR837609
     C**********         SETON                                        5053                  AR837609
     C**********         MOVEL     'USR9966'     ZAMSID                                     AR837609
     C**********         MOVEL     'SDUSRMSG'    ZAMSGF                                     AR837609
     C**********         EXSR      ZASNMS                                                   AR837609
     C**********         ENDIF                                                              AR837609
     C**********         ENDIF                                                              AR837609
     C**********         ENDIF                                                              AR837609
      **********                                                                            AR837609
      ** Validate Stamp Tax Rate on Principal under 1 year                                  AR837609
      **********                                                                            AR837609
     C*****U#F01Y        IFEQ      *BLANKS                                                  AR837609
     C**********         SETON                                        5058                  AR837609
     C**********         MOVEL     'USR9987'     ZAMSID                                     AR837609
     C**********         MOVEL     'SDUSRMSG'    ZAMSGF                                     AR837609
     C**********         EVAL      ZAMSDA = ErrorMsg(1)                                     AR837609
     C**********         EXSR      ZASNMS                                                   AR837609
     C**********         ELSE                                                               AR837609
      **********                                                                            AR837609
     C**********         MOVE      *BLANKS       ZFIELD                                     AR837609
     C**********         MOVE      U#F01Y        ZFIELD                                     AR837609
     C**********         MOVE      6             ZADEC                                      AR837609
     C**********         MOVE      7             ZADIG                                      AR837609
     C**********         EXSR      ZALIGN                                                   AR837609
     C******IN99         IFEQ      *ON                                                      AR837609
     C**********         SETON                                        5058                  AR837609
     C**********         MOVEL     'USR9988'     ZAMSID                                     AR837609
     C**********         MOVEL     'SDUSRMSG'    ZAMSGF                                     AR837609
     C**********         EVAL      ZAMSDA = ErrorMsg(1)                                     AR837609
     C**********         EXSR      ZASNMS                                                   AR837609
     C**********         ELSE                                                               AR837609
     C**********         MOVE      ZFIELD        ##F01Y           13 8                      AR837609
     C**********         ENDIF                                                              AR837609
      **********                                                                            AR837609
     C**********         ENDIF                                                              AR837609
      **********                                                                            AR837609
      ** Validate Stamp Tax Rate on Principal over 1 year under 5                           AR837609
      **********                                                                            AR837609
     C*****U#F05Y        IFEQ      *BLANKS                                                  AR837609
     C**********         SETON                                        5060                  AR837609
     C**********         MOVEL     'USR9987'     ZAMSID                                     AR837609
     C**********         MOVEL     'SDUSRMSG'    ZAMSGF                                     AR837609
     C**********         EVAL      ZAMSDA = ErrorMsg(2)                                     AR837609
     C**********         EXSR      ZASNMS                                                   AR837609
     C**********         ELSE                                                               AR837609
      **********                                                                            AR837609
     C**********         MOVE      *BLANKS       ZFIELD                                     AR837609
     C**********         MOVE      U#F05Y        ZFIELD                                     AR837609
     C**********         MOVE      6             ZADEC                                      AR837609
     C**********         MOVE      7             ZADIG                                      AR837609
     C**********         EXSR      ZALIGN                                                   AR837609
     C******IN99         IFEQ      *ON                                                      AR837609
     C**********         SETON                                        5060                  AR837609
     C**********         MOVEL     'USR9988'     ZAMSID                                     AR837609
     C**********         MOVEL     'SDUSRMSG'    ZAMSGF                                     AR837609
     C**********         EVAL      ZAMSDA = ErrorMsg(2)                                     AR837609
     C**********         EXSR      ZASNMS                                                   AR837609
     C**********         ELSE                                                               AR837609
     C**********         MOVE      ZFIELD        ##F05Y           13 8                      AR837609
     C**********         ENDIF                                                              AR837609
      **********                                                                            AR837609
     C**********         ENDIF                                                              AR837609
      **********                                                                            AR837609
      ** Validate Stamp Tax Rate on Principal over 5 years                                  AR837609
      **********                                                                            AR837609
     C*****U#F99Y        IFEQ      *BLANKS                                                  AR837609
     C**********         SETON                                        5062                  AR837609
     C**********         MOVEL     'USR9987'     ZAMSID                                     AR837609
     C**********         MOVEL     'SDUSRMSG'    ZAMSGF                                     AR837609
     C**********         EVAL      ZAMSDA = ErrorMsg(3)                                     AR837609
     C**********         EXSR      ZASNMS                                                   AR837609
     C**********         ELSE                                                               AR837609
      **********                                                                            AR837609
     C**********         MOVE      *BLANKS       ZFIELD                                     AR837609
     C**********         MOVE      U#F99Y        ZFIELD                                     AR837609
     C**********         MOVE      6             ZADEC                                      AR837609
     C**********         MOVE      7             ZADIG                                      AR837609
     C**********         EXSR      ZALIGN                                                   AR837609
     C******IN99         IFEQ      *ON                                                      AR837609
     C**********         SETON                                        5062                  AR837609
     C**********         MOVEL     'USR9988'     ZAMSID                                     AR837609
     C**********         MOVEL     'SDUSRMSG'    ZAMSGF                                     AR837609
     C**********         EVAL      ZAMSDA = ErrorMsg(3)                                     AR837609
     C**********         EXSR      ZASNMS                                                   AR837609
     C**********         ELSE                                                               AR837609
     C**********         MOVE      ZFIELD        ##F99Y           13 8                      AR837609
     C**********         ENDIF                                                              AR837609
      **********                                                                            AR837609
     C**********         ENDIF                                                              AR837609
 
      ** Validate New fields
      ** Validate Effective Date
 
     C                   EXSR      VEDTN
 
      ** Validate Stamp Tax Rate on Principal under 1 year
 
     C                   EXSR      VN01Y
 
      ** Validate Stamp Tax Rate on Principal over 1 year under 5
 
     C                   EXSR      VN05Y
 
      ** Validate Stamp Tax Rate on Principal over 5 years
 
     C                   EXSR      VN99Y
 
 
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
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      * Validate New Effective Date
      *****************************************************************
 
     C     VEDTN         BEGSR
     C                   IF        U#EDTN = *BLANKS
     C                   SETON                                        5054
     C                   MOVEL     'USR9950'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
 
     C                   ELSE
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      U#EDTN        ZFIELD
     C                   MOVE      0             ZADEC
     C                   MOVE      6             ZADIG
     C                   EXSR      ZALIGN
     C     *IN99         IFEQ      *ON
     C                   SETON                                        5054
     C                   ELSE
     C                   MOVE      U#EMMN        ##EMMN            2 0
     C                   MOVE      U#ECCN        ##ECCN            2 0
     C     ##EMMN        IFLT      01
     C     ##EMMN        ORGT      12
     C     ##ECCN        ORGT      20
     C     ##ECCN        ORLT      19
 
     C                   SETON                                        5054
     C                   ENDIF
     C                   ENDIF
 
      ** If error send message 'Invalid Date - must be in MMYYYY format'
 
     C     *IN54         IFEQ      *ON
     C                   MOVEL     'USR9948'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
 
      ** If error send message 'Date must be later than current month'
 
     C     *IN54         IFEQ      *OFF
     C**********         MOVE      BJRDNB        ZDAYNO                                    AR837609A
     C                   MOVE      *OFF          *IN98
     C**********         EXSR      ZDATE2                                                  AR837609A
     C**********         MOVE      ZDATE         U#RDAT                                    AR837609A
     C**********         MOVE      U#RMM         U#6EMM                                    AR837609A
     C**********         Z-ADD     20            U#6ECC                                    AR837609A
     C**********         MOVE      U#RYY         U#6EYY                                    AR837609A
     C                   MOVE      U#EMMN        U#6NMM
     C                   MOVE      U#ECCN        U#6NCC
     C                   MOVE      U#EYYN        U#6NYY
 
     C     U#6DTN        IFLE      U#6DTE
     C                   SETON                                        5054
     C                   MOVEL     'USR9949'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   MOVE      U#EMM         U#6EMM
     C                   MOVE      U#ECC         U#6ECC
     C                   MOVE      U#EYY         U#6EYY
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      * Validate Stamp Tax RAte Principal - Under 1 year
      *****************************************************************
 
     C     VN01Y         BEGSR
     C     U#N01Y        IFEQ      *BLANKS
     C                   SETON                                        5059
     C                   MOVEL     'USR9987'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EVAL      ZAMSDA = ErrorMsg(4)
     C                   EXSR      ZASNMS
     C                   ELSE
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      U#N01Y        ZFIELD
     C                   MOVE      6             ZADEC
     C                   MOVE      7             ZADIG
     C                   EXSR      ZALIGN
     C     *IN99         IFEQ      *ON
     C                   SETON                                        5059
     C                   MOVEL     'USR9988'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EVAL      ZAMSDA = ErrorMsg(4)
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   MOVE      ZFIELD        ##N01Y           13 8
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      * Validate Stanp tax Rate on Principal - over 1 under 5 years
      *****************************************************************
 
     C     VN05Y         BEGSR
     C     U#N05Y        IFEQ      *BLANKS
     C                   SETON                                        5061
     C                   MOVEL     'USR9987'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EVAL      ZAMSDA = ErrorMsg(5)
     C                   EXSR      ZASNMS
     C                   ELSE
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      U#N05Y        ZFIELD
     C                   MOVE      6             ZADEC
     C                   MOVE      7             ZADIG
     C                   EXSR      ZALIGN
     C     *IN99         IFEQ      *ON
     C                   SETON                                        5061
     C                   MOVEL     'USR9988'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EVAL      ZAMSDA = ErrorMsg(5)
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   MOVE      ZFIELD        ##N05Y           13 8
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      * Validate Stanp tax Rate on Principal -  over 5 years
      *****************************************************************
 
     C     VN99Y         BEGSR
     C     U#N99Y        IFEQ      *BLANKS
     C                   SETON                                        5063
     C                   MOVEL     'USR9987'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EVAL      ZAMSDA = ErrorMsg(6)
     C                   EXSR      ZASNMS
     C                   ELSE
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      U#N99Y        ZFIELD
     C                   MOVE      6             ZADEC
     C                   MOVE      7             ZADIG
     C                   EXSR      ZALIGN
     C     *IN99         IFEQ      *ON
     C                   SETON                                        5063
     C                   MOVEL     'USR9988'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EVAL      ZAMSDA = ErrorMsg(6)
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   MOVE      ZFIELD        ##N99Y           13 8
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      * Update subroutine
      *****************************************************************
 
     C     UPDAT         BEGSR
 
      ** Chain to SDSTPDPD
 
     C     KLIST1        CHAIN     SDSTPDL0                           80
 
      ** If record found then update otherwise insert
 
     C     *IN80         IFEQ      *OFF
 
      ** Set up type of last change and last change date
 
     C                   MOVE      BJRDNB        A3LCD
     C                   MOVE      'A'           A3TYLC
 
      ** Move display file fields to file fields
      ** Set new fields
 
     C                   Z-ADD     ##N01Y        A3N01Y
     C                   Z-ADD     ##N05Y        A3N05Y
     C                   Z-ADD     ##N99Y        A3N99Y
     C                   MOVEL     'M'           A3N01F
     C                   Z-ADD     0             A3NDTN
 
      ** Convert New Effective Date in CCYYMM format to Midas Day No.
 
     C                   MOVEL     U#6DTN        ##6DTN            8
     C                   MOVE      '01'          ##6DTN
     C                   MOVE      ##6DTN        ZZDTIN
     C                   EXSR      ZDAT10
     C                   MOVE      ZZMDNO        A3EDTN
 
     C                   UPDATE    @STPDV0
 
     C                   ELSE
 
      ** Set up type of last change and last change date
 
     C                   MOVE      BJRDNB        A3LCD
     C                   MOVE      'I'           A3TYLC
 
      ** Move display file fields to file fields
 
     C                   MOVEL     'FACILITY'    A3KEY
     C                   MOVE      U#FTYP        A3FTYP
 
      ** Set new fields
 
     C**********         Z-ADD     ##F01Y        A3F01Y                                     AR837609
     C**********         Z-ADD     ##F05Y        A3F05Y                                     AR837609
     C**********         Z-ADD     ##F99Y        A3F99Y                                     AR837609
     C                   Z-ADD     *ZEROS        A3F01Y                                     AR837609
     C                   Z-ADD     *ZEROS        A3F05Y                                     AR837609
     C                   Z-ADD     *ZEROS        A3F99Y                                     AR837609
     C                   Z-ADD     ##N01Y        A3N01Y
     C                   Z-ADD     ##N05Y        A3N05Y
     C                   Z-ADD     ##N99Y        A3N99Y
     C                   MOVEL     'M'           A3F01F
     C                   Z-ADD     0             A3FDTE
     C                   MOVEL     'M'           A3N01F
     C                   Z-ADD     0             A3NDTN
 
      * Convert Effective Date in CCYYMM format to Midas Day No.
 
     C                   MOVEL     U#6DTN        ##6DTN            8
     C                   MOVE      '01'          ##6DTN
     C                   MOVE      ##6DTN        ZZDTIN
     C                   EXSR      ZDAT10
     C                   MOVE      ZZMDNO        A3EDTN
 
     C**********         MOVEL     U#6DTE        ##6DTE            8                        AR837609
     C**********         MOVE      '01'          ##6DTE                                     AR837609
     C**********         MOVE      ##6DTE        ZZDTIN                                     AR837609
     C**********         EXSR      ZDAT10                                                   AR837609
     C**********         MOVE      ZZMDNO        A3EDTE                                     AR837609
     C                   MOVE      *ZEROS        A3EDTE                                     AR837609
 
     C                   WRITE     @STPDV0
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
 
     C                   ENDSR
      *****************************************************************
      * Reset Error Indicator
      *****************************************************************
     C     RESETERR      BEGSR
     C                   SETOFF                                       505354
     C                   SETOFF                                       585960
     C                   SETOFF                                       616263
     C                   SETOFF                                       6455
     C                   ENDSR
      *****************************************************************
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
      * EXIT FROM PROGRAM
      *****************************************************************
     C     END           BEGSR
     C                   MOVE      'Y2U9999'     #RTRN
     C                   RETURN
     C                   ENDSR
      *****************************************************************
      * F12 FROM PROGRAM
      *****************************************************************
     C     PREV          BEGSR
     C                   MOVE      'USR0790'     #RTRN
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
     C/COPY ZSRSRC,ZDATE2Z2LE
      ********************************************************************
      /EJECT
** @YD  USED BY SR. ZDATE9 - YEARS, IN DAYS, CUMULATIVE IN 4 YEAR SPAN
00366007310109601461
** @MD  USED BY SR. ZDATE9 - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
00000000310005900090001200015100181002120024300273003040033400365
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
** CPY@
(c) Copyright Misys International Banking Systems Ltd. 2010
** ErrorMsg
The Current Stamp Tax Rate on Facility under 1 year
The Current Stamp Tax Rate on Facility over 1 under 5 years
The Current Stamp Tax Rate on facility over 5 years
The New Stamp Tax Rate on Facility under 1 year
The New Stamp Tax Rate on Facility over 1 under 5 years
The New Stamp Tax Rate on Facility over 5 years
