     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC Data Replication Error Prompt')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC000410 - Data Replication Error Prompt                     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Last Amend No. CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *  01   Error indicator for reply
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Data Replication Error Prompt Display File
     FSC000410DFCF   E             WORKSTN INFSR(*PSSR)

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
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

     D WQcmd           S             70    DIM(1) CTDATA PERRCD(1)

      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Parameters for QCMDEXC
     D Command         S             70A
     D CommandLen      S             15  5

     D PRtCd           S              7A
     D POptn           S              7A
     D PNoDtl          S              1A
     D PMsgId          S             10A
     D PACTN           S              1A

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

      ** Call DR Error Log Report Program

     C                   CALL      'SC000400'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM      *BLANK        PNoDtl

      ** SC000400 is in error

     C                   IF        ReturnCode <> *BLANKS
     C                   EVAL      DBase = 002
     C                   EVAL      DBfile = 'SC000400'
     C                   EVAL      DBkey = '*CALL'
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Display screen when data replication is in error

     C                   IF        PNoDtl <> 'Y'

     C                   DOW       #0REPLY <> 'Y' AND
     C                             #0REPLY <> 'N'

     C                   TIME                    #0TIME

     C                   WRITE     SC000410C0
     C                   EXFMT     SC000410F0

      ** Clear message subfile

     C                   CALL      'ZA0250'

     C                   EXSR      SRVald

     C                   ENDDO
     C                   ENDIF

     C                   EVAL      *INLR = '1'
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVald - Validate Reply                                       *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: ZA0340                                                 *
      *                                                               *
      *****************************************************************

     C     SRVald        BEGSR

     C                   EVAL      *IN01 = '0'

      ** Reply must either be 'Y' or 'N'

     C                   IF        (#0REPLY <> 'Y') AND (#0REPLY <> 'N')

     C                   CALL      'ZA0340'
     C                   PARM                    #MsgFile
     C                   PARM      'DRM0015'     PMsgId

     C                   EVAL      *IN01 = '1'
     C                   ENDIF

     C                   IF        #0REPLY = 'Y'
     C                   EVAL      Command = WQcmd(1)
     C                   EVAL      CommandLen = 21

      ** Clear SCELOGPD file when reply is 'Y'

     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
     C                   ENDIF

      ** Pass 'C' to action when reply is 'N'

     C                   IF        #0REPLY = 'N'
     C                   EVAL      PACTN = 'C'
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: AOBANKR0                                               *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    PACTN

     C/COPY ZACPYSRC,DBFIELDS

      ** Access bank details

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST  '    POptn
     C     SDBANK        PARM      SDBANK        DSFDY

      ** If error found

     C                   IF        (PRtcd <> *BLANKS)
     C                   EVAL      DBase = 001
     C                   EVAL      DBfile = 'SDBANKPD'
     C                   EVAL      DBkey = '*FIRST'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      #MsgFile = 'SDUSRMSG'

     C                   EVAL      #0USER = PsUser
     C                   EVAL      #0WSID = PsJobName
     C                   EVAL      #0RUNA = BJMRDT
     C                   EVAL      #0REPLY = *BLANK
     C                   EVAL      #0PGM = '*'
     C                   EVAL      #0REPLY = *BLANK

     C                   ENDSR

      *****************************************************************
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

     C                   DUMP

     C                   IF        RunBefore = *BLANK
     C                   EVAL      RunBefore = 'Y'

     C                   CALLB     'DBERRCTL'

     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
**  WQcmd
CLRPFM FILE(SCELOGPD)
