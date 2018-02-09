     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*XBIA*: OVRDBF FILE(MESSAGES10) TOFILE(MEML10PD)                     *
/*XBIB*: OVRDBF FILE(MESSAGES11) TOFILE(MEML11PD)                     *
/*XBIC*: OVRDBF FILE(SEMESSPDX) TOFILE(SEMESSPD)                      *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SE SWIFT message enquiry')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Module                                    *
      *                                                               *
      *  SE4410 - SWIFT Message Enquiry                               *
      *                                                               *
      *  Function:  This program allows the user to see all SWIFT     *
      *             messages for a particular transaction             *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSE039  *CREATE    Date 21Jan03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSE039 - Auto-settle of trades                               *
      *                                                               *
      *****************************************************************
      *  Subroutine Index                                             *
      *                                                               *
      *  Sr_Create   - Write records to new file SEMESSPD             *
      *  Sr_Load     - Initialise and load subfile                    *
      *  Sr_Build    - Load subfile page                              *
      *  Sr_Display  - Display screen                                 *
      *  Sr_ScreenIn - Process screen input                           *
      *  Sr_Modified - Process modified subfile record                *
      *  Sr_ReLoad   - Request subfile reload                         *
      *  Sr_ResetFld - Initialise and reset all the Subfile fields    *
      *  Sr_LoadFld  - Load the subfile fields                        *
      *  #IY8TS - Test cursor                                         *
      *  ZASNMS - Send message to programs message  queue             *
      *  Sr_Exit     - Exit program: Normal                           *
      *  Sr_ExitD    - exit program: Direct                           *
      *  Sr_Init     - Initialisation                                 *
      *  *PSSR  - Program exception error routine                     *
      *                                                               *
      *****************************************************************
      * Indicator Summary                                             *
      *                                                               *
      *   03 - Exit program                                           *
      *   05 - Refresh                                                *
      *   27 - Next Page                                              *
      *   32 - Invalid Subfile Selection                              *
      *   50 - Validation Check                                       *
      *   60 - E of F                                                 *
      *   70 - If On the Message field details are being displayed    *
      *   71 - If On no data to display                               *
      *   72 - On if SFLCTL2 has been displayed.                     *
      *   80 - Clear Subfile                                          *
      *   81 - Display subfile                                        *
      *   82 - End of subfile                                         *
      *   83 - Scan for Commission Code                               *
      *   84 - SFLNXTCHG                                              *
      *   86 - PUTOVER                                                *
      *   87 - Enable key screen                                      *
      *   88 - Protect key fields                                     *
      *   89 - ADD mode                                               *
      *   92 - Read change SFLRCD                                     *
      *   94 - Clear DDS indicator                                    *
      *   98 - Force input format                                     *
      *   99 - Initialise Record relative number                      *
      *U7-U8 - General Error Indicators                               *
      *   LR - Last Record                                            *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** SWIFT Messages Display File
     FSE4410DF  CF   E             WORKSTN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     SFILE(#SFLRCD2:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      *
     FSEMVTSL0  IF   E           K DISK
     F                                     INFSR(*PSSR)
      ** RTV : Midas SE Movements
     FMESSAGES11IF   E           K DISK
     F                                     INFSR(*PSSR)
      ** RTV : Midas MM Messages by TRANS00001
     FMESSAGES10IF   E           K DISK
     F                                     INFSR(*PSSR)
     F                                     RENAME(MESSAGES:MESSAGES1)
      ** RTV : Midas MM Messages by MYKEY
     FSEMESSPDX UF A E           K DISK
     F                                     INFSR(*PSSR)
      ** UPD : Midas SE SWIFT Messages Temporary file
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
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
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, Long Data Structure
      *
      ** Display file information data structure
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      *
      ** File information data structure
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      *
      *****************************************************************
      ** Data structure for rundat
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
      *
     D KMESSAGE        DS            50
     D  KMESSAGE3              1      3
     D  KMESSAGE9              4      9
     D  KMESSAGE1_9            1      9
     D  KMESSAGE16            10     16
      *
     D KMESSAGEB       DS            50
     D  KMESSAGEB1_9           1      9
      *
     D                 DS
     D  W@CR                   1      1    INZ(x'0d')
     D  W@LF                   2      2    INZ(x'25')
     D  W@CRLF                 1      2
      *
     D TIME_STAMP      DS            26
     D  DATE_HH_MM_SS          1     19
     D TXT             S             78    DIM(2) CTDATA PERRCD(1)
      *
     D STS             S             23    DIM(7) CTDATA PERRCD(1)
      *
     D TRN             S              1    DIM(5) CTDATA PERRCD(1)
      *
     D CPY2@           S             80
      *
     D @RUN            S              1
      *
     D JBDTTM          DS
      ** Job date/time
      *
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
      *
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Initialize
      *
     C                   EXSR      Sr_Init
      *
      ** Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      *
      * Create SEMESSPD file with all messages if SWIFT Message enquiry
      * subfile is to be shown
     C     *IN70         IFEQ      *OFF
     C                   EXSR      Sr_Create
     C                   ENDIF
      *
     C                   DO        *HIVAL
      *
     C  N70              Z-ADD     8             ##SFPG            3 0          SFLPAG
     C   70              Z-ADD     14            ##SFPG            3 0          SFLPAG
      *
      ** Initialise and load subfile page
     C                   EXSR      Sr_Load
      *
     C                   MOVEL     'N'           W0RSF             1
      *
      ** Display screen until reload requested
      *
     C     W0RSF         DOWEQ     'N'
      *
      ** Display screen
      *
     C                   EXSR      Sr_Display
      *
      ** Process response
      ** Cancel & exit program
      *
     C                   SELECT
     C     *IN03         WHENEQ    *ON
     C                   MOVE      'Y2U9999'     Ret_Code
     C                   EXSR      SR_Exit
      *
      * If F12 taken from Linked Trade sub file screen then ensure
      * main subfile is displayed again if program not called with
      * message key as a parameter
     C     *IN70         WHENEQ    *ON
     C     Mess_Key      ANDEQ     *BLANKS
     C     *IN12         ANDEQ     *ON
     C                   MOVE      'Y'           W0RSF
     C                   MOVE      *OFF          *IN70
      *
     C     *IN70         WHENEQ    *OFF
     C     *IN12         ANDEQ     *ON
     C     *IN70         OREQ      *ON
     C     Mess_Key      ANDNE     *BLANKS
     C     *IN12         ANDEQ     *ON
     C                   MOVE      'USR0790'     Ret_Code
     C                   EXSR      SR_Exit
      *
      ** Display next SFL page
      *
     C     *IN27         WHENEQ    *ON
     C                   EXSR      Sr_Build
      *
      ** Process screen input
      *
     C                   OTHER
     C                   EXSR      Sr_ScreenIn
     C                   ENDSL
      *
     C                   ENDDO
      *
     C                   ENDDO
      *****************************************************************
      *                                                               *
      * Sr_Create - Create file with all messages on                  *
      *                                                               *
      * Calls                                                         *
      *                                                               *
      *                                                               *
      * Called by - MAIN                                              *
      *                                                               *
      *****************************************************************
     C     Sr_Create     BEGSR
      *
      * Access MESSAGES file using Transaction Number for all
      * Outgoing messages.
     C                   MOVE      '       '     KMessage16
     C     Tr_Type       IFEQ      'TP'
     C     Tr_Type       OREQ      'TS'
     C                   MOVE      'SET'         KMessage3
     C                   ELSE
     C     Tr_Type       IFEQ      'WI'
     C     Tr_Type       OREQ      'WI'
     C                   MOVE      'SED'         KMessage3
     C                   ELSE
     C                   MOVE      'SEV'         KMessage3
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVEL     Tr_Ref        KMessage9
      *
     C     KMessage      SETLL     MESSAGES11
     C                   READ      MESSAGES11                             82
      *
     C                   MOVEL     TRANS00001    KMESSAGEB
     C     KMESSAGE1_9   IFNE      KMESSAGEB1_9
     C                   MOVE      *ON           *IN82
     C                   ENDIF
     C
     C     *IN82         DOWNE     *ON
     C                   MOVEL     Tr_Ref        TTREF
     C                   MOVEL     Tr_Type       TTYPE
      *
      * Time Receieved
     C                   MOVEL     TIMER00001    TIME_STAMP
     C                   MOVEL     Date_HH_MM_SS TDTTM
      *
      * Direction
     C     DIRECTION     IFEQ      'I'
     C                   MOVE      'IN'          TINOUT
     C                   ELSE
     C                   MOVE      'OUT'         TINOUT
     C                   ENDIF
      *
      * Message Type
     C                   MOVEL     EXTER00001    TMTYPE
      * Network
     C                   MOVEL     NETWORK       TNETW
      *
      * Message Status
     C                   SELECT
     C     STATUS        WHENEQ    'A'
     C                   MOVEA     STS(1)        TSTAT
     C     STATUS        WHENEQ    'S'
     C                   MOVEA     STS(2)        TSTAT
     C     STATUS        WHENEQ    'D'
     C                   MOVEA     STS(3)        TSTAT
     C     STATUS        WHENEQ    'C'
     C                   MOVEA     STS(4)        TSTAT
     C     STATUS        WHENEQ    'R'
     C                   MOVEA     STS(5)        TSTAT
     C     STATUS        WHENEQ    'N'
     C                   MOVEA     STS(6)        TSTAT
     C     STATUS        WHENEQ    'Q'
     C                   MOVEA     STS(7)        TSTAT
     C                   ENDSL
      *
      * TRN Reference
     C                   MOVEL     TRANS00001    TTRN
      *
      * Message Key
     C                   MOVEL     MYKEY         TKEY
      *
      * Output record to SWIFT Messages file
     C                   WRITE     SEMESSD0
      *
     C                   READ      MESSAGES11                             82
      *
     C                   MOVEL     TRANS00001    KMESSAGEB
     C     KMESSAGE1_9   IFNE      KMESSAGEB1_9
     C                   MOVE      *ON           *IN82
     C                   ENDIF
      *
     C                   ENDDO
      *
      * Access SEMVTSPD for all records with required transaction
      * number and non-blank message key. Then access MESSAGES to get
      * details for message with that key.
     C                   MOVE      Tr_Ref        KTREF
     C     Tr_Type       IFEQ      'TP'
     C     Tr_Type       OREQ      'TS'
     C                   MOVE      'T'           KTYPE
     C                   ELSE
     C     Tr_Type       IFEQ      'WI'
     C     Tr_Type       OREQ      'WO'
     C                   MOVE      'W'           KTYPE
     C                   ELSE
     C                   MOVE      'D'           KTYPE
     C                   ENDIF
     C                   ENDIF
     C
     C     KMVTS         SETLL     SEMVTSL0
     C     KMVTS         READE     SEMVTSL0                               82
      *
      * If message key is blank read next record.
     C     *IN82         DOWNE     *ON
     C     TMMSGK        IFEQ      *BLANKS
     C                   GOTO      NXT_READ
     C                   ENDIF
     C*
     C     TMMSGK        CHAIN     MESSAGES10
      *
     C                   MOVEL     Tr_Ref        TTREF
     C                   MOVEL     Tr_Type       TTYPE
      *
      * Direction
     C     DIRECTION     IFEQ      'I'
     C                   MOVE      'IN'          TINOUT
     C                   ELSE
     C                   MOVE      'OUT'         TINOUT
     C                   ENDIF
      *
      * Message Type
     C                   MOVEL     EXTER00001    TMTYPE
      * Network
     C                   MOVEL     NETWORK       TNETW
      *
      * Message Status and time
     C                   SELECT
     C     STATUS        WHENEQ    'A'
     C                   MOVEA     STS(1)        TSTAT
     C                   MOVEL     TIMESENT      TIME_STAMP
     C                   MOVEL     Date_HH_MM_SS TDTTM
     C     STATUS        WHENEQ    'S'
     C                   MOVEA     STS(2)        TSTAT
     C                   MOVEL     TIMESENT      TIME_STAMP
     C                   MOVEL     Date_HH_MM_SS TDTTM
     C     STATUS        WHENEQ    'D'
     C                   MOVEA     STS(3)        TSTAT
     C     STATUS        WHENEQ    'C'
     C                   MOVEA     STS(4)        TSTAT
     C                   MOVEL     TIMER00001    TIME_STAMP
     C                   MOVEL     Date_HH_MM_SS TDTTM
     C     STATUS        WHENEQ    'R'
     C                   MOVEA     STS(5)        TSTAT
     C     STATUS        WHENEQ    'N'
     C                   MOVEA     STS(6)        TSTAT
     C     STATUS        WHENEQ    'Q'
     C                   MOVEA     STS(7)        TSTAT
     C                   ENDSL
      *
      * TRN Reference
     C                   MOVEL     TRANS00001    TTRN
      *
      * Message Key
     C                   MOVEL     MYKEY         TKEY
      *
      * Output record to SWIFT Messages file
     C                   WRITE     SEMESSD0
      *
     C     NXT_READ      TAG
     C     KMVTS         READE     SEMVTSL0                               82
     C                   ENDDO
     C
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * Sr_Load   - Initialise and Load Subfile Page                  *
      *                                                               *
      * Calls     - Sr_Build                                          *
      *           - ZASNMS                                            *
      *                                                               *
      * Called by - MAIN                                              *
      *                                                               *
      *****************************************************************
     C     Sr_Load       BEGSR
      *
      ** Set Up Function Key Text - Standard Functions
     C     *IN70         IFEQ      *OFF
     C                   MOVEA     TXT(1)        ##CTX1
     C                   ELSE
     C                   MOVEA     TXT(2)        ##CTX1
     C                   ENDIF
      *
      ** Clear subfile
     C                   MOVE      *ON           *IN80
     C     *IN70         IFEQ      *OFF
     C                   WRITE     #SFLCTL
     C                   ELSE
     C                   WRITE     #SFLCTL2
     C                   ENDIF
     C                   MOVE      *OFF          *IN80
      *
      ** Reset no of records in subfile
     C                   Z-ADD     *ZERO         ##RRMX            5 081        Setof 81
      *
     C     *IN70         IFEQ      *OFF
     C     *LOVAL        SETLL     SEMESSD0
     C                   READ      SEMESSD0                               82
     C                   ELSE
     C     *IN70         IFEQ      *ON
      *
      * Call RTVMSGFLD to obtain Message fields contained as CLOB in NETWO00001
     C                   EVAL      @FIELD = 'NetworkDependentFormat'
     C     Mess_Key      IFNE      *BLANKS
     C                   EVAL      @KEY = Mess_Key
     C                   ELSE
     C                   EVAL      @KEY = D1KEY
     C                   ENDIF
     C                   CALL      'RTVMSGFLD'
     C                   PARM                    @KEY             40
     C                   PARM                    @FIELD           50
     C                   PARM                    @VALUE        32000
      *
     C                   ENDIF
     C                   ENDIF
      *
      * Set up page header
     C                   MOVEL     Tr_Ref        D2TRAN
     C                   MOVEL     Tr_Type       D2TYPE
      *
      *
     C     *IN70         IFEQ      *ON
     C     Mess_Key      IFNE      *BLANKS
     C     Mess_Key      CHAIN     MESSAGES10
     C                   ELSE
     C     D1KEY         CHAIN     MESSAGES10
     C                   ENDIF
     C                   MOVEL     SENDE00001    D2SEND
     C                   MOVEL     DESTI00002    D2DEST
     C                   MOVEL     EXTER00001    D2MTYPE
      *
     C                   SELECT
     C     STATUS        WHENEQ    'A'
     C                   MOVEA     STS(1)        D2STAT
     C     STATUS        WHENEQ    'S'
     C                   MOVEA     STS(2)        D2STAT
     C     STATUS        WHENEQ    'D'
     C                   MOVEA     STS(3)        D2STAT
     C     STATUS        WHENEQ    'C'
     C                   MOVEA     STS(4)        D2STAT
     C     STATUS        WHENEQ    'R'
     C                   MOVEA     STS(5)        D2STAT
     C     STATUS        WHENEQ    'N'
     C                   MOVEA     STS(6)        D2STAT
     C     STATUS        WHENEQ    'Q'
     C                   MOVEA     STS(7)        D2STAT
     C                   ENDSL
      *
     C     DIRECTION     IFEQ      'I'
     C     DIRECTION     OREQ      'O'
     C     STATUS        ANDEQ     'C'
     C                   MOVEL     TIMER00001    TIME_STAMP
     C                   MOVEL     Date_HH_MM_SS D2DTTM
     C                   ELSE
     C                   MOVEL     TIMER00001    TIME_STAMP
     C                   MOVEL     Date_HH_MM_SS D2DTTM
     C                   ENDIF
      *
     C                   MOVEL     NETWORK       D2NETW
     C                   ENDIF
      *
      ** Load subfile page
     C                   EXSR      Sr_Build
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * Sr_Build  - Load Subfile Page                                 *
      *                                                               *
      * Calls     - Sr_ResetFld                                       *
      *           - Sr_LoadFld                                        *
      *           - Sr_DspAttr1                                       *
      *                                                               *
      * Called by - MAIN                                              *
      *           - Sr_Load                                           *
      *                                                               *
      *****************************************************************
     C     Sr_Build      BEGSR
      *
     C                   MOVE      *OFF          *IN84                          No SFLNXTCHG
      *
      ** Start at previous highest record in SFL
     C                   Z-ADD     ##RRMX        ##RR              5 0
     C                   Z-ADD     *ZERO         ##RROK            5 0
      *
      ** Reset count of DBF records read
     C                   Z-ADD     0             ##RRRD            5 0
      *
      ** Set required pages based on *Set Cursor or *Subfile Pages
     C     W0RR0         IFGT      0
     C     W0RR0         DIV       ##SFPG        ##SPG             3 0
     C                   MVR                     ##SLIN            3 0
     C     ##SLIN        IFGT      0
     C                   ADD       1             ##SPG
     C                   ENDIF
     C     W0SPG         IFGT      ##SPG
     C                   Z-ADD     W0SPG         ##SPG
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     W0SPG         ##SPG
     C                   ENDIF
      *
      ** Compute lines required based on pages
     C     ##SPG         MULT      ##SFPG        ##SFLN            9 0
     C     ##SFLN        IFGT      999
     C                   Z-ADD     999           ##SFLN
     C                   ENDIF
      *
      * If message details are to be displayed and this is the first page
      * of the subfile then obtain detail starting position.
     C     *IN70         IFEQ      *ON
     C     *IN71         ANDNE     *ON
     C                   MOVE      '}{4'         TEST              3
     C     TEST          SCAN      @VALUE        P                 5 0    82
      *
      * Test for end of subfile records is *IN82 being OFF. No more message
      * details switches *IN82 On so need to make the opposite.
     C     *IN82         IFEQ      *ON
     C                   MOVE      *OFF          *IN82
     C                   ELSE
     C                   MOVE      *ON           *IN82
     C                   ENDIF
      *
     C                   ADD       6             P
     C                   ENDIF
      *
      ** Load next SFL page until SFL page full, or :
      ** scan limit reached.
     C     *IN82         DOWEQ     '0'
     C     ##RROK        ANDLT     ##SFPG
     C     ##RRRD        ANDLT     W0SLM
      *
     C                   MOVE      *OFF          *IN32
     C                   MOVE      *OFF          *IN87
      *
     C     *IN70         IFEQ      *OFF
      ** Clear subfile fields
     C                   EXSR      Sr_ResetFld
      *
      ** Load SFL fields.
     C                   EXSR      Sr_LoadFld
      *
     C                   ELSE
     C                   MOVE      *BLANKS       D1MLINE
      *
     C     W@CRLF        SCAN      @VALUE:P      Q                 5 0    82
      *
      * Test for end of subfile records is *IN82 being OFF. No more message
      * details switches *IN82 On so need to make the opposite.
     C     *IN82         IFEQ      *ON
     C                   MOVE      *OFF          *IN82
     C                   ELSE
     C                   MOVE      *ON           *IN82
     C                   ENDIF
      *
     C     *IN82         IFEQ      *OFF
     C     Q             SUB       P             R                 5 0
     C     R             SUBST     @VALUE:P      D1MLINE
     C                   ADD       2             Q
     C                   Z-ADD     Q             P
     c                   ENDIF
      *
     C                   ENDIF
     C
      ** Record will be selected unless overridden
     C                   MOVEL     'Y'           W0RSL             1
      *
      ** If record dropped...
     C                   SUB       1             ##RR
     C     W0RSL         IFNE      'N'
     C                   ADD       1             ##RR
     C                   ENDIF
      *
      ** Output to subfile.
     C     W0RSL         IFNE      'N'
     C                   ADD       1             ##RR                 81
     C                   ADD       1             ##RROK
     C     *IN70         IFEQ      *OFF
     C                   WRITE     #SFLRCD
     C                   ELSE
     C                   WRITE     #SFLRCD2
     C                   ENDIF
     C                   ENDIF
      *
      ** Increment scan check count.
     C                   ADD       1             ##RRRD
      *
     C     *IN70         IFEQ      *OFF
     C                   READ      SEMESSD0                               82
     C                   ENDIF
      *
      *
     C                   ENDDO
      *
      ** If no DBF records found, display error message.
     C     ##RR          IFEQ      *ZERO
     C     *IN82         ANDEQ     '1'
      *
      ** Send message '*no data to display'
     C                   MOVEL     'Y2U0008'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   MOVE      *ON           *IN71
      *
     C                   ELSE
     C                   MOVE      *OFF          *IN71
     C                   END                                                    FI ##RR = *ZERO
      *
      ** Save highest SFL record load can continue at end point.
     C     ##RR          IFGT      ##RRMX
     C     ##RRMX        ADD       1             ##SFRC
     C                   Z-ADD     ##RR          ##RRMX
     C                   END
      *
      ** If scan limit reached, display error message.
     C     ##RRRD        IFGE      W0SLM
      *
      ** Send message '*Scan limit reached'
     C                   MOVEL     'Y2U0017'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE
     C                   Z-ADD     0             ##RROK
     C                   END
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * Sr_Display - Display screen                                    *
      *                                                               *
      * Calls     -                                                   *
      *           - #IY8TS                                            *
      *           - #IHPKY                                            *
      *                                                               *
      * Called by - MAIN                                              *
      *                                                               *
      *****************************************************************
     C     Sr_Display    BEGSR
      *
      ** PUTOVR unless conditioned fields change
     C                   MOVE      *ON           *IN86
     C     *IN81         IFNE      CAIN81
     C                   MOVE      *OFF          *IN86
     C                   ENDIF
     C                   MOVE      *IN81         CAIN81            1
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C     *IN70         IFEQ      *OFF
     C                   EXFMT     #SFLCTL
     C                   MOVE      *OFF          *IN71
     C                   ELSE
     C                   EXFMT     #SFLCTL2
     C                   MOVE      *ON           *IN71
     C                   ENDIF
      *
      ** Maintain subfile position where possible
     C     @#SFRC        IFGT      *ZERO
     C                   Z-ADD     @#SFRC        ##SFRC
     C                   ENDIF
      *
      ** Test cursor
     C                   EXSR      #IY8TS
      *
      ** Clear set cursor DDS indicator
     C     WCSRLC        IFEQ      'OFF'
     C                   MOVE      *OFF          *IN94
     C                   ENDIF
     C                   MOVE      *BLANK        WCSRLC
      *
      ** Update job time
     C                   TIME                    ##JTM
      *
      ** Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      *
      ** Reset first message only flag
     C                   MOVEL     'Y'           ZAFSMS            1      99
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * Sr_ScreenIn - Process Screen Input                            *
      *                                                               *
      * Calls     - Sr_Modified                                       *
      *           - Sr_UpdateSfl                                      *
      *           - Sr_AddChange                                      *
      *                                                               *
      * Called by - MAIN                                              *
      *                                                               *
      *****************************************************************
     C     Sr_ScreenIn   BEGSR
      *
      ** Change of position specified
      *
      ** Validate subfile control
      ** Quit if reload requested
      *
     C     W0RSF         IFNE      'Y'
      *
     C     *IN81         IFEQ      *ON
      *
     C                   DO
      *
      ** No data entered as yet
     C                   MOVEL     'N'           WKIPIN            1
      *
      ** Confirm/update is not deferred
     C                   MOVEL     'N'           W0DCF             1
      *
      ** Process subfile records
      * Only if *IN71 is off as no records to READC if on.
     C     *IN71         IFEQ      *OFF
     C                   EXSR      Sr_Modified
     C                   ENDIF
      *
     C                   ENDDO
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * Sr_Modified - Process Modified Subfile Record                 *
      *                                                               *
      * Calls     -                                                   *
      *                                                               *
      * Called by - MAIN                                              *
      *                                                               *
      *****************************************************************
     C     Sr_Modified   BEGSR
      *
     C                   READC     #SFLRCD                                92
      *
     C     *IN92         DOWEQ     *OFF
     C                   MOVE      *OFF          *IN87
      *
     C     *IN92         IFEQ      *OFF
     C                   MOVE      *ON           *IN70
     C                   EXSR      Sr_ReLoad
     C                   ENDIF
      *
     C                   UPDATE    #SFLRCD
     C                   READC     #SFLRCD                                92
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * Sr_ReLoad - Request Subfile Reload                            *
      *                                                               *
      * Calls     -                                                   *
      *                                                               *
      * Called by - MAIN                                              *
      *           - Sr_ScreenIn                                       *
      *           - Sr_AddChange                                      *
      *                                                               *
      *****************************************************************
     C     Sr_ReLoad     BEGSR
     C                   MOVEL     'Y'           W0RSF
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * Sr_ResetFld - Initialise Subfile Record                       *
      *                                                               *
      * Calls     -                                                   *
      *                                                               *
      * Called by - Sr_Build                                          *
      *                                                               *
      *****************************************************************
     C     Sr_ResetFld   BEGSR
      *
     C                   MOVEL     *BLANK        D1DTTM
     C                   MOVEL     *BLANK        D1INOUT
     C                   MOVEL     *BLANK        D1MTYPE
     C                   MOVEL     *BLANK        D1NETW
     C                   MOVEL     *BLANK        D1STAT
     C                   MOVEL     *BLANK        D1TRN
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * Sr_LoadFld- Move file fields to subfile                       *
      *                                                               *
      * Calls     -                                                   *
      *                                                               *
      * Called by - Sr_Build                                          *
      *           - EEDRLQ                                            *
      *           - Sr_ProcChng                                       *
      *                                                               *
      *****************************************************************
     C     Sr_LoadFld    BEGSR
      *
     C                   MOVE      *BLANKS       D1SELC
     C                   MOVEL     TDTTM         D1DTTM
     C                   MOVE      TINOUT        D1INOUT
     C                   MOVEL     TMTYPE        D1MTYPE
     C                   MOVEL     TNETW         D1NETW
     C                   MOVEL     TSTAT         D1STAT
     C                   MOVEL     TTRN          D1TRN
     C                   MOVEL     TKEY          D1KEY
     C                   MOVEL     TTREF         D1TREF
     C                   MOVEL     TTYPE         D1TYPE
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * #IY8TS    - Test Cursor                                       *
      *                                                               *
      * Calls     -                                                   *
      *                                                               *
      * Called by - Sr_Display                                        *
      *                                                               *
      *****************************************************************
     C     #IY8TS        BEGSR
     C                   Z-ADD     @#RWCL        ZINPOS            5 0
     C     ZINPOS        DIV       256           W0CRW
     C                   MVR                     W0CCL
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZASNMS    - Send message to program message queue             *
      *                                                               *
      * Calls                                                         *
      *                                                               *
      * Called by - Sr_Load                                           *
      *                                                               *
      *****************************************************************
     C     ZASNMS        BEGSR
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   ENDIF
      *
      ** If no message file specified, use default
      *
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     'SEUSRMSG'    ZAMSGF
     C                   ENDIF
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C                   PARM                    ZAMSTP            7            Message type
      *
      ** Clear all fields for default mechanism next time
      *
     C                   MOVEL     *BLANK        ZAPGMQ
     C                   MOVEL     *BLANK        ZAPGRL
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSTP
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Sr_Exit   - Exit Program : Normal                             *
      *                                                               *
      * Calls     - Sr_ExitD                                          *
      *                                                               *
      * Called by - MAIN                                              *
      *                                                               *
      *****************************************************************
     C     Sr_Exit       BEGSR
      *
      ** Exit program processing
      *
     C                   MOVEL     *BLANK        P0RTN             7
     C                   EXSR      Sr_ExitD
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Sr_ExitD  - Exit Program : Direct                             *
      *                                                               *
      * Calls     -                                                   *
      *                                                               *
      * Called by - Sr_Exit                                           *
      *           - Sr_Init                                           *
      *                                                               *
      *****************************************************************
     C     Sr_ExitD      BEGSR
      *
      ** Terminate program
     C                   MOVE      *ON           *INLR
      *
      ** Exit program
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * Sr_Init   - Initialisation                                    *
      *                                                               *
      * Calls     - Sr_ExitD                                          *
      *                                                               *
      * Called by - MAIN                                              *
      *                                                               *
      *****************************************************************
     C     Sr_Init       BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    Tr_Ref            6
     C                   PARM                    Tr_Type           2
     C                   PARM                    Mess_Key         40
     C                   PARM                    Ret_Code          7
      *
      ** Set up copyright parameter
     C                   MOVEA     CPY@          CPY2@
      *
      ** Initialize program name
     C                   MOVEL     'SE4410'      DBPGM
      *
      ** Move workstation ID to screen field
     C                   EVAL      ##PGM  = PSProcName
     C                   EVAL      DDUSR  = PsUser
     C                   EVAL      DDWID  = PsJobName
 
      ** Initialisation
     C     W0ICL         IFEQ      *BLANK
     C                   MOVEL     'Y'           W0ICL             1            Initial call
     C                   ELSE
     C                   MOVEL     'N'           W0ICL
     C                   ENDIF
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
     C                   MOVEL     *BLANK        W0RSL             1
     C                   MOVEL     *BLANK        W0RSF             1
      *
      ** Setup job date/time
      *
     C                   Z-ADD     UDATE         ##JDT
     C                   TIME                    ##JTM
      *
      ** Update screen time
      *
     C                   MOVEL     *BLANK        WUSUC             1            Set up Complete
     C                   MOVEL     *BLANK        WUTQKF            1            Test ? Key field
     C                   MOVEL     *BLANK        WUIVKF            1            If value in key fiel
      *
     C                   Z-ADD     *ZERO         WURDNB            5 0          Run day Number
     C                   MOVEL     *BLANK        WUMRDT            7            Midas Run Date
     C                   MOVEL     *BLANK        WUDFF             1            Date Format FLag
     C                   MOVEL     *BLANK        WUMBIN            1            Multi-branching Indi
     C                   MOVE      'N'           YSETCS            1            *SET Cursor
     C                   MOVE      *BLANK        WCSRLC            3
      *
     C                   MOVEL     *BLANKS       W0CFL            10            *Cursor field
     C                   Z-ADD     *ZEROS        W0CRW             5 0          *Cursor row
     C                   Z-ADD     *ZEROS        W0CCL             5 0          *Cursor column
      *
      ** Move main file information to JOB context
     C                   MOVE      @1FFL         ZZFFL            10            Main file
     C                   MOVE      @1FLB         ZZFLB            10            Main file library
     C                   MOVE      @1FMB         ZZFMB            10            Main file mbr
     C                   MOVE      ZZFFL         @1FFL            10
     C                   MOVE      ZZFLB         @1FLB            10
     C                   MOVE      ZZFMB         @1FMB            10
     C                   CALL      'Y2QLVNR'
     C                   PARM                    ZZFFL            10
     C                   PARM                    ZZFLB            10
     C                   PARM                    ZZFQL            21            Library/File
     C                   MOVEL     'N'           W0PMT             1
      *
     C                   Z-ADD     1             ##SFRC
      *
      ** Maximum record number
     C                   Z-ADD     *ZERO         ##RRMX
      *
      ** Scan limit
     C                   Z-ADD     9999          W0SLM             5 0
      *
      ** Subfile pages
     C                   Z-ADD     1             W0SPG             3 0
      *
      ** Processed Subfile record
     C                   Z-ADD     0             W0RR0             4 0
      *
      ** Initialize program
      ** Get Rundate - Rundate
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB                         Runday No.
     C                   MOVE      SUC           WUSUC                          Sse Up Complete
     C                   MOVE      DFF           WUDFF                          Data format flag
     C                   MOVE      MBIN          WUMBIN                         Multi-branching ind
      *
      * KLIST for SEMVTSPD
     C     KMVTS         KLIST
     C                   KFLD                    KTREF             6
     C                   KFLD                    KTYPE             1
      *
      * Initialise indicator to show Main subfile is to be built
      * unless Message Key has been passed in and so Message Detail
      * screen should be displayed.
     C     Mess_Key      IFEQ      *BLANKS
     C                   MOVE      *OFF          *IN70
     C                   ELSE
     C                   MOVE      *ON           *IN70
     C                   ENDIF
      *
      ** Access Bank Details
      *  (database error handling done in access program)
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
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
      *****************************************************************
**CTDATA TXT
F3=Exit F12=Previous X=Message Details
F3=Exit F12=Previous
**CTDATA STS
Acknowledged
Sent
Deleted
Created
Rejected
Neg. Ack.
Queued
**CTDATA CPY@
(c) Finastra International Limited 2003
