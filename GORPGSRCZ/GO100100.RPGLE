     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Audit Enquiry Prompt')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GO100100 - Audit Enquiry Prompt                              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CGP004  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGP004 - Audit Reporting                                     *
      *                                                               *
      *****************************************************************
 
     FGO100100DFCF   E             WORKSTN INFSR(*PSSR)
     FGPAUIPPD  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      * Program Status Data Structure
      /COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs
 
 
      /SPACE 5
 
 
      * Display screen until F3 taken
      * or valid input
 
     C     *INKC         DOUEQ     '1'
     C     Valid_Input   OREQ      'Y'
     C                   EXSR      DSPLAY_SCN
     C                   ENDDO
 
      * End
 
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKL         @INKL
 
      * End of program
 
     C                   SETON                                        LR
 
      /SPACE 5
      *****************************************************************
      * Display screen
      *****************************************************************
     C     DSPLAY_SCN    BEGSR
 
      * Write screen and foooter
 
     C                   TIME                    DDTIME
     C                   WRITE     MSGSUBCT
     C                   WRITE     FOOTER
     C                   WRITE     MAIN
 
      * Read screen
 
     C                   READ      MAIN                                   99    *
     C                   SETOFF                                       4142
     C                   SETOFF                                       4344
 
      ** Clear the message queue & init error indicators
 
     C                   EXSR      CLR_MSGQ
 
      ** If F3 was not taken
 
     C     *INKC         IFEQ      '0'
 
      * Validate input
 
     C                   EXSR      VALIDATE
 
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      ** Clear the message queue
      *****************************************************************
     C     CLR_MSGQ      BEGSR
 
     C                   CALL      'Y2CLMSC'
     C                   PARM      DDPGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Validate input
      ********************************************************************
     C     VALIDATE      BEGSR
 
      * Input must exist
      * ----------------
 
     C     DDINPT        IFNE      *BLANK
     C     DDINPT        IFEQ      '?'                                          B2
     C                   CALL      'GPAU0017'                           9999    *
     C                   PARM      *BLANK        RETC              6
     C                   PARM      *BLANK        DDINPT
     C     RETC          IFEQ      'EXIT  '
     C                   MOVE      '1'           *INKC
     C                   END
     C                   END                                                    E2
 
     C     DDINPT        CHAIN     GPAUIPD0                           99        *
     C     *IN99         IFEQ      *ON
     C                   SETON                                        42
     C                   MOVEL     'GO00102'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN42
     C                   ENDIF
     C                   ENDIF
 
      * From date must be valid
      * -----------------------
 
     C     DDFRD         IFEQ      *BLANK
     C                   MOVEL     RunDate       DDFRD
     C                   ENDIF
 
     C                   TESTN                   DDFRD                9798
     C     *IN97         IFEQ      '1'
     C     *IN98         OREQ      '1'
     C                   CALLB     'ZAVDATE'
     C                   PARM      *BLANK        RetCode          10
     C                   PARM      DDFRD         @@DATE            6
     C                   PARM                    BJDFIN
     C                   PARM                    FromDAYN          5 0
     C                   END
      *
      * From date is invalid
      * or is not numeric
      *
     C     RetCode       IFEQ      'Error'
     C     *IN97         OREQ      '0'
     C     *IN98         ANDEQ     '0'
     C                   MOVEL     'GO00110'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN43
     C                   END
 
      * From date can't be in the future
 
     C     *IN43         IFEQ      '0'
     C     FromDAYN      IFGT      BJRDNB
     C                   MOVEL     'GO00111'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN43
     C                   END
     C                   END
 
      * To date must be valid
      * ---------------------
 
     C     DDTOD         IFEQ      *BLANK
     C                   MOVEL     RunDate       DDTOD
     C                   ENDIF
 
     C                   TESTN                   DDTOD                9798
     C     *IN97         IFEQ      '1'
     C     *IN98         OREQ      '1'
     C                   CALLB     'ZAVDATE'
     C                   PARM      *BLANK        RetCode          10
     C                   PARM      DDTOD         @@DATE            6
     C                   PARM                    BJDFIN
     C                   PARM                    ToDAYN            5 0
     C                   END
      *
      * To date is invalid
      * or is not numeric
      *
     C     RetCode       IFEQ      'Error'
     C     *IN97         OREQ      '0'
     C     *IN98         ANDEQ     '0'
     C                   MOVEL     'GO00112'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN44
     C                   END
 
      * To date can't be in the future
      * or prior to the from date
 
     C     *IN44         IFEQ      '0'
     C     ToDAYN        IFGT      BJRDNB
     C     ToDAYN        ORLT      FromDAYN
     C                   MOVEL     'GO00113'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN44
     C                   END
     C                   END
 
      * Error
 
     C     *IN41         IFEQ      *ON
     C     *IN42         OREQ      *ON
     C     *IN43         OREQ      *ON
     C     *IN44         OREQ      *ON
     C                   MOVEL     'N'           Valid_Input       1
     C                   ELSE
     C                   MOVEL     'Y'           Valid_Input
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * ZASNMS - SEND A MESSAGE
      *****************************************************************
     C     ZASNMS        BEGSR
 
     C                   CALL      'Y2SNMGC'                            0909    *
     C                   PARM      DDPGM         ZAPGMQ           10
     C                   PARM                    ZAPGRL            5
     C                   PARM                    ZAMSID            7
     C                   PARM      'MIDAS   '    ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM                    ZAMSTP            7
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      * Return code
      * Error Message
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * OUTPUT
      * Zone
      * User
      * Input
      * From Date
      * To Date
     C                   PARM                    O#ZONE
     C                   PARM                    DDUSER
     C                   PARM                    DDINPT
     C                   PARM                    FromDAYN
     C                   PARM                    ToDAYN
      * Command Keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
 
      * Initialize program name
 
     C                   MOVEL     'GO100100 '   DDPGM
 
      * Set up subfile message queue information
 
     C                   MOVEL     '*'           DDPGMQ
     C                   MOVE      '1'           *IN40
 
      * Set up standard screen fields.
 
     C                   MOVEL     PsJobName     DDJOB
     C                   MOVEL     PsUser        DDUSR
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Run Date
 
     C                   CALLB     'ZDATE2'
     C                   PARM      BJRDNB        ZDAYNO            5 0          Value date
     C                   PARM                    BJDFIN                         Date format ind
     C                   PARM      *ZEROS        ZDATE             6 0          Value date
     C                   PARM      *BLANK        ZADATE            7            Run-date in DDM
     C                   MOVE      ZDATE         RunDate           6
 
      * From & To Dates
 
     C     FromDAYN      IFNE      *ZERO
     C                   CALLB     'ZDATE2'
     C                   PARM      FromDAYN      ZDAYNO                         Value date
     C                   PARM                    BJDFIN                         Date format ind
     C                   PARM      *ZEROS        ZDATE                          Value date
     C                   PARM      *BLANK        ZADATE                         Run-date in DDM
     C                   MOVE      ZDATE         DDFRD
     C                   ENDIF
 
     C     ToDAYN        IFNE      *ZERO
     C                   CALLB     'ZDATE2'
     C                   PARM      ToDAYN        ZDAYNO                         Value date
     C                   PARM                    BJDFIN                         Date format ind
     C                   PARM      *ZEROS        ZDATE                          Value date
     C                   PARM      *BLANK        ZADATE                         Run-date in DDM
     C                   MOVE      ZDATE         DDTOD
     C                   ENDIF
 
      * Get Zone
 
      /COPY GOCPYSRC,GOGETZONE
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
