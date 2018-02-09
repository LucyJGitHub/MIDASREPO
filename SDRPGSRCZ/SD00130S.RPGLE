     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Retail Transaction type selection')           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD00130S - Transaction Identifier subfile                    *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER030  *CREATE    Date 09Jul08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRInit - Initialisation processing                           *
      *  SRClearSFL -  Clear the Subfile                              *
      *  SRLoadSfl - Load the subfile                                 *
      *  SRDspScn - Display Screen                                    *
      *  SRReset - Reset Error Flags/Fields                           *
      *  SrProcess - Process the Subfile                              *
      *  SRError - On Error, send message to message subfile          *
      *  *INZSR - Initialisation Subroutine                           *
      *  *PSSR - Error processing                                     *
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
      *
      ** Midas SD Network Transaction Identifier
      *
     FSDNTTIL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas SD Network Transaction Identifier
      *
     FSDNTTIL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDNTTID0:RTNTTID0)
      *
      ** Midas SD Transaction Identifier - display file
      *
     FSD00130SDFCF   E             WORKSTN
     F                                     SFILE(SD00130SR:D1SFRN)
     F                                     INFSR(*PSSR)
      *
      *****************************************************************
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
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      **
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      **
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** First DS For Access Programs, Short Data Structure
      *
     DDSSDY          E DS                  EXTNAME(DSSDY)
      *
     DDSFDY          E DS                  EXTNAME(DSFDY)
      *
      ** Bank Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Indicators Data Structure
      *
     DINDICATORS       DS                  BASED(IND_POINTER)
     D EXIT                   03     03
     D SFLDSP                 30     30
     D SFLCLEAR               31     31
     D SFLEND                 32     32
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     DIND_POINTER      S               *   Inz(%Addr(*IN))
      *
     D PTRTYP          S              5A
     D PRTCD           S              7A
     D PRNTTI          S                   LIKE(NINTTI)
     D D1SFRN          S              5  0
      *
     D POPTN           S              7A
      *
     D PRTTYP          S              5A
      *
     D PCOUNT          S              5  0
      *
     D WRTTY           S                   LIKE(NIRTTY)
      *
     D WNWRK           S                   LIKE(NINWRK)
      *
     D WRUN            S              1A
      *
     D IDX             S              2S 0
      *
      ** Parameters for ZA0350
      *
     D PMsgFile        S             10A   INZ('SDUSRMSG')
      *
     D PMsgId          S             10A
      *
     D PMsgData        S             45A
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
      ** Initial Processing
      *
     C                   EXSR      SRInit
      *
      ** Main Processing
      *
     C                   DOW       EXIT = *OFF
      *
     C                   EXSR      SRDspScn
      *
     C                   EXSR      SRReset
      *
     C                   IF        D1RTTY <> WRTTY
     C                   EVAL      WRTTY = D1RTTY
     C                   ELSE
     C                   EVAL      WRTTY = *BLANKS
     C                   ENDIF
      *
     C                   SELECT
     C                   WHEN      Exit  = *ON
     C                   EVAL      PCount = D1Sfrn
     C                   LEAVE
      *
     C                   WHEN      WRTTY <> *BLANKS
     C                   EXSR      SRClearSFL
      *
     C                   IF        PRNtti <> *BLANKS
      *
     C                   EXSR      SRLoadSfl
      *
     C                   ELSE
      *
     C                   EXSR      SRLoadSfl1
      *
     C                   ENDIF
      *
      ** User has pressed 'Enter' - Process Subfile
      *
     C                   OTHER
     C                   EXSR      SrProcess
      *
     C                   IF        PTRTYP<> *BLANKS
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
      *
     C*                  RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInit - Initialisation processing                            *
      *                                                               *
      * Called By: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRInit        BEGSR
      *
      ** Format Header Information
      *
     C                   EVAL      D1MRDT = BJMRDT
     C                   EVAL      D1USR  = PSUSER
     C                   EVAL      D1JOB = PSJOBNAME
      *
      ** Clear Screen Fields
      *
     C                   EVAL      D1RTTY = *BLANKS
     C                   EVAL      D2RTTY = *BLANKS
     C                   EVAL      D2SEL  = *BLANKS
      *
      ** Clear Program Message Queue
      *
     C                   CALL      'ZA0250'
      *
      ** Clear the subfile
      *
     C*                  EXSR      SRClearSFL
      *
      ** Load the subfile
      *
     C                   IF        PRNtti <> *BLANKS
      *
     C                   EXSR      SRLoadSfl
      *
     C                   ELSE
      *
     C                   EXSR      SRLoadSfl1
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClearSFL - Clear the Subfile                               *
      *                                                               *
      *  Called By: Main Processing, SRINIT                           *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRClearSFL    BEGSR
      *
     C                   EVAL      D1SFRN = 0
     C                   EVAL      SFLClear = *ON
     C                   WRITE     SD00130SC
     C                   EVAL      SFLClear = *OFF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLoadSfl - Load the subfile                                 *
      *                                                               *
      *  Called by:  Main Processing, SRINIT                          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRLoadSfl     BEGSR
      *
     C                   EVAL      D1SFRN = 0
      *
     C                   IF        D1RTTY <> *BLANKS
     C     KRTTY         SETLL     SDNTTIL1
     C*                  EVAL      WRTTY = *BLANKS
     C                   ELSE
     C     PRNtti        SETLL     SDNTTIL1
     C                   ENDIF
      *
     C*                  IF        WFilter <> 'N'
     C     PRNtti        READE     SDNTTIL1
     C*                  ENDIF
      *
     C                   DOW       NOT %EOF(SDNTTIL1)
      *
     C                   EVAL      D2RTTY = NIRTTY
     C                   EVAL      D1SFRN = D1SFRN + 1
      *
     C                   IF        D1SFRN >= 1
     C                   WRITE     SD00130SR
     C                   ENDIF
      *
      ** Read the next record
      *
     C     PRNtti        READE     SDNTTIL1
      *
     C                   ENDDO
      *
      ** Display the records only when  RRN is greatre than zero
      *
     C                   IF        D1SFRN > 0
     C                   EVAL      SFLDSP = *ON
     C                   ELSE
     C                   EVAL      SFLDSP = *OFF
     C                   ENDIF
      *
     C                   IF        D1SFRN = 0
     C                   EVAL      PMsgId = 'ASM0001'
     C                   EVAL      Idx = Idx + 1
     C                   EXSR      SRError
     C                   ENDIF
      *
      ** Last Record reached
      *
     C                   IF        %EOF(SDNTTIL1)
     C                   EVAL      SflEnd = *ON
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLoadSfl1 - Load the subfile with SDNTTIl2                  *
      *                                                               *
      *  Called by:  Main Processing, SRINIT                          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRLoadSfl1    BEGSR
      *
     C                   EVAL      D1SFRN = 0
      *
     C                   IF        D1RTTY <> *BLANKS
     C     D1RTTY        SETLL     SDNTTIL2
     C                   ELSE
     C     *LOVAL        SETLL     SDNTTIL2
     C                   ENDIF
      *
     C                   READ      SDNTTIL2
      *
     C                   DOW       NOT %EOF(SDNTTIL2)
      *
     C                   EVAL      D2RTTY = NIRTTY
     C                   EVAL      D1SFRN = D1SFRN + 1
      *
     C                   IF        D1SFRN >= 1
     C                   WRITE     SD00130SR
     C                   ENDIF
      *
      ** Read the next record
      *
     C                   READ      SDNTTIL2
      *
     C                   ENDDO
      *
      ** Display the records only when  RRN is greatre than zero
      *
     C                   IF        D1SFRN > 0
     C                   EVAL      SFLDSP = *ON
     C                   ELSE
     C                   EVAL      SFLDSP = *OFF
     C                   ENDIF
      *
     C                   IF        D1SFRN = 0
     C                   EVAL      PMsgId = 'ASM0001'
     C                   EVAL      Idx = Idx + 1
     C                   EXSR      SRError
     C                   ENDIF
      *
      ** Last Record reached
      *
     C                   IF        %EOF(SDNTTIL2)
     C                   EVAL      SflEnd = *ON
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReset - Reset Error Flags/Fields                           *
      *                                                               *
      *  Called by:                                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRReset       BEGSR
      *
      ** Clear Error Fields
      *
     C                   EVAL      PMsgId = *BLANKS
     C                   EVAL      PMsgData = *BLANKS
     C                   EVAL      Idx = 0
      *
     C                   CALL      'ZA0250'
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      *                                                               *
      *  SRDspScn - Display Screen                                    *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRDspScn      BEGSR
      *
      ** Check if records are written in the subfile or not
      *
     C                   WRITE     SD00130SMC
      *
     C                   WRITE     SD00130SF
     C                   EXFMT     SD00130SC
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrProcess - Process the Subfile                              *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SrProcess     BEGSR
      *
      ** Read Changed records from Subfile
      *
     C                   READC     SD00130SR
     C                   DOW       NOT %EOF
      *
     C                   IF        D2SEL = '1'
     C                   EVAL      PTRTYP = D2Rtty
     C                   ENDIF
      *
     C                   UPDATE    SD00130SR
     C                   READC     SD00130SR
      *
     C                   IF        PTRTYP<> *BLANKS
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRError - On Error, send message to message subfile          *
      *                                                               *
      *  Called by: SrProcess                                         *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRError       BEGSR
      *
     C                   CALL      'ZA0350'
     C                   PARM                    PMsgFile
     C                   PARM                    PMsgId
     C                   PARM      *BLANKS       PMsgData
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR                                                       *
      *                                                               *
      *  Called by:                                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *DTAARA       DEFINE                  LDA
      *
      ** Intialise working fields
      *
     C                   EVAL      DBASE = *ZEROS
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBPROC = *BLANKS
      *
      ** Define the *Entry parameter list with the following parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    PTRTYP
     C                   PARM                    PRNtti
     C                   PARM                    PCOUNT
      *
      ** Key list fir the file SDNTTIL1
      *
     C     KRTTY         KLIST
     C                   KFLD                    PRNtti
     C                   KFLD                    D1RTTY
      *
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST'      POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Populate Program Message queue
      *
     C                   EVAL      D1PGMQ =  '*'
      *
     C                   ENDSR
      *
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      *  *PSSR  - Program exception error routine                         *
      *           Called automatically if a program error occurs,         *
      *           or directly by the program code using EXSR.             *
      *           This subroutine DUMPs the program just once.            *
      *                                                                   *
      *  Called by: (**calling routines**)                                *
      *                                                                   *
      *  Calls: None                                                      *
      *                                                                   *
      *********************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
      *
     C                   EVAL      WRun = 'Y'
     C                   DUMP
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
      *
