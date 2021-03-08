     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas GP Midas WIP config maintenance')                *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GP009621 - Midas GP WIP configutaion maintenance             *
      *                                                               *
      *  Function: This program displays a screen for the main-       *
      *            temance (or enqiry) of WIP configuration.          *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. MD054733           Date 02Dec19               *
      *  Prev Amend No. MD054209 *CREATE   Date 31Aug19               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *MD054733 - Merge GPWPBCTD to GPWIPCTD.
      *  MD054209 - Deliverable Data Split                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *       03         F3 has been pressed (Exit program).          *
      *       05         F5 has been pressed (Reset to default).      *
      *       12         F12 has been pressed (Previous screen).      *
      *       35         Invalidate Current Setting entry.            *
      *       86         Enable PUTOVR for Insert/Amend.              *
      *       87         Amend mode, ON to enable CA05 and allow      *
      *                  Current Setting entry.                       *
      *       90         Record not found, OR                         *
      *                  Error when calling program.                  *
      *       92         End of file.                                 *
      *       99         Global error flag.                           *
      *                                                               *
     F*****************************************************************
     FGP009621DFCF   E             WORKSTN
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
     D*
     D********************************************************************
     D A@CPY           DS
      * Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright
      *
      * Program data structure
      *
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file information data structure
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure
      *
     D @1DBRC          DS
     D  @1NBOW                 1     30
     D  @1ABOW                31     60
     D  @1AUTL                61     90
     D
      * Current/previous master file format fields for change control
     D GPWIP         E DS                  EXTNAME(GPWIPJW0)
     D NullInds        s              5i 0 dim(23)
     D WWC_ID          S              9  0
      *
     D #1DBRC          DS            90
      * Stored master file format fields
     D  #1DB1                  1      1
      *
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      * Program data structure
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

      ** Declare variables for field range validations

     D #1VLD           S            200
     D WRNGU1          S            200
     D WRNGU2          S            200
     D WUMSGF          S             10    INZ('SDUSRMSG')
      *
      * Programs to call
      *
      /EJECT
      *
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C                   PARM                    P1UNII            9 0          WIP Unique Id
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
      *
     C/EXEC SQL
     C+ SELECT *
     C+ into :GPWIP :NullInds
     C+ from GPWIPJW0
     C+ where WC_ID = :P1UNII
     C/END-EXEC
     C                   If        SQLCODE = 100
     C                   SETON                                        90
     C                   Else
     C                   SETOFF                                       90
     C                   Endif
      *
      * If record does not exist, error
     C     *IN90         IFEQ      '1'
     C                   SETON                                        99        *
      * Send message 'WIP Config Unique Id record not found'
     C                   MOVEL     'USR7011'     ZAMSID
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
      * Redisplay previous screen
     C   12              CAS                     CCDSPV
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
     C                   SETOFF                                           86    *
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
     CSR   DCVLCS        BEGSR
      *================================================================
      * Validate input capable field:
      *   - Check if blank entry
      *   - Check if any data entered matches default
      *================================================================
      *
      *
      * If New Back Office Write Workflow is blank
     C     #1NBOW        IFEQ      *BLANK
     C                   SETON                                        3299
     C                   MOVEL     'USR7013'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
      * If New Back Office Write Workflow is not COMPLETE or AUTHORISE
     C     #1NBOW        IFNE      *BLANK
     C     #1NBOW        ANDNE     'COMPLETE'
     C     #1NBOW        ANDNE     'AUTHORISE'
     C                   SETON                                        3299
     C                   MOVEL     'USR7014'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
      * If Amend Back Office Write Workflow is blank
     C     #1ABOW        IFEQ      *BLANK
     C                   SETON                                        3399
     C                   MOVEL     'USR7015'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
      * If New Back Office Write Workflow is not COMPLETE or AUTHORISE
     C     #1ABOW        IFNE      *BLANK
     C     #1ABOW        ANDNE     'COMPLETE'
     C     #1ABOW        ANDNE     'AUTHORISE'
     C                   SETON                                        3399
     C                   MOVEL     'USR7016'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
      * If Authorization Level is blank
     C     #1AUTL        IFEQ      *BLANK
     C                   SETON                                        3499
     C                   MOVEL     'USR7017'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
      * If New Back Office Write Workflow is not COMPLETE or AUTHORISE
     C     #1AUTL        IFNE      *BLANK
     C     #1AUTL        ANDNE     '2_EYES'
     C     #1AUTL        ANDNE     '4_EYES'
     C     #1AUTL        ANDNE     '6_EYES'
     C                   SETON                                        3499
     C                   MOVEL     'USR7018'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     CSR   DCEXIT        ENDSR
      /EJECT
     CSR   EBPR##        BEGSR
      *================================================================
      * Process details screen:
      *   - Validate input
      *   - Update WIP config file if no validation error.
      *================================================================
      *
      * Validate input if data has been changed
     C     #1NBOW        IFNE      @1NBOW
     C     #1ABOW        ORNE      @1ABOW
     C     #1AUTL        ORNE      @1AUTL
     C                   EXSR      DCVLCS
      * QUIT if error:
     C   99              GOTO      EBEXIT
      *
      * No error: update record
      * Change WIP Config
     C                   EXSR      SYCHRC
     C     W0RTN         IFNE      *BLANK
      * Data update error
      * Reset screen fields if changed record
     C     W0RTN         CASEQ     'Y2U0007'     MBFL#1
     C                   END
     C                   ELSE
     C                   EXSR      ZXEXPG
     C                   END
     C                   ELSE
     C                   MOVEL     'N'           W0TRN
     C                   END
      *
      *================================================================
     CSR   EBEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move GPWIPJT0 fields to screen
      *================================================================
     C                   Z-ADD     P1UNII        #1UNII
     C                   MOVEL     WC_API        #1APIN
     C                   MOVEL     WC_BONSTP     #1NBOW
     C                   MOVEL     WC_BOASTP     #1ABOW
     C                   MOVEL     WC_AUTLVL     #1AUTL
     C                   MOVEL     WC_ZONE       #1ZONE
      *
      * Hold existing record image
     C                   MOVEL     WC_BONSTP     @1NBOW
     C                   MOVEL     WC_BOASTP     @1ABOW
     C                   MOVEL     WC_AUTLVL     @1AUTL
     C                   MOVEL     @1DBRC        #1DBRC
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   SYCHRC        BEGSR
      *================================================================
      * Change WIP Config API record
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Chain to WIP Config file
     C/EXEC SQL
     C+ SELECT *
     C+ into :GPWIP :NullInds
     C+ from GPWIPJW0
     C+ where WC_ID = :P1UNII
     C/END-EXEC
     C                   If        SQLCODE = 100
     C                   SETON                                        90
     C                   Else
     C                   SETOFF                                       90
     C                   Endif
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
      * Reload image record
     C                   MOVEL     WC_BONSTP     @1NBOW
     C                   MOVEL     WC_BOASTP     @1ABOW
     C                   MOVEL     WC_AUTLVL     @1AUTL
      * Check for changed record
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SYEXIT
     C                   END                                                    FI #1DBRC
      *
     C/EXEC SQL
     C+ update GPWIPBTD
     C+  SET WC_BONSTP = :#1NBOW, WC_BOASTP = :#1ABOW, WC_AUTLVL = :#1AUTL
     C+ where WC_ID = :P1UNII
     C/END-EXEC
     C/EXEC SQL
     C+ update GPWIPXTD
     C+  SET WC_BONSTP = :#1NBOW, WC_BOASTP = :#1ABOW, WC_AUTLVL = :#1AUTL
     C+ where WC_ID = :P1UNII
     C/END-EXEC
     C                   If        SQLCODE = 0
     C                   MOVEL     'USR7009'     P0RTN
     C                   Endif
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
     C                   MOVEL     WUMSGF        ZAMSGF
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
     C     P0RTN         IFNE      'USR7009'
     C                   MOVEL     *BLANK        P0RTN
     C                   ENDIF
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
     C                   MOVE      *BLANKS       WUMTXT           80
      *
      *  If Action Code is Amend :
      *
     C     P1SEL         IFEQ      'A'
      *
      *  Set on indicator for enabling CA5 and current setting input capable.
     C                   SETON                                        87
      * Setup footer text:
      * F3=Main Menu   F12=Previous
     C                   MOVEL     'USR7012'     WUMSID            7            Message Identifier
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
     C                   MOVEL     'USR7012'     WUMSID                         Message Identifier
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
(c) Finastra International Limited 2019
