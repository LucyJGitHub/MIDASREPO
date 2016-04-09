     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Customer Loans BoE Input')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LECLIPSIN1 - LE Customer Loans BoE Input                     *
      *                                                               *
      *  Function:  This will handle the processing of transactions   *
      *               on customer loans entered via SIN for           *
      *               BoE Customer Loans.                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Last Amend No. LLN022  *CREATE    Date 24Jan05               *
      *  Prev Amend No.                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LLN022 - BOE Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
      /TITLE    S U B R O U T I N E   I N D E X .                     *
      *                                                               *
      *     Subroutine Index                                          *
      *     ================                                          *
      *                                                               *
      *     1. SRINIT    -   Initial Processing                       *
      *     2. SRCLEAR   -   Clear fields/indicators                  *
      *     3. SREXIT    -   Leave Program via END (F3)               *
      *     4. SRPREV    -   Leave program via END (F12)              *
      *     5. SRVCLR    -   Initialise variables                     *
      *     6. SRUPDAT   -   Update Processing                        *
      *     7. SRVALID   -   Validation Processing                    *
      *     8. SRTERM    -   Leave program                            *
      *     9. ZASNMS    -   Sends Message to Message Subfile         *
      *    10. SREMOVI   -   Move Fields into screen fields           *
      *    11. *INZSR    -   First time routine                       *
      *    12. *PSSR     -   Database Error Handling                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *       03      F3 PRESSED EXIT PROGRAM                         *
      *       12      F12 PRESSED GOTO PREVIOUS SCREEN                *
      *       20      FIELDS TO BE PRETECTED DURING ENQUIRY           *
      *       25      REDISPLAY THE SCREEN                            *
      *---------------------------------------------------------------*
      *       86      CHAIN TO BYLOANX0 FAILED                        *
      *                                                               *
      *****************************************************************
      ** Input Files
      *
      ** Extension file (retrieval)
     FBYLOANY0  IF   E           K DISK
     F                                     INFSR(*PSSR)
      *
      ** Display File for Window
     F***LELOAN#0* CF   E             WORKSTN                                               MD034876
     FLELOANDF  CF   E             WORKSTN                                                  MD034876
     F                                     INFSR(*PSSR)

      *****************************************************************
      /EJECT
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Add 1 onto elements in array for each field on window
     D @EI             S              1    DIM(10)

      *
     D SPARE2          S            256A

      *
     D** Copyright array
     D A@CPY           DS

      *
      ** Local data area for database error details

      ** Datastructure to define input parameter DATA
     D/COPY QWINDSRC,LECLIPDTA

      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Data structure for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** NEW Loan Details in Screen Format
     D NwCLIPScnFmt  E DS                  EXTNAME(LECLEXPD)

      ** NEW Loan Details in File Format
     D NwCLIPFilFmt  E DS                  EXTNAME(LEVCLIPX0)

      ** Error indicators (OK#S)
     D OKFLAGS       E DS                  EXTNAME(LEECLIPX0)

      ** Loan number ranges file
     D SDLENO        E DS                  EXTNAME(SDLENOPD)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Action Code
     D ACTN            S              1A
     D W0RTN           S              7A
     D W8RTN           S              7A
     D WLEN            S              3S 0
     D WWID            S              3S 0
     D WProcess        S              1
     D TITLE           S              7A
     D TEXT            S            132A

      ** Standards Input Parameters

      ** Window position
     D SROW            S              3  0
     D SCOL            S              3  0

      ** Standards Output Parameters

      ** Function Keys
     D @INKC           S              1
     D @INKL           S              1

      ** Index error array
     D Idx             S              3P 0 INZ(0)
      ** Index warning array
     D WIdx            S              3P 0 INZ(0)

     D PRTCD           S              7A
     D POPTN           S              7A

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      **               M A I N  P R O C E S S I N G                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Main Loop                                                    *
      *                                                               *
      *  Calls: SRINIT                                                *
      *         SRCLEAR                                               *
      *         SRVCLR                                                *
      *         SREXIT                                                *
      *         SRPREV                                                *
      *         SRVALID                                               *
      *         SRTERM                                                *
      *                                                               *
      *****************************************************************
      *
      ** Initialise data
      *
     C                   EXSR      SRINIT
      *
      ** Do while screen: Key Details Screen
      *
     C                   DOU       WProcess = 'N'
      *
      ** Set screen error indicators according to status of 'OK' flags
      *
     C                   MOVEA     OKFLAGS       @EI
      *
      ** Initialise variables
      *
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     50            E                 2 0
      *
      ** Do until greater thab 10
      *
     C     C             DOUGT     10
      *
      ** If array field value is 'N' or 'W'
      *
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
     C                   ENDIF
      *
      ** Increment variables by 1
      *
     C                   ADD       1             C
     C                   ADD       1             E
      *
     C                   ENDDO
      *
      ** Do while error messages found write error messages to subfile
      *
     C                   Z-ADD     1             C
      *
     C     C             DOWLE     ArrayMax
     C     FldNameArr(C) ANDNE     *BLANKS
     C                   MOVEL     MsgIDArr(C)   ZAMSID
     C                   MOVEL     MsgDtaArr(C)  ZAMSDA
     C                   EXSR      ZASNMS
     C                   ADD       1             C
     C                   ENDDO
      *
      ** Write message subfile and window details screen
      *
     C                   IF        Idx > 0
     C                   WRITE     #MSGCTL
     C                   ENDIF
      *
      ** Display the window
      *
     C                   EXFMT     WINDOWF
      *
      ** Clear the message subfile
      *
     C                   EXSR      SRCLEAR
      *
      ** Set return keys
      *
     C                   EVAL      @INKC = *INKC
     C                   EVAL      @INKL = *INKC
      *
      ** Initialise the variables
      *
     C                   EXSR      SRVCLR
      *
      ** If F3 is pressed
      *
     C     *INKC         CASEQ     '1'           SREXIT
      *
      ** If F12 is pressed
      *
     C     *INKL         CASEQ     '1'           SRPREV
      *
      ** If other keys other than F3 & F12 is pressed
      *
     C                   CAS                     SRVALID
      *
     C                   ENDCS
      *
     C                   ENDDO
      *
      ** Exit from program
      *
     C                   EXSR      SRTERM
      *
      *****************************************************************
      *  *INZSR - INITIAL PROCESSING                                  *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Entry Parameters
     C     *ENTRY        PLIST
     C                   PARM                    ACTN
     C                   PARM                    DATA
     C                   PARM                    W8RTN
     C                   PARM                    WLEN
     C                   PARM                    WWID
     C                   PARM                    SROW
     C                   PARM                    SCOL
     C                   PARM                    TITLE
     C                   PARM                    SPARE2
      *
      ** Access bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     POPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  SRINIT - Initialisation                                      *
      *                                                               *
      *   Calls: SREMOVI                                              *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR
      *
      ** Define window position
      *
     C                   EVAL      SWROW = SROW
     C                   EVAL      SWCOL = SCOL
      *
      ** Initialize program name
      *
     C                   MOVEL     'LECLIPSIN1'  L#PGM
      *
      ** Retrieve title for window
      *
     C                   EVAL      ZAMSGF = 'GBBYUSRMSG'
     C                   CALL      'SDRTVTXT'
     C                   PARM                    TITLE
     C                   PARM                    ZAMSGF
     C                   PARM                    TEXT
     C                   EVAL      L#TITL = %TRIM(TEXT)
      *
      ** Protect input fields if enquiry,
      **  else make sure they are highlighted on window
      *
     C                   IF        ACTN = 'E'
     C                   EVAL      *IN20 = *ON
     C                   ENDIF
      *
     C                   IF        ACTN = 'E' or ACTN = 'A'
      *
      ** Get the Loan details from BYLOANX0
      *
     C     LVLNRF        CHAIN     BYLOANY0                           99
     C     *IN99         IFEQ      *OFF
      *
      ** Moving fields into screen fields
      *
     C                   EXSR      SREMOVI
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *  SRCLEAR - Clear the message subfile                          *
      *                                                               *
      *   Called by: MAIN LOOP                                        *
      *              SRPREV                                           *
      *                                                               *
      *****************************************************************
     C     SRCLEAR       BEGSR
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      PSProcName    ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      *
     C                   ENDSR
      *
      *****************************************************************
      *  SREXIT - F3 is pressed                                       *
      *                                                               *
      *   Called by: MAIN LOOP                                        *
      *                                                               *
      *****************************************************************
     C     SREXIT        BEGSR
      *
      ** Set F3 return code and end program
      *
     C                   EVAL      W8RTN = 'Y2U9999'
     C                   EVAL      WProcess = 'N'
      *
     C                   ENDSR
      *
      *****************************************************************
      *  SRPREV - F12 is pressed                                      *
      *                                                               *
      *   Called by: MAIN LOOP                                        *
      *                                                               *
      *   Calls: SRCLEAR                                              *
      *                                                               *
      *****************************************************************
     C     SRPREV        BEGSR
      *
      ** Set F12 return code and end program
      *
     C                   EVAL      W8RTN = 'USR0790'
     C                   EXSR      SRCLEAR
     C                   EVAL      WProcess = 'N'
      *
     C                   ENDSR
      *
      *****************************************************************
      *  SRVCLR - F12 is pressed                                      *
      *                                                               *
      *   Called by: MAIN LOOP                                        *
      *                                                               *
      *****************************************************************
     C     SRVCLR        BEGSR
      *
      ** Function Keys
      *
     C                   MOVE      *ALL'0'       *IN
      *
      ** Reset Errors
      *
     C                   MOVE      *ALL'Y'       OKFLAGS
     C                   EVAL      FldNameArr = *BLANK
     C                   EVAL      MsgIDArr   = *BLANK
     C                   EVAL      MsgDtaArr  = *BLANK
     C                   EVAL      WFldNamArr = *BLANK
     C                   EVAL      WMsgIDArr  = *BLANK
     C                   EVAL      WMsgDtaArr = *BLANK
     C                   EVAL      W0RTN      = *BLANK
     C                   EVAL      Idx        = 0
     C                   EVAL      WIdx       = 0
      *
     C                   ENDSR
      *****************************************************************
      *  SRVALID - If function key (other than F3 & F12) or Enter is  *
      *           pressed                                             *
      *                                                               *
      *   Called by: MAIN LOOP                                        *
      *                                                               *
      *   Calls: SRUPDAT                                              *
      *                                                               *
      *****************************************************************
     C     SRVALID       BEGSR
      *
     C                   EVAL      LLNTPX = L#LNTP
     C                   EVAL      LFMATX = L#FMAT
      *
      ** Call LEPCLIPVAL1
      *
     C                   CALLB     'LECLIPVAL1'
     C                   PARM                    ACTN
     C                   PARM                    DATA
     C                   PARM                    NwCLIPScnFmt
     C                   PARM                    BJDFIN
     C                   PARM                    OKFLAGS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwCLIPFilFmt
      *
      ** No errors so update the extension file
      *
     C                   IF        Idx = 0
     C                   EVAL      WProcess = 'N'
     C                   EXSR      SRUPDAT
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *  SRUPDAT - Update                                             *
      *                                                               *
      *   Called by: SRVALID                                          *
      *                                                               *
      *****************************************************************
     C     SRUPDAT       BEGSR
      *
     C                   EVAL      BYLNRF = LVLNRF
     C                   EVAL      BYLNTP = LVLNTP
     C                   EVAL      BYFMAT = LVFMAT
      *
     C                   ENDSR
      *****************************************************************
      *  ZASNMS - Send message to program's message queue             *
      *                                                               *
      *   Called by: MAIN LOOP                                        *
      *                                                               *
      *****************************************************************
     C     ZASNMS        BEGSR
      *
      ** Send message to program's message queue.
      *
     C                   CALL      'Y2SNMGC'
      ** Program queue
     C                   PARM      L#PGM         ZAPGMQ           10
      ** Rel queue
     C                   PARM                    ZAPGRL            5
      ** Message ID
     C                   PARM                    ZAMSID            7
      ** Message File
     C                   PARM                    ZAMSGF           10
      ** Message Data
     C                   PARM                    ZAMSDA          132
      ** Message Type
     C                   PARM                    ZAMSTP            7
      *
     C                   ENDSR
      *****************************************************************
      *  SRTERM - Seton LR and return                                 *
      *                                                               *
      *   Called by: MAIN LOOP                                        *
      *                                                               *
      *****************************************************************
     C     SRTERM        BEGSR
      *
     C                   SETON                                            LR
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SREMOVI - Move fields to the screen fields                   *
      *                                                               *
      *   Called by: SRINIT                                           *
      *                                                               *
      *****************************************************************
      *
      ** Move Fields into screen fields in Amend and Enquiry modes
      *
     C     SREMOVI       BEGSR
      *
     C                   EVAL      LLNTPX = LLNTP
     C                   EVAL      LFMATX = LFMAT
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2005
