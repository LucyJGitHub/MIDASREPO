     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058068
/*STD *  RPGSQLBND                                                    *                     MD058068
/*EXI *  TEXT('Midas BoE Securities Details Maintenance Window')      *
      *****************************************************************
      *                                                               *
      *  Midas - Windows                                              *
      *                                                               *
      *  BYSECTW9 - Securities Details Maintenance Window Program     *
      *                                                               *
      *  Function:  This program processes the fields on extn file    *
      *             SECTYDX9 if this feature is switched on.          *
      *                                                               *
      *  (c) Finastra International Limited 1999                      *
      *                                                               *
      *  Last Amend No. MD058068           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 LLN012             Date 21Apr99               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Amendment Details                                            *
      *  -----------------                                            *
      *                                                               *
      *  MD058068 - Deliverable Data Split for Bank of England        *
      *  MD046248 - Finastra Rebranding                               *
      *  LLN012 - Financial Services Authority - Liquidity Report     *
      *                                                               *
      *****************************************************************
      *                                                                  *
      *  FUNCTION OF INDICATORS                                          *
      *                                                                  *
      *       03      F3 PRESSED EXIT PROGRAM
      *       12      F12 PRESSED GOTO PREVIOUS SCREEN
      *       20      PROTECT FIELDS IN ENQUIRE MODE
      *       30      REDISPLAY THE SCREEN
      *       40      ENABLE F10
      *       50      QUALIFYING FLAG INVALID
      *       51      GUARANTEE CODE INVALID
      *
      *****************************************************************
      *                                                                  *
     FBYSECTY0  UF A E           K DISK
     F                                     INFSR(*PSSR)
      * Securities Details extension file - update
      *
     F*BYGTEEPP* IF   E           K DISK                                                    MD058068
     F**********                           INFSR(*PSSR)                                     MD058068
      * Guarantee Codes - retrieval
      *
     FBYSECT#0  CF   E             WORKSTN
     F                                     INFSR(*PSSR)
      * Securities Details window screen
      *
      *****************************************************************
      /EJECT
      *
      ** Array containing Copyright statement
      *
      *****************************************************************
      /SPACE 3
      *****************************************************************
     D A@CPY           DS
     D* Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D LDA           E DS           256    EXTNAME(LDA)
     D  W24          E                     EXTFLD(SPARE)
      *
      ** Local data area for database error details
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure - gives Job/Workstation name and
      ** User ID
      *
     D  ##PGM            *PROC
     D  JOB                  244    253
     D  WSID                 244    246
     D  USER                 254    263
      *
     D P@FMT         E DS                  EXTNAME(DSSDY)
     D BYGTEE        E DS                  EXTNAME(BYGTEJW0)                                MD058068
      *
      **
     I*COPY*QWINDSRC,SE0040GDTA                                                             MD058068
     D/COPY QWINDSRC,SE0040GDTL                                                             MD058068
      * DATA MEMBER FOR MAIN PROGRAM
      *****************************************************************
     C/EJECT
      *****************************************************************
      *
      **   Parameter list for window manager
     C     *ENTRY        PLIST
     C                   PARM                    ACTN              1
     C                   PARM                    DATA
     C                   PARM                    W0RTN             7
     C                   PARM                    WLEN              3 0
     C                   PARM                    WWID              3 0
     C                   PARM                    SROW              3 0
     C                   PARM                    SCOL              3 0
     C                   PARM                    TITLE             7
     C                   PARM                    SPARE           256
      *
      *****************************************************************
      *
      *                M A I N  P R O C E S S I N G
      *
      *****************************************************************
      *
      ** Continue to redisplay the screen if *IN30 remains off
     C     *IN30         DOUEQ     '1'
      *
      ** Main Format of the Display File
     C     ULERRI        IFEQ      'Y'
     C                   WRITE     #MSGCTL
     C                   ENDIF
     C                   EXFMT     WINDOWF
     C                   EXSR      CLEAR
      *
     C     *IN03         CASEQ     '1'           EXIT
     C     *IN12         CASEQ     '1'           PREV
     C                   CAS                     VALID
     C                   ENDCS
     C                   ENDDO
      *
      **   Exit from program
     C                   EXSR      TERM
      *
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
      * EXIT FROM PROGRAM
      *****************************************************************
     C     TERM          BEGSR
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT FROM PROGRAM IF F3 HAS BEEN PRESSED
      *****************************************************************
     C     EXIT          BEGSR
     C                   MOVE      'Y2U9999'     W0RTN
     C                   EXSR      TERM
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INITIALISE FIELDS
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Check to see if FSA Liquidity Report (LLN012) is switched on.
     C                   MOVEL     'LLN012'      ULSARN            6            SAR number fiel
     C                   MOVEL     *BLANK        ULRTCD            7            Access Pgm Retu
     C                   MOVEL     *BLANK        LLN012            1
      *
      ** SAR switched on check - Standard Functions  *
     C                   CALL      'AOSARDR0'                           90      SAR switched on
     C                   PARM                    ULRTCD            7            Access Pgm Retu
     C                   PARM      '*VERIFY'     WQ0288            7            Option for ACCO
     C                   PARM                    ULSARN            6            SAR number fiel
     C                   PARM      *BLANK        WQ0290           76            Access obj dumm
      *
      **  Error on call to AOSARDR0
     C     *IN90         IFEQ      '1'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If feature is 'off' end program
     C     ULRTCD        IFEQ      '*NRF'                                       *IF
     C                   EXSR      TERM
     C                   ENDIF
      *
      ** Define the LDA for error handling
     C     *DTAARA       DEFINE                  LDA
      *
      ** Define window position
     C                   Z-ADD     SROW          SWROW
     C                   Z-ADD     SCOL          SWCOL
      *
      ** Initialise screen fields
     C                   MOVE      *BLANKS       L#QUAL
     C                   MOVE      *BLANKS       L#GTEE
      *
      ** Get extension file details if insert or amend
     C     ACTN          IFEQ      'A'
     C     ACTN          OREQ      'E'
     C     #1SESN        CHAIN(N)  BYSECTY0                           90
     C     *IN90         IFEQ      *OFF
     C                   MOVE      LQUAL         L#QUAL
     C                   MOVE      LGTEE         L#GTEE
     C                   ENDIF
     C                   ENDIF
      *
      ** Delete record if 'DELETE' and exit program
     C     ACTN          IFEQ      'D'
     C     #1SESN        DELETE    BYSECTY0                           90
     C                   RETURN
     C                   ENDIF
      *
      ** Protect input fields if 'ENQUIRY' and enable command keys
     C     ACTN          IFEQ      'E'
     C                   SETON                                        20
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *    EXIT FROM PROGRAM IF F12 HAS BEEN PRESSED
      *
      *****************************************************************
      *
     C     PREV          BEGSR
      *
      ** Set F12 return code and end program
     C                   MOVE      'USR0790'     W0RTN
     C                   EXSR      TERM
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATE THE EXTENSION FILE
      *****************************************************************
      *
     C     UPDAT         BEGSR
      *
      ** Check if record exists or not
     C     #1SESN        CHAIN     BYSECTY0                           90
      *
      ** Move display field values into extension file fields
     C                   MOVEL     #1SESN        LSESN
     C                   MOVEL     L#QUAL        LQUAL
     C     LQUAL         IFEQ      *BLANK
     C                   MOVE      '0'           LQUAL
     C                   ENDIF
     C                   MOVEL     L#GTEE        LGTEE
     C     LGTEE         IFEQ      *BLANK
     C                   MOVE      '00'          LGTEE
     C                   ENDIF
      *
      * Write/Update extension file
     C     *IN90         IFEQ      *ON
     C                   WRITE     BYSECTD0
     C                   ELSE
     C                   UPDATE    BYSECTD0
     C                   ENDIF
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      * VALIDATE THE SCREEN
      *****************************************************************
     C     VALID         BEGSR
      *
      *  Reset indicators
     C                   MOVE      *ON           *IN30
     C                   MOVE      *OFF          *IN50
     C                   MOVE      *OFF          *IN51
     C                   MOVE      'N'           ULERRI            1
      *
      ** Validate only for insert or amend
     C     ACTN          IFEQ      'I'
     C     ACTN          OREQ      'A'
      *
      ** Validate Qualifying Flag
     C     L#QUAL        IFNE      ' '
     C     L#QUAL        ANDNE     '0'
     C     L#QUAL        ANDNE     '1'
     C     L#QUAL        ANDNE     '2'
     C     L#QUAL        ANDNE     '3'
     C                   MOVEL     'GBBYUSR'     ZAMSGF
     C                   MOVE      'MSG'         ZAMSGF
     C                   MOVEL     'BYM0204'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'BYM0204'     W0RTN
     C                   MOVE      *OFF          *IN30
     C                   MOVE      *ON           *IN50
     C                   MOVE      'Y'           ULERRI
     C                   ENDIF
      *
      ** Validate Guarantee Code
     C     L#GTEE        IFNE      *BLANK
     C*****L#GTEE        CHAIN     BYGTEEPP                           90                    MD058068
     C/EXEC SQL                                                                             MD058068
     C+ SELECT *                                                                            MD058068
     C+ into :BYGTEE                                                                        MD058068
     C+ from BYGTEJW0                                                                       MD058068
     C+ where LGTEE  = :L#GTEE                                                              MD058068
     C/END-EXEC                                                                             MD058068
     C******IN90         IFEQ      *ON                                                      MD058068
     C     SQLCODE       IFEQ      100                                                      MD058068
     C                   MOVEL     'GBBYUSR'     ZAMSGF
     C                   MOVE      'MSG'         ZAMSGF
     C                   MOVEL     'BYM0203'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'BYM0203'     W0RTN
     C                   MOVE      *OFF          *IN30
     C                   MOVE      *ON           *IN51
     C                   MOVE      'Y'           ULERRI
     C                   ENDIF                                                  *IN90
     C                   ENDIF                                                  L#GTEE
      *
      *
      * If no errors, perform update
     C     *IN30         IFEQ      '1'
     C                   EXSR      UPDAT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     VAEXIT        ENDSR
      *
      /EJECT
      *****************************************************************
      * Send message to program's message queue.
      *****************************************************************
      *
     C     ZASNMS        BEGSR
      *
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   ENDIF
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message Id.
     C                   PARM                    ZAMSGF           10            Message file.
     C                   PARM                    ZAMSDA          132            Message data.
     C                   PARM                    ZAMSTP            7            Message type.
      *
     C     ZAEXIT        ENDSR
      *
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
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   SETON                                        U7U8LR
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      ********************************************************************
      /EJECT
**CTDATA CPY@
(c) Finastra International Limited 1999
