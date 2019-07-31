     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Account Enquiry Prompt')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL002000 - Account Enquiry Prompt                            *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG6979            Date 04May05               *
      *                 BG1769             Date 23May03               *
      *                 CGP004  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG6979 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  BG1769 - Complete 10 digit account code changes.             *
      *  CGP004 - Audit Reporting                                     *
      *                                                               *
      *****************************************************************
 
     FGL002000DFCF   E             WORKSTN INFSR(*PSSR)
 
      *****************************************************************
      * Program Status Data Structure
      /COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
     D ZMUSER          DS            17
     D  UBRC                  11     13
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
      /SPACE 5
 
      *                                                                                      BUG6979
      **  GET ZMUSER to access default branch.                                               BUG6979
      *                                                                                      BUG6979
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG6979
     C                   IN        ZMUSER                                                    BUG6979
     C                   UNLOCK    ZMUSER                                                    BUG6979
                                                                                             BUG6979
      * Set up standard screen fields.                                                       BUG6979
                                                                                             BUG6979
     C                   MOVEL     PsJobName     DDJOB                                       BUG6979
     C                   MOVEL     PsUser        DDUSR                                       BUG6979
 
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
 
      * Default
 
     C     DDBRCA        IFEQ      *BLANK
     C                   MOVE      UBRC          DDBRCA
     C                   ENDIF
 
      * Branch must exist
      * -----------------
 
     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDBRCA        @BRCA             3
     C     SDBRCH        PARM      SDBRCH        DSFDY
 
      * 'Invalid Branch'
 
     C     DDBRCA        IFEQ      *BLANK
     C     @RTCD         ORNE      *BLANKS
     C                   MOVE      '1'           *IN41
     C                   MOVEL     'GLE0020 '    ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   MOVE      A8BRCD        DDBRCA
 
      * Check for user authority to action code
 
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           @ZACTN            1
     C                   PARM      DDBRCA        @ZBR              3
     C                   PARM      *ZERO         @ERR              1 0
     C     @ERR          IFEQ      1
     C     @ERR          OREQ      2
     C                   MOVE      '1'           *IN41
     C                   MOVEL     'GLE0021 '    ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
 
      * At least one enquiry must be selected
 
     C     DDENQ1        IFEQ      *BLANK
     C     DDENQ2        ANDEQ     *BLANK
     C     DDENQ3        ANDEQ     *BLANK
     C     DDENQ4        ANDEQ     *BLANK
     C                   MOVE      '1'           *IN42
     C                   MOVEL     'GLE0022 '    ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
 
      * Omit closed a/cs
 
     C     DDOMCL        IFNE      'Y'
     C     DDOMCL        ANDNE     'N'
     C                   MOVE      '1'           *IN43
     C                   MOVEL     'GLE0023 '    ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
 
      * Activity months
 
     C     DDACMN        IFNE      *BLANK
     C                   TESTN                   DDACMN               99
     C     *IN99         IFEQ      *OFF
     C                   MOVE      '1'           *IN44
     C                   MOVEL     'GLE0024 '    ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
 
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
     C                   PARM      'GLUSRMSG'    ZAMSGF           10
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
      * Branch
     C                   PARM                    DDBRCA            3
      * Enquiries
     C                   PARM                    DDENQ1            1
     C                   PARM                    DDENQ2            1
     C                   PARM                    DDENQ3            1
     C                   PARM                    DDENQ4            1
      * Retail a/c
     C                   PARM                    DDRET3            1
      * Omit closed a/cs
      * Activity months
     C                   PARM                    DDOMCL            1
     C                   PARM                    DDACMN            2
      * Command Keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
      **********                                                                             BUG6979
      ****GET*ZMUSER*to*access*default*branch.                                               BUG6979
      **********                                                                             BUG6979
     C******DTAARA       DEFINE                  ZMUSER                                      BUG6979
     C**********         IN        ZMUSER                                                    BUG6979
     C**********         UNLOCK    ZMUSER                                                    BUG6979
 
      * Initialize program name
 
     C                   MOVEL     'GL002000 '   DDPGM
 
      * Set up subfile message queue information
 
     C                   MOVEL     '*'           DDPGMQ
     C                   MOVE      '1'           *IN40
      **********                                                                             BUG6979
      **Set*up*standard*screen*fields.                                                       BUG6979
      **********                                                                             BUG6979
     C**********         MOVEL     PsJobName     DDJOB                                       BUG6979
     C**********         MOVEL     PsUser        DDUSR                                       BUG6979
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C     DDOMCL        IFEQ      ' '
     C                   MOVEL     'Y'           DDOMCL
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
