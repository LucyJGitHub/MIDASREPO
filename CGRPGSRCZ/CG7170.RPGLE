     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas Retail Inter Scale Qualifying Acc code Maint')   *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG7170 - Retail Interest Scale Qualifying Account Codes      *
      *           Maintenance                                         *
      *                                                               *
      *  Called By: CGC7170                                           *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR813994           Date 11Aug11               *
      *                 CER042  *CREATE    Date 11May11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR813994 - Retail Account Codes should be mandatory listed in*
      *             Retail Qualifying Account Codes maintenance in    *
      *             order to flag Retail Account in AMAD with Interest*
      *             Scale Flag required ; account code also cannot be *
      *             deleted if there is a record in Accounts Maint    *
      *             where Interest Scale flag is ticked               *
      *  CER042 - Interest Scale Report Correspondence                *
      *           (Upgrade of FGE178/179)                             *
      *                                                               *
      *---------------------------------------------------------------*
      *  Indicator Usage                                              *
      *                                                               *
      *  03 - Terminate function                                      *
      *  06 - Confirm delete/ amend                                   *
      *  09 - Add/ display mode                                       *
      *  12 - Previous                                                *
      *  25 - Message SFL processing                                  *
      *  40 - SFLCLR                                                  *
      *  41 - SFLDSP                                                  *
      *  65 - Result of test numeric                                  *
      *  66 - Account (PC)                                            *
      *  67 - SFL option (PC)                                         *
      *  68 - SFL option error                                        *
      *  69 - SFLNXTCHG                                               *
      *  70 - Account code error - Add/ Amend mode                    *
      *  86 - CHAIN/ SETLL                                            *
      *  87 - Delete/ amend record                                    *
      *  88 - Read changed SFL record/s                               *
      *  89 - SFLEND                                                  *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Interest Scale Retail Qualifying Account Codes
     FCGISRQL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     INFDS(INFDS1)
     F                                     RENAME(CGISRQD0:ZRQPL0)
     F                                     COMMIT
      ** Midas GL Account Extension File                                                    AR813994
     FGLACNTL9  IF   E           K DISK    INFSR(*PSSR)                                     AR813994
      ** Retail Interest Scale Qualifying Account Codes Maint Screen
     FCG7170DF  CF   E             WORKSTN INFDS(INFDS2)
     F                                     SFILE(CG7170S1:WSRRN)
 
      ** Parameter list for Y2SNMGC
     D ZAPGMQ          S             10A
     D ZAPGRL          S              5A
     D ZAMSID          S              7A
     D ZAMSGF          S             10A
     D ZAMSDA          S            132A
     D ZAMSTP          S              7A
      ** Parameter list for AOACODR0
     D PMRTCD          S              7A
     D PMTYPE          S              7A
     D PMACOD          S             10A
      ** Working variables
     D WDel_Acod_Flg   S              1A                                                    AR813994
     D WSMODE          S              5A
     D WSRUN           S              1A
     D WSVAL           S              3A
     D WSFERR          S              3A
     D WSCHGS          S              3A
 
      ** Copyright statement array
     D CPY             S             80    DIM(1) CTDATA PERRCD(1)
      ** Interest Scale Retail Qualifying Account Codes INFDS
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      ** Retail Interest Scale Qualifying Account Codes Maint Screen
      ** INFDS
     D INFDS2        E DS                  EXTNAME(Y2I#DSP)
      ** Database error details DA
     D LDA           E DS           256    EXTNAME(LDA)
      ** Installation control details DS
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      ** Account Code details DS
     D SDACOD        E DS                  EXTNAME(SDACODPD)
      ** Local DS for access programs, short DS
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Program status DS
     D PSDS           SDS
     D  WPGM             *PROC
     D  WSID                 244    253
     D  USER                 254    263
      ** Midas message file default
     D MSGFIL          DS
     D  CSMSGF                 1     10    INZ('CGUSRMSG')
 
      *****************************************************************
      *                                                               *
      * Main routine - Main controlling subroutine                    *
      *                                                               *
      * Called by: None                                               *
      *                                                               *
      * Calls:                                                        *
      * CLRSFL - Clear SFL                                            *
      * LODSFL - Load SFL Next Page                                   *
      * CHGMOD - Change Mode                                          *
      * PAGDWN - Page Down                                            *
      * ENTKEY - Enter Key Processing                                 *
      *                                                               *
      *****************************************************************
      ** Screen header
     C                   WRITE     CGC7170H1
      ** Display mode
     C     WSMODE        IFEQ      'DSPLY'
     C                   EXSR      CLRSFL
     C                   EXSR      LODSFL
     C                   ENDIF
      ** Process selection screen until F3
     C     *IN03         DOWEQ     *OFF
     C                   WRITE     #MSGCTL
      ** Display mode
     C     WSMODE        IFEQ      'DSPLY'
     C                   WRITE     CG7170F5
     C                   EXFMT     CG7170S0
      ** SFL RRN
     C                   Z-ADD     @#SFRC        DFRNBR
      ** Add mode
     C                   ELSE
     C                   EXFMT     CG7170F2
     C                   ENDIF
      ** Clear the program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM                    ZAPGMQ
     C                   PARM                    ZAPGRL
 
     C                   SELECT
      ** Exit
     C     *IN03         WHENEQ    *ON
     C                   LEAVE
      ** Change mode
     C     *IN09         WHENEQ    *ON
     C                   EXSR      CHGMOD
      ** Pagedown & display mode
     C     *IN25         WHENEQ    *ON
     C     WSMODE        ANDEQ     'DSPLY'
     C                   EXSR      PAGDWN
 
     C                   OTHER
      ** Enter key
     C                   EXSR      ENTKEY
     C                   ENDSL
 
     C                   ENDDO
      ** Terminate function
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CLRSFL - Clear SFL                                            *
      *                                                               *
      * Called by:                                                    *
      * Main routine - Main controlling subroutine                    *
      *                                                               *
      * Calls:                                                        *
      * None                                                          *
      *                                                               *
      *****************************************************************
     C     CLRSFL        BEGSR
      ** Clear SFL & reset SFL display indicator
     C                   MOVE      *ON           *IN40
     C                   WRITE     CG7170S0
     C                   MOVE      *OFF          *IN40
      ** Reset SFL record number
     C                   Z-ADD     *ZERO         WSRRN
 
      ** Reset RRN of last record loaded into SFL
     C                   Z-ADD     *ZERO         WSLRRN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * LODSFL - Load SFL Next Page                                   *
      *                                                               *
      * Called by:                                                    *
      * Main routine - Main controlling subroutine                    *
      *                                                               *
      * Calls:                                                        *
      * SNDMSG - Send Message To Message Queue                        *
      *                                                               *
      *****************************************************************
     C     LODSFL        BEGSR
 
      ** Reset SFL record number to RRN of last record loaded into sfl
     C                   Z-ADD     WSLRRN        WSRRN
      ** Position SFL
     C     Z6ACOD        SETLL     ZRQPL0
     C                   MOVE      *ON           *IN67
     C                   MOVEA     '000'         *IN(68)
     C                   MOVE      *ON           *IN69
      ** Build a SFL page
     C                   DO        SFLPAG
     C                   READ(N)   ZRQPL0                                 89
      ** At EOF
     C     *IN89         IFEQ      *ON
      ** Position SFL key fields
     C                   Z-ADD     9999999999    Z6ACOD
     C                   LEAVE
     C                   ENDIF
      ** Initialise SFL fields with data
     C                   CLEAR                   DSOPTN
     C                   Z-ADD     Z6ACOD        DSACOD
     C                   MOVE      DSACOD        PMACOD
      ** Account code description
     C                   CALL      'AOACODR0'
     C                   PARM      *BLANKS       PMRTCD
     C                   PARM      '*KEY   '     PMTYPE
     C                   PARM                    PMACOD
     C     SDACOD        PARM      SDACOD        DSFDY
     C     PMRTCD        IFEQ      *BLANK
     C                   MOVEL(P)  A5ACCN        DSDESC
     C                   ELSE
     C                   MOVE      *BLANK        DSDESC
     C                   ENDIF
      ** Increment SFL record number
     C                   ADD       1             WSRRN
      ** Write SFL record
     C                   WRITE     CG7170S1
     C                   MOVE      *OFF          *IN67
     C                   MOVE      *OFF          *IN69
     C                   ENDDO
      ** If not EOF read one more record, used to set the SFLEND indicatr
     C     *IN89         IFEQ      *OFF
     C                   READ(N)   ZRQPL0                                 89
     C                   ENDIF
 
      ** If SFl empty
     C     WSRRN         IFEQ      *ZERO
     C                   MOVE      *OFF          *IN41
     C                   MOVE      'ISR0001'     ZAMSID
     C                   EXSR      SNDMSG
      ** SFl not empty
     C                   ELSE
     C                   MOVE      *ON           *IN41
      ** Reset SFL RRN to SFL record number
     C                   Z-ADD     WSRRN         DFRNBR
 
      ** Reset RRN of last record loaded into SFL to SFL record number
     C                   Z-ADD     WSRRN         WSLRRN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CHGMOD - Change Mode                                          *
      *                                                               *
      * Called by:                                                    *
      * Main routine - Main controlling subroutine                    *
      *                                                               *
      * Calls:                                                        *
      * CLRSFL - Clear SFL                                            *
      * LODSFL - Load SFL Next Page                                   *
      *                                                               *
      *****************************************************************
     C     CHGMOD        BEGSR
 
     C                   CLEAR                   CG7170F2
     C                   SELECT
      ** Display mode
     C     WSMODE        WHENEQ    'DSPLY'
     C                   MOVEL     'ADD  '       WSMODE
      ** Add mode
     C                   OTHER
     C                   MOVEL     'DSPLY'       WSMODE
     C                   Z-ADD     *ZERO         Z6ACOD
     C                   CLEAR                   DFACOS
      ** Clear & load next SFL page
     C                   EXSR      CLRSFL
     C                   EXSR      LODSFL
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * PAGDWN - Page Down                                            *
      *                                                               *
      * Called by:                                                    *
      * Main routine - Main controlling subroutine                    *
      *                                                               *
      * Calls:                                                        *
      * CLRSFL - Clear SFL                                            *
      * LODSFL - Load SFL Next Page                                   *
      * SNDMSG - Send Message To Message Queue                        *
      *                                                               *
      *****************************************************************
     C     PAGDWN        BEGSR
 
     C                   SELECT
      ** When SFL position to field changes
     C     DFACOS        WHENNE    *BLANK
     C                   MOVE      DFACOS        Z6ACOD
     C                   CLEAR                   DFACOS
     C                   EXSR      CLRSFL
     C                   EXSR      LODSFL
      ** When EOF
     C     *IN89         WHENEQ    *ON
     C                   MOVE      'ISR0002'     ZAMSID
     C                   EXSR      SNDMSG
 
      ** Load next SFL page
     C                   OTHER
     C                   EXSR      LODSFL
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ENTKEY - Enter Key Processing                                 *
      *                                                               *
      * Called by:                                                    *
      * Main routine - Main controlling subroutine                    *
      *                                                               *
      * Calls:                                                        *
      * CLRSFL - Clear SFL                                            *
      * LODSFL - Load SFL Next Page                                   *
      * SNDMSG - Send Message To Message Queue                        *
      * DSPVAL - Validate SFL Option/s                                *
      * DSPPRO - Process SFL Option/s                                 *
      * ADDVAL - Validate Add Record Request                          *
      * ADDCRT - Create Record                                        *
      *                                                               *
      *****************************************************************
     C     ENTKEY        BEGSR
 
     C                   SELECT
 
      ** When SFL position to field changes
     C     DFACOS        WHENNE    *BLANK
     C                   MOVE      DFACOS        Z6ACOD
     C                   CLEAR                   DFACOS
     C                   EXSR      CLRSFL
     C                   EXSR      LODSFL
 
      ** When SFl empty
     C     WSMODE        WHENEQ    'DSPLY'
     C     WSRRN         ANDEQ     *ZERO
     C                   MOVE      'ISR0001'     ZAMSID
     C                   EXSR      SNDMSG
 
      ** Enter key processing
     C                   OTHER
      ** Validate screen
     C     WSMODE        IFEQ      'DSPLY'
     C                   EXSR      DSPVAL
 
      ** Screen is valid
     C     WSVAL         IFEQ      'YES'
     C                   EXSR      DSPPRO
     C                   ENDIF
 
      ** Add mode
     C                   ELSE
     C                   EXSR      ADDVAL
      ** Screen is valid
     C     WSVAL         IFEQ      'YES'
     C                   EXSR      ADDCRT
     C                   ENDIF
     C                   ENDIF
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DSPVAL - Validate SFL Option/s                                *
      *                                                               *
      * Called by:                                                    *
      * ENTKEY - Enter Key Processing                                 *
      *                                                               *
      * Calls:                                                        *
      * SNDMSG - Send Message To Message Queue                        *
      *                                                               *
      *****************************************************************
     C     DSPVAL        BEGSR
 
     C                   MOVE      'YES'         WSVAL
     C                   MOVE      'YES'         WSFERR
 
      ** Process first changed SFL record
     C                   READC     CG7170S1                               88
     C     *IN88         DOWEQ     *OFF
 
      ** If SFL option field is blank, setoff the SFLNXTCHG & option
      ** (RI) indicators
     C     DSOPTN        IFEQ      *BLANK
     C                   MOVEA     '00'          *IN(68)
 
      ** Update & read next changed SFL record
     C                   UPDATE    CG7170S1
     C                   READC     CG7170S1                               88
     C                   ITER
     C                   ENDIF
 
      ** If SFL option field is NOT one of the following, then error.
      ** 'D' - Delete, 'E' - Enquire or 'A' - Amend
     C     DSOPTN        IFEQ      'D'
     C     DSOPTN        OREQ      'E'
     C     DSOPTN        OREQ      'A'
     C                   ELSE
     C                   MOVE      'NO '         WSVAL
     C                   MOVEA     '11'          *IN(68)
 
      ** If first SFL option field in error
     C     WSFERR        IFEQ      'YES'
     C                   MOVE      'NO '         WSFERR
     C                   Z-ADD     WSRRN         DFRNBR
     C                   ENDIF
     C                   MOVE      'ISR0021'     ZAMSID
     C                   EXSR      SNDMSG
 
      ** Update & read next changed SFL record
     C                   UPDATE    CG7170S1
     C                   READC     CG7170S1                               88
     C                   ITER
     C                   ENDIF
 
      ** If valid SFL option
     C                   MOVEA     '0'           *IN(68)
     C                   MOVEA     '1'           *IN(69)
 
      ** Update & read next changed SFL record
     C                   UPDATE    CG7170S1
     C                   READC     CG7170S1                               88
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DSPPRO - Process SFL Option/s                                 *
      *                                                               *
      * Called by:                                                    *
      * ENTKEY - Enter Key Processing                                 *
      *                                                               *
      * Calls:                                                        *
      * DELSCR - Delete Screen Processing                             *
      * ENQSCR - Enquiry Screen Processing                            *
      * AMDSCR - Amend Screen Processing                              *
      * CLRSFL - Clear SFL                                            *
      * LODSFL - Load SFL Next Page                                   *
      *                                                               *
      *****************************************************************
     C     DSPPRO        BEGSR
 
     C                   MOVE      'NO '         WSCHGS
 
      ** Process first changed SFL record
     C                   READC     CG7170S1                               88
     C     *IN88         DOWEQ     *OFF
 
     C                   SELECT
 
      ** Delete screen processing
     C     DSOPTN        WHENEQ    'D'
     C                   EXSR      DELSCR
 
      ** Enquiry screen processing
     C     DSOPTN        WHENEQ    'E'
     C                   EXSR      ENQSCR
 
      ** Amend screen processing
     C     DSOPTN        WHENEQ    'A'
     C                   EXSR      AMDSCR
     C                   ENDSL
 
      ** Exit selected from previous screen
     C     *IN03         IFEQ      *ON
     C                   LEAVE
     C                   ENDIF
     C                   CLEAR                   DSOPTN
     C                   MOVEA     '00'          *IN(68)
 
      ** Update & read next changed SFL record
     C                   UPDATE    CG7170S1
     C                   READC     CG7170S1                               88
     C                   ENDDO
 
      ** If record change/s have taken place then re-build SFL
      ** prior to re-display
     C     *IN03         IFEQ      *OFF
     C     WSCHGS        ANDEQ     'YES'
     C                   Z-ADD     *ZERO         Z6ACOD
 
      ** Clear & re-load SFL
     C                   EXSR      CLRSFL
     C                   EXSR      LODSFL
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DELSCR - Delete Screen Processing                             *
      *                                                               *
      * Called by:                                                    *
      * DSPPRO - Process SFL Option/s                                 *
      *                                                               *
      * Calls:                                                        *
      * None                                                          *
      *                                                               *
      *****************************************************************
     C     DELSCR        BEGSR
 
      ** Setup delete screen fields
     C                   Z-ADD     DSACOD        D1ACOD
     C                   MOVEL(P)  DSDESC        D1DESC
      ** Validate account code to be deleted                                                AR813994
     C                   EXSR      SrVal_ACOD                                               AR813994
     C                   IF        WDel_Acod_Flg = 'N'                                      AR813994
     C                   MOVE      'ISR0041'     ZAMSID                                     AR813994
     C                   EXSR      SNDMSG                                                   AR813994
     C                   ELSE                                                               AR813994
 
      ** Setup record delete warning message
     C                   MOVE      'ISR0031'     ZAMSID
     C                   EXSR      SNDMSG
     C                   ENDIF                                                              AR813994
     C                   MOVE      *OFF          *IN12
 
      ** Until exit or previous
     C     *IN03         DOUEQ     *ON
     C     *IN12         OREQ      *ON
     C                   WRITE     #MSGCTL
     C                   EXFMT     CG7170F1
     C                   SELECT
     C     *IN03         WHENEQ    *ON
     C     *IN12         OREQ      *ON
 
      ** Confirm delete selected
     C     *IN06         WHENEQ    *ON
 
      ** Attempt to delete the retail interest scale qualifying account
      ** code record
     C                   IF        WDel_Acod_Flg = 'Y'                                      AR813994
     C     DSACOD        DELETE    ZRQPL0                             87
 
      ** If record deleted
     C     *IN87         IFEQ      *OFF
     C                   COMMIT
     C                   ENDIF
     C                   MOVE      'YES'         WSCHGS
     C                   MOVE      *ON           *IN12
     C                   ENDIF                                                              AR813994
     C                   ENDSL
     C                   ENDDO
 
      ** Clear the program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM                    ZAPGMQ
     C                   PARM                    ZAPGRL
 
     C                   ENDSR
      *****************************************************************                     AR813994
      *                                                               *                     AR813994
      * SrVal_ACOD  - Validate Account Code selected for deletion     *                     AR813994
      *                                                               *                     AR813994
      *****************************************************************                     AR813994
     C     SrVal_ACOD    BEGSR                                                              AR813994
                                                                                            AR813994
     C                   EVAL      WDel_Acod_Flg = 'Y'                                      AR813994
     C     DSACOD        SETLL     GLACNTL9                                                 AR813994
     C     DSACOD        READE     GLACNTL9                                                 AR813994
     C                   DOW       NOT %EOF(GLACNTL9)                                       AR813994
      ** Check in Accounts Maintenance if there is an associated account code               AR813994
      ** where Interest Scale Required flag is ticked                                       AR813994
     C                   IF        F1ZINS = 'Y'                                             AR813994
     C                   EVAL      WDel_Acod_Flg = 'N'                                      AR813994
     C                   LEAVE                                                              AR813994
     C                   ENDIF                                                              AR813994
     C     DSACOD        READE     GLACNTL9                                                 AR813994
     C                   ENDDO                                                              AR813994
                                                                                            AR813994
     C                   ENDSR                                                              AR813994
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ENQSCR - Enquiry Screen Processing                            *
      *                                                               *
      * Called by:                                                    *
      * DSPPRO - Process SFL Option/s                                 *
      *                                                               *
      * Calls:                                                        *
      * None                                                          *
      *                                                               *
      *****************************************************************
     C     ENQSCR        BEGSR
 
      ** Setup enquiry screen fields
     C                   Z-ADD     DSACOD        D3ACOD
     C                   MOVEL(P)  DSDESC        D3DESC
     C                   MOVE      *OFF          *IN12
 
      ** Until exit or previous
     C     *IN03         DOUEQ     *ON
     C     *IN12         OREQ      *ON
     C                   EXFMT     CG7170F3
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * AMDSCR - Amend Screen Processing                              *
      *                                                               *
      * Called by:                                                    *
      * DSPPRO - Process SFL Option/s                                 *
      *                                                               *
      * Calls:                                                        *
      * VALACD - Validate Account Code                                *
      *                                                               *
      *****************************************************************
     C     AMDSCR        BEGSR
 
      ** Setup amend screen fields
     C                   MOVE      DSACOD        D4ACOD
     C                   MOVEL(P)  DSDESC        D4DESC
     C                   MOVE      *OFF          *IN70
     C                   MOVE      *OFF          *IN12
 
      ** Until exit or previous
     C     *IN03         DOUEQ     *ON
     C     *IN12         OREQ      *ON
     C                   WRITE     #MSGCTL
     C                   EXFMT     CG7170F4
 
      ** Clear the program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM                    ZAPGMQ
     C                   PARM                    ZAPGRL
 
     C                   SELECT
     C     *IN03         WHENEQ    *ON
     C     *IN12         OREQ      *ON
 
      ** Confirm amend selected
     C     *IN06         WHENEQ    *ON
 
      ** Account code amended
     C                   MOVE      'YES'         WSVAL
     C                   MOVE      *OFF          *IN70
     C                   MOVE      D4ACOD        WSACOD
 
      ** Validate account code
     C                   EXSR      VALACD
 
      ** Invalid account code
     C     WSVAL         IFEQ      'NO '
     C                   MOVE      *ON           *IN70
     C                   CLEAR                   D4DESC
 
     C                   ELSE
      ** Account code description
     C                   MOVEL(P)  A5ACCN        D4DESC
     C                   Z-ADD     Z6ACOD        W1ACOD
 
      ** Update retail qualifying account code record
     C     DSACOD        CHAIN     ZRQPL0                             86
     C     *IN86         IFEQ      *OFF
     C                   MOVE      D4ACOD        Z6ACOD
     C                   CLEAR                   Z6DLTP
     C                   CLEAR                   Z6DLST
     C                   Z-ADD     AGRDNB        Z6LCDT
     C                   MOVE      'A'           Z6LCTP
     C                   UPDATE    ZRQPL0
     C                   COMMIT
     C                   MOVE      'YES'         WSCHGS
     C                   MOVE      *ON           *IN12
     C                   ENDIF
     C                   Z-ADD     W1ACOD        Z6ACOD
     C                   ENDIF
 
      ** Enter key
     C                   OTHER
 
      ** Validate screen
     C                   MOVE      'YES'         WSVAL
     C                   MOVE      *OFF          *IN70
     C                   MOVE      D4ACOD        WSACOD
 
      ** Validate account code
     C                   EXSR      VALACD
 
      ** Invalid account code
     C     WSVAL         IFEQ      'NO '
     C                   MOVE      *ON           *IN70
     C                   CLEAR                   D4DESC
 
     C                   ELSE
      ** Account code description
     C                   MOVEL(P)  A5ACCN        D4DESC
     C                   ENDIF
     C                   ENDSL
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ADDVAL - Validate Add Record Request                          *
      *                                                               *
      * Called by:                                                    *
      * ENTKEY - Enter Key Processing                                 *
      *                                                               *
      * Calls:                                                        *
      * VALACD - Validate Account Code                                *
      *                                                               *
      *****************************************************************
     C     ADDVAL        BEGSR
 
     C                   MOVE      'YES'         WSVAL
     C                   MOVE      *OFF          *IN70
     C                   MOVE      D2ACOD        WSACOD
 
      ** Validate account code
     C                   EXSR      VALACD
 
      ** Invalid account code
     C     WSVAL         IFEQ      'NO '
     C                   MOVE      *ON           *IN70
     C                   CLEAR                   D2DESC
     C                   ELSE
      ** Account code description
     C                   MOVEL(P)  A5ACCN        D2DESC
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * VALACD - Validate Account Code                                *
      *                                                               *
      * Called by:                                                    *
      * ADDVAL - Validate Add Record Request                          *
      * AMDSCR - Amend Screen Processing                              *
      * Calls:                                                        *
      * SNDMSG - Send Message To Message Queue                        *
      *                                                               *
      *****************************************************************
     C     VALACD        BEGSR
 
     C                   DO
      ** Account code required
     C     WSACOD        IFEQ      *BLANK
     C                   MOVE      'NO '         WSVAL
     C                   MOVE      'ISR0016'     ZAMSID
     C                   EXSR      SNDMSG
     C                   LEAVE
     C                   ENDIF
 
      ** Account code must be numeric
     C                   TESTN                   WSACOD               65
     C     *IN65         IFEQ      *OFF
     C                   MOVE      'NO '         WSVAL
     C                   MOVE      'ISR0017'     ZAMSID
     C                   EXSR      SNDMSG
     C                   LEAVE
     C                   ENDIF
 
      ** Must be a valid Midas account code
     C                   CALL      'AOACODR0'
     C                   PARM      *BLANKS       PMRTCD
     C                   PARM      '*KEY   '     PMTYPE
     C                   PARM      WSACOD        PMACOD
     C     SDACOD        PARM      SDACOD        DSFDY
     C     PMRTCD        IFNE      *BLANK
     C     A5ACTY        ORNE      'R'
     C                   MOVE      'NO '         WSVAL
     C                   MOVE      'ISR0030'     ZAMSID
     C                   EXSR      SNDMSG
     C                   LEAVE
     C                   ENDIF
 
      ** Must not already exist within the retail interest scale
      ** qualifying account codes file
     C                   Z-ADD     Z6ACOD        W1ACOD
     C                   MOVE      WSACOD        Z6ACOD
 
     C     Z6ACOD        SETLL     ZRQPL0                                 86
     C     *IN86         IFEQ      *ON
     C                   MOVE      'NO '         WSVAL
     C                   MOVE      'ISR0019'     ZAMSID
     C                   EXSR      SNDMSG
     C                   ENDIF
 
     C                   Z-ADD     W1ACOD        Z6ACOD
     C                   LEAVE
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ADDCRT - Create Record                                        *
      *                                                               *
      * Called by:                                                    *
      * ENTKEY - Enter Key Processing                                 *
      *                                                               *
      * Calls:                                                        *
      * SNDMSG - Send Message To Message Queue                        *
      *                                                               *
      *****************************************************************
     C     ADDCRT        BEGSR
 
     C                   MOVE      D2ACOD        Z6ACOD
     C                   CLEAR                   Z6DLTP
     C                   CLEAR                   Z6DLST
     C                   Z-ADD     AGRDNB        Z6LCDT
     C                   MOVE      'I'           Z6LCTP
 
      ** Create retail qualifying account code record
     C                   WRITE     ZRQPL0
     C                   COMMIT
      ** Completion message
     C                   MOVE      'ISR0020'     ZAMSID
     C                   EXSR      SNDMSG
      ** Clear screen fields
     C                   CLEAR                   CG7170F2
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SNDMSG - Send Message To Message Queue                        *
      *                                                               *
      * Called by:                                                    *
      * LODSFL - Load SFL Next Page                                   *
      * PAGDWN - Page Down                                            *
      * ENTKEY - Enter Key Processing                                 *
      * DSPVAL - Validate SFL Option/s                                *
      * VALACD - Validate Account Code                                *
      * ADDCRT - Create Record                                        *
      *                                                               *
      * Calls:                                                        *
      * None                                                          *
      *                                                               *
      *****************************************************************
     C     SNDMSG        BEGSR
 
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM                    ZAMSTP
 
      ** Clear all fields for default mechanism next time
     C                   MOVE      *BLANKS       ZAPGRL
     C                   MOVE      *BLANKS       ZAMSID
     C                   MOVE      *BLANKS       ZAMSDA
     C                   MOVE      *BLANKS       ZAMSTP
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - First Time In Processing                             *
      *                                                               *
      * Called by:                                                    *
      * Automatically                                                 *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C                   MOVEA     CPY           CPY2             80
     C     *DTAARA       DEFINE                  LDA
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C     *LIKE         DEFINE    DFRNBR        SFLPAG
     C     *LIKE         DEFINE    DFRNBR        WSRRN
     C     *LIKE         DEFINE    DFRNBR        WSLRRN
     C     *LIKE         DEFINE    DFRNBR        WSCRRN
     C     *LIKE         DEFINE    D2ACOD        WSACOD
     C     *LIKE         DEFINE    Z6ACOD        W1ACOD
     C                   MOVEL(P)  USER          D0USER
     C                   MOVEL(P)  WSID          D0WSID
     C                   MOVEL(P)  WPGM          D0PGMN
     C                   MOVEL(P)  AGMRDT        D0RUNA
     C                   MOVEL     WPGM          ZAPGMQ
     C                   MOVEL(P)  CSMSGF        ZAMSGF
     C                   MOVEL     WPGM          ##PGM
     C                   Z-ADD     15            SFLPAG
 
      ** If the retail interest scale qualifying account codes file is
      ** empty, the default program mode is 'ADD' otherwise it is
      ** 'DISPLAY'
     C     @1NROP        IFEQ      *ZERO
     C                   MOVEL     'ADD  '       WSMODE
     C                   ELSE
     C                   MOVEL     'DSPLY'       WSMODE
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - File exception/ error subroutine                     *
      *                                                               *
      * Called by:                                                    *
      * Automatically                                                 *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
      ** Check to see that *PSSR has not already been called
     C     WSRUN         IFEQ      *BLANK
     C                   MOVE      'Y'           WSRUN
 
     C     DBFILE        IFNE      *BLANK
     C                   MOVE      *ON           *INU8
     C                   ENDIF
 
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INLR
     C                   DUMP
      ** Program running interactively, call the error handling program
     C                   CALL      'DBERRCTL'
     C                   ENDIF
 
      ** If *PSSR already run, then end the program here
     C     DBFILE        IFNE      *BLANK
     C                   MOVE      *ON           *INU8
     C                   ENDIF
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INLR
     C                   RETURN
 
     C                   ENDSR
      ********************************************************************
** CPY
(c) Finastra International Limited 2011
