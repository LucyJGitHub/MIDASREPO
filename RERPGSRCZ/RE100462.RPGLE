     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cash Management Balance Purge Request')       *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100462 - Cash Management Balance Purge Request             *
      *                                                               *
      *  Function: This module allows requests to be made to do       *
      *            cash management balance purging.                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. AR976539           Date 25Feb13               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BG8539             Date 15Sep05               *
      *                 214360             Date 03Feb03               *
      *                 212904             Date 14Jan03               *
      *                 213261             Date 14Jan03               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR976539 - Purge request fails. CGL029 changes missing.      *
      *             Updated expected ACOD length from 4 to 10.        *
      *             (Child:AR976540)                                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BG8539 - Screen not dispaly properly in WebFacing            *
      *           Change the write/read order so that the last        *
      *           written format of the screen is next one to be READ *
      *  214360 - Cash Management Deferred Posting                    *
      *  212904 - Balance purge errors                                *
      *  213261 - Balance purge can't be done for internal top a/cs   *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FRE100462DFCF   E             WORKSTN INFSR(*PSSR)
     FREZSHDL0  IF   E           K DISK    INFSR(*PSSR)                         213261
     FRECMHLL2  IF   E           K DISK    INFSR(*PSSR)
     FRECMHLL4  IF   E           K DISK    INFSR(*PSSR)                         212904
     F                                     RENAME(RECMHLD0:RECMHLF)             212904
     FREZSHLL0  IF   E           K DISK    INFSR(*PSSR)
     FRECMPRL0  UF A E           K DISK    INFSR(*PSSR)                         212904
     F                                     COMMIT                               212904
     F*RECMPRPD*O****E*************DISK****INFSR(*PSSR)                         212904
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency Details
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
      * Link account details
 
     C     I_REQTYP      IFEQ      'L'
     C                   MOVE      I_CCUS        WrkCUS            6
     C**********         MOVE      I_CACD        WrkACD            4                        AR976539
     C                   MOVE      I_CACD        WrkACD           10                        AR976539
     C                   MOVE      I_CASN        WrkASN            2
     C                   EVAL      DDACC = I_CBRC +  '-'  +  WrkCUS  +  '-'
     C                                      +  I_CCCY +  '-'  +  WrkACD   +
     C                                      '-'  +  WrkASN
 
     C                   EVAL      DDRAN  = I_RAN
     C                   EVAL      DDANAM = I_ANAM
     C                   ENDIF
 
      * If hierarchy
      *   Access zero balancing/sweeping hierarchy details                      213261
      *   Currency to be used is currency from top account of hierarchy
      * If link
      *   Currency to be used is currency of the link account
 
     C     I_REQTYP      IFEQ      'H'
     C     REZSHDK       CHAIN     REZSHDL0                           60        213261
     C     *IN60         IFEQ      '1'                                          213261
     C                   EVAL      X_ERMS = 'NO HIERARCHY HEADER FOR HIERARCHY '213261
     C                                      + I_HISN                            213261
     C                   EXSR      *PSSR                                        213261
     C                   ENDIF                                                  213261
     C                   Z-ADD     *ZERO         CLLEVL
     C     RECMHLK       CHAIN     RECMHLL2                           60
     C     *IN60         IFEQ      '1'
     C                   EVAL      X_ERMS = 'NO TOP ACCOUNT FOR HIERARCHY '
     C                                      + I_HISN
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVEL     CLCCCY        CCY
     C                   ELSE
     C                   MOVEL     I_CCCY        CCY
     C                   ENDIF
 
      * Access top a/c currency
 
     C                   EXSR      ACS_CURR
 
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
      *   Read all zero balancing links for hierarchy
      *   Write to the cash management balances purge requested file
      * If link
      *   Write to the cash management balances purge requested file
 
     C     I_REQTYP      IFEQ      'H'
     C     I_HIER        SETLL     REZSHLL0
     C     I_HIER        READE     REZSHLL0                               60
     C     *IN60         DOWEQ     '0'
     C     ZLSTYP        IFEQ      'Z'
     C     ZLPNAR        IFNE      *BLANK                                       213261
     C     ZLPNAR        OREQ      *BLANK                                       213261
     C     ZDEXTL        ANDEQ     'Y'                                          213261
     C                   EXSR      WRT_CMPR
     C                   ENDIF                                                  213261
     C                   ENDIF
     C     I_HIER        READE     REZSHLL0                               60
     C                   ENDDO
     C                   ELSE
     C                   EXSR      WRT_CMPR
     C                   ENDIF
 
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
      * Write to the cash management balances purge requested file
      ********************************************************************
     C     WRT_CMPR      BEGSR
 
      * Hierarchy ID
      * Link ID
     C                   MOVEL     I_HIER        PRHIER
     C     I_REQTYP      IFEQ      'H'
     C                   MOVEL     ZLLINK        PRLINK
     C                   ELSE
     C                   MOVEL     I_LINK        PRLINK
     C                   ENDIF
      * Hierarchy Shortname
     C                   MOVEL     I_HISN        PRHISN
                                                                                212904
      * Access hierarchy link                                                   212904
                                                                                212904
     C     RECMHLLK      CHAIN     RECMHLL4                           60        212904
     C     *IN60         IFEQ      '1'                                          212904
     C                   EVAL      X_ERMS = 'NO HIERARCHY LINK FOR HIERARCHY '  212904
     C                                      + I_HISN                            212904
     C                   EXSR      *PSSR                                        212904
     C                   ENDIF                                                  212904
                                                                                212904
      * Look for an existing record                                             212904
                                                                                212904
     C     RECMHLLK      CHAIN     RECMPRL0                           60        212904
                                                                                212904
      * Child A/c Category                                                      212904
      * Level                                                                   212904
     C                   MOVE      CLCCAT        PRCCAT                         212904
     C                   MOVE      CLLEVL        PRLEVL                         212904
      * Request Date                                                            212904
     C                   Z-ADD     BJRDNB        PRRDAT                         212904
      * Maximum Debit
      * Maximum Credit
      **Net*or*Gross*****                                                       212904
     C                   MOVEL     W_MAXD        PRMAXD
     C                   MOVEL     W_MAXC        PRMAXC
     C*******************MOVEL     DDZBNG        PRZBNG                         212904
      * Processed Y/N                                                           212904
     C                   MOVE      'N'           PRPROC                         212904
      * User
     C                   MOVEL     DDUSR         PRUSR
 
     C   60              WRITE     RECMPRD0                                     212904
     C  N60              UPDATE    RECMPRD0                                     212904
     C*******************WRITE     RECMPRD0                                     212904
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Validate input
      *****************************************************************
     C     VALID_INPUT   BEGSR
 
     C                   MOVE      'Y'           Valid             1
 
      * 'Maximum debit must be a valid value.'
 
     C     DDMAXD        IFNE      *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDMAXD        ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      A6NBDP        ZADEC             1 0
     C                   PARM      11            ZADIG             2 0
     C     ZALIGNok      IFEQ      'Y'
     C                   MOVE      ZFIELD        W_MAXD
     C                   ELSE
     C                   MOVE      'N'           Valid
     C                   MOVE      *ON           *IN51
     C                   MOVEL     'RE75911'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     *ZERO         W_MAXD           15 0
     C                   ENDIF
 
      * 'Maximum credit must be a valid value.'
 
     C     DDMAXC        IFNE      *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDMAXC        ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      A6NBDP        ZADEC             1 0
     C                   PARM      11            ZADIG             2 0
     C     ZALIGNok      IFEQ      'Y'
     C                   MOVE      ZFIELD        W_MAXC
     C                   ELSE
     C                   MOVE      'N'           Valid
     C                   MOVE      *ON           *IN52
     C                   MOVEL     'RE75912'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     *ZERO         W_MAXC           15 0
     C                   ENDIF
      *******************                                                       212904
      **'Net*or*Gross*must be N or G.'                                          212904
      *******************                                                       212904
     C*****DDZBNG********IFNE      'N'                                          212904
     C*****DDZBNG********ANDNE     'G'                                          212904
     C*******************MOVE      'N'           Valid                          212904
     C*******************MOVE      *ON           *IN53                          212904
     C*******************MOVEL     'RE75913'     ZAMSID                         212904
     C*******************EXSR      ZASNMS                                       212904
     C*******************ENDIF                                                  212904
 
      * 'Input Y or N to confirm.'
 
     C     DDCONFIRM     IFNE      'Y'
     C     DDCONFIRM     ANDNE     'N'
     C                   MOVE      'N'           Valid
     C                   MOVE      *ON           *IN54
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
      ********************************************************************
      * Access a currency
      ********************************************************************
     C     ACS_CURR      BEGSR
 
     C                   CALLB     'ZAACSCURR'
     C                   PARM                    CCY               3
     C                   PARM                    SDCURR
 
      * Database error if currency not found
 
     C     A6CYCD        IFEQ      *BLANK
     C                   EVAL      X_ERMS = 'BAD CCY CODE:' + CCY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
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
     C**********         PARM                    I_CACD            4 0                      AR976539
     C                   PARM                    I_CACD           10 0                      AR976539
     C                   PARM                    I_CASN            2 0
      * Retail A/c Number
      * Account Name
     C                   PARM                    I_RAN            10
     C                   PARM                    I_ANAM           20
 
      * Command keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
 
      * Initialize program name
 
     C                   MOVEL     'RE100462 '   DDPGM
 
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
 
      * Key lists
 
     C     REZSHDK       KLIST                                                  213261
     C                   KFLD                    I_HIER                         213261
     C     RECMHLK       KLIST
     C                   KFLD                    I_HIER
     C                   KFLD                    CLLEVL
     C     RECMHLLK      KLIST                                                  212904
     C                   KFLD                    PRHIER                         212904
     C                   KFLD                    PRLINK                         212904
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
