     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cash Management Block Request')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100463 - Cash Management Blocking Request                  *
      *                                                               *
      *  Function: This module allows requests to be made to block    *
      *            cash management zero balancing/sweeping.           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BG8539             Date 15Sep05               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 213910             Date 23Jan03               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BG8539 - Screen not dispaly properly in WebFacing            *
      *           Change the write/read order so that the last        *
      *           written format of the screen is next one to be READ *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  213910 - Show blocked links                                  *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FRE100463DFCF   E             WORKSTN INFSR(*PSSR)
     FREZSHLL0  IF   E           K DISK    INFSR(*PSSR)
     FRECMHLL4  IF   E           K DISK    INFSR(*PSSR)
     FRECMBRL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(RECMBRD0:RECMBRF0)
     FRECMBRPD  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
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
 
     C                   MOVEA     '000'         *IN(30)                        213910
     C     I_REQTYP      IFEQ      'L'
     C                   MOVE      I_CCUS        WrkCUS            6
     C**********         MOVE      I_CACD        WrkACD            4                          CGL029
     C                   MOVE      I_CACD        WrkACD           10                          CGL029
     C                   MOVE      I_CASN        WrkASN            2
     C                   EVAL      DDACC = I_CBRC +  '-'  +  WrkCUS  +  '-'
     C                                      +  I_CCCY +  '-'  +  WrkACD   +
     C                                      '-'  +  WrkASN
 
     C                   EVAL      DDRAN  = I_RAN
     C                   EVAL      DDANAM = I_ANAM
     C                   MOVEL     I_HIER        BRHIER                         213910
     C                   MOVEL     I_LINK        BRLINK                         213910
     C     RECMBRK       CHAIN     RECMBRF0                           99        213910
     C     *IN99         IFEQ      '1'                                          213910
     C                   MOVEL     '1'           *IN31                          213910
     C                   MOVEL     'B'           REQUEST                        213910
     C                   ELSE                                                   213910
     C                   MOVEL     '1'           *IN32                          213910
     C                   MOVEL     'U'           REQUEST                        213910
     C                   ENDIF                                                  213910
      * Hierarchy                                                               213910
     C                   ELSE                                                   213910
     C                   MOVEL     '1'           *IN30                          213910
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
 
      * If hierarchy
      *   Read all zero balancing/sweeping links for hierarchy
      *   Update the cash management blocks requested file
      * If link
      *   Update the cash management blocks requested file
 
     C     I_REQTYP      IFEQ      'H'
     C     I_HIER        SETLL     REZSHLL0
     C     I_HIER        READE     REZSHLL0                               60
     C     *IN60         DOWEQ     '0'
     C                   EXSR      UPD_CMBR
     C     I_HIER        READE     REZSHLL0                               60
     C                   ENDDO
     C                   ELSE
     C                   EXSR      UPD_CMBR
     C                   ENDIF
 
     C                   COMMIT
 
      *   Display confirmation screen
 
     C                   MOVE      '1'           *IN70
     C     REQUEST       IFEQ      'B'                                                       BG8539
     C                   WRITE     CONFIRMB                                                  BG8539
     C                   ELSE                                                                BG8539
     C                   WRITE     CONFIRMU                                                  BG8539
     C                   ENDIF                                                               BG8539
     C     I_REQTYP      IFEQ      'H'
     C                   WRITE     HIERARCHY
     C                   ELSE
     C                   WRITE     HIERLINK
     C                   ENDIF
     C*****REQUEST       IFEQ      'B'                                                        BG8539
     C**********         WRITE     CONFIRMB                                                   BG8539
     C**********         ELSE                                                                 BG8539
     C**********         WRITE     CONFIRMU                                                   BG8539
     C**********         ENDIF                                                                BG8539
 
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
      * Update the cash management blocks requested file
      ********************************************************************
     C     UPD_CMBR      BEGSR
 
      * Hierarchy ID
     C                   MOVEL     I_HIER        BRHIER
      * Hierarchy Shortname
     C                   MOVEL     I_HISN        BRHISN
      * Link ID
     C     I_REQTYP      IFEQ      'H'
     C                   MOVEL     ZLLINK        BRLINK
     C                   ELSE
     C                   MOVEL     I_LINK        BRLINK
     C                   ENDIF
      * Branch
      * Customer
      * Currency
      * A/c code
      * A/c seq
     C     I_REQTYP      IFEQ      'H'
     C     RECMBRK       CHAIN     RECMHLL4                           99
     C                   MOVEL     CLCBRC        BRCBRC
     C**********         Z-ADD     CLCCUS        BRCCUS                                       CSD027
     C                   EVAL      BRCCUS =      CLCCUS                                       CSD027
     C                   MOVEL     CLCCCY        BRCCCY
     C                   Z-ADD     CLCACD        BRCACD
     C                   Z-ADD     CLCASN        BRCASN
     C                   ELSE
     C                   MOVEL     I_CBRC        BRCBRC
     C**********         Z-ADD     I_CCUS        BRCCUS                                       CSD027
     C                   EVAL      BRCCUS =      I_CCUS                                       CSD027
     C                   MOVEL     I_CCCY        BRCCCY
     C                   Z-ADD     I_CACD        BRCACD
     C                   Z-ADD     I_CASN        BRCASN
     C                   ENDIF
 
     C     RECMBRK       CHAIN     RECMBRD0                           99        *
      * Block
     C     REQUEST       IFEQ      'B'
     C     *IN99         ANDEQ     '1'
     C                   WRITE     RECMBRD0
     C                   ENDIF
      * Unblock
     C     REQUEST       IFEQ      'U'
     C     *IN99         ANDEQ     '0'
     C                   DELETE    RECMBRD0
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Validate input
      *****************************************************************
     C     VALID_INPUT   BEGSR
 
     C                   MOVE      'Y'           Valid             1
 
      * 'Request must be B for Block or U for Unblock'
 
     C     REQUEST       IFNE      'B'
     C     REQUEST       ANDNE     'U'
     C                   MOVE      'N'           Valid
     C                   MOVE      *ON           *IN51
     C                   MOVEL     'RE75915'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
 
      * If link
 
     C     I_REQTYP      IFEQ      'L'
 
     C                   MOVEL     I_HIER        BRHIER
     C                   MOVEL     I_LINK        BRLINK
     C     RECMBRK       CHAIN     RECMBRF0                           99        *
 
      * 'Block requested but block already exists'
 
     C     REQUEST       IFEQ      'B'
     C     *IN99         ANDEQ     '0'
     C                   MOVE      'N'           Valid
     C                   MOVE      *ON           *IN51
     C                   MOVEL     'RE75916'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
 
      * 'Unblock requested but block does not exist'
 
     C     REQUEST       IFEQ      'U'
     C     *IN99         ANDEQ     '1'
     C                   MOVE      'N'           Valid
     C                   MOVE      *ON           *IN51
     C                   MOVEL     'RE75917'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
 
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
     C**********         PARM                    I_CCUS            6 0                        CSD027
     C                   PARM                    I_CCUS            6                          CSD027
     C                   PARM                    I_CCCY            3
     C**********         PARM                    I_CACD            4 0                        CGL029
     C                   PARM                    I_CACD           10 0                        CGL029
     C                   PARM                    I_CASN            2 0
      * Retail A/c Number
      * Account Name
     C                   PARM                    I_RAN            10
     C                   PARM                    I_ANAM           20
 
      * Command keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
 
      * Initialize program name
 
     C                   MOVEL     'RE100463 '   DDPGM
 
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
 
      * Key list
 
     C     RECMBRK       KLIST
     C                   KFLD                    BRHIER
     C                   KFLD                    BRLINK
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
