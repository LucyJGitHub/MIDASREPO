     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cash Management Sweep Request')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100461 - Cash Management Sweep Request                     *
      *                                                               *
      *  Function: This module allows requests to be made to do       *
      *            cash management sweeping.                          *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BG8539             Date 15Sep05               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BG8539 - Screen not dispaly properly in WebFacing            *
      *           Change the write/read order so that the last        *
      *           written format of the screen is next one to be READ *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FRE100461DFCF   E             WORKSTN INFSR(*PSSR)
     FRECMSRPD  O    E             DISK    INFSR(*PSSR)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
      * Link account details
 
     C     I_REQTYP      IFEQ      'L'
     C                   MOVE      I_CCUS        WrkCUS            6
     C                   MOVE      I_CACD        WrkACD            4
     C                   MOVE      I_CASN        WrkASN            2
     C                   EVAL      DDACC = I_CBRC +  '-'  +  WrkCUS  +  '-'
     C                                      +  I_CCCY +  '-'  +  WrkACD   +
     C                                      '-'  +  WrkASN
 
     C                   EVAL      DDRAN  = I_RAN
     C                   EVAL      DDANAM = I_ANAM
     C                   ENDIF
 
      * Default screen input field
 
     C                   MOVEL     'N'           DDCONFIRM
 
      * Display screen
      * until F/3 or F/12 are taken
 
     C     *INKC         DOWEQ     '0'
     C     *INKL         ANDEQ     '0'
     C                   EXSR      DSPLAY_SCN
     C                   ENDDO
 
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
 
      * Write screen and foooter
 
     C                   TIME                    DDTIME
     C                   WRITE     MSGSUBCT
     C                   WRITE     FOOTER                                                     BG8539
     C     I_REQTYP      IFEQ      'H'
     C                   WRITE     HIERARCHY
     C                   ELSE
     C                   WRITE     HIERLINK
     C                   ENDIF
     C**********         WRITE     FOOTER                                                     BG8539
 
      * Read screen
 
     C     I_REQTYP      IFEQ      'H'
     C                   READ      HIERARCHY
     C                   ELSE
     C                   READ      HIERLINK
     C                   ENDIF
 
      ** Clear the message queue & init error indicators
 
     C                   EXSR      CLR_MSGQ
 
      * If F/3 or F/12 were not taken
 
     C     *INKC         IFEQ      '0'
     C     *INKL         ANDEQ     '0'
 
      * Validate input
 
     C                   EXSR      VALID_INPUT
 
      * If the input is valid
      * and confirmed
 
     C     Valid         IFEQ      'Y'
     C     DDCONFIRM     ANDEQ     'Y'
 
      *   Submit sweep job
 
     C     I_REQTYP      IFEQ      'H'
     C                   MOVEL     I_HIER        I_RHIER
     C                   MOVEL     'ALL      '   I_RLINK
     C                   ELSE
     C                   MOVEL     I_HIER        I_RHIER
     C                   MOVEL     I_LINK        I_RLINK
     C                   ENDIF
     C                   MOVEL     DDTIME        I_RTIME
 
     C                   CALL      'REC101205'
     C                   PARM                    I_RHIER           9
     C                   PARM                    I_RLINK           9
     C                   PARM                    I_RTIME           6
 
      * Write to the cash management sweeps requested file
 
     C                   EXSR      WRT_CMSR
 
     C                   COMMIT
 
      *   Display confirmation screen
 
     C                   MOVE      '1'           *IN70
     C                   WRITE     CONFIRM                                                    BG8539
     C     I_REQTYP      IFEQ      'H'
     C                   WRITE     HIERARCHY
     C                   ELSE
     C                   WRITE     HIERLINK
     C                   ENDIF
     C**********         WRITE     CONFIRM                                                    BG8539
 
     C     I_REQTYP      IFEQ      'H'
     C                   READ      HIERARCHY                              99
     C                   ELSE
     C                   READ      HIERLINK                               99
     C                   ENDIF
 
     C     *INKC         IFNE      '1'
     C                   MOVE      '1'           *INKL
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Write to the cash management sweeps requested file
      ********************************************************************
     C     WRT_CMSR      BEGSR
 
      * Hierarchy ID
      * Link ID
     C                   MOVEL     I_HIER        SRHIER
     C                   MOVEL     I_LINK        SRLINK
      * Hierarchy Shortname
     C                   MOVEL     I_HISN        SRHISN
      * Reason
      * User
      * Time
     C                   MOVEL     REASON        SRREAS
     C                   MOVEL     DDUSR         SRUSR
     C                   MOVEL     DDTIME        SRTIME
 
     C                   WRITE     RECMSRD0
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Validate input
      *****************************************************************
     C     VALID_INPUT   BEGSR
 
     C                   MOVE      'Y'           Valid             1
 
      * 'Reason for sweep must be defined'
 
     C     REASON        IFEQ      *BLANK
     C                   MOVE      'N'           Valid
     C                   MOVE      *ON           *IN51
     C                   MOVEL     'RE75910'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
 
      * 'Input Y or N to confirm.'
 
     C     DDCONFIRM     IFNE      'Y'
     C     DDCONFIRM     ANDNE     'N'
     C                   MOVE      'N'           Valid
     C                   MOVE      *ON           *IN52
     C                   MOVEL     'RE75914'     ZAMSID
     C                   EXSR      ZASNMS
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
     C                   PARM      'REUSRMSG'    ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM                    ZAMSTP            7
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      ** Clear the message queue & init error indicators
      *****************************************************************
     C     CLR_MSGQ      BEGSR
 
     C                   CALL      'Y2CLMSC'
     C                   PARM      DDPGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
 
     C                   MOVEA     '000000'      *IN(51)
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      * Return code
      * Error Message
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * Request Type
     C                   PARM                    I_REQTYP          1
      * Hierarchy ID
      * Hierarchy Shortname
      * Hierarchy Type
      * Hierarchy Description
      * Link ID
     C                   PARM                    I_HIER            9 0
     C                   PARM                    I_HISN           10
     C                   PARM                    I_HTYP            2
     C                   PARM                    I_DESC           50
     C                   PARM                    I_LINK            9 0
      * Child branch
      * Child customer
      * Child currency
      * Child a/c code
      * Child a/c seq.
     C                   PARM                    I_CBRC            3
     C                   PARM                    I_CCUS            6 0
     C                   PARM                    I_CCCY            3
     C                   PARM                    I_CACD            4 0
     C                   PARM                    I_CASN            2 0
      * Retail A/c Number
      * Account Name
     C                   PARM                    I_RAN            10
     C                   PARM                    I_ANAM           20
 
      * Command keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
 
      * Initialize program name
 
     C                   MOVEL     'RE100461 '   DDPGM
 
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
 
      ** Clear the message queue & init error indicators
 
     C                   EXSR      CLR_MSGQ
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
