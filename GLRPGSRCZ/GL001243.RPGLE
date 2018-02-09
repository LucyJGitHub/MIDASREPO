     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas Netting Groups set-up utility')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL001243 - Netting Groups set-up utility                     *
      *                                                               *
      *  Function:  This program is used to set-up the risk           *
      *             netting weghting groups.                          *
      *                                                               *
      *  Called By: GLC001243 - Netting Groups set-up utility         *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG2407            Date 11May04               *
      *                 CGL029             Date 01Sep03               *
      *                 CGL018  *CREATE    Date 28Sep02               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG2407 - Change the default message file given in this      *
      *            program.                                           *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CGL018 - Risk Weighted Assets                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    20       Protect fields on a input screen                  *
      *    21       Protect function keys F10, F12 on a input screen  *
      *    22       Enable f14 for confirm                            *
      *    23       highlight fields when there are errors            *
      *    50       ACOD found in AccdArr                             *
      *    91       SFLMSG indicator                                  *
      *    95       Date Format                                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      * ClrMsgF - Cleare message subfile                              *
      * SendMsg - Send message to subfile                             *
      * ScrValid -  Validation of account code on a screen            *
      * ChkAccount - Check if an acount already exists in a netting   *
      *              group                                            *
      * CreateGrp -  Preparation of a new netting group               *
      * WriteGroup -  Write accounts to netting group                 *
      * DelAll -  Delete all records of GLNETGPD                      *
      * EndRout -  End routine                                        *
      * InitScr -  Initialise an input screen                         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas GL Account details - full a/c number
      *
     FACCNTL0   IF   E           K DISK    INFSR(*PSSR)
      *
     **  Risk Weighted Asset Netting Group Master File Update
      *
     FGLNETGL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(L0)
     F                                     RENAME(GLNETGD0:RGLNET0)
      *
     **  Risk Weighted Asset Netting Group Master File Retr
      *
     FGLNETGL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(L1)
     F                                     RENAME(GLNETGD0:RGLNET1)
      *
     **  Risk Weighted Asset Netting Group by account code
      *
     FGLNETGL7  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(L7)
     F                                     RENAME(GLNETGD0:RGLNET7)
      *
     **  Netting Group Set-up Utility Display
      *
     FGL001243DFCF   E             WORKSTN INFSR(*PSSR)
     F                                     INFDS(INFDS#)
 
      /EJECT
      *****************************************************************
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
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
     ** First DS for Access Programs, Short Data Structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D ACCD          E DS                  EXTNAME(SDACODPD)
      *
     **
     D*AccdArr         S              4A   DIM(17)                                            CGL029
     D AccdArr         S             10A   DIM(17)                                            CGL029
     D DspAccd         DS
     D**#1AC01*                1      4                                                       CGL029
     D**#1AC02*                5      8                                                       CGL029
     D**#1AC03*                9     12                                                       CGL029
     D**#1AC04*               13     16                                                       CGL029
     D**#1AC05*               17     20                                                       CGL029
     D**#1AC06*               21     24                                                       CGL029
     D**#1AC07*               25     28                                                       CGL029
     D**#1AC08*               29     32                                                       CGL029
     D**#1AC09*               33     36                                                       CGL029
     D**#1AC10*               37     40                                                       CGL029
     D**#1AC11*               41     44                                                       CGL029
     D**#1AC12*               45     48                                                       CGL029
     D**#1AC13*               49     52                                                       CGL029
     D**#1AC14*               53     56                                                       CGL029
     D**#1AC15*               57     60                                                       CGL029
     D**#1AC16*               61     64                                                       CGL029
     D**#1AC17*               65     68                                                       CGL029
     D  #1AC01                 1     10                                                       CGL029
     D  #1AC02                11     20                                                       CGL029
     D  #1AC03                21     30                                                       CGL029
     D  #1AC04                31     40                                                       CGL029
     D  #1AC05                41     50                                                       CGL029
     D  #1AC06                51     60                                                       CGL029
     D  #1AC07                61     70                                                       CGL029
     D  #1AC08                71     80                                                       CGL029
     D  #1AC09                81     90                                                       CGL029
     D  #1AC10                91    100                                                       CGL029
     D  #1AC11               101    110                                                       CGL029
     D  #1AC12               111    120                                                       CGL029
     D  #1AC13               121    130                                                       CGL029
     D  #1AC14               131    140                                                       CGL029
     D  #1AC15               141    150                                                       CGL029
     D  #1AC16               151    160                                                       CGL029
     D  #1AC17               161    170                                                       CGL029
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
     D Enter           C                   const(X'F1')
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
     D Index           S              2  0
     D ErrAccd         S              1    INZ(*blank)
     D AccFound        S              1    INZ(*blank)
     D*wcnum****       S              6S 0                                                    CSD027
     D wcnum           S              6A                                                      CSD027
     D wccy            S              3A
     D*sacod**         S              4A                                                      CGL029
     D sacod           S             10A                                                      CGL029
     D GrpErr          S              1
     D*GL7Accd         S              4S 0                                                    CGL029
     D GL7Accd         S             10S 0                                                    CGL029
      *
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      *
      ** Display screen
      *
     C                   DOW       *inkc = *off
     C                   EVAL      ErrAccd = *blanks
     C                   EXFMT     GL001243F1
     C                   EXSR      ClrMsgF
     C                   WRITE     #MSGCTL
     C                   IF        *inkc = *on
     C                   ITER
     C                   ENDIF
      *
      ** Validate account codes
      *
     C     validation    TAG
     C                   EXSR      ClrMsgF
     C                   MOVEA     DspAccd       AccdArr
     C                   EXSR      ScrValid
      *
      ** If no errors enable F14 to confirm selection for group creation
      ** If errors ensure fields are highlighted.
      *
     C                   EVAL      *IN22 = *OFF
     C                   EVAL      *IN23 = *ON
     C                   IF        ErrAccd <> '1'
     C                   EVAL      *IN22 = *ON
     C                   EVAL      *IN23 = *OFF
      *
      ** Create groups:
      ** Redisplay screen to allow user to take F14 to confirm or (if
      ** account code already used) F10 to delete all netting groups and
      ** re-start or F12 to cancel.
      ** Write groups.
      *
     C                   EXSR      CreateGrp
     C                   IF        GrpErr = *blank
     C                   EVAL      *in22 = *OFF
     C                   EXSR      InitScr
     C                   ELSE
     C                   EVAL      *in20 = *off
     C                   EVAL      *in21 = *off
     C                   EXSR      ClrMsgF
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
 
     C                   EXSR      EndRout
 
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     glkey         KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
      *
      **  Initialise LDA field.
      *
     C     *DTAARA       DEFINE                  LDA
 
     C     *LOCK         IN        LDA
     C                   MOVEL     'GL001243  '  DBPGM
     C                   OUT       LDA
 
      **  Call Access Program for Bank Details - Title, Run Date and
      **  Run Day Number.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     WRTCD             7
     C                   PARM      '*FIRST '     WOPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      **  Handle Database Error.
      *
     C     WRTCD         IFNE      *BLANKS
     C                   MOVE      'SDBANKPD'    DBFILE                         ***************
     C                   Z-ADD     001           DBASE                          * DB ERROR 01 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
      *
      **  Check System Date Format, DDMMYY (*IN95 off)
      **                            MMDDYY (*IN95 on).
      *
     C     AGDFF         IFEQ      'M'
     C                   SETON                                        98
     C                   ENDIF
      *
      **  Access RUNDAT for multibranching indicator
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C
     C     AGMBIN        IFEQ      'M'
     C                   SETON                                        37
     C                   ENDIF
     C
     C**********         MOVEL     'GLUSRMSG'    ZAMSGF           10                         BUG2407
     C                   MOVEL     'SDUSRMSG'    ZAMSGF           10                         BUG2407
     C                   MOVEL     '*SAME'       ZAPGRL            5
     C                   MOVEL     *BLANK        ZAMSID            7
     C                   MOVEL     *BLANK        ZAMSDA          132
     C                   MOVEL     *BLANK        ZAMSTP            7
      *
      **  Set Display Variables
      *
     C                   EVAL      SUSER = PSUser
     C                   EVAL      SWSID = PSJobName
     C                   EVAL      *IN22 = *OFF
     C                   EVAL      *IN23 = *OFF
     C                   EVAL      ##PGM = PSProcPgm
      *
      **  Clear Message Subfile
      *
     C                   EXSR      ClrMsgF
      *
      **  Set SFLMSG IND.
      *
     C                   MOVE      *ON           *IN91
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * ScrValid - Screen Validation routine                          *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     ScrValid      BEGSR
 
     C                   EVAL      Index = 1
     C                   EVAL      ErrAccd = *blank
     C                   EVAL      *IN23 = *OFF
 
     C                   DOW       (Index<18)
     C                   IF        AccdArr(Index) <> *blank                     only nonblank fields
     C                   CALL      'AOACODR0'
     C                   PARM      '       '     WRTCD             7
     C                   PARM      '*KEY   '     WOPTN             7
     C**********         PARM      AccdArr(Index)WKEY              4                          CGL029
     C                   PARM      AccdArr(Index)WKEY             10                          CGL029
     C*****ACCD*         PARM      ACCD          DSFDY                                        CGL029
     C     ACCD          PARM      ACCD          DSSDY                                        CGL029
     C                   IF        WRTCD = *BLANKS
     C                   EVAL      AccdArr(Index) = A5ACCD
     C                   MOVEA     AccdArr       DspAccd
     C                   ENDIF
     C                   DUMP
      *
     C                   SELECT
      *
      ** Record not found or not selected, or F3 pressed
      *
     C                   WHEN      wrtcd = '*NRF'  or wrtcd = '*NOSEL '
     C                   EVAL      ZAMSID = 'USR9383'
     C                   EVAL      ZAMSDA = AccdArr(Index)
     C                   EXSR      SendMsg
     C                   WRITE     #MSGCTL
     C                   EVAL      Index = Index + 1                            next acod from scree
     C                   EVAL      ErrAccd = '1'                                acod does not exist
      *
      ** Record found, but a title only account code = invalid
      *
     C                   WHEN      wrtcd = *BLANKS
     C                              and A5TOIN = 'Y'
     C                   EVAL      ZAMSID = 'USR9385'
     C                   EVAL      ZAMSDA = AccdArr(Index)
     C                   EXSR      SendMsg
     C                   WRITE     #MSGCTL
     C                   EVAL      Index = Index + 1                            next acod from scree
     C                   EVAL      ErrAccd = '1'                                acod does not exist
      *
      ** Record found and valid
      *
     C                   WHEN      wrtcd = *blanks
     C                              and A5TOIN = 'N'
     C                   EVAL      Index = Index + 1                            next acod from scree
      *
      **  Other error
      *
     C                   OTHER
     C                   EVAL      ErrAccd = '1'                                acod does not exist
     C                   EVAL      Index = Index + 1                            next acod from scree
     C                   ENDSL
 
     C                   ELSE
     C                   EVAL      Index = Index + 1                            next acod from scree
     C                   ENDIF
     C                   ENDDO
     C                   EVAL      Index = 1
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      * SendMsg  - Send Message To The Program Message Queue          *
      * --------                                                      *
      * Called by:                                                    *
      * Calls: None                                                   *
      *****************************************************************
 
     C     SendMsg       BEGSR
     C
     C                   IF        ZAMSGF = *BLANKS
     C**********         MOVEL     'GLUSRMSG'    ZAMSGF                                      BUG2407
     C                   MOVEL     'SDUSRMSG'    ZAMSGF                                      BUG2407
     C                   ENDIF
     C
     C                   CALL      'Y2SNMGC'
     C                   PARM      PSProcPgm     ZAPGM            10
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM      *BLANK        ZAMSTP
     C
     C                   ENDSR
      /EJECT
      *****************************************************************
      * ClrMsF - CLEAR MESSAGE SUBFILE                                *
      * ------                                                        *
      * CALLED BY:                                                    *
      * CALLS: NONE                                                   *
      *****************************************************************
 
     C     ClrMsgF       BEGSR
     C
     C                   CALL      'Y2CLMSC'
     C                   PARM      PSProcName    ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
     C
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      * CreateGrp - Create group of accounts                          *
      * ------                                                        *
      * CALLED BY:                                                    *
      * CALLS: NONE                                                   *
      *****************************************************************
 
     C     CreateGrp     BEGSR
      *
      ** Account code already used, press F10 to delete ALL netting groups
      ** or F12 to cancel
      *
     C                   EXSR      ChkAccount
     C                   EVAL      Index =  1
     C                   IF        AccFound = '1'
     C                   EVAL      *in20 = *on                                  to protect fields
     C                   EVAL      *in21 = *on                                  to allowed F10, F12
     C                   EVAL      *IN23 = *ON                                  next acod from scree
     C                   EVAL      ZAMSID = 'USR9386'
     C                   EXSR      SendMsg
     C                   WRITE     #MSGCTL
     C                   ELSE
      *
      ** If selection complete press F14 to confirm, else continue to amend
      ** list.
      *
     C                   EVAL      *in22 = *on                                  to allowed F10, F12
     C                   EVAL      *IN23 = *off                                 next acod from scree
     C                   EVAL      ZAMSID = 'USR9375'
     C                   EVAL      ZAMSDA = *blank
     C                   EXSR      SendMsg
     C                   WRITE     #MSGCTL
     C                   ENDIF
      *
      ** Redisplay screen with messages and handle response.
      *
     C                   EXFMT     GL001243F1
     C                   SELECT
      *
      ** F3
      *
     C                   WHEN      *INKC                                        F03
     C                   EXSR      ClrMsgF
     C                   EXSR      EndRout
      *
      ** F10
      *
     C                   WHEN      *INKJ                                        F10
     C                   EXSR      ClrMsgF
     C                   WRITE     #MSGCTL
     C                   EXSR      DelAll
     C                   EXSR      WriteGroup
     C                   EVAL      GrpErr =  *blank
      *
      ** F12
      *
     C                   WHEN      *INKL                                        F12
     C                   EXSR      ClrMsgF
     C                   WRITE     #MSGCTL
     C                   EVAL      GrpErr = 'C'
      *
      ** F14
      *
     C                   WHEN      *INKN
     C                   EXSR      WriteGroup
      *
      ** If Enter pressed revalidate entries
      *
     C                   OTHER
     C                   GOTO      Validation
     C                   ENDSL
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      * ChkAccount - Check account if exist in any netting group.     *
      * ------                                                        *
      * CALLED BY:                                                    *
      * CALLS: NONE                                                   *
      *****************************************************************
 
     C     ChkAccount    BEGSR
 
     C                   EVAL      AccFound = *blank
     C                   EVAL      Index = 1
     C                   MOVE      AccdArr(Index)GL7Accd
     C     GL7Accd       CHAIN     GLNETGL7                           60
     C                   DOW       Index < 18                                   1b
     C                   IF        *IN60 = *OFF
     C                   EVAL      AccFound = '1'
     C                   leave
     C                   ENDIF
     C                   EVAL      Index = Index + 1
     C                   IF        Index < 18
     C                   MOVE      AccdArr(Index)GL7Accd
     C     GL7Accd       CHAIN     GLNETGL7                           60
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      * WriteGroup - Write accounts to groups                         *
      * ------                                                        *
      * CALLED BY:                                                    *
      * CALLS: NONE                                                   *
      *****************************************************************
      *
     C     WriteGroup    BEGSR
 
     C**********         EVAL      wcnum = 0                                                  CSD027
     C                   EVAL      wcnum = *blanks                                            CSD027
     C                   EVAL      wccy = *blank
     C                   SORTA     AccdArr
     C     *loval        SETLL     ACCNTL0
     C                   DOU       %eof
 
     C                   READ(E)   ACCNTL0
     C                   IF        RECI = 'D'
     C                   move      ACOD          sacod
     C     sacod         LOOKUP    AccdArr                                50
     C                   IF        *in50= *on
 
     C                   IF        not(wcnum=CNUM and wccy=CCY)
     C                   EVAL      wcnum = CNUM
     C                   EVAL      wccy = CCY
     C                   EVAL      L0RWPRIM = 'P'
     C                   EVAL      L0RWPBRCA = BRCA
     C                   EVAL      L0RWPCUST = CNUM
     C                   EVAL      L0RWPCCY = CCY
     C                   EVAL      L0RWPACOD = ACOD
     C                   EVAL      L0RWPACSQ = ACSQ
     C                   EVAL      L0RWPACNO = ACNO
     C                   ELSE
     C                   EVAL      L0RWPRIM = 'S'
     C                   ENDIF
 
     C                   EVAL      L0RWRECI = *blank
     C                   EVAL      L0RWBRCA = BRCA
     C                   EVAL      L0RWCUST = CNUM
     C                   EVAL      L0RWCCY = CCY
     C                   EVAL      L0RWACOD = ACOD
     C                   EVAL      L0RWACSQ = ACSQ
     C                   EVAL      L0RWACNO = ACNO
 
     C                   EVAL      L0RWCHTP = 'I'
     C                   EVAL      L0RWPBAL = 0
     C                   EVAL      L0RWSBAL = 0
     C                   EVAL      L0RWCONF = 'U'
     C                   EVAL      L0RWLCD = AGRDNB
     C                   IF        RECI = 'D'
     C                   WRITE(E)  RGLNET0
     C                   ENDIF
     C                   ENDIF
      *
      **  Handle Database Error.
      *
     C                   IF        %error
     C                   EVAL      DBFILE = 'GLNETGPD'                          ***************
     C                   EVAL      DBASE = 3                                    * DB ERROR 03 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      * DelAll - Delete all etting groups                             *
      * ------                                                        *
      * CALLED BY:                                                    *
      * CALLS: NONE                                                   *
      *****************************************************************
 
     C     DelAll        BEGSR
 
     C     *loval        SETLL     GLNETGL0
     C                   DOU       %eof
     C                   READ      GLNETGL0
     C                   IF        %eof
     C                   LEAVE
     C                   ENDIF
     C                   DELETE(E) GLNETGL0
      *
      **  Handle Database Error.
      *
     C                   IF        %error
     C                   EVAL      DBFILE = 'GLNETGPD'                          ***************
     C                   EVAL      DBASE = 4                                    * DB ERROR 04 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * EndRout - End routine                                         *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     EndRout       BEGSR
 
     C                   EVAL      *inlr = *on
     C                   RETURN
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * InitScr - Initialisation of screen                            *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     InitScr       BEGSR
 
     C                   EVAL      *in20 = *off
     C                   EVAL      *in21 = *off
     C                   CLEAR                   AccdArr
     C                   CLEAR                   DspAccd
     C                   EXSR      ClrMsgF
 
     C                   ENDSR
