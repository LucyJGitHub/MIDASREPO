     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas DE I/c bulk transfer prompt program')
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEBLKPRMT - I/C Bulk Transfer Prompt                         *
      *                                                               *
      *  Function:  This program will prompt for the departmental     *
      *             server id to which to download all the standing   *
      *             data and transaction extract data required to     *
      *             run CCRM - Limits.                                *
      *                                                               *
      *  Called By: DEC0050 - Send Standing Data available message    *
      *             DEC0060 - Send Transaction extract data available *
      *                       message                                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      *  Last Amend No. CDE002             Date 05Dec00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *  Prev Amend No. CDE001  *CREATE    Date 16Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDE002 - Data Export - CCRM Revenue Analysis                 *
      *  CDE001 - Data Export - CCRM Limits                           *
      *                                                               *
      *****************************************************************
     FDEBLKPDDF CF   E             WORKSTN   INFSR(*PSSR)
 
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *                                                               *
      * 01 - Show CCRM - Limits title                                 *                       CDE002
      * 02 - Show CCRM - Revenue Analysis title                       *                       CDE002
      * 40 - Protect and non-display if CCRM - Limits not active      *
      * 41 - Error indicator for Departmental server                  *
      * 45 - Message SFLEND                                           *
      *                                                               *
      *---------------------------------------------------------------*
      * U7 U8 LR                                                      *
      *****************************************************************
      /EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  ##PGM            *PROC
     D  SWSID                244    253
     D  SUSER                254    263
      /EJECT
      *****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    DeptServ          2
     C                   PARM                    MessType          2                          CDE002
      *
      *****************************************************************
      *  MAIN
      *****************************************************************
      *
      ** Perform initial processing
      *
     C                   EXSR      INIT
      *
      ** Display Prompt Screen
      *
     C                   EXSR      DISPLY
      *
      ** Terminate the Program
      *
     C                   MOVE      '1'           *INLR
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *  INIT - Initialisation
      *****************************************************************
      *
     C     INIT          BEGSR
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
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
     C                   MOVE      '1'           *IN98
     C                   END
      *
     C                   MOVE      '0'           *IN40
     C                   MOVE      '0'           *IN41
     C                   MOVE      '0'           *IN45
     C                   MOVE      '0'           *IN01                                        CDE002
     C                   MOVE      '0'           *IN02                                        CDE002
      *
      ** Determine if Data Export for CCRM Limits is active
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CDE001'      @SARD             6
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CDE001            1
     C                   MOVEL     'Y'           W#ERR1            1
     C                   ENDIF
      *                                                                                       CDE002
      ** Determine if Data Export for CCRM Revenue is active                                  CDE002
     C                   CALL      'AOSARDR0'                                                 CDE002
     C                   PARM      *BLANKS       @RTCD                                        CDE002
     C                   PARM      '*VERIFY'     @OPTN                                        CDE002
     C                   PARM      'CDE002'      @SARD                                        CDE002
      *                                                                                       CDE002
     C     @RTCD         IFEQ      *BLANK                                                     CDE002
     C                   MOVEL     'Y'           CDE002            1                          CDE002
     C                   MOVEL     'Y'           W#ERR1            1                          CDE002
     C                   ENDIF                                                                CDE002
      *                                                                                       CDE002
     C     CDE002        IFEQ      'Y'                                                        CDE002
     C     CDE001        ANDNE     'Y'                                                        CDE002
     C                   MOVE      '1'           *IN02                                        CDE002
     C                   ELSE                                                                 CDE002
     C                   MOVE      '1'           *IN01                                        CDE002
     C                   ENDIF                                                                CDE002
      *
      * Set up message file name for error message execution, and
      * rundate.
      *
     C                   MOVEL     'MIDAS'       ZAMSGF
     C                   MOVE      AGMRDT        SRUNA
     C                   MOVEL     'DEBLKPRMT'   DBPGM
      *
      * Clear message queue for screen.
      *
     C                   EXSR      CLEARM
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  DISPLY - Display Prompt screen
      *****************************************************************
      *
     C     DISPLY        BEGSR
      *
      * Error CCRM - Limits is not active.
      * and if CCRM - Revenue Analysis is not active.                                         CDE002
      *
     C     CDE001        IFNE      'Y'
     C     CDE002        ANDNE     'Y'                                                        CDE002
     C                   MOVEL     'DEP0001'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN40
     C                   ENDIF
      *
     C                   WRITE     DEBLKPD0
     C                   EXSR      SCREEN
      *
     C     *IN03         DOWEQ     *OFF
     C     *IN12         ANDEQ     *OFF
     C     W#ERR1        ANDEQ     'Y'
     C     CDE001        ANDEQ     'Y'
     C     *IN03         OREQ      *OFF                                                       CDE002
     C     *IN12         ANDEQ     *OFF                                                       CDE002
     C     W#ERR1        ANDEQ     'Y'                                                        CDE002
     C     CDE002        ANDEQ     'Y'                                                        CDE002
      *
     C                   MOVE      'N'           W#ERR1
      *
      * Validate screen fields.
      *
     C                   EXSR      VALID
      *
      * Display error message.
      *
     C     W#ERR1        IFEQ      'Y'
     C                   EXSR      SCREEN
     C                   ENDIF
      *
     C                   ENDDO
      *
      * If exit or error pressed, blank out return parameters.
      * Otherwise set up Mode and Branch fields.
      *
     C     *IN03         IFEQ      *ON
     C     *IN12         OREQ      *ON
     C     CDE001        ORNE      'Y'
     C     CDE002        ANDNE     'Y'                                                        CDE002
     C                   MOVE      *BLANKS       DeptServ
     C                   ELSE
     C                   MOVE      TRANSF        DeptServ
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  VALID - Validate Screen input
      *****************************************************************
      *
     C     VALID         BEGSR
      *
      *   Validate Transfer Departmental Server
      *
     C     TRANSF        IFEQ      '  '
     C                   MOVEL     'DEP0002'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN41
     C                   MOVE      'Y'           W#ERR1
     C                   ELSE
     C                   MOVE      *OFF          *IN41
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SCREEN  - Display Screen
      *****************************************************************
     C     SCREEN        BEGSR
      *
     C     *IN05         DOUEQ     *OFF
      *
      * Refresh
     C     *IN05         IFEQ      *ON
     C                   MOVE      *BLANKS       TRANSF
     C                   MOVE      '0'           *IN41
     C                   ENDIF
      *
     C                   MOVE      '1'           *IN45
     C                   WRITE     #MSGCTL
     C                   EXFMT     DEBLKPD1
     C                   EXSR      CLEARM
      *
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  ZASNMS - Sends messages to the program's message queue       *
      *****************************************************************
     C     ZASNMS        BEGSR
      *
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       ZAMSDA
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10
     C                   PARM                    ZAPGRL            5
     C                   PARM                    ZAMSID            7
     C                   PARM                    ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM                    ZAMSTP            7
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * CLEARM  -  Clears the message queue                           *
      *****************************************************************
     C     CLEARM        BEGSR
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
      *
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
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   END
      *
     C                   ENDSR
      *
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
