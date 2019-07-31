     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cash Management Outgoing Messages Enquiry')   *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100456 - Cash Management Outgoing Messages Enquiry         *
      *                                                               *
      *  Function: This module allows message management outgoing     *
      *            messages for a top account to be enquired upon.    *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BG8539             Date 15Sep05               *
      *                 213572             Date 07Jan03               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BG8539 - Screen not dispaly properly in WebFacing            *
      *           Change the write/read order so that the last        *
      *           written format is not the footer before the READ    *
      *  213572 - Outgoing message fields not set correctly           *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FRE100456DFCF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(SUBFLREC:RRN)
     FMGOREFLA  IF   E           K DISK    INFSR(*PSSR)
     FREICSDL4  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
      * Hierarchies Array
     D ARR_HIERS       S              9S 0 DIM(999) ASCEND
 
 
     D TABCD           S              4    DIM(49) CTDATA PERRCD(1)
     D TABNAR          S             12    DIM(49) ALT(TABCD)
     D TABMM           S              2    DIM(12) CTDATA PERRCD(1)
     D TABMON          S              3    DIM(12) ALT(TABMM)
 
 
     D MGOREF        E DS                  EXTNAME(MGOREFPD)
     D**MT********************57     64                                         213572
     D  MT                    57     62                                         213572
     D  MGDEY                183    184
     D  MGDEM                185    186
     D  MGDED                187    188
 
 
     D                 DS
     D  @DDMONYY               1      7
     D  @DD1                   1      2
     D  @MM1                   3      5
     D  @YY1                   6      7
     D                 DS
     D  @DDMMYY                1      6
     D  @DD2                   1      2
     D  @MM2                   3      4
     D  @YY2                   5      6
 
 
     D                 DS
     D  @MTRN                  1     15
     D  @MT                    1      6                                         213572
     D**@MT********************1      8                                         213572
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency Details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs
 
 
      /SPACE 5
 
 
      * Link ID
     C                   MOVE      I_LINK        LinkID            6
 
      * Convert run date to DD/MM/YY format
      * and set the screen date to this
 
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATEN        RunDate           6
     C                   MOVE      RunDate       DDDATE
 
      * Fill the subfile with messages
 
     C                   EXSR      FILL_SUB
 
      * Display screen until F3, or F12 taken
 
     C     *INKC         DOWEQ     '0'
     C     *INKL         ANDEQ     '0'
     C                   EXSR      DSPLAY_SCN
     C                   END
 
      * Pass back function keys taken
 
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKL         @INKL
 
      * End of program
 
     C                   SETON                                        LR
 
      /SPACE 5
      *****************************************************************
      * Display screen
      *****************************************************************
     C     DSPLAY_SCN    BEGSR
 
     C                   MOVEL     DDDATE        P_DDDATE          6
 
      * Write and read screen
 
     C                   TIME                    DDTIME
     C                   WRITE     MSGSUBCT
     C**********         WRITE     SUBFLCTL                                                   BG8539
     C                   WRITE     FOOTER
     C                   WRITE     SUBFLCTL                                                   BG8539
 
      * Read subfile control
 
     C                   READ      SUBFLCTL                               99    *
 
      ** Clear the message queue & init error indicators
 
     C                   EXSR      CLR_MSGQ
 
      ** If selection has changed and it's valid
      ** Re-fill the subfile with the outgoing messages
 
     C     *INKC         IFNE      '1'
     C     *INKL         ANDNE     '1'
 
     C                   EXSR      VALID_DATE
 
     C     DDDATE        IFNE      P_DDDATE
     C     Valid         ANDEQ     'Y'
     C                   EXSR      FILL_SUB
     C                   ENDIF
 
      * Check for a record selected from the subfile
 
     C                   EXSR      CHK_SUBF
 
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Fill the subfile with the outgoing messages
      *****************************************************************
     C     FILL_SUB      BEGSR
 
      * Clear subfile
     C                   MOVEA     '0000'        *IN(11)
     C                   Z-ADD     *ZERO         RRN
     C                   WRITE     SUBFLCTL                                     *
 
      * Read all outgoing messages for date
 
     C                   MOVEL     DDDATE        @DDMMYY
     C                   EVAL      @MODI = 'RE'
     C                   EVAL      @MTRN = LinkID + @YY2 + @MM2 + @DD2          213572
     C*******************EVAL      @MTRN = 'RE' + LinkID + @YY2 + @MM2 + @DD2   213572
     C     MGOREFK       SETLL     MGOREFLA
     C     @MODI         READE     MGOREFLA                               99    *
 
      * Do while outgoing messages found for the link
 
     C     *IN99         DOWEQ     '0'
     C     MT            ANDEQ     @MT
 
     C                   EXSR      FMT_MSG
     C                   ADD       1             RRN               4 0          *
     C                   WRITE     SUBFLREC
 
     C     @MODI         READE     MGOREFLA                               99    *
     C                   ENDDO
 
     C                   CLEAR                   MGOREF
     C                   MOVEL     *BLANK        MSGSTAT
     C                   MOVEL     *BLANK        MSGGNDT
     C                   MOVEL     *BLANK        SWIFTAMT
     C                   MOVEL     *BLANK        UNMATCH
     C                   ADD       1             RRN                  14
     C                   WRITE     SUBFLREC
 
      * Reset subfile
 
     C                   MOVEA     '111'         *IN(11)
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Format message
      *****************************************************************
     C     FMT_MSG       BEGSR
 
      * Message status description
 
     C     MGST          LOOKUP    TABCD         TABNAR                   99
     C     *IN99         IFEQ      '1'
     C                   MOVEL     TABNAR        MSGSTAT
     C                   ELSE
     C                   MOVE      *BLANKS       MSGSTAT
     C                   MOVEL     MGST          MSGSTAT
     C                   END
 
      * Message generation date
 
     C     MGDEM         LOOKUP    TABMM         TABMON                   99
     C                   MOVE      MGDEY         @YY1
     C                   MOVE      TABMON        @MM1
     C                   MOVE      MGDED         @DD1
     C                   MOVE      @DDMONYY      MSGGNDT
 
     C                   MOVEL     AMTX          SWIFTAMT
     C                   MOVEL     *BLANK        UNMATCH
 
     C                   MOVEL     TRNO          TRNOK            16
     C                   MOVEL     'RE'          TRNOK
     C     TRNOK         CHAIN     REICSDL4                           60
     C     *IN60         CABEQ     '1'           E_FMT_MSG
 
 
      * Access currency details
 
     C                   MOVEL     IDPCCY        CCY
     C                   EXSR      ACS_CURR
 
      * Edit SWIFT amount
 
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      IDSWFA        ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        SWIFTAMT
 
      * Unmatched
 
     C     IDTPSW        IFEQ      'T'
     C     IDMTYN        ANDNE     'Y'
     C     IDDELD        ANDNE     'Y'
     C                   MOVEL     'Unmatched'   UNMATCH
     C                   ENDIF
 
     C     E_FMT_MSG     ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Check for a record selected from the subfile
      *****************************************************************
     C     CHK_SUBF      BEGSR
 
     C                   READC     SUBFLREC                               99    *RECORD CHANGED
 
      * Do until all records processed
 
     C     *IN99         DOWEQ     '0'
 
      * If an action code is specified
      *   Enquire on the record in the subfile
 
     C     DDACTN        IFNE      *BLANK
     C                   EXSR      ENQ_SflREC
     C     RRN           CHAIN     SUBFLREC                           99
     C                   MOVEL     *BLANK        DDACTN
     C                   MOVE      *OFF          *IN14
     C                   UPDATE    SUBFLREC
     C                   ELSE
     C                   MOVE      '0'           @INKC
     C                   ENDIF
 
      * Read next if F3 not requested
 
     C     @INKC         IFEQ      '0'
     C                   READC     SUBFLREC                               99    *RECORD CHANGED
     C                   ELSE
     C                   MOVE      '1'           *IN99
     C                   MOVE      @INKC         *INKC
     C                   END
 
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Enquire on the record in the subfile
      ********************************************************************
     C     ENQ_SflREC    BEGSR
 
      * Call the Outgoing Message Detail Enquiry
 
     C                   CALL      'MEC0600'
     C                   PARM      TRNO          @TRNO            16
     C                   PARM      'N'           BGCFMT            1
     C                   PARM      'E'           @ACTN             1
     C                   PARM      'S'           @FILA             1
     C                   PARM                    @RTC              2
     C                   PARM      '0'           @ERR              1
 
      * Error
     C     @ERR          IFNE      '0'
     C                   EVAL      X_ERMS = 'ENQUIRY FAILED'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      ** Validate date
      *****************************************************************
     C     VALID_DATE    BEGSR
 
     C                   MOVE      'Y'           Valid             1
 
      * The date must be a valid date
      * (default it to the run date if it is not defined)
 
     C     DDDATE        IFEQ      *BLANK
     C                   MOVE      RunDate       DDDATE
     C                   ENDIF
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDDATE        ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   PARM      6             ZADIG             2 0
 
     C     ZALIGNok      IFEQ      'Y'
     C                   MOVE      ZFIELD        ZDATEI
     C                   EXSR      ZDATE1
     C                   END
 
      * If either ZALIGN and ZDATE1 errors
      * 'Invalid Date'
 
     C     ZALIGNok      IFEQ      'N'
     C     ErrorFlag     OREQ      'Y'
     C                   MOVE      'N'           Valid
     C                   MOVE      *ON           *IN51
     C                   MOVEL     'RE75920 '    ZAMSID
     C                   EXSR      ZASNMS
     C                   END
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Access a currency
      ********************************************************************
     C     ACS_CURR      BEGSR
 
     C                   CALLB     'ZAACSCURR'
     C                   PARM                    CCY               3
     C                   PARM                    SDCURR
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *****************************************************************
      * Edit a signed field
      *****************************************************************
     C     ZSEDIT        BEGSR
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM      'J'           ZECODE            1
     C                   PARM                    ZOUT21           21
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Convert a date into a day number
      ********************************************************************
     C     ZDATE1        BEGSR
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATEI            6
     C                   PARM      *ZEROS        ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM      'N'           ErrorFlag         1
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * Convert a day number into a date
      ********************************************************************
     C     ZDATE2        BEGSR
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDATEN            6 0
     C                   PARM      *BLANK        ZADATE            7
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *****************************************************************
      ** Clear the message queue
      *****************************************************************
     C     CLR_MSGQ      BEGSR
 
     C                   CALL      'Y2CLMSC'
     C                   PARM      DDPGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
 
     C                   MOVEA     '0'           *IN(51)
 
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
     C                   PARM      'REUSRMSG'    ZAMSGF           10
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
     C                   PARM                    X_RTCD
     C                   PARM                    X_ERMS
      * Link ID
     C                   PARM                    I_LINK            9 0
      * Command keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
 
      * Initialize program name
 
     C                   MOVEL     'RE100456'    DDPGM
 
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
 
      * Key lists
 
     C     MGOREFK       KLIST
     C                   KFLD                    @MODI             2
     C                   KFLD                    @MTRN            15
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
** TABCD/TABNAR - Table of Status/Narrative.
CRTDCreated
AMNDAmended
DLTDDeleted
RSNDRdy to send
PENDPending Trans
TRANTransmitted
EFMT#Format err¢
ELAU#Lgl Aut err¢
ESEQ#Inp seq err¢
ETID#Term ID err¢
ELEN#Length err¢
EAUT#SW auth err¢
QRDQ#RDYQ error¢
QVRQ#VRYQ error¢
LACKLogical ack
NACK#Neg ack¢
EBL1#Err bas hd¢
EBL2#Err app hd¢
EBL4#Err text¢
EBL5#Err trlr¢
PRTDPrinted
RRTDRe-routed
TSNTSent
TOUTPending Tx
TCANCancelled
TRTYIn retry
TACTActive
TSENSent
THLEHeld - error
THLOHeld/Oper.
TBOXAt Telex box
TCNRCancel req.
TRELHeld on TlxQ
TWTGWaiting
TRTSRdy to send
TDESIn despatch
TONQOn Tlx queue
TCMPComplete
TUNKUnknown
TRRTRe-route Q
TDLTDeleted
TSPVSupervisor
THORHeld Origntr
THTCHeld Time C.
THLOHeld by Oper
TCARAt Carrier
THOPHeld by Oper
TIRSItem Reset
TCNANot accountd
**  Months MM/MMM format
01JAN
02FEB
03MAR
04APR
05MAY
06JUN
07JUL
08AUG
09SEP
10OCT
11NOV
12DEC
