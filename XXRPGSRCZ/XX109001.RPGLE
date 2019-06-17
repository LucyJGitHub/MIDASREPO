     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('G-AML ICD Maintenance')                                *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      ***SDJ107*-*MIDAS SD G-AML ICD Maintenance***********************
      *  XX109001 - MIDAS SD G-AML ICD Maintenance                    *
      *                                                               *
      *  Function:  This program maintains the G-AML ICD record.      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. JMI109             Date 21May18               *
      *  Prev Amend No. JMI026I02          Date 15Oct08               *
      *                 JMI026  *CREATE    Date 30Apr08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI109 - G-AML PreProcessor (Upgrade to FB Midas)            *
      *  JMI026I02- Recompile due to changes in SDGAMLX0              *
      *  JMI026 - G-AML PreProcessor                                  *
      *                                                               *
      *****************************************************************
     F*SDJ107#   CF   E             WORKSTN USROPN                                            JMI109
     FXX109001# CF   E             WORKSTN USROPN                                             JMI109
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      ** DSP: Midas SD G-AML Installation Control Data Maintenance
      *
     F*SDGAMLX0  UF A E             DISK    USROPN                                            JMI109
     FXXGAMLPD  UF A E             DISK    USROPN                                             JMI109
     F                                     INFDS(INFDS1)
     F                                     INFSR(*PSSR)
      ** RTV: Midas SD G-AML ICD Details
      *
      ********************************************************************
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

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      *
      /EJECT
      *
      ** Data structures:
      *
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      ** Display file information data structure
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      ** File information data structure
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Midas SD Bank Details
      *
     D A@CPY           DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
      *
      /EJECT
      *
      ** Data Structures used by Access Programs
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      /EJECT
      *
      ** Parameter declarations
     D P1PARM          DS            10
      ** KEY: Midas SD GCMS Interface ICD
      ** I : RST GCMS Interface ICD Key
     D  P1MODE                 1      1
     D P2PARM          DS
      ** O :  *Return code
     D  P2RTN                  1      7
     D P3PARM          DS
      ** B : MAP Work Return code
     D  P3WRTC                 1      5
     D                 DS
     D  ZAPGMQ         S             10
     D  ZAPGRL         S              5
     D  ZAMSID         S              7
     D  ZAMSGF         S             10
     D  ZAMSDA         S            132
     D  ZAMSTP         S              7
     D  ERR            S              1
      /EJECT
      *****************************************************************
      *
      ** Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C                   PARM                    P1PARM
     C     P2RTN         PARM      P2RTN         WP0001            7
     C     P3WRTC        PARM      P3WRTC        WP0002            5
      *****************************************************************
      ** Initialize
     C                   EXSR      ZZINIT
      *
      ** Perform once if all passed, else repeat
      ** Display and process key screen
     C
     C                   EXSR      BADSKY
     C
      ** Terminate program
     C                   EXSR      ZXEXPG
      *
      /EJECT
      *****************************************************************
     C     BADSKY        BEGSR
      *
      ** Display and process key screen
      *
     C     *IN30         DOUEQ     '1'
      *
      ** If error write messages
     C                   IF        ERR = 'Y'
     C                   WRITE     #MSGCTL
     C                   ENDIF
      *
     C                   WRITE     #RCDKEY
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #RCDDTL1
     C                   EXSR      CLEAR
      *
      ** Process response to screen
      ** Cancel & exit program
     C   03              CAS                     ZXEXPG
     C   05              CAS                     RESET
     C   12              CAS                     ZYEXPG
      ** Process key screen input
     C                   CAS                     VALID
     C                   ENDCS
      *
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * Clear message file
      *****************************************************************
     C     CLEAR         BEGSR
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
     C     RESET         BEGSR
      *
      ** Clear the program message queue and call SR/INIT to retrieve
      ** the last committed data from the extension file.
      *
     C                   EXSR      CLEAR
     C                   WRITE     #MSGCTL
     C                   EXSR      ZZINIT
      *
      ** Reset all error indicators
      *
     C                   EXSR      CLRIND
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
     C     VALID         BEGSR
      *
     C                   IF        P1MODE = 'E'
     C                   EXSR      ZYEXPG
     C                   ENDIF
      *
      ** Clear error conditioning fields
      *
     C                   EVAL      P0RTN = *BLANKS
     C                   EVAL      ERR = 'N'
     C                   SETON                                        30
     C                   EXSR      CLRIND
      *
      ** Validate screen fields
      *
     C                   EXSR      PROCESS
      *
      ** Error detected?
      *
     C                   IF        ERR = 'Y'
     C                   SETOFF                                           30
     C                   ENDIF
      *
     C                   IF        *IN30 = '1'  AND
     C                             P1MODE = 'M'
     C                   EXSR      UPDAT
     C                   ENDIF
      *
      ** Reset global error indicator
     C                   SETOFF                                           99    *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     CLRIND        BEGSR
      *
     C                   SETOFF                                       293132
     C                   SETOFF                                       3334
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     UPDAT         BEGSR
      *
      ** Move screen values to file
      *
     C                   IF        ERR = 'N' AND
     C                             *IN87 = '0'
      *
     C**********         OPEN      SDGAMLX0                                                   JMI109
     C**********         READ      SDGAMLX0                               91                  JMI109
     C                   OPEN      XXGAMLPD                                                   JMI109
     C                   READ      XXGAMLPD                               91                  JMI109
      *
     C                   EVAL      GIPS = SIPS
     C                   EVAL      GUSER = SUSER
     C                   EVAL      GPWORD = SPWORD
     C                   EVAL      GDIR = SDIR
     C                   EVAL      GOPDPT = SOPDPT
     C                   EVAL      GLCHT = CHTYP
     C                   EVAL      GLCHD = BJRDNB
      *
     C                   IF        *IN91 = *ON
     C**********         WRITE     SDGAMLD0                                                   JMI109
     C                   WRITE     XXGAMLD0                                                   JMI109
     C                   ELSE
     C**********         UPDATE    SDGAMLD0                                                   JMI109
     C                   UPDATE    XXGAMLD0                                                   JMI109
     C                   ENDIF
     C**********         CLOSE     SDGAMLX0                                                   JMI109
     C                   CLOSE     XXGAMLPD                                                   JMI109
      *
     C                   ENDIF
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     ZXEXPG        BEGSR
      *
     C     *IN03         IFEQ      '1'                                          *IF
     C                   MOVEL     '**CMD**'     P2RTN                          *Return code
     C                   MOVEL     'CMD01'       P3WRTC                         Work Return cod
     C                   END                                                    *FI
     C                   MOVEL     *BLANK        P0RTN
      *
     C**********         CLOSE     SDGAMLX0                                                   JMI109
     C                   CLOSE     XXGAMLPD                                                   JMI109
      ** Terminate program
     C                   SETON                                        LR
      *
      ** Exit program
     C                   RETURN
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     ZYEXPG        BEGSR
      *
     C**********         CLOSE     SDGAMLX0                                                   JMI109
     C                   CLOSE     XXGAMLPD                                                   JMI109
      ** Terminate program
     C                   SETON                                        LR
      *
      ** Exit program
     C                   RETURN
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     ZZINIT        BEGSR
      *
     C                   TIME                    ##TME
      ** Initialisation
      *
      ** Only do first time through
      *
     C                   IF        *IN01 = *OFF
      * Open files
     C**********         OPEN      SDJ107#                                                    JMI109
     C                   OPEN      XX109001#                                                  JMI109
     C                   EVAL      ERR = 'N'
     C                   MOVEL     'XXUSRMSG'    ZADFMF            8
      *  Get rundate
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Move rundate to display
     C                   MOVEL     BJMRDT        ##MRDT
      *
     C                   IF        P1MODE = 'E'
      * Protect input fields
     C                   SETON                                        87
      *
     C**********         OPEN      SDGAMLX0                                                   JMI109
     C**********         READ      SDGAMLX0                                                   JMI109
     C                   OPEN      XXGAMLPD                                                   JMI109
     C                   READ      XXGAMLPD                                                   JMI109
     C                   DOW       NOT %EOF
     C                   EVAL      SIPS = GIPS
     C                   EVAL      SUSER = GUSER
     C                   EVAL      SPWORD = GPWORD
     C                   EVAL      SDIR = GDIR
     C                   EVAL      SOPDPT = GOPDPT
     C***********        READ      SDGAMLD0                                                   JMI109
     C                   READ      XXGAMLD0                                                   JMI109
     C                   ENDDO
     C***********        CLOSE     SDGAMLX0                                                   JMI109
     C                   CLOSE     XXGAMLPD                                                   JMI109
     C                   ENDIF
     C                   SETON                                        01
     C                   ENDIF
      *
      ** Read file on maintenance mode
     C                   IF        P1MODE = 'M'


     C**********         OPEN      SDGAMLX0                                                   JMI109
     C**********         READ      SDGAMLD0                                                   JMI109
     C                   OPEN      XXGAMLPD                                                   JMI109
     C                   READ      XXGAMLD0                                                   JMI109
     C                   DOW       NOT %EOF
      *
     C                   MOVE      'Y'           FLAG              1
     C                   EVAL      SIPS = GIPS
     C                   EVAL      SUSER = GUSER
     C                   EVAL      SPWORD = GPWORD
     C                   EVAL      SDIR = GDIR
     C                   EVAL      SOPDPT = GOPDPT
      *
     C**********         READ      SDGAMLD0                                                   JMI109
     C                   READ      XXGAMLD0                                                   JMI109
     C                   ENDDO
     C                   IF        FLAG = 'Y'
     C                   MOVE      'A'           CHTYP             1
     C                   ELSE
     C                   MOVE      'I'           CHTYP
     C                   ENDIF
     C**********         CLOSE     SDGAMLX0                                                   JMI109
     C                   CLOSE     XXGAMLPD                                                   JMI109
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C     PROCESS       BEGSR
      *
      ** If there is an error in any of the fields then we need to
      ** redisplay the screen and send all error messages
      *
     C                   IF        *IN30 = '1'
      *
      ** Validate Operating Department
      *
     C                   IF        SOPDPT = *BLANKS
     C                   EVAL      ZAMSID = 'XXX1155'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETON                                        34
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     ZASNMS        BEGSR
      *
      ** Send message to program's message queue
      *
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   END
      *
      ** If no message file specified, use default
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   END
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C                   PARM                    ZAMSTP            7            Message type
      *
      ** Clear all fields for default mechanism next time
     C                   MOVEL     *BLANK        ZAPGMQ
     C                   MOVEL     *BLANK        ZAPGRL
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSTP
      *
     C                   ENDSR
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

     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   DUMP
     C                   RETURN
      *
     C                   ENDSR
      *
      *================================================================
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2008
