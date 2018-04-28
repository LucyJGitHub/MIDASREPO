     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME Message tags / FT fields selection')
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  ME1320 - Select FT fields                                    *
      *                                                               *
      *  Function:  This program prompts a list of possible           *
      *  relationships between SWIFT message tags and FT fields.      *
      *                                                               *
      *  Called By:        - Menu option                              *
      *                                                               *
      *  Calls: DBERRCTL - Error processing                           *
      *         ZA0250   - Clear program sfl message queue            *
      *         AOCREPT  - Add message to program sfl message queue   *
      *         MEC1150  - Extract message information                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *  Last Amend No. CFT006  *CREATE    Date 03Nov99               *
      *  Prev Amend No.                    Date ddmmmyy               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT006 - MT101/2 message addtion for outgoing/incoming RFT   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    50         For reading input parameter table               *
      *    51         Sflclr SF1                                      *
      *    52         Sfldsp SF1                                      *
      *    53         Sflnxtchg SF1                                   *
      *    54         Sfl INZ SF1                                     *
      *    55         Sfldspctl SF1                                   *
      *    56         Readc SF1                                       *
      *    60         Error field                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR  - Error processing                                    *
      *  *INZSR - Initialise                                          *
      *  INISF1 - Initialise SF1                                      *
      *  CHKSF1 - Check SF1                                           *
      *  FMTSF1 - Format fields SF1                                   *
      *  CKGSF1 - Common checks in SF1                                *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FME1320DF  CF   E             WORKSTN
     F                                     SFILE(ME1320S1:EMRNS1)
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D##PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
      ** Constants
      ** ---------
     DMAXFT            C                   CONST(200)
      *
      ** Arrays
      ** ------
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** FT fields passed as parameter
     D FT@             S             10    DIM(MAXFT)
     D FTM@            S              7    DIM(MAXFT)
      *
      ** Working variables
      ** -----------------
      *
      ** Subfile
     DSF               DS
     D  EMRNS1                        5  0         INZ(0)
      *
      ** Indexes
      ** -------
     DWFTN             S              3  0
      *
      ** Flags
      ** -----
     DWFPOSPAG         S              1
     DWFINIT           S                   LIKE(WFPOSPAG)
     DWFINISF1         S                   LIKE(WFPOSPAG)
     DWFSEL            S                   LIKE(WFPOSPAG)
      *
      ** Parameters for AOCREPT
     DMSGID            S              7
     DMSGF             S             10    INZ('MEMSG')
     DMSGLIB           S             10    INZ('*LIBL')
     DMSGDTA           S            256
     DMSGREL           S              5
     DMSGQ             S             10
     DMSGT             S              7
      *
      ** Parameters for MEC1150
     D**MSGID          S
     D**MSGF           S
     DMSDTA            S            132
     DTXT1             S            132
     DTXT2             S            512
      /EJECT
      /SPACE 3
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE
      *****************************************************************
      *
      ** PARAMETERS
     C     *ENTRY        PLIST
     C                   PARM                    FT@
     C                   PARM                    FTM@
     C                   PARM                    P#FTFL           10
      *
     C     *INKC         DOWEQ     *OFF
      *
     C                   EXSR      INISF1
      *
     C                   EXSR      CHKSF1
      *
      ** One item selected we exit from the program
     C     P#FTFL        IFNE      *BLANK
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   SETON                                        LR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      ************ CALL DBERRCTL IF INTERACTIVE PROGRAM ***************
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
      ************ CALL DBERRCTL IF INTERACTIVE PROGRAM ******************
      *
     C                   CALLB     'DBERRCTL'
      *
      ********************************************************************
     C                   ENDIF
      *
      ************ END PROGRAM IF DBERRCTL NOT CALLED ********************
     C                   SETON                                        U7U8LR
     C                   RETURN
      ********************************************************************
      *
     C                   ENDSR
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *****************************************************************
     C     *INZSR        BEGSR
     C                   SETON                                        25
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Force SF1 initialization
      *
     C                   MOVE      'Y'           WFINISF1
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
      *
     C     AGDFF         IFEQ      'M'
     C                   SETON                                        98
     C                   ENDIF
      *
     C                   MOVEL     AGMRDT        SRUNA
     C                   MOVEL     USER          SUSER
     C                   MOVEL     WSID          SWSID
      *
     C                   ENDSR
      *****************************************************************
      * S/R INITIALIZE SF1                                            *
      * CALLED BY MAIN PROCEDURE                                      *
      *****************************************************************
     C     INISF1        BEGSR
      *
      ** SFLDSP ON
     C                   SETON                                        52
      *
      ** Errors detected in the subfile
     C     MSGID         IFNE      *BLANK
     C                   MOVEL     *BLANK        MSGID
     C                   WRITE     #MSGCTL
     C                   WRITE     ME1320F1
     C                   EXFMT     ME1320C1
      *
      ** No errors detected in the subfile
     C                   ELSE
      *
     C     WFINISF1      IFEQ      'Y'
     C                   MOVE      'N'           WFINISF1
      *
      ** SFLCLR
     C                   SETON                                        51
     C                   WRITE     ME1320C1
     C                   SETOFF                                       51
     C                   Z-ADD     0             EMRNS1
     C                   Z-ADD     1             WFTN
     C     WFTN          DOWLE     MAXFT
      *
     C     FT@(WFTN)     IFEQ      *BLANK
     C                   LEAVE
     C                   ENDIF
      *
     C                   ADD       1             EMRNS1
     C                   Z-ADD     EMRNS1        @@RNC1
     C                   EXSR      FMTSF1
     C                   WRITE     ME1320S1
      *
     C                   ADD       1             WFTN
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   WRITE     ME1320F1
     C                   Z-ADD     1             @@RNC1
     C                   WRITE     #MSGCTL
     C                   EXFMT     ME1320C1
      *
     C                   ENDIF
      *
     C     END_INISF1    ENDSR
      *****************************************************************
      * S/R CHECKING SF1                                              *
      * CALLED BY MAIN PROCEDURE                                      *
      * CALLS : ZA0250                                                *
      *****************************************************************
     C     CHKSF1        BEGSR
      *
      ** Clear the message queue
      *
     C                   CALL      'ZA0250'
      *
     C                   MOVEL     *BLANK        P#FTFL
     C                   MOVEL     'N'           WFPOSPAG
     C                   MOVEL     'N'           WFSEL
      *
     C                   READC     ME1320S1                               56
     C     *IN56         DOWEQ     '0'
      *
     C                   SETOFF                                       60
      *
      ** Global checks
     C                   EXSR      CKGSF1
      *
      ** SFLNXTCHG for S/R UPDSF1
     C                   SETON                                        53
     C     MSGID         IFNE      *BLANK
      ** To avoid leaving the program (one item selected)
     C                   MOVEL     *BLANK        P#FTFL
      ** To display the right page in case of several errors
     C     WFPOSPAG      IFEQ      'N'
     C                   MOVEL     'Y'           WFPOSPAG
     C                   Z-ADD     EMRNS1        @@RNC1
     C                   ENDIF
     C                   ENDIF
      *
     C                   UPDATE    ME1320S1
     C                   READC     ME1320S1                               56
     C                   ENDDO
      *
     C     END_CHKSF1    ENDSR
      *****************************************************************
      * S/R FIELDS FORMATING SF1                                      *
      * CALLED BY S/R INISF1                                          *
      *****************************************************************
     C     FMTSF1        BEGSR
     C                   MOVEL     FT@(WFTN)     SFTFLD
     C                   MOVEL     FTM@(WFTN)    MSGID
      *
      ** Extract Text for option
      *
     C                   CALL      'MEC1150'                            90
     C                   PARM                    MSGID
     C                   PARM      'MEMSG'       MSGF
     C                   PARM                    MSDTA
     C                   PARM      *BLANKS       TXT1
     C                   PARM      *BLANKS       TXT2
      *
     C                   MOVEL     TXT1          SFTDSC
      ** MSGID is used as a flag to detect errors
     C                   MOVEL     *BLANK        MSGID
      *
     C     END_FMTSF1    ENDSR
      *****************************************************************
      * S/R COMMONS CHECKS IN SF1                                     *
      * CALLED BY S/R CHKSF1                                          *
      *****************************************************************
     C     CKGSF1        BEGSR
      *
     C     SSEL          IFNE      *BLANK
     C     SSEL          ANDNE     '1'
     C                   MOVEL     'MEM7000'     MSGID
     C                   EXSR      SNDMSG
     C                   SETON                                        60
     C                   ENDIF
      *
      ** Only one selection is allowed
     C     SSEL          IFEQ      '1'
     C     WFSEL         IFEQ      'N'
     C                   MOVEL     'Y'           WFSEL
     C                   MOVEL     SFTFLD        P#FTFL
     C                   ELSE
     C                   MOVEL     'MIN0388'     MSGID
     C                   EXSR      SNDMSG
     C                   SETON                                        60
     C                   ENDIF
     C                   ENDIF
      *
     C     END_CKGSF1    ENDSR
      *****************************************************************
      * S/R SNDMSG SEND PROGRAM MESSAGE                               *
      * CALLED BY SEVERAL SUBROUTINES                                 *
      * CALLS : AOCREPT                                               *
      *****************************************************************
     C     SNDMSG        BEGSR
      ** Only write message if requested
     C     MSGID         IFNE      *BLANK
     C                   CALLB     'AOCREPT'
     C                   PARM                    MSGID
     C                   PARM                    MSGF
     C                   PARM                    MSGLIB
     C                   PARM                    MSGDTA
     C                   PARM      '*SAME'       MSGREL
     C                   PARM                    ##PGM
     C                   PARM      *BLANK        MSGQ
     C                   PARM      *BLANK        MSGT
      *
     C                   MOVEL     *BLANK        MSGDTA
      *
     C                   ENDIF
      *
     C     END_SNDMSG    ENDSR
      *
      ********************************************************************
      *
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
